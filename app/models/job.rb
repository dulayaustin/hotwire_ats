class Job < ApplicationRecord
  include PgSearch::Model
  pg_search_scope :text_search,
    against: %i[ title ],
    using: {
      tsearch: {
        any_word: true,
        prefix: true
      }
    }

  has_rich_text :description

  enum status: {
    draft: 'draft',
    open: 'open',
    closed: 'closed'
  }

  enum job_type: {
    full_time: 'full_time',
    part_time: 'part_time'
  }

  belongs_to :account

  has_many :applicants, dependent: :destroy

  validates_presence_of :title, :status, :job_type, :location

  FILTER_PARAMS = %i[ query status sort].freeze

  scope :for_status, ->(status) { status.present? ? where(status: status) : all }
  scope :search, ->(query) { query.present? ? text_search(query) : all }
  scope :sorted, ->(selection) { selection.present? ? apply_sort(selection) : all }
  scope :for_account, ->(account_id) { where(account_id: account_id) }

  def self.apply_sort(selection)
    return if selection.blank?
    sort, direction = selection.split('-')
    order("jobs.#{sort} #{direction}")
  end

  def self.filter(filters)
    search(filters['query'])
      .for_status(filters['status'])
      .sorted(filters['sort'])
  end
end
