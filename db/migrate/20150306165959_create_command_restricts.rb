class CreateCommandRestricts < ActiveRecord::Migration
  def change
    create_table :command_restricts do |t|
      t.references :cgroup, index: true
      t.references :ugroup, index: true

      t.timestamps null: false
    end
    add_foreign_key :command_restricts, :cgroups
    add_foreign_key :command_restricts, :ugroups
  end
end
