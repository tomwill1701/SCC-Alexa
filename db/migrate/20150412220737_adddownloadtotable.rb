class Adddownloadtotable < ActiveRecord::Migration
  def change
    add_column :run_commands, :download, :boolean
    add_column :run_commands, :hide, :boolean
    add_column :run_views, :hide, :boolean
    add_column :commands, :hide, :boolean
  end
end
