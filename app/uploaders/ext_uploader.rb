# encoding: utf-8

class ExtUploader < CarrierWave::Uploader::Base

  storage :fog

  def store_dir
    "scc/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end


end
