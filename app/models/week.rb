class Week < ActiveRecord::Base
  attr_accessible :start_date, :end_date, :free_days, :week
  belongs_to :program
  scope :closed, where("end_date <= ?", Date.current - 2).order("start_date desc")

  def days
  	p = Program.find(self.program_id)
  	alldays = p.days
  	sd = alldays.find { |d| d.date == self.start_date }
  	ed = alldays.find { |d| d.date == self.end_date }
  	days = alldays.order("day asc")[(sd.day - 1)..(ed.day - 1)]
  end

  def missed
  	x = [0]
  	self.days.each { |day| x.push(1) if day.result == 4 }
  	x.inject(:+)
  end

  def used_free_days
    x = [0]
    self.days.each { |day| x.push(1) if day.result == 5 }
    x.inject(:+)
  end

  def successful
  	x = [0]
  	self.days.each { |day| x.push(1) if day.result == 1 }
  	x.inject(:+)
  end

  def unsuccessful
  	x = [0]
  	self.days.each { |day| x.push(1) if day.result == 2 }
  	x.inject(:+)
  end
end
