class CreateRunViews < ActiveRecord::Migration
  def change
    create_table :run_views do |t|
      t.string :type
      t.string :file
      t.string :file_type
      t.references :run_command, index: true
      t.references :command, index: true
      t.references :job_item, index: true

      t.timestamps null: false
    end
    add_foreign_key :run_views, :run_commands
    add_foreign_key :run_views, :commands
    add_foreign_key :run_views, :job_items
  end
end
