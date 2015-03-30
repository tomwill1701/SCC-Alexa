# == Schema Information
#
# Table name: user_jobs
#
#  id      :integer          not null, primary key
#  user_id :integer
#  job_id  :integer
#

class UserJob < ActiveRecord::Base

  belongs_to :user, required: true
  belongs_to :job, required: true

  validates :user_id, :job_id, presence: true

end
