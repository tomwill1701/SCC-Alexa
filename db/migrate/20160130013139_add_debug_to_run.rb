class AddDebugToRun < ActiveRecord::Migration
  def change
    add_column :runs, :debug, :boolean
  end
end
