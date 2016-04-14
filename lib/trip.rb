require_relative '../config/environment.rb'


class Trip
  attr_accessor :trip_id, :start_date, :route_id, :stop_time_updates

  # ========================== Object creation =========================== #

  def initialize
    @stop_time_updates = []
  end

  def self.create(params)
    new_trip = Trip.new

    new_trip.trip_id = params[:trip][:trip_id] 
    new_trip.start_date = params[:trip][:start_date]
    new_trip.route_id = params[:trip][:route_id]

    params[:stop_time_update].each do |entry|
      stop_time = StopTimeUpdate.new

      stop_time.arrival_time = entry[:arrival][:time] if entry[:arrival]
      stop_time.departure_time = entry[:departure][:time] if entry[:departure]
      stop_time.stop_id = entry[:stop_id]
      stop_time.parse_direction

      new_trip.stop_time_updates << stop_time
    end

    new_trip
  end

  # ======================= Data parsing ================================ #

  def passes_station?(station_name)
    stop_time_updates.any? { |update| update.stop_id == station_name.chop }
  end

  def get_stop_time(station_name)
    stop_time = {}
    next_stop = stop_time_updates.find { |update| update.stop_id == station_name.chop }
    if next_stop
      arrival = next_stop.arrival_time
      stop_time[:time] = StopTimeUpdate.time_formatter(arrival.to_i)
      stop_time[:direction] = next_stop.direction
      stop_time
    end
  end


  # ======================= Command line output ========================= #

  def to_s
    output_string = "-------------------\n" \
    "Trip ID: #{trip_id}\n" \
    "Start date: #{date_formatter(start_date.to_s)}\n" \
    "Route ID: #{route_id}\n"

    stop_time_updates.each { |entry| output_string += entry.to_s }

    output_string
  end

  private
  def date_formatter(date)
    formatted_date = Date.strptime(date, "%Y%m%d")
    formatted_date.strftime("%m/%d/%Y")
  end

end