class CreateLparRestricts < ActiveRecord::Migration
  def change
    create_table :lpar_restricts do |t|
      t.references :lgroup, index: true
      t.references :ugroup, index: true

      t.timestamps null: false
    end
    add_foreign_key :lpar_restricts, :lgroups
    add_foreign_key :lpar_restricts, :ugroups
  end
end
