ActiveAdmin.register Cgroup do


  menu label: "Command Groups", parent: "Commands"

  permit_params :id, :name, :description

  sidebar "Command Groups" do
  end

  #
  #  only show the true groups
  #
  scope_to do
    Class.new do
      def self.cgroups
        Cgroup.is_group
      end
    end
  end

  filter :name
  filter :description
  filter :command_restricts

  #
  # index
  #
  index do
    selectable_column
    column :name
    column "Commands" do |cgroup|
      names_comma(cgroup.commands)
    end
    actions
  end

  #
  #  show
  #
  show do |command|
    attributes_table do
      row :name, :input_html => { :size => 10 }
      row :description, input_html: {:class => 'autogrow', :rows => 10, :cols => 20, :maxlength => 100 }
      row "Commands" do |cgroup|
        names_comma(cgroup.commands)
      end
    end
  end

  #
  #  new/edit form
  #
  form do |f|
    inputs '' do
      input :name
      input :description
    end
    actions
  end


end
