ActiveAdmin.register Job do

  permit_params :id, :name, :jtype, :description, ugroup_ids:[] ,
        job_items_attributes: [:id, :job_id, :lgroup_id, :cgroup_id,
        :cache, :chart_type, :chart_x, :chart_y, :chart_opt, :_destroy]


  sidebar "Jobs" do
  end

  menu priority: 4

  filter :name
  filter :description
  filter :jtype, label: "Type", as: :select
  filter :cclass, label: "Class", as: :select
  filter :users, label: "User/favorite", as: :select
  filter :owner, label: "Owner", as: :select

  #
  #  show
  #
  show do "Jobs"
    attributes_table do
      row :name
      row :jtype, label: "Type"
      row :description
      panel "Commands" do
        table_for job.job_items do
          column "LPAR" do |jobitem|
            name_qual(Lgroup.find_by(id: jobitem.lgroup_id))
          end
          column "Command" do |jobitem|
            name_qual(Cgroup.find_by(id: jobitem.cgroup_id))
          end
          column :cache
          column :chart_type
          column :chart_x
          column :chart_y
          column :chart_opt
        end
      end
    end
  end

  #
  #  index
  #
  index do
    selectable_column
    column :name
    column "Type", :jtype
    column "Class", :cclass
    actions
  end

  #
  #  edit form
  #
  form do |f|
    f.semantic_errors *f.object.errors.keys
    inputs "Details" do
      input :name
      input :jtype, label: "Type", collection: ["Text", "Grid", "Chart"]
      input :cclass, label: "Class"
      input :users, label: "Users", as: :check_boxes
      input :description
    end
    f.inputs "Command" do
      f.has_many :job_items, heading: 'Items', allow_destroy: true, new_record: true do |a|
        a.input :cgroup_id, as: :select, collection: Cgroup.all, input_html: {class: 'chosen-select'},
        label: "Command", member_label: :qual
    #      collection: option_groups_from_collection_for_select(Command.all,
    #          :class_members, :cclass, :id, :name)
        a.input :lgroup_id, as: :select, collection: Lgroup.all, label: "LPAR",
    #    member_label: lambda {|g| "#{g.qual("","group: ")}" }
          member_label: :qual
          a.input :cache
          a.input :chart_type
          a.input :chart_x
          a.input :chart_y
          a.input :chart_opt
      end
    end
    actions
  end


end
