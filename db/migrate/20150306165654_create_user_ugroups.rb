class CreateUserUgroups < ActiveRecord::Migration
  def change
    create_table :user_ugroups do |t|
      t.references :user, index: true
      t.references :ugroup, index: true

      t.timestamps null: false
    end
    add_foreign_key :user_ugroups, :users
    add_foreign_key :user_ugroups, :ugroups
  end
end
