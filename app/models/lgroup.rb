# == Schema Information
#
# Table name: lgroups
#
#  id          :integer          not null, primary key
#  name        :string
#  description :text
#  sysplex     :boolean          default(FALSE)
#  private     :boolean          default(FALSE)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class Lgroup < ActiveRecord::Base

  has_many :lpar_lgroups, dependent: :destroy
  has_many :lpars, through: :lpar_lgroups, dependent: :destroy

  has_many :lpar_restricts, dependent: :destroy

  has_many :job_items, dependent: :destroy
  has_many :jobs, through: :jobitems, dependent: :destroy

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
