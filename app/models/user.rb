# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  username        :string
#  name            :string
#  department      :string
#  phone           :string
#  email           :string
#  racf_userid     :string
#  racf_group      :string
#  racf_password   :string
#  admin           :boolean          default("false")
#  password_digest :string
#  last_login      :datetime
#  login_count     :integer
#  background      :string
#  notify          :string
#  prompt_ok       :string
#  prompt_cancel   :string
#  prompt_values   :string
#  prompt_fields   :string
#  lpar_id         :integer
#  command_id      :integer
#  job_id          :integer
#  ugroup_id       :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

class User < ActiveRecord::Base

  has_secure_password

  serialize :prompt_values
  serialize :prompt_fields

  belongs_to :lpar
  belongs_to :ugroup

  has_many :user_ugroups, dependent: :destroy
  has_many :ugroups, through: :user_ugroups
  has_many :runs, through: :ugroups
  has_many :notices, through: :ugroups

  has_many :user_jobs, dependent: :destroy
  has_many :jobs, through: :user_jobs

  has_many :private_jobs, class_name: 'Job', foreign_key: 'owner_id'

  accepts_nested_attributes_for :user_ugroups, allow_destroy: true,
      reject_if: proc { |a| a[:ugroup_id].blank? }

  validates :name, presence: true
  validates :name, uniqueness: true

  after_save :reset_group
  after_destroy :delete_group

  def prompt(key)
    self.prompt_values[key] if self.prompt_values
  end

  def prompt=(newvalues)
    self.prompt_values = Hash.new if !prompt_values
    self.prompt_values = self.prompt_values.merge(newvalues)
  end

  def prompt_control(fields, route_ok, route_cancel)
    self.prompt_fields = fields
    self.prompt_ok = route_ok
    self.prompt_cancel = route_cancel
    self.save
  end

  #
  #  every individual entry is put into a group with the same name
  #
  private
  def reset_group

    old = Ugroup.where(name: name_was, private: true).first
    if old
      old.update_attributes(name: name)
    else
      new = Ugroup.create(name: name, private: true)
      UserUgroup.create(user: self, ugroup: new)
    end
    all = Ugroup.where(name: "All").first_or_create
    UserUgroup.where(user: self, ugroup: all).first_or_create

  end

  def delete_group
    u = Ugroup.where(name: name, private: true).first
    u.destroy if u
  end


end
