class Airjob < ApplicationRecord
  extend ActsAsTree::TreeView
  acts_as_tree order: 'job_name'
  enum status: { idle: 0, processing: 1, done: 2, error: 3 }

  validates :job_name, :status, presence: true
  validates :job_name, format: /[\w\-\_]+/
  validates :result, presence: true, on: :update, if: 'done?'
end
