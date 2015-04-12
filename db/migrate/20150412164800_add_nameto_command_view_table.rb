class AddNametoCommandViewTable < ActiveRecord::Migration
  def change
    add_column :run_views, :name, :string
  end
end
