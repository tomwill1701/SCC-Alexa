# == Schema Information
#
# Table name: cload_items
#
#  id          :integer          not null, primary key
#  name        :string
#  description :text
#  source      :string
#  member      :string
#  model       :text
#  keys        :string
#  ctype       :string
#  cclass      :string
#  tags        :string
#  prompts     :string
#  size        :string
#  chart_type  :string
#  chart_x     :string
#  chart_y     :string
#  chart_opt   :text
#  status      :string
#  group       :string
#  preload     :string
#  tab         :string
#  env         :string
#  prompt      :string
#  related     :string
#  cache_time  :integer
#  file        :string
#  hide        :boolean          default(FALSE)
#  cload_id    :integer
#  command_id  :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class CloadItem < ActiveRecord::Base

  belongs_to :cload
  belongs_to :command

  validates :cload_id, presence: true

  #
  #  create or update the command table entry using the cload_item info
  #
  def self.update_command(cli)

    hash = cli.attributes
    hash.delete("id")
    hash.delete("cload_id")
    hash.delete("command_id")
    hash.delete("status")
    hash.delete("batch")
    hash.delete("group")
    hash["source"] = cli["source"]
    # puts hash.inspect

    c = Command.find_by(name: cli.name)

    if c
      c.update(hash)
      cli.update(status: "Replaced")
    else
      c = Command.create(hash)
      cli.update(status: "Added")
    end

    if cli["group"]
      cg = Cgroup.find_or_create_by(name: cli["group"])
    # cg.commands << c
      CommandCgroup.find_or_create_by(command:c, cgroup: cg)
    end

  end


end
