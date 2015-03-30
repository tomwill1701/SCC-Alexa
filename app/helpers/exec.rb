class Exec

  attr_accessor :lpar, :cmd, :errors, :rtext, :bad_passward
  attr_accessor :connect_time, :response_code, :rlength, :command

  def initialize
    self.rlength = 0
    self.rtext = String.new
  end


end
