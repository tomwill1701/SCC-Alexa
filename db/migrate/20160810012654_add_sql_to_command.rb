class AddSqlToCommand < ActiveRecord::Migration
  def change
    add_column :commands, :sql, :string
    add_column :commands, :sort_field, :string
    add_column :commands, :group_field, :string
    add_column :commands, :timeout, :string
    add_column :commands, :table_name, :string
    add_column :commands, :dbtype, :string
  end
end
