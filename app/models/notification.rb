class Notification < ApplicationRecord
  include Rails.application.routes.url_helpers

  serialize :params, coder: YAML, type: Hash unless %i[json jsonb hstore].include?(columns_hash['params'].type)

  belongs_to :user

  scope :unread, ->{ where(read_at: nil) }

  def to_partial_path
    'notifications/notification'
  end
end
