class CreateCgroups < ActiveRecord::Migration
  def change
    create_table :cgroups do |t|
      t.string :name
      t.text   :description
      t.boolean :private, default: false

      t.timestamps null: false
    end
  end
end
