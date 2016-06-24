# == Schema Information
#
# Table name: run_views
#
#  id             :integer          not null, primary key
#  name           :string
#  file           :string
#  file_type      :string
#  hide           :boolean          default(FALSE)
#  run_command_id :integer
#  run_id         :integer
#  job_item_id    :integer
#  command_id     :integer
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#

class RunViewSerializer < ActiveModel::Serializer

  attributes :id, :name, :file_url, :file_type, :view_url

  def view_url
    path = Rails.application.routes.url_helpers.run_view_path(object.id)
    return path
  end

end
