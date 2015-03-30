class CreateLpars < ActiveRecord::Migration
  def change
    create_table :lpars do |t|
      t.string :name
      t.text   :description
      t.string :ip
      t.integer :port
      t.string :location
      t.string :zos_release
      t.string :subsystems
      t.string :monproc

      t.timestamps null: false
    end
    add_foreign_key :users, :lpars
  end
end
