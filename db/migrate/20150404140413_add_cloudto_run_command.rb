class AddCloudtoRunCommand < ActiveRecord::Migration
  def change
    change_table :run_commands do |t|
      t.boolean :cloud
    end
  end
end
