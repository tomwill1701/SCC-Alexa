ActiveAdmin.register User do

  permit_params :id, :name, :department, :phone, :email, :lpar_id,
        :racf_userid, :racf_group, :racf_password, :admin, :password,
        user_ugroups_attributes: [:id, :name, :user_id, :ugroup_id, :_destroy]


  sidebar "Users" do
  end

  menu priority: 1

  filter :name
  filter :ugroups, as: :select, label: "Group", collection: proc { Ugroup.is_group }
  filter :department, as: :select
  filter :racf_group
  filter :admin, as: :check_boxes

  #
  #  show
  #
  show do |user|
    attributes_table do
      row :name
      row :department
      row "Groups" do |user|
        names_comma(user.ugroups.is_group)
      end
      row :admin
      row :racf_userid
      row :racf_group
      row :lpar, label: "LPAR/Signon"
      row :phone
      row :email
    end
  end

  #
  #  index
  #
  index do
    selectable_column
    column :name
    column :department
    column :email
    column :admin
    actions
  end

  #
  #  edit form
  #
  form do |f|
    if params[:id]
      name = User.find(params[:id]).name
    else
      name = ""
    end
    f.semantic_errors *f.object.errors.keys
    inputs '' do
      input :name
      input :password
      input :lpar, label: "LPAR/Signon"
      input :admin
      input :department
      f.has_many :user_ugroups, allow_destroy: true do |ug|
        ug.input :ugroup, label: "Group", collection: Ugroup.is_group(name),
        member_label: lambda {|g| "#{g.qual("LOCKED-")}" }
      end
      input :racf_userid, label: "RACF Userid"
      input :racf_group, label: "RACF Group`"
      input :racf_password, label: "RACF Password"
      input :phone
      input :email
    end
    actions
  end

  #
  #  dont allow the first group to be deleted
  #
  controller do

    def update
      if params["user"]["user_ugroups_attributes"]
        params["user"]["user_ugroups_attributes"]["0"]["_destroy"] = false
      end
      super
    end

  end

end
