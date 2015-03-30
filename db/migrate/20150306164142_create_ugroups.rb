class CreateUgroups < ActiveRecord::Migration
  def change
    create_table :ugroups do |t|
      t.string :name
      t.text   :description
      t.string :racf_group
      t.boolean :private, default: false

      t.timestamps null: false
    end
  end
end
