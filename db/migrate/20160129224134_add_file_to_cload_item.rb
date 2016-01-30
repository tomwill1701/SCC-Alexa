class AddFileToCloadItem < ActiveRecord::Migration
  def change
    add_column :cload_items, :file, :string
  end
end
