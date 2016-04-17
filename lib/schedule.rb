class Schedule
  include DataFormat::StationFormat

  attr_accessor :stations
  attr_reader :trips

  def initialize
    @trips = []
  end

  def self.create(realtime_data, station_data)
    new_schedule = Schedule.new

    new_schedule.stations = station_data

    realtime_data.each do |trip|
      id          = trip[:trip][:trip_id]
      date        = trip[:trip][:start_date]
      name        = trip[:trip][:route_id]
      stop_times  = trip[:stop_time_update]

      new_schedule.trips << Trip.create(id, date, name, stop_times)
    end
    new_schedule
  end

  def next_n_arrivals(station_name, n)
    station_ids = station_name_to_ids(station_name, stations)
    passing_trains = get_passing_trains(station_ids)
    return nil unless passing_trains

    station_schedule = create_schedule(passing_trains, station_ids)
    unique_schedule = flatten_trips(station_schedule)

    unique_schedule.each { |train| train[:arrival_time] = Time.at(train[:arrival_time]).to_datetime }
    unique_schedule.sort_by { |train| train[:arrival_time] }
    first_n = unique_schedule.take(n)
  end

  def get_passing_trains(station_ids)
    passing_trains = []
    station_ids.each do |id|
      passing_trains << trips.select { |trip| trip.passes_station?(id) }
    end
    passing_trains.flatten!
  end

  def flatten_trips(trains)
    trip_ids = []
    trains.map do |train|
      if trip_ids.include?(train[:trip_id])
        nil
      else
        trip_ids << train[:trip_id]
        train
      end
    end
  end

  def create_schedule(passing_trains, station_ids)
    station_schedule = []
    passing_trains.each do |train|
      arrival = {}
      arrival[:trip_id]   = train.id
      arrival[:trip_name] = train.name

      station_ids.each do |id|
        if train.passes_station?(id)
          arrival[:arrival_time] = train.get_stop_time(id)
          arrival[:direction] = train.get_stop_direction(id)
        end
      end

      station_schedule << arrival
    end
    station_schedule
  end

end