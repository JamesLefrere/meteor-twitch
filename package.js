Package.describe({
  name: "jameslefrere:twitch",
  summary: "Twitch API integration for Meteor",
  version: "0.1.0",
  git: "https://github.com/JamesLefrere/meteor-twitch.git"
});

Package.onUse(function(api) {
  api.versionsFrom("METEOR@1.0");
  api.use("http", "server");
  api.use([
    "coffeescript",
    "oauth2",
    "oauth",
    "underscore",
    "service-configuration"
    ], ["client", "server"]);
  api.use([
    "templating",
    "random"
    ], "client");
  api.addFiles("twitch_globals.js", ["client", "server"]);
  api.addFiles([
    "twitch_client.coffee",
    "twitch_configure.html",
    "twitch_configure.coffee"
    ], "client");
  api.export("Twitch");
  api.addFiles("twitch_server.coffee", "server");
});
