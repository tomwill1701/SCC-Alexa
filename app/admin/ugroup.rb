ActiveAdmin.register Ugroup do

  permit_params :id, :name, :description, :racf_group

  sidebar "User Groups" do
  end

  #
  #  only show the true groups
  #
  scope_to do
    Class.new do
      def self.ugroups
        Ugroup.is_group
      end
    end
  end

  menu label: "User Groups", parent: "Users"

  filter :name
  filter :users
  filter :description
  filter :racf_group
  filter :command_restricts
  filter :lpar_restricts

  #
  # index
  #
  index do
    selectable_column
    column :name
    actions
  end

  #
  #  show
  #
  show do |user|
    attributes_table do
      row :name, :input_html => { :size => 10 }
      row :description, input_html: {:class => 'autogrow', :rows => 10, :cols => 20, :maxlength => 100 }
      row "Users" do |ugroup|
        names_comma(ugroup.users)
      end
    end
  end

  #
  #  new/edit form
  #
  form do |f|
    inputs '' do
      input :name, :input_html => { :class => "text-capitalize" }
      input :description
      input :racf_group
    end
    actions
  end

end
