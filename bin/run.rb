require_relative "../config/environment.rb"

gtfs_url = "your personal MTA key here"
stations_url = "http://mtaapi.herokuapp.com/stations"

interface = MtaApiInterface.new(gtfs_url, stations_url)
interface.create_schedule
schedule = interface.schedule.next_n_arrivals("34 St - Penn Station", 10)

schedule.each do |arrival|
  puts "A #{arrival[:direction]} #{arrival[:trip_name]} train is arriving at #{arrival[:arrival_time].strftime("%I:%M:%S%p")}."
end

