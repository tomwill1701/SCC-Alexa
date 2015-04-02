class CreateRunViews < ActiveRecord::Migration
  def change
    create_table :run_views do |t|
      t.string     :type
      t.string     :file
      t.string     :file_type
      t.references :run_command, index: true
      t.references :run, index: true
      t.references :job_item, index: true
      t.references :command, index: true

      t.timestamps null: false
    end
    add_foreign_key :run_views, :run_commands
    add_foreign_key :run_views, :runs
    add_foreign_key :run_views, :job_items
    add_foreign_key :run_views, :commands
  end
end
