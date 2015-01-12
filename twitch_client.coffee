# Request Twitch credentials for the user
# @param options {optional}
# @param credentialRequestCompleteCallback {Function} Callback function to call on
#   completion. Takes one argument, credentialToken on success, or Error on
#   error.
Twitch.requestCredential = (options, credentialRequestCompleteCallback) ->
  
  # support both (options, callback) and (callback).
  if not credentialRequestCompleteCallback and typeof options is "function"
    credentialRequestCompleteCallback = options
    options = {}
  config = ServiceConfiguration.configurations.findOne(service: "twitch")
  unless config
    credentialRequestCompleteCallback and credentialRequestCompleteCallback(new ServiceConfiguration.ConfigError())
    return
  credentialToken = Random.secret()
  scope = (options and options.requestPermissions) or []
  flatScope = _.map(scope, encodeURIComponent).join(" ")
  loginStyle = OAuth._loginStyle("twitch", config, options)
  loginUrl = "https://api.twitch.tv/kraken/oauth2/authorize?response_type=code&client_id=" + config.clientId + "&redirect_uri=" + OAuth._redirectUri("twitch", config) + "&scope=" + flatScope + "&state=" + OAuth._stateParam(loginStyle, credentialToken)

   # twitch box gets taller when permissions requested.
  height = 620
  height += 130  if _.without(scope, "basic").length
  OAuth.launchLogin
    loginService: "twitch"
    loginStyle: loginStyle
    loginUrl: loginUrl
    credentialRequestCompleteCallback: credentialRequestCompleteCallback
    credentialToken: credentialToken
    popupOptions:
      width: 900
      height: height

  return