class CreateCloads < ActiveRecord::Migration
  def change
    create_table :cloads do |t|
      t.string :dsname
      t.string :volser
      t.references :lpar, index: true
      t.timestamps null: false
    end
    add_foreign_key :cloads, :lpars
  end
end
