class WelcomeController < ApplicationController

  def index
    if current_user
      @jobs = current_user.jobs
      @runs = current_user.runs
      @data={
        rows:[
          { id:1, data: ["A Time to Kill", "John Grisham", "100"]},
          { id:2, data: ["Blood and Smoke", "Stephen King", "1000"]},
          { id:3, data: ["The Rainmaker", "John Grisham", "-200"]}
        ]
        };
        @cols = "First name, Last name, Phone"
        @data2 = [
          ["A Time to Kill","John Grisham","100"],
          ["Blood and Smoke", "Stephen King", "1000"],
          ["The Rainmaker","John Grisham","-200"]
          ];
        end
      end

    end
