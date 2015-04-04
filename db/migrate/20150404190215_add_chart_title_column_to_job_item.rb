class AddChartTitleColumnToJobItem < ActiveRecord::Migration
  def change
    add_column :job_items, :chart_title, :string
  end
end
