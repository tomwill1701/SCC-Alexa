
#
#  there is a problem with ransack when a paramater is passed to a scope
#  if the value is 0  or 1 it is converted to true/false and the scope call will
#  fail with a missing parameter.
#
#  so to get around this problem we will create a dummy user that will never be used
#  this will make all the real users have an id > 1
#

  User.create(username: "dummy", name: "dummy", racf_userid: "x", password: "x")
  User.create(username: "tom", name: "tom", racf_userid: "TOM", admin: true, password: "tom")
  User.create(username: "joe", name: "joe", racf_userid: "TOM", admin: true, password: "joe")
  User.create(username: "sam", name: "sam", racf_userid: "TOM", admin: true, password: "sam")
  User.find_by(name: "dummy").destroy

  Lpar.where(name: "Iron", ip: "192.168.128.110", port: 10).first_or_create
  Lpar.where(name: "DTS-MP3000", ip: "mail1.dtssoftware.com", port: 10, monproc: "MONRUNM").first_or_create
  Lpar.where(name: "DTS-zPdt", ip: "mail1.dtssoftware.com", port: 20).first_or_create

  Cload.where(dsname: "TOM.SCC.CLOAD", lpar_id: 2).first_or_create
  Cload.where(dsname: "TOM.DCC.CLOAD", lpar_id: 2).first_or_create
  Cload.where(dsname: "TOM.MVS.CLOAD", lpar_id: 2).first_or_create

  jtype = ["Text", "Grid", "Chart"]
  cclass = ["class1", "class2", "class3", "class4"]
  tag = ["tag1 tag2", "tag3", "tag4"]

  0.times do |x|
      job = Job.create(name: Faker::Lorem.characters(30),
        description: Faker::Lorem.sentences(rand(2...4)).join(" "),
        jtype: jtype[rand(0..2)], cclass: cclass[rand(0..3)],
        tags: tag[rand(0..2)] )
      user = User.find(rand(2..4))
      UserJob.create(user: user, job: job)
  end