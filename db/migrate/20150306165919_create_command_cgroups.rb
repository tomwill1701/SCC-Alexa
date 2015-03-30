class CreateCommandCgroups < ActiveRecord::Migration
  def change
    create_table :command_cgroups do |t|
      t.references :command, index: true
      t.references :cgroup, index: true

      t.timestamps null: false
    end
    add_foreign_key :command_cgroups, :commands
    add_foreign_key :command_cgroups, :cgroups
  end
end
