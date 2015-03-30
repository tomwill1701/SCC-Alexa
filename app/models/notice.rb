# == Schema Information
#
# Table name: notices
#
#  id         :integer          not null, primary key
#  title      :text
#  ugroup_id  :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Notice < ActiveRecord::Base

  belongs_to :ugroup

end
