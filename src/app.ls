app = angular.module('vimsetupApp', ['ngRoute'])

app.controller 'pluginController', ($scope) ->
  $scope.name = "obar!?"

app.config ($route-provider, $location-provider) ->
  $route-provider.when '/' {
    templateUrl: 'pages/home.html'
    controller: 'pluginController'
  }
  $location-provider.html5Mode(true)
