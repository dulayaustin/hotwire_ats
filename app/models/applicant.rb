class Applicant < ApplicationRecord
  include PgSearch::Model

  FILTER_PARAMS = %i[ query job sort].freeze

  pg_search_scope :text_search,
    against: %i[ first_name last_name email ],
    using: {
      tsearch: {
        any_word: true,
        prefix: true
      }
    }

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

  has_many :emails, dependent: :destroy
  has_many :comments, as: :commentable, dependent: :destroy, counter_cache: :commentable_count

  validates_presence_of :first_name, :last_name, :email

  scope :for_account, ->(account_id) { where(jobs: { account_id: account_id }) }
  scope :for_job, ->(job_id) { job_id.present? ? where(job_id: job_id) : all }
  scope :search, ->(query) { query.present? ? text_search(query) : all }
  scope :sorted, ->(selection) { selection.present? ? apply_sort(selection) : all }

  def self.apply_sort(selection)
    return if selection.blank?
    sort, direction = selection.split('-')
    order("applicants.#{sort} #{direction}")
  end

  def self.filter(filters)
    includes(:job)
      .sorted(filters['sort'])
      .for_job(filters['job'])
      .search(filters['query'])
  end

  def name
    [first_name, last_name].join(' ')
  end
end
