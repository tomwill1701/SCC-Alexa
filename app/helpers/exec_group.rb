
class ExecGroup

  attr_accessor :execs, :errors, :requests, :prompts, :current_user

  def initialize
    @execs = Array.new
    @request = Array.new
  end

  def run_one(cmd, lpar, current_user)

    e = Exec.new
    e.lpar = lpar
    e.cmd = cmd
    self.execs << e
    self.current_user = current_user
    self.run(current_user)

  end

  #
  #  build request and put it on the queue
  #
  def run(current_user)
    hydra = Typhoeus::Hydra.new
    execs.each do |e|

      lpar = e.lpar
      userid = current_user.prompt("Userid")
      password = current_user.prompt("Password")
      userid = current_user.racf_userid if !userid
      password = current_user.racf_password if !password

      req = Typhoeus::Request.new("http://#{lpar.ip}:#{lpar.port}/#{e.cmd}".gsub(' ','+'),
          userpwd: "#{userid}:#{password}" )
      hydra.queue(req)
      @request << req

      #
      #  wait for some data
      #
      req.on_body do |chunk|
        e.rtext = e.rtext + chunk
        e.rlength = e.rtext.length
      end

    end

    #
    #  run all requests
    #
    hydra.run

    #
    #  look at each response
    #
    @request.each_with_index do |request, x|
      response = request.response
      exec = execs[x]
      exec.connect_time = response.connect_time
      exec.response_code = response.code

      if response.success?
        exec.rtext.sub!('<html><body><pre>','')

      elsif response.timed_out?
        add_error("#{exec.lpar.name}: request time out")

        #
        #  prompt for userid/password
        #
        elsif response.code == 401
          bad_password = true
          @prompts = ["Userid", "Password"]
        elsif response.code == 0
          add_error(response.return_message)
        else
          add_error("#{exec.lpar.name}: HTTP request failed with " + response.code.to_s)
        end
      end
    end

    def add_error(text)
      self.errors ||= Array.new
      self.errors << text
    end

end
