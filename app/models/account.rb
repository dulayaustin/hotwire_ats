class Account < ApplicationRecord
  include CableReady::Updatable

  validates_presence_of :name

  has_many :users, dependent: :destroy
  has_many :jobs, dependent: :destroy
  has_many :applicants, through: :jobs, enable_cable_ready_updates: { on: :create }
end
