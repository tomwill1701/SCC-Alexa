class RunCommandSerializer < ActiveModel::Serializer

  attributes :id, :model, :status, :run_views

  def run_views
    object
      .run_views
      .map { |x| RunViewSerializer.new(x).as_json }
  end

end
