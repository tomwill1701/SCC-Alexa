class RunViewSerializer < ActiveModel::Serializer

  attributes :id, :name, :file_url, :file_type, :view_url

  def view_url
    path = Rails.application.routes.url_helpers.run_view_path(object.id)
    return path
  end

end
