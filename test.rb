require 'urbanairship'

UA = Urbanairship
cl = UA::Client.new(key: 'yu0NtsbAQZGyMlLRUV4Apw', secret:'SfrCSuZuRMyk34eV6SPtxA')

push = cl.create_push
push.audience = UA.and(
   UA.tag('tag1', group: "DTS2")
)
push.notification = UA.notification(alert: 'BREAKING: Important news')
push.device_types = UA.all
push.send_push
