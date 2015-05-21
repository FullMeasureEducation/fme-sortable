#= require bower_components/jQuery/dist/jquery.js
#= require bower_components/angular/angular.js
#= require bower_components/angular/angular-mocks.js
#= require node_modules/karma-sinon/index.js
#= require node_modules/karma-sinon-chai/index.js

window.mock_window_service =
  confirm: ->
  alert: ->
  open: ->
  document:
    getElementById: ->
    height: ->
  location:
    href: 'hello'
    reload: ->
  sessionStorage:
    clear: ->
    removeItem: ->
    setItem: ->
    getItem: ->

document.mock_document_service = 
  height: ->

beforeEach ->
  module('fme-sortable')
  angular.module('foo', []).config ($provide) ->
    $provide.value '$window',         window.mock_window_service
    $provide.value '$document',         document.mock_document_service
  module 'foo'
