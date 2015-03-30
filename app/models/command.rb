# == Schema Information
#
# Table name: commands
#
#  id          :integer          not null, primary key
#  name        :string
#  description :text
#  ctype       :integer
#  model       :text
#  prompts     :string
#  source      :string
#  member      :string
#  keys        :string
#  chart_type  :integer
#  chart_x     :string
#  chart_y     :string
#  chart_opt   :text
#  cclass      :string
#  tags        :string
#  preload     :string
#  cache_time  :integer
#  rscript     :text
#  vscript     :text
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class Command < ActiveRecord::Base

  has_many :command_cgroups, dependent: :destroy
  has_many :cgroups, through: :command_cgroups

  validates :name, :ctype, presence: true
  validates :name, :uniqueness => {:scope => [:ctype, :chart_type]}

  accepts_nested_attributes_for :command_cgroups, allow_destroy: true,
      reject_if: proc { |a| a[:cgroup_id].blank? }

  enum ctype: [:DIFCmd, :MVSCmd, :Grid, :Chart, :External, :REXXCmd, :MONCmd]
  enum chart_type: [:Bar, :Pie, :Gage, :Line]

  after_save :reset_group
  after_destroy :delete_group


  #
  #  return class list of commands for a class name
  #
  def class_members
    Command.where(cclass: self.cclass)
  end

  #
  #  every individual entry is put into a group with the same name
  #
  private
  def reset_group

    old = Cgroup.where(name: name_was, private: true).first
    if old
      old.update_attributes(name: name)
    else
      new = Cgroup.create(name: name, private: true)
      CommandCgroup.create(command: self, cgroup: new)
    end
    all = Cgroup.where(name: "All").first_or_create
    CommandCgroup.where(command: self, cgroup: all).first_or_create
  end


  def delete_group
    l = Cgroup.where(name: name, private: true).first
    l.destroy if l
  end

end
