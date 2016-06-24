# == Schema Information
#
# Table name: alerts
#
#  id         :integer          not null, primary key
#  device_id  :string
#  alert_type :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Alert < ActiveRecord::Base
end
