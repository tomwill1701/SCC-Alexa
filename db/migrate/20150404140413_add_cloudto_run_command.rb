class AddCloudtoRunCommand < ActiveRecord::Migration
  def change
    change_table :run_commands do |t|
      t.boolean :cloud, default: :false
      t.boolean :compressed, default: false
    end
  end
end
