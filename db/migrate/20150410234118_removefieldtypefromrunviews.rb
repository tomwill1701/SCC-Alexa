class Removefieldtypefromrunviews < ActiveRecord::Migration
  def change
    remove_column :run_views, :type
  end
end
