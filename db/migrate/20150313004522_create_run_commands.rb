class CreateRunCommands < ActiveRecord::Migration
  def change
    create_table :run_commands do |t|
      t.text :model
      t.text :rtext
      t.boolean :done, default: false
      t.boolean :error, default: false
      t.boolean :add_lpar, default: false
      t.string  :error_text
      t.string :status
      t.string :source
      t.datetime :data_acquired
      t.boolean :cloud, default: false
      t.boolean :compressed, default: false
      t.boolean :merge_grid, default: false
      t.boolean :download, default: false
      t.boolean :hide, default: false
      t.references :run, index: true
      t.references :lpar, index: true
      t.references :job_item, index: true
      t.references :command, index: true

      t.timestamps null: false
    end
    add_foreign_key :run_commands, :runs
    add_foreign_key :run_commands, :lpars
    add_foreign_key :run_commands, :job_items
    add_foreign_key :run_commands, :commands
  end
end
