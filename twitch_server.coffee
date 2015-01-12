OAuth.registerService "twitch", 2, null, (query) ->
  accessToken = getAccessToken(query)
  identity = getIdentity(accessToken)
  serviceData:
    id: identity.id
    accessToken: OAuth.sealSecret(accessToken)
    email: identity.email
    username: identity.login

  options:
    profile:
      name: identity.name


getAccessToken = (query) ->
  console.log "getAccessToken"
  config = ServiceConfiguration.configurations.findOne(service: "twitch")
  throw new ServiceConfiguration.ConfigError()  unless config
  response = undefined
  try
    response = HTTP.post("https://api.twitch.tv/kraken/oauth2/token",
      headers: Accept: "application/json"
      params:
        code: query.code
        client_id: config.clientId
        client_secret: OAuth.openSecret(config.secret)
        grant_type: "authorization_code"
        redirect_uri: OAuth._redirectUri("twitch", config)
        state: query.state
    )
  catch err
    throw _.extend(new Error("Failed to complete OAuth handshake with Twitch. " + err.message),
      response: err.response
    )
  if response.data.error # if the http response was a json object with an error attribute
    throw new Error("Failed to complete OAuth handshake with Twitch. " + response.data.error)
  else
    console.log "received", response.data.access_token
    return response.data.access_token
  return

getIdentity = (accessToken) ->
  console.log "getIdentity"
  console.log "Access token: ", accessToken
  config = ServiceConfiguration.configurations.findOne(service: "twitch")
  throw new ServiceConfiguration.ConfigError()  unless config
  response = undefined
  try
    response = HTTP.get("https://api.twitch.tv/kraken/user",
      headers: Accept: "application/json"
      params:
        client_id: config.clientId
        access_token: accessToken
        oauth_token: accessToken
    )
    return response.data
  catch err
    console.log response
    throw _.extend(new Error("Failed to fetch identity from Twitch. " + err.message),
      response: err.response
    )
  return

Twitch.retrieveCredential = (credentialToken, credentialSecret) ->
  OAuth.retrieveCredential credentialToken, credentialSecret