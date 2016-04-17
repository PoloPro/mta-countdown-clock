class Trip
  include DataFormat::TimeFormat
  include DataFormat::StationFormat

  attr_accessor :id, :date, :name
  attr_reader :stops

  def initialize
    @stops = []
  end

  def self.create(id, date, name, stop_times)
    new_trip = Trip.new

    new_trip.id = id
    new_trip.date = date
    new_trip.name = name

    stop_times.each do |stop|
      arrival_time = stop[:arrival][:time] if stop[:arrival]
      id = stop[:stop_id]

      new_trip.stops << Stop.new(id, arrival_time)
    end

    new_trip
  end

  def passes_station?(station_id)
    stops.any? { |stop| stop.id == station_id }
  end

  def get_stop_time(station_id)
    stop = stops.find { |stop| stop.id == station_id}
    stop.arrival_time
  end

  def get_stop_direction(station_id)
    stop = stops.find { |stop| stop.id == station_id}
    station_id_to_direction(stop.id)
  end

  private
  attr_writer :stops

end