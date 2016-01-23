ActiveAdmin.register Command do

  permit_params :id, :name, :description, :source,
        :ctype, :model, :prompts, :keys, :tags, :cclass, :preload, :file,
        :chart_type, :chart_x, :chart_y, :chart_opt, :cache_time, :size, :hide,
        command_cgroups_attributes: [:id, :name, :command_id, :cgroup_id, :_destroy]

  sidebar "Commands" do
  end

  menu label: "Commands", priority: 4

  filter :name
  filter :ctype, as: :select, label: "Type"
  filter :cclass, as: :select, label: "Class"
  filter :cgroups, as: :select, label: "Group", collection: proc { Cgroup.is_group }
  filter :source, as: :select
  filter :hide
  filter :tags
  filter :keys
  filter :prompts
  filter :chart_type, as: :select
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
      row :file
      row :hide
      row :prompts
      row :keys
      row :size
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
    column :chart_type
    column "Class", :cclass
    column :source
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
        member_label: lambda {|g| "#{g.qual("LOCKED-","")}" }
      end
      input :ctype, label: "Type", as: :select,
        collection:  ["DIFCmd", "MVSCmd", "Grid", "Chart", "External", "XML"]
      input :cclass, label: "Class"
      input :tags
      input :model, input_html: {rows: 6}
      input :file
      input :hide
      input :prompts
      input :keys
      input :size
      input :chart_type, as: :select,
        collection: ["Pie", "Bar", "StackedBar", "Line", "Gauge", "Area", "Candle", "Bubble",
          "Column", "Combo", "Scatter", "Spark"]
      input :chart_x
      input :chart_y
      input :chart_opt, input_html: {rows: 2}
      input :cache_time, label: "Cache time (min)"
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
