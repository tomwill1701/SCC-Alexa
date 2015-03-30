class CreateJobs < ActiveRecord::Migration
  def change
    create_table :jobs do |t|
      t.string :name
      t.string :jtype
      t.text   :description
      t.string :menu
      t.string :cclass
      t.string :tags
      t.string :when
      t.string :when_time
      t.string :run_type
      t.boolean :background, default: false
      t.boolean :private, default: false
      t.boolean :notify_email, default: false
      t.boolean :notify_email_group, default: false
      t.boolean :notify_dash, default: false
      t.integer :owner_id

      t.timestamps null: false
    end
  end
end
