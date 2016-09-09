angular.module('fme-sortable', [])
.directive 'fmeSortable' , ($log, $timeout) ->
  restrict: 'A'
  scope:
    fmeList: '='
    fmeIndex: '='
    fmeOnDrop: '&'
    fmeNotSortable: '&'
  link: (scope, element) ->
    unless scope.fmeNotSortable()
      element.attr('draggable', 'true')
      dragging_index = null

      element.on 'dragstart' , (event) ->
        dragging_index = scope.fmeIndex
        e = if event.originalEvent? then event.originalEvent else event
        e.dataTransfer.setData('text/plain', dragging_index)

      element.on 'dragover', (event) ->
        e = if event.originalEvent? then event.originalEvent else event
        event.preventDefault()
        unless scope.fmeIndex is dragging_index
          element.addClass('dropzone')
          e.dataTransfer.dropEffect = 'move'

      element.on 'dragleave', ->
        element.removeClass('dropzone')

      element.on 'drop', (event) ->
        e = if event.originalEvent? then event.originalEvent else event
        dropped_fmeIndex = e.dataTransfer.getData('text/plain')
        dropped_model = scope.fmeList[dropped_fmeIndex]
        element.removeClass('dropzone')
        $timeout ->
          scope.fmeList.splice(dropped_fmeIndex, 1)
          scope.fmeList.splice(scope.fmeIndex, 0, dropped_model)
          scope.fmeOnDrop()
