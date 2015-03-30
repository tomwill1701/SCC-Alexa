ActiveAdmin.register Command do

  permit_params :id, :name, :description, :source,
        :ctype, :model, :prompts, :keys, :tags, :cclass, :preload,
        :chart_type, :chart_x, :chart_y, :chart_opt, :cache_time,
        command_cgroups_attributes: [:id, :name, :command_id, :cgroup_id, :_destroy]

  sidebar "Commands" do
  end

  menu label: "Commands", priority: 4

  filter :name
  filter :ctype, as: :select, label: "Type", collection: Command.ctypes.keys
  filter :cclass, as: :select, label: "Class"
  filter :cgroups, as: :select, label: "Group", collection: proc { Cgroup.is_group }
  filter :source, as: :select
  filter :tags
  filter :keys
  filter :prompts
  filter :chart_type, as: :select, collection: Command.chart_types.keys
  filter :preload
  filter :description

  #
  #  show
  #
  show do |command|
    attributes_table do
      row :name
      row "Groups" do |command|
        names_comma(command.cgroups.is_group)
      end
      row :data_source_type
      row "Type", :ctype
      row "Class", :cclass
      row :source
      row :tags
      row :model
      row :prompts
      row :keys
      row :chart_type
      row :chart_x
      row :chart_y
      row :chart_opt
      row :cache_time
      row :preload
      row :description
    end
  end

  #
  #  index
  #
  index do
    selectable_column
    column :name
    column "Type", :ctype
    column "Class", :cclass
    column :source
    column :tags
    actions
  end

  #
  #  edit form
  #
  form do |f|
    if params[:id]
      name = Command.find(params[:id]).name
    else
      name = ""
    end
    f.semantic_errors *f.object.errors.keys
    inputs '' do
      input :name
      f.has_many :command_cgroups, allow_destroy: true do |ug|
        ug.input :cgroup, label: "Group", collection: Cgroup.is_group(name),
        member_label: lambda {|g| "#{g.qual("LOCKED-")}" }
      end
      input :ctype, label: "Type", as: :select, collection: Command.ctypes.keys
      input :cclass, label: "Class"
      input :tags
      input :model, input_html: {rows: 4}
      input :prompts
      input :keys
      input :chart_type, as: :select, collection: Command.chart_types.keys
      input :chart_x
      input :chart_y
      input :chart_opt, input_html: {rows: 2}
      input :cache_time
      input :preload
      input :source
      input :description
    end
    actions
  end

  #
  #  dont allow the first group to be deleted
  #
  controller do

    def update
      if params["command"]["command_cgroups_attributes"]
        params["command"]["command_cgroups_attributes"]["0"]["_destroy"] = false
      end
      super
    end

  end


end
