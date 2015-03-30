class CreateLgroups < ActiveRecord::Migration
  def change
    create_table :lgroups do |t|
      t.string :name
      t.text   :description
      t.boolean :sysplex, default: false
      t.boolean :private, default: false

      t.timestamps null: false
    end
  end
end
