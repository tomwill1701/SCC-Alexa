# == Schema Information
#
# Table name: lpars
#
#  id          :integer          not null, primary key
#  name        :string
#  description :text
#  ip          :string
#  port        :integer
#  location    :string
#  zos_release :string
#  subsystems  :string
#  monproc     :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class Lpar < ActiveRecord::Base

  attr_accessor :status

  has_many :lpar_lgroups, dependent: :destroy
  has_many :lgroups, through: :lpar_lgroups
  has_many :cloads, dependent: :destroy

  validates :name, :ip, :port, presence: true

  after_save :reset_group
  after_destroy :delete_group

  accepts_nested_attributes_for :lpar_lgroups, allow_destroy: true,
      reject_if: proc { |a| a[:lgroup_id].blank? }


  #
  #  every individual entry is put into a group with the same name
  #
  private
  def reset_group

    old = Lgroup.where(name: name_was, private: true).first
    if old
      old.update_attributes(name: name)
    else
      new = Lgroup.create(name: name, private: true)
      LparLgroup.create(lpar: self, lgroup: new)
    end
    all = Lgroup.where(name: "All").first_or_create
    LparLgroup.where(lpar: self, lgroup: all).first_or_create
  end


  def delete_group
    l = Lgroup.where(name: name, private: true).first
    l.destroy if l
  end


end
