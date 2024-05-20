class Notification < ApplicationRecord
  include Rails.application.routes.url_helpers

  serialize :params

  belongs_to :user

  scope :unread, ->{ where(read_at: nil) }
end
