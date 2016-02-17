class AddFilestampToJob < ActiveRecord::Migration
  def change
    add_column :jobs, :ar_file_modified, :datetime
    add_column :runs, :file_delete, :string
  end
end
