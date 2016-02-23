ActiveAdmin.register CloadItem do

  belongs_to :cload
  config.paginate = false

  actions :index, :show

  scope :all, default: true
  scope("New") { |scope| scope.where(status: "New") }
  scope("Replace") { |scope| scope.where(status: "Replace") }
  scope("Error") { |scope| scope.where(status: "Error") }
  scope("Missing") { |scope| scope.where(status: "Missing") }

  sidebar "Command Load Items" do
  end

  filter :ctype, as: :select, label: "Type"
  filter :cclass, as: :select, label: "Class"
  filter :tags
  filter :keys
  filter :prompts
  filter :chart_type, as: :select
  filter :preload
  filter :description

  #
  # index
  #
  index do
    selectable_column
    column :status
    column :name
    column :member
    column "Type", :ctype
    column "Class", :cclass
    actions do |ci|
      link_to "Accept", accept_admin_cload_cload_item_path(ci.cload_id, ci.id),
          class: "member_link", method: :post
    end
  end

  #
  #  show
  #
  show do |cload|
    attributes_table do
      row :name
      row :member
      row :model
      row :file
      row :keys
      row "Type", :ctype
      row "Class", :cclass
      row :group
      row :tags
      row :prompts
      row :size
      row :chart_type
      row :chart_x
      row :chart_y
      row :chart_opt
      row :status
      row :preload
      row :description
    end
  end

  #
  #  new/edit form
  #
  form do |f|
    inputs '' do
      input :name
      input :member
      input :model, input_html: {rows: 4}
      input :file
      input :keys
      input :ctype, label: "Type", as: :select,
        collection: ["DIFCmd", "MVSCmd", "Grid", "Chart", "External", "XML", "CSV", "Data"]
      input :cclass, label: "Class"
      input :tags
      input :size
      input :prompts
      input :chart_type, as: :select,
        collection: ["Pie", "Bar", "Line", "Gage"]
      input :chart_x
      input :chart_y
      input :chart_opt, input_html: {rows: 2}
      input :status
      input :preload
      input :batch
      input :description
    end
    actions
  end

  #
  #  add accept item to batch
  #
  batch_action :accept do |ids|
    cli = ""
    ids.each do |ids|
      cli = CloadItem.find(ids)
      CloadItem.update_command(cli)
    end
    redirect_to admin_cload_cload_items_path(cli.cload_id), alert: "All items accepted"
  end

  #
  #  do accept option on index
  #
  member_action :accept, method: :post do
    cli = CloadItem.find(params[:id])
    CloadItem.update_command(cli)
    redirect_to admin_cload_cload_items_path(cli.cload_id)
  end

end
