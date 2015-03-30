class CreateRuns < ActiveRecord::Migration
  def change
    create_table :runs do |t|
      t.boolean :background, default: false
      t.boolean :error, default: false
      t.boolean :done, default: false
      t.string  :status
      t.string  :error_text
      t.text    :log
      t.datetime :start
      t.datetime :end
      t.datetime :viewed_at
      t.datetime :delete_at
      t.references :ugroup, index: true
      t.references :job, index: true
      t.references :user, index: true

      t.timestamps null: false
    end
  end
end
