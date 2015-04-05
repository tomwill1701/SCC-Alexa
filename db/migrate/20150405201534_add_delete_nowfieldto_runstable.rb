class AddDeleteNowfieldtoRunstable < ActiveRecord::Migration
  def change
    add_column :runs, :delete_when, :string
  end
end
