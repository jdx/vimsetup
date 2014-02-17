app = require './app'
plugin = require './models/plugin'

app.Router.reopen location: 'history'

app.Router.map ->
  this.resource 'author', path: '/:author', ->
    this.resource 'plugin', path: '/:name'
  this.resource 'home' path: '/'

app.HomeRoute = Ember.Route.extend {
  model: plugin.all
}

app.PluginRoute = Ember.Route.extend {
  model: plugin.get
}
