class CreateCloaditems < ActiveRecord::Migration
  def change
    create_table :cload_items do |t|
      t.string :name
      t.text   :description
      t.string :source
      t.string :member
      t.text   :model
      t.string :keys
      t.string :ctype
      t.string :cclass
      t.string :tags
      t.string :prompts
      t.string :size
      t.string :chart_type
      t.string :chart_x
      t.string :chart_y
      t.text   :chart_opt
      t.string :status
      t.string :group
      t.string :preload
      t.integer :cache_time
      t.references :cload
      t.references :command

      t.timestamps null: false
    end
    add_foreign_key :cload_items, :cloads
    add_foreign_key :cload_items, :commands
  end
end
