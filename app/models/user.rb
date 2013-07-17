class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me
  # attr_accessible :title, :body
  attr_accessible :first_name, :phone, :time_zone, :first_habit, :programs_attributes, :setup_flag
  has_many :programs, dependent: :destroy
  accepts_nested_attributes_for :programs

  validates :first_habit, presence: true
  validates :phone, presence: true, uniqueness: true, :on => :update, :if => :setup_complete?
  validate  :phone_length, :on => :update, :if => :setup_complete?
  validates :first_name, presence: true, :on => :update, :if => :setup_complete?
  validates_inclusion_of :time_zone, in: ActiveSupport::TimeZone.zones_map(&:name)

  before_validation :set_default_time_zone, :on => :create

  def next_program
    programs = self.programs
    x = []
    programs.each { |p| x.push(p.start_date) if p.start_date > Date.today }
    programs.where("start_date = ?", x.min).first
  end

  def current_program
    programs = self.programs
    current_program = programs.where("start_date <= ? AND end_date >= ?", Date.current, Date.current - 1).first # - 1 for end-date so that calendar is shown on last checkin day (1 day after end_date)
  end

  def midprogram?
    programs = self.programs
    active_programs = programs.where("start_date <= ? AND end_date >= ?", Date.current, Date.current - 1).count # - 1 for end-date so that calendar is shown on last checkin day (1 day after end_date)
    active_programs >= 1 ? true : false
  end

  def program
    if self.midprogram?
      self.current_program
    elsif self.next_program != nil
      self.next_program
    end
  end

  def phone_length
    if !self.phone.blank? && self.phone.length != 10
      self.errors[:phone_number] = "must be 10 digits"
    end
  end

  def set_default_time_zone
    self.time_zone = "Eastern Time (US & Canada)"
  end

  def setup_complete?
    self.setup_flag == true
  end

  # For rails admin
  def custom_label_method
    "#{self.email}"
  end

  def future_date
    if self.start_date != nil && self.start_date < Time.zone.now.to_date + 1
      self.errors[:start_date] << "can't be earlier than tomorrow"
    end
  end

  def prev_week
    ((Date.current - 1 - self.start_date)/7).to_i # Current date minus one to account for 1 day checkin lag
  end

  def prev_week_sdays
    x = []
    self.days.reported.order("date desc")[(-7 - 7*(self.prev_week - 1))..(-1 - 7*(self.prev_week - 1))].each { |day| x.push(day.result) if day.result == 1 }
    x.inject(:+)
  end

  def completed_days
    d = Date.current - self.start_date
    d.to_i
  end

  def badge
    if self.prev_week_sdays == 7
      "Congratulations on a perfect week!  Well, in terms of #{self.habit_name} anyway."
    elsif self.prev_week_sdays <= 6 && self.prev_week_sdays >= 5
      "Strong week.  Strong to Quite Strong."
    elsif self.prev_week_sdays <= 4 && self.prev_week_sdays >= 3
      "Pretty good success rate, but I know you can do better.  I give it about a B."
    elsif self.prev_week_sdays <= 2 && self.completed_days <= 7
      "The first week is always hard.  Make a comeback in week 2!"
    elsif self.prev_week_sdays <= 2 && self.completed_days > 7    
      "Looks like you had a tough week.  Hit the reset button and start fresh next week."
    end
  end
end
