class Applicant < ApplicationRecord
  has_one_attached :resume

  enum stage: {
    application: 'application',
    interview: 'interview',
    offer: 'offer',
    hired: 'hired'
  }

  enum status: {
    active: 'active',
    inactive: 'inactive'
  }

  belongs_to :job

  validates_presence_of :first_name, :last_name, :email

  def name
    [first_name, last_name].join(' ')
  end
end
