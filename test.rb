require 'urbanairship'

UA = Urbanairship
cl = UA::Client.new(key: 'yu0NtsbAQZGyMlLRUV4Apw', secret:'SfrCSuZuRMyk34eV6SPtxA')

push = cl.create_push
push.audience = UA.and(
   UA.tag('tag1', group: "DTS")
)
push.notification = UA.notification(alert: 'BREAKING: Important news is 2')
push.device_types = UA.all
push.send_push
