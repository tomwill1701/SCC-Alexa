# encoding: utf-8

class ExtUploader < CarrierWave::Uploader::Base

  if Rails.env.production?
    storage :fog
  else
    storage :file
  # assets_host = ENV['SERVER_IP']
  end

  def store_dir
    "scc/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end


end
