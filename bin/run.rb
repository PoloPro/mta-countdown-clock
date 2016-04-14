require_relative "../config/environment.rb"

GTFS_URL = "http://datamine.mta.info/mta_esi.php?key=ecdac9dab9595408073272ba5dec9cc1"
STATIONS_URL = "http://mtaapi.herokuapp.com/stations"

mta_interface = ApiInterface.new
mta_interface.load_trip_data(GTFS_URL)
mta_interface.load_station_data(STATIONS_URL)

station = "631S"
puts "Station ID: #{station}"
puts "Station   : #{mta_interface.get_station_name(station)}"

n = 10
trains = mta_interface.get_next_n_trains(n, station)
puts "---------------"
puts "The next #{n} trains to arrive will be:"
trains.each do |train|
  puts "A #{train[:direction]} #{train[:route_id]} train arriving at #{train[:time]}."
end

