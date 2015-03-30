class CreateLparLgroups < ActiveRecord::Migration
  def change
    create_table :lpar_lgroups do |t|
      t.references :lpar, index: true
      t.references :lgroup, index: true

      t.timestamps null: false
    end
    add_foreign_key :lpar_lgroups, :lpars
    add_foreign_key :lpar_lgroups, :lgroups
  end
end
