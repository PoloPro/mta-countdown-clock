require_relative '../config/environment.rb'

class ApiInterface
  attr_accessor :trips, :stations

  def initialize
    @trips = []
    @stations = []
  end

  # ===================== Accessing GTFS Data ========================= #
  # Reference = http://www.rubydoc.info/gems/gtfs-realtime-bindings/0.0.5

  def get_realtime_gtfs(url)
    data = Net::HTTP.get(URI.parse(url))
    Transit_realtime::FeedMessage.decode(data)
  end

  def load_trip_data(url)
    data_feed = get_realtime_gtfs(url)

    trips_hash = []
    data_feed.entity.each do |entity|
      if entity.field?(:trip_update)
        trips_hash << entity.trip_update.to_hash_value
      end
    end

    self.trips = format_trip_data(trips_hash)
  end

  def format_trip_data(hash)
    hash.map { |trip| Trip.create(trip) }
  end

  # ===================== Accessing Static Data ======================= #
  # Reference = https://github.com/mimouncadosch/MTA-API

  def load_station_data(url)
    data = Net::HTTP.get(URI.parse(url))
    self.stations = JSON.parse(data)["result"]
  end

  def get_all_stations
    stations.map { |station| station["name"] }
  end

  # ===================== Parsing GTFS Results ======================== #

  def select_by_line(subway_line)
    trips.select { |trip| trip.route_id == subway_line}
  end

  def select_by_station(station_name)
    trips.select { |trip| trip.passes_station?(station_name) }
  end

  def get_station_schedule(station_name)
    passing_trains = select_by_station(station_name)
    schedule = []
    passing_trains.each do |train|
      if train.passes_station?(station_name)
        arrival = train.get_stop_time(station_name)
        passing_train = {}
        passing_train[:route_id] = train.route_id
        passing_train[:direction] = arrival[:direction]
        passing_train[:time] = arrival[:time]
        schedule << passing_train
      end
    end
    schedule
  end

  def get_station_name(station_id)
    stations.find { |station| station["id"] == station_id }["name"]
  end

  def get_next_n_trains(n, station_name)
    schedule = get_station_schedule(station_name)
    schedule.sort_by { |train| train[:time] }
    schedule.take(n)
  end

  private
  attr_writer :trips

end

