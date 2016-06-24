# == Schema Information
#
# Table name: run_commands
#
#  id            :integer          not null, primary key
#  model         :text
#  rtext         :text
#  done          :boolean          default(FALSE)
#  error         :boolean          default(FALSE)
#  add_lpar      :boolean          default(FALSE)
#  error_text    :string
#  status        :string
#  source        :string
#  data_acquired :datetime
#  cloud         :boolean          default(FALSE)
#  compressed    :boolean          default(FALSE)
#  merge_grid    :boolean          default(FALSE)
#  download      :boolean          default(FALSE)
#  hide          :boolean          default(FALSE)
#  run_id        :integer
#  lpar_id       :integer
#  job_item_id   :integer
#  command_id    :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

class RunCommandSerializer < ActiveModel::Serializer

  attributes :id, :model, :status, :run_views

  def run_views
    object
      .run_views
      .map { |x| RunViewSerializer.new(x).as_json }
  end

end
