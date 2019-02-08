curl --request POST \
  --url https://dtsscc.auth0.com/oauth/token \
  --header 'content-type: application/json' \
  --data '{"client_id":"tk4cVxqEJtC0qbxIEZVLr9FYmXSBdeP2","client_secret":"LqsVMS2VkMqEAHP4wrB23X1UUJ4OcB5D1EhLksJuFU82PvYCGEkK0WGNXglK7rKV","audience":"https://sccdemo.com/alexa/api","grant_type":"client_credentials","email":"tom@dtssoftware.com"}'
  
  
curl --request POST \
  --url https://96d135ac.ngrok.io/api/alexa/handler/ \
  --header 'authorization: Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiIsImtpZCI6IlFVWkZPVVkwUVRVeVJFWkROVGxCTlVFME5FVkRSVEJFUkVWRk1FVkRNRFV4UVVNMVJUVTNNdyJ9.eyJpc3MiOiJodHRwczovL2R0c3NjYy5hdXRoMC5jb20vIiwic3ViIjoidGs0Y1Z4cUVKdEMwcWJ4SUVaVkxyOUZZbVhTQmRlUDJAY2xpZW50cyIsImF1ZCI6Imh0dHBzOi8vc2NjZGVtby5jb20vYWxleGEvYXBpIiwiaWF0IjoxNTQ5NDAzNjQ3LCJleHAiOjE1NDk0OTAwNDcsImF6cCI6InRrNGNWeHFFSnRDMHFieElFWlZMcjlGWW1YU0JkZVAyIiwiZ3R5IjoiY2xpZW50LWNyZWRlbnRpYWxzIn0.kup8hvZPuU5NwUGb4eGynvtc9zWSiGeW1UZmio71dSgSred6c1Jyi-xXywFjyTY9Pa_UoDB5JIvtgamSkGLVPP1rZ97dt1fSpcvxkdJr8SYEVpidsk4tYGdpAB25a3ZDi8-1i0IfnXSAvvKD97TWp-CX7SgIILUcO5ikcpW8osF9jY5XEUx3jz9EYLUPIyWMc24rKs8Djlmqh74QtYYgU_G1zyocGw3XbX-oYTsIl9ajB_HeXjKIh-I_wHh7dld147Ule19__T15vHm5zygHZoq9YtyMWUhbNWNZbEwQiih-Jo5bgfR7rYxxuTt_ixb73db5ZNmTBrHBICl5Ocll0w'
  
    