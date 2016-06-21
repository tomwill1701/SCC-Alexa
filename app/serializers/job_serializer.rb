class JobSerializer < ActiveModel::Serializer

  attributes :id, :name, :description, :cclass, :jgroup, :jtype

  has_many :runs

end
