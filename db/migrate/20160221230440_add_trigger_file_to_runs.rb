class AddTriggerFileToRuns < ActiveRecord::Migration
  def change
    add_column :runs, :file_trigger, :string
  end
end
