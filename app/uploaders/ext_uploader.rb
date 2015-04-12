# encoding: utf-8

class ExtUploader < CarrierWave::Uploader::Base

  storage :fog

  def store_dir
    "pdf/"
  end


end
