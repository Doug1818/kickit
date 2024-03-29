class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me
  # attr_accessible :title, :body
  attr_accessible :first_name, :phone, :time_zone, :first_habit, :programs_attributes, :setup_flag, 
    :stripe_card_token, :stripe_customer_id, :stripe_card_type, :stripe_card_last4
  attr_accessor :stripe_card_token
  has_many :programs, dependent: :destroy
  accepts_nested_attributes_for :programs

  validates :first_habit, presence: true
  validates :phone, presence: true, uniqueness: true, :on => :update, :if => :setup_complete?
  validate  :phone_length, :on => :update, :if => :setup_complete?
  validates :first_name, presence: true, :on => :update, :if => :setup_complete?
  validates_inclusion_of :time_zone, in: ActiveSupport::TimeZone.zones_map(&:name)

  before_validation :set_default_time_zone, :on => :create

  def save_with_payment
    # Update or Create stripe customer
    if self.stripe_customer_id?
      customer = Stripe::Customer.retrieve(self.stripe_customer_id)
      customer.card = stripe_card_token
      customer.save
      self.update_attributes(
        stripe_card_type: customer.cards.data[0].type,
        stripe_card_last4: customer.cards.data[0].last4)
    else
      customer = Stripe::Customer.create(
        :card => stripe_card_token,
        :email => email,
        :description => first_name)
      self.update_attributes(
        stripe_customer_id: customer.id,
        stripe_card_type: customer.cards.data[0].type,
        stripe_card_last4: customer.cards.data[0].last4)
    end
  rescue Stripe::InvalidRequestError => e
    logger.error "Stripe error while creating customer: #{e.message}"
    errors.add :base, "There was a problem with your credit card."
  end

  def next_program
    if self.programs.count >= 1
      programs = self.programs
      x = []
      programs.each { |p| x.push(p.start_date) if p.start_date > Date.current }
      programs.find { |p| p.start_date == x.min }
    else
      nil
    end
  end

  def current_program
    if self.programs.count >= 1
      self.programs.find { |p| p.start_date <= Date.current && p.end_date >= Date.current - 1 } # - 1 for end-date so that calendar is shown on last checkin day (1 day after end_date)
    else
      nil
    end
  end

  def last_program
    if self.programs.count >= 1
      programs = self.programs
      x = []
      programs.each { |p| x.push(p.end_date) if Date.current > p.end_date }
      programs.find { |p| p.end_date == x.max }
    else
      nil
    end
  end

  def program
    if self.current_program != nil
      self.current_program
    elsif self.next_program != nil
      self.next_program
    elsif self.last_program != nil
      self.last_program
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
end
