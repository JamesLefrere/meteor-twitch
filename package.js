Package.describe({
  name: "jameslefrere:twitch",
  summary: "Twitch API integration for Meteor",
  version: "0.1.0",
  git: "https://github.com/JamesLefrere/meteor-twitch.git"
});

Package.onUse(function(api) {
  api.versionsFrom("METEOR@1.0");
  api.use([
    "coffeescript",
    "accounts-base",
    "accounts-oauth2-helper",
    "http"
    ], ["client", "server"]);
  api.use("templating", "client");
  api.addFiles("twitch_globals.js", ["client", "server"]);
  api.addFiles([
    "twitch_client.coffee",
    "twitch_configure.coffee",
    "twitch_configure.html"
    ], "client");
  api.addFiles("twitch_common.coffee", ["client", "server"]);
  api.addFiles("twitch_server.coffee", "server");
});
