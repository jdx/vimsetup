app = angular.module('vimsetupApp', ['ngRoute', 'ngResource'])

app.factory 'Plugin', ($resource) ->
  $resource 'plugins.json', {}, {
    query: { method: 'GET', isArray: true }
  }

app.controller 'pluginController', ($scope, Plugin) ->
  $scope.plugins = Plugin.query!

app.config ($route-provider, $location-provider) ->
  $route-provider.when '/' {
    templateUrl: 'pages/home.html'
    controller: 'pluginController'
  }
  $location-provider.html5Mode(true)
