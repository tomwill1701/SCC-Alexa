ActiveAdmin.register Lpar do

  permit_params :id, :name, :description, :ip, :port,
  :location, :zos_release, :racf_userid, :racf_group, :racf_password,
  :force_userid, :monproc,
  lpar_lgroups_attributes: [:id, :name, :lpar_id, :lgroup_id, :_destroy]


  sidebar "LPARs" do
  end

  menu label: "LPARs", priority: 3

  filter :name
  filter :lgroups, as: :select, label: "Group", collection: proc { Lgroup.is_group }
  filter :location, as: :select
  filter :subsystems
  filter :zos_release, as: :select
  filter :description


  #
  #  show
  #
  show do |user|
    attributes_table do
      row :name
      row "Groups" do |lpar|
        names_comma(lpar.lgroups.is_group)
      end
      row :ip
      row :port
      row :location
      row :monproc
      row :subsystems
      row :zos_release
      row :description
    end
  end

  #
  #  index
  #
  index do
    selectable_column
    column :name
    column :ip
    column :port
    column :location
    actions
  end

  #
  #  edit form
  #
  form do |f|
    if params[:id]
      name = Lpar.find(params[:id]).name
    else
      name = ""
    end
    f.semantic_errors *f.object.errors.keys
    inputs '' do
      input :name
      f.has_many :lpar_lgroups, allow_destroy: true do |ug|
        ug.input :lgroup, label: "Group", collection: Lgroup.is_group(name),
        member_label: lambda {|g| "#{g.qual("LOCKED-")}" }
      end
      input :ip
      input :port
      input :location
      input :monproc
      input :subsystems
      input :zos_release
      input :description
    end
    actions
  end


  #
  #  add test connection batch item
  #
  batch_action :destroy, false
  batch_action :test do |ids|
    ids.each do |ids|
      lpar = Lpar.find(ids)
      test_connection(lpar)
      lpar.status = "ok"
    end
    redirect_to admin_lpars_path, alert: "All LPARs are active"
  end


  #
  #  test connection option
  #
  action_item :view_site, only: :show do
    link_to "Test Connection", test_admin_lpar_path
  end

  #
  #  check dif status
  #
  member_action :test, method: :get do

    lpar = Lpar.find(params[:id])
    eg = test_connection(lpar, current_user)
    #
    #  see if the request failed and we have some prompts to do for a retry
    #
    if eg.prompts
      current_user.prompt_control(eg.prompts, test_admin_lpar_path(lpar), admin_lpar_path(lpar))
      current_user.save
      redirect_to prompt_show_path, flash: { manifesto_modal: true }
      return
    end

    if eg.errors
      redirect_to admin_lpar_path(lpar), notice: "Failed: #{eg.errors.join(" : ")}"
    else
      lines = eg.execs[0].rtext.split( /\r?\n/ )
      redirect_to admin_lpar_path(lpar), notice: "Success: #{lines[-1]}"
    end

  end

  controller do

    #
    #  dont allow the first group to be deleted
    #
    def update
      if params['lpar']['lpar_lgroups_attributes']
        params['lpar']['lpar_lgroups_attributes']['0']['_destroy'] = false
      end
      super
    end

    #
    #  send dif a status command
    #
    def test_connection(lpar, current_user)

      eg = ExecGroup.new
      eg.run_one('status', lpar, current_user)
      return eg

    end

  end



end
