# == Schema Information
#
# Table name: cgroups
#
#  id          :integer          not null, primary key
#  name        :string
#  description :text
#  private     :boolean          default("false")
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class Cgroup < ActiveRecord::Base

  has_many :command_cgroups, dependent: :destroy
  has_many :commands, through: :command_cgroups, dependent: :destroy

  has_many :command_restricts, dependent: :destroy

  has_many :job_items, dependent: :destroy
  has_many :jobs, through: :jobitems

  scope :is_group, lambda {|name =  nil| where("private = false or name = '#{name}'") }
  scope :is_private, -> { where(private: true) }

  #
  #  add to object name based on group or individual
  #
  def qual(u = "", g = "GROUP: ")
    if private
      return u + name
    else
      return g + name
    end
  end

end
