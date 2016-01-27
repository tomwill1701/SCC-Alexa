class AddArFileToJobs < ActiveRecord::Migration
  def change
    add_column :jobs, :ar_file, :string
    add_column :jobs, :ar_active, :boolean, default: false
  end
end
