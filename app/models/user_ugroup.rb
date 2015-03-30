# == Schema Information
#
# Table name: user_ugroups
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  ugroup_id  :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class UserUgroup < ActiveRecord::Base

  belongs_to :user, required: true
  belongs_to :ugroup, required: true

  validates :ugroup_id, :uniqueness => {:scope => :user_id}

end
