class CreateRunViews < ActiveRecord::Migration
  def change
    create_table :run_views do |t|
      t.string :type
      t.string :file
      t.string :file_type
      t.string :size
      t.string :chart_type
      t.string :chart_x
      t.string :chart_y
      t.string :chart_opt
      t.references :run_command, index: true
      t.references :command, index: true
      t.references :run, index: true

      t.timestamps null: false
    end
    add_foreign_key :run_views, :run_commands
    add_foreign_key :run_views, :commands
    add_foreign_key :run_views, :runs
  end
end
