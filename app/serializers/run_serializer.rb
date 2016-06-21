class RunSerializer < ActiveModel::Serializer

  attributes :id, :error, :done, :name, :status, :error_text

  has_many :run_commands

end
