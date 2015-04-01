ActiveAdmin.register Run do


  menu label: "Runs", priority: 5

  menu priority: 4

  actions :all, except: [:new]

  filter :job
  filter :user
  filter :ugroup
  filter :background
  filter :error
  filter :done
  filter :status
  filter :log
  filter :start
  filter :end
  filter :viewed
  filter :delete_at

  #
  #  show
  #
  show do "Runs"
    attributes_table do
      row :job
      row :user
      row :ugroup
      row :error
      row :done
      row :status
      row :log
      row :start
      row :end
      row :viewed
      row :delete_at
      panel "Commands" do
        table_for run.run_commands do |rc|
          column :lpar
          column :command
          column :model
          column :done
          column :error
          column :error_textc
          column :source
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
