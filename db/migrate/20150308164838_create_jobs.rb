class CreateJobs < ActiveRecord::Migration
  def change
    create_table :jobs do |t|
      t.string :name
      t.string :jgroup, default: "Job"
      t.string :jtype
      t.text   :description
      t.string :menu
      t.string :cclass
      t.string :tags
      t.string :run_type
      t.integer :keep_days
      t.boolean :private, default: false
      t.boolean :notify, default: true
      t.boolean :notify_group, default: true
      t.boolean :cache, default: true
      t.boolean :debug, default: true
      t.integer :owner_id
      t.datetime :ar_start
      t.date :ar_start_date
      t.time :ar_start_time
      t.string :ar_type
      t.string :ar_repeat
      t.string :ar_hour
      t.string :ar_wday
      t.string :ar_day
      t.string :ar_month
      t.string :ar_wdayt


      t.timestamps null: false
    end
  end
end
