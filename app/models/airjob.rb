class Airjob < ApplicationRecord
  ERROR = 'error'.freeze
  PROCESSING = 'processing'.freeze
  DONE = 'done'.freeze

  STATUSES = [ERROR, PROCESSING, DONE]

  validates :job_name, :status, presence: true
  validates :job_name, format: /[\w\-\_]+/
  validates :status, inclusion: { in: STATUSES }
  validates :result, presence: true, on: :update, if: 'success?'

  def success?
    status == DONE
  end
end
