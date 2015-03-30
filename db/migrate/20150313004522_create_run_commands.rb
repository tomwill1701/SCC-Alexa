class CreateRunCommands < ActiveRecord::Migration
  def change
    create_table :run_commands do |t|
      t.text :model
      t.text :rtext
      t.boolean :done, default: false
      t.boolean :error, default: false
      t.boolean :grid, default: false
      t.string  :error_text
      t.string :status
      t.string :source
      t.datetime :data_acquired
      t.references :run, index: true
      t.references :lpar, index: true
      t.references :command, index: true

      t.timestamps null: false
    end
    add_foreign_key :run_commands, :runs
    add_foreign_key :run_commands, :lpars
    add_foreign_key :run_commands, :commands
  end
end
