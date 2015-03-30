class CreateNotices < ActiveRecord::Migration
  def change
    create_table :notices do |t|
      t.text :title
      t.references :ugroup, index: true

      t.timestamps null: false
    end
    add_foreign_key :notices, :ugroups
  end
end
