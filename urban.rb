require 'urbanairship'

UA = Urbanairship
#cl = UA::Client.new(key: 'yu0NtsbAQZGyMlLRUV4Apw', secret:'SfrCSuZuRMyk34eV6SPtxA')
cl = UA::Client.new(key: 'jPwPvdPPTCW-iwuloYqWCQ', secret:'n_hHWZIWQb-N2Q07WIRR9A')

push = cl.create_push
push.audience = UA.and(
   UA.tag('test', group: "DTS")
)
push.notification = UA.notification(alert: 'BREAKING: Important news')
push.device_types = UA.all
push.send_push
