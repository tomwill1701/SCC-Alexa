class CreateJobitems < ActiveRecord::Migration
  def change
    create_table :job_items do |t|
      t.references :job
      t.references :lgroup
      t.references :cgroup
      t.string     :size
      t.string     :chart_type
      t.string     :chart_x
      t.string     :chart_y
      t.string     :chart_opt
      t.string     :chart_title
      t.string     :racf_password
      t.string     :command_prefix
      t.string     :command_suffix

      t.timestamps null: false
    end
    add_foreign_key :job_items, :jobs
  end
end
