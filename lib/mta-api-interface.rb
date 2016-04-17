class MtaApiInterface

  attr_reader :schedule

  def initialize(realtime_url, stations_url)
    @realtime_url = realtime_url
    @stations_url = stations_url
  end

  def create_schedule
    self.schedule = Schedule.create(load_realtime_data, load_station_data)
  end

  # =============== Load realtime GTFS data from MTA API ============= #
  # Reference: http://www.rubydoc.info/gems/gtfs-realtime-bindings/0.0.5

  def load_realtime_data
    proto = Net::HTTP.get(URI.parse(realtime_url))
    data = Transit_realtime::FeedMessage.decode(proto)

    schedule_data = []
    data.entity.each do |entity|
      if entity.field?(:trip_update)
        schedule_data << entity.trip_update.to_hash_value
      end
    end
    schedule_data
  end

  # =============== Load station data from static MTA API =========== #
  # Reference: https://github.com/mimouncadosch/MTA-API

  def load_station_data
    data = Net::HTTP.get(URI.parse(stations_url))
    JSON.parse(data)["result"]
  end

  private
  attr_accessor :realtime_url, :stations_url
  attr_writer :schedule
end