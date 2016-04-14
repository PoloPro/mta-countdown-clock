class StopTimeUpdate
  attr_accessor :arrival_time, :departure_time, :stop_id, :direction, :station_name

  def to_s
    "  --------\n" \
    "  Stop ID: #{stop_id}\n" \
    "  Departure time: #{time_formatter(departure_time.to_i)}\n" \
    "  Arrival time: #{time_formatter(arrival_time.to_i)}\n"
  end

  def self.time_formatter(time)
    if time
      datetime = Time.at(time).to_datetime
      datetime.strftime("%I:%M:%S%p")
    else
      ""
    end
  end

  def parse_direction
    if stop_id[-1] == "S"
      self.direction = "southbound"
      stop_id.chop!
    elsif stop_id[-1] == "N"
      self.direction = "northbound"
      stop_id.chop!
    end

    stop_id
  end

end