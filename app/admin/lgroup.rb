ActiveAdmin.register Lgroup do

  menu label: "LPAR Groups", parent: "LPARs"

  permit_params :id, :name, :description, :racf_group

  sidebar "LPAR Groups" do
  end

  #
  #  only show the true groups
  #
  scope_to do
    Class.new do
      def self.lgroups
        Lgroup.is_group
      end
    end
  end

  filter :name
  filter :lpars
  filter :description
  filter :lpar_restricts

  #
  # index
  #
  index do
    selectable_column
    column :name
    column "LPARs" do |lgroup|
      names_comma(lgroup.lpars)
    end
    actions
  end

  #
  #  show
  #
  show do |user|
    attributes_table do
      row :name, :input_html => { :size => 10 }
      row "LPARs" do |lgroup|
        names_comma(lgroup.lpars)
      end
      row :description, input_html: {:class => 'autogrow', :rows => 10, :cols => 20, :maxlength => 100 }
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
