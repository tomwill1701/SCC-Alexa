class CreateUserJob < ActiveRecord::Migration
  def change
    create_table :user_jobs do |t|
      t.references :user, index: true
      t.references :job, index: true
    end
    add_foreign_key :user_jobs, :users
    add_foreign_key :user_jobs, :jobs
  end
end
