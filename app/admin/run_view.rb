ActiveAdmin.register RunView do

  permit_params :id, :file, :file_type

  menu label: "Run Views", parent: "Runs"


end
