class AddSqlToCloadItems < ActiveRecord::Migration
  def change
    add_column :cload_items, :sql, :string
    add_column :cload_items, :sort_field, :string
    add_column :cload_items, :group_field, :string
    add_column :cload_items, :timeout, :string
    add_column :cload_items, :table_name, :string
    add_column :cload_items, :dbtype, :string
  end
end
