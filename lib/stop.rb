class Stop
  attr_reader :id, :arrival_time

  def initialize(id, arrival_time)
    @id = id
    @arrival_time = arrival_time
  end

end