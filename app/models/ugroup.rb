# == Schema Information
#
# Table name: ugroups
#
#  id          :integer          not null, primary key
#  name        :string
#  description :text
#  racf_group  :string
#  private     :boolean          default(FALSE)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class Ugroup < ActiveRecord::Base

  has_many :user_ugroups, dependent: :destroy
  has_many :users, through: :user_ugroups

  has_many :command_restricts, dependent: :destroy
  has_many :lpar_restricts, dependent: :destroy

  has_many :runs, dependent: :destroy
  has_many :notices, dependent: :destroy

  scope :is_group, lambda {|name =  nil| where("private = false or name = '#{name}'") }
  scope :is_private, -> { where(private: true) }

  validates :name, presence: true

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
