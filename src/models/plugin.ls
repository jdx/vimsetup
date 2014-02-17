module.exports.all = ->
  return Ember.$.getJSON 'http://vimsetup.com/plugins'

module.exports.get = (params) ->
  return Ember.$.getJSON "http://vimsetup.com/plugins/#{params.author}/#{params.name}/readme"
