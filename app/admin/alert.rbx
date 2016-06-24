ActiveAdmin.register Alert do

permit_params :id, :device_id, :alert_type

sidebar "Alerts" do
end


filter :device_id
filter :alert_type

#
#  show
#
show do |alert|
  attributes_table do
    row :device_id
    row :alert_type
  end
end

#
#  index
#
index do
  selectable_column
  column :device_id
  column :alert_type
  actions
end

#
#  edit form
#
form do |f|
  f.semantic_errors *f.object.errors.keys
  inputs '' do
    input :device_id
    input :alert_type
  end
  actions
end

end
