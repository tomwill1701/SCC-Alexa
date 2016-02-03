class Exec

  attr_accessor :lpar, :cmd, :errors, :rtext, :bad_passward
  attr_accessor :connect_time, :response_code, :rlength, :command
  attr_accessor :file, :filename, :xmlfile

  def initialize
    self.rlength = 0
    self.rtext = String.new
  end

  #
  #  if this is a dataset download then set parms
  #
  def cmd=(str)
    @cmd = str.strip
    if str[0..3] == "FILE"
      oper = str.split(' ',3)
      self.filename = Rails.root.to_s + "/tmp/" + oper[1]
      @cmd = oper[2]
    end
  end


end
