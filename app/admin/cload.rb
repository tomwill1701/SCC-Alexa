ActiveAdmin.register Cload do


  menu label: "Command Load", parent: "Commands"

  permit_params :id, :dsname, :lpar_id

  sidebar "Command Load" do
  end

  filter :dsname
  filter :lpar

  #
  # index
  #
  index do
    selectable_column
    column :dsname
    column :lpar
    actions
  end

  #
  #  show
  #
  show do |cload|
    attributes_table do
      row :dsname
      row :lpar
    end
  end

  #
  #  new/edit form
  #
  form do |f|
    inputs '' do
      input :dsname
      input :lpar
    end
    actions
  end

  action_item :view_site, only: :show do
    link_to "Load", load_admin_cload_path
  end
  action_item :view_site, only: :show do
    c = Cload.find(params[:id])
    link_to "Commands", admin_cload_cload_items_path(c)
  end

  #
  #  load members
  #
  member_action :load, method: :get do

    cload = Cload.find(params[:id])
    eg = ExecGroup.new
    eg.run_one("download+dsn(#{cload.dsname}) pds control", cload.lpar, current_user)

    #
    #  see if we have any prompts
    #
    if eg.prompts
      current_user.prompt_control(eg.prompts, load_admin_cload_path(cload), admin_cload_path(cload))
      current_user.save
      redirect_to prompt_show_path, flash: { manifesto_modal: true }
    else
      Cload.load(cload, eg.execs[0].rtext)
      redirect_to admin_cload_cload_items_path(cload)
    end

  end


end
