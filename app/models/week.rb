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

  def badge
    program = Program.find(self.program_id)
    #binding.pry
    if self.successful == 7 - self.used_free_days && program.habit != "Other"
      "Congratulations on a perfect week!  Well, in terms of #{program.habit.downcase} anyway."
    elsif self.successful == 7 - self.used_free_days && program.habit == "Other"
      "Congratulations on a perfect week!"
    elsif self.successful <= 6 - self.used_free_days && self.successful >= 5 - self.used_free_days
      "Strong week.  Strong to Quite Strong."
    elsif self.successful <= 4 - self.used_free_days && self.successful >= 3 - self.used_free_days && self.used_free_days <= 1
      "Pretty good success rate, but I know you can do better.  I give it about a B."
    elsif self.successful <= 4 - self.used_free_days && self.successful >= 3 - self.used_free_days && self.used_free_days > 1
      "Looks like you had a tough week.  Hit the reset button and start fresh next week."
    elsif self.successful <= 2 - self.used_free_days && program.weeks.closed.count == 1
      "The first week is always hard.  Make a comeback in week 2!"
    elsif self.successful <= 2 - self.used_free_days && program.weeks.closed.count > 1
      "Looks like you had a tough week.  Hit the reset button and start fresh next week."
    end
  end
end
