# == Schema Information
#
# Table name: commands
#
#  id          :integer          not null, primary key
#  name        :string
#  description :text
#  ctype       :string
#  model       :text
#  file        :string
#  prompts     :string
#  variables   :string
#  source      :string
#  member      :string
#  keys        :string
#  size        :string
#  chart_type  :string
#  chart_x     :string
#  chart_y     :string
#  chart_opt   :text
#  cclass      :string
#  tags        :string
#  preload     :string
#  cache_time  :integer          default("0")
#  rscript     :text
#  vscript     :text
#  hide        :boolean          default("false")
#  data_type   :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class Command < ActiveRecord::Base

  has_many :command_cgroups, dependent: :destroy
  has_many :cgroups, through: :command_cgroups, dependent: :destroy
  has_many :run_views, dependent: :destroy
  has_many :run_commands, dependent: :destroy

  validates :name, :ctype, presence: true
  validates :name, :uniqueness => {:scope => [:ctype, :chart_type]}

  accepts_nested_attributes_for :command_cgroups, allow_destroy: true,
      reject_if: proc { |a| a[:cgroup_id].blank? }

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
  end


  def delete_group
    l = Cgroup.where(name: name, private: true).first
    l.destroy if l
  end

end
