describe 'MTA Countdown Clock' do
  before(:all) do
    @realtime_url = "http://datamine.mta.info/mta_esi.php?key=ecdac9dab9595408073272ba5dec9cc1"
    @stations_url = "http://mtaapi.herokuapp.com/stations"
  end

  let(:interface) { MtaApiInterface.new(@realtime_url, @stations_url) }

  describe 'API interface' do
    it '#load_realtime_data loads gtfs data successfully' do
      expect{ interface.load_realtime_data }.to_not raise_error
    end

    it '#load_station_data loads static data successfully' do
      expect{ interface.load_station_data }.to_not raise_error
    end

    it '#create_schedule creates a Schedule object' do
      interface.create_schedule
      expect(interface.schedule).to be_a(Schedule)
    end
  end

  describe 'Schedule' do
    it 'initializes with an empty trips array' do
      new_schedule = Schedule.new
      expect(new_schedule.trips).to be_empty
    end

    it 'properly loads with Trip objects' do
      interface.create_schedule
      expect(interface.schedule.trips.first).to be_a(Trip2)
    end

    describe '#next_n_arrivals' do
      before(:each) do
        interface.create_schedule
        @schedule = interface.schedule
      end

      it 'returns an array of hashes' do
        expect(@schedule.next_n_arrivals("170 St", 2).first).to be_a(Hash)
      end

      it 'each hash contains a trip id' do
        expect(@schedule.next_n_arrivals("96 St", 3).first[:trip_id]).to be_a(String)
      end

      it 'each hash contains a trip name' do
        expect(@schedule.next_n_arrivals("96 St", 5).first[:trip_name]).to be_a(String)
      end

      it 'each hash contains an arrival time' do
        expect(@schedule.next_n_arrivals("Bleecker St", 3).first[:arrival_time]).to be_a(String)
      end

      it 'each hash contains a direction' do
        expect(@schedule.next_n_arrivals("Bleecker St", 4).first[:direction]).to be_a(String)
      end

    end
  end

  describe 'Trip2' do
    it 'initializes with an empty stops array' do
      new_trip = Trip2.new
      expect(new_trip.stops).to be_empty
    end

    it 'properly loads with Stop objects' do
      interface.create_schedule
      first_trip = interface.schedule.trips.first
      expect(first_trip.stops.first).to be_a(Stop)
    end
  end

  describe 'Stop' do
    before(:each) do
      interface.create_schedule
    end

    it 'properly loads with an id' do
      fifth_trip = interface.schedule.trips[4]
      second_stop = fifth_trip.stops[1]
      expect(second_stop.id).to be_a(String)
    end

    it 'properly loads with an arrival time' do
      tenth_trip = interface.schedule.trips[9]
      third_stop = tenth_trip.stops[2]
      expect(third_stop.arrival_time).to be_a(Integer)
    end

  end
end


