ActiveAdmin.register Run do


  menu label: "Runs", priority: 5

  menu priority: 4

  filter :job
  filter :ugroup
  filter :error
  filter :done
  filter :status
  filter :log

  #
  #  show
  #
  show do "Runs"
    attributes_table do
      row :job
      row :ugroup
      row :error
      row :done
      row :status
      row :log
      panel "Commands" do
        table_for run.run_commands do |rc|
          column :lpar
          column :command
          column :model
#          panel "Views" do
#            table_for rc.run_views do
#              column :command
#              column :job_item
#            end
#          end
        end
      end
    end

  end

end
