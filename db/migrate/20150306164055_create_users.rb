class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :username
      t.string :name
      t.string :department
      t.string :phone
      t.string :email
      t.string :racf_userid
      t.string :racf_group
      t.string :racf_password
      t.boolean :admin, default: false
      t.string :password_digest
      t.datetime :last_login
      t.integer :login_count, default: 0
      t.string :background
      t.string :notify
      t.string :cache
      t.string :prompt_ok
      t.string :prompt_cancel
      t.string :prompt_values
      t.string :prompt_fields
      t.references :lpar, index: true
      t.references :command, index: true
      t.references :job, index: true
      t.references :ugroup, index: true

      t.timestamps null: false
    end
  end
end
