class CreateAlerts < ActiveRecord::Migration
  def change
    create_table :alerts do |t|
      t.string :device_id
      t.string :alert_type

      t.timestamps null: false
    end
  end
end
