module DataFormat

  module TimeFormat
    def unix_to_string(time)
      date_time = Time.at(time).to_datetime
      date_time.strftime("%I:%M:%S%p")
    end

    def ymd_to_mdy(date)
      Date.strptime(date, "%Y%m%d").strftime("%m/%d/%Y")
    end
  end

  module StationFormat
    def station_id_to_name(id, stations)
      stations.find { |station| station["id"] == id }["name"]
    end

    def station_name_to_ids(station_name, stations)
      matches = stations.select { |station| station["name"] == station_name }
      matches.map { |station| station["id"] }
    end

    def station_id_to_direction(id)
      case id[-1]
      when "S"
        "southbound"
      when "N"
        "northbound"
      else
        "error"
      end
    end
  end

end



