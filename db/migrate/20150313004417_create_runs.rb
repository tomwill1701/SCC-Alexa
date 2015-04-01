class CreateRuns < ActiveRecord::Migration
  def change
    create_table :runs do |t|
      t.boolean :background, default: true
      t.boolean :cache, default: true
      t.boolean :error, default: false
      t.boolean :done, default: false
      t.boolean :notify, default: false
      t.boolean :cache, default: true
      t.string  :status
      t.string  :error_text
      t.text    :log
      t.integer :total_data
      t.datetime :start
      t.datetime :end
      t.datetime :viewed
      t.datetime :delete_at
      t.references :ugroup, index: true
      t.references :job, index: true
      t.references :user, index: true

      t.timestamps null: false
    end
  end
end
