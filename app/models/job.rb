# == Schema Information
#
# Table name: jobs
#
#  id           :integer          not null, primary key
#  name         :string
#  jtype        :string
#  description  :text
#  menu         :string
#  cclass       :string
#  tags         :string
#  when         :string
#  when_time    :string
#  run_type     :string
#  keep_days    :integer
#  private      :boolean          default("false")
#  notify       :boolean          default("true")
#  notify_group :boolean          default("true")
#  cache        :boolean          default("true")
#  debug        :boolean          default("true")
#  owner_id     :integer
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

class Job < ActiveRecord::Base

  has_many :user_jobs, dependent: :destroy
  has_many :users, through: :user_jobs

  has_many :job_items, -> { order(:created_at) }, dependent: :destroy

  has_many :cgroups, through: :job_items
  has_many :commands, through: :cgroups

  has_many :lgroups, through: :job_item
  has_many :lpars, through: :lgroups

  has_many :runs, dependent: :destroy

  belongs_to :owner, class_name: 'User', foreign_key: 'owner_id'

  validates :name, presence: true

  accepts_nested_attributes_for :job_items, allow_destroy: true, reject_if: :all_blank

  scope :for_user, -> user { where("owner_id = ?", user.id) unless user.admin? }

  scope :with_favorite, lambda { |id| where('user_id = ?', id).joins(:user_jobs) }

  scope :with_private, lambda { |id| where('owner_id = ?', id) }

  scope :for_user, lambda { |id| where('private =  false OR owner_id = ?', id) }

  def self.ransackable_scopes(auth_object = nil)
    [:with_favorite, :with_private]
  end

  def favorite_job?(user)
    user_jobs.find_by(user: user)
  end

  def owner?(user)
    self.owner_id == user.id
  end

end
