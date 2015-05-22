angular.module('fme-sortable', [])
.directive 'fmeSortable' , ($log, $timeout) ->
  restrict: 'A'
  scope:
    fmeList: '='
    fmeIndex: '='
    fmeOnDrop: '&'
    fmeNotSortable: '&'
  link: (scope, element, attrs) ->
    unless scope.fmeNotSortable()
      element.attr('draggable', 'true')
      dragging_index = null

      element.on 'dragstart' , (event) ->
        dragging_index = scope.fmeIndex
        event.originalEvent.dataTransfer.setData('text/plain', dragging_index)

      element.on 'dragover', (event) ->
        event.originalEvent.preventDefault()
        unless scope.fmeIndex is dragging_index
          element.addClass('dropzone')
          event.originalEvent.dataTransfer.dropEffect = 'move'

      element.on 'dragleave', (event) ->
        element.removeClass('dropzone')

      element.on 'drop', (event) ->
        dropped_fmeIndex = event.originalEvent.dataTransfer.getData('text/plain')
        dropped_model = scope.fmeList[dropped_fmeIndex]
        element.removeClass('dropzone')
        #timeout needed see http://stackoverflow.com/questions/19391773/angularjs-parent-scope-not-updated-in-directive-with-isolated-scope-two-way-b
        $timeout ->
          scope.fmeList.splice(dropped_fmeIndex,1)
          scope.fmeList.splice(scope.fmeIndex,0,dropped_model)
          scope.fmeOnDrop()