class CreateCommands < ActiveRecord::Migration
  def change
    create_table :commands do |t|
      t.string :name
      t.text   :description
      t.string :ctype
      t.text   :model
      t.string :prompts
      t.string :source
      t.string :member
      t.string :keys
      t.string :size
      t.string :chart_type
      t.string :chart_x
      t.string :chart_y
      t.text   :chart_opt
      t.string :cclass
      t.string :tags
      t.string :preload
      t.integer :cache_time, default: 0
      t.text   :rscript
      t.text   :vscript

      t.timestamps null: false
    end
  end
end
