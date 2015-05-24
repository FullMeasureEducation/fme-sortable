#= require spec_helper.coffee
describe 'fmeSortable', ->
  beforeEach inject ($rootScope, $compile, $timeout) ->
    @timeout = $timeout
    @scope = $rootScope.$new()
    @compile = $compile
    @scope.onDrop = ->
      false
    @scope.sortable = ->
      false
    @scope.array_of_models = [{name:'test1'},{name:'test2'},{name:'test3'}]
    @element = angular.element("<ul><li id='item_{{$index}}' fme-sortable='true'  fme-index='$index' fme-list='array_of_models'  ng-repeat='model in array_of_models' fme-on-drop='onDrop()'>{{model.name}}</li></ul>")
    @compile(@element)(@scope);
    @scope.$digest()

    @element_not_sortable = angular.element("<ul><li id='item_not_sortable_{{$index}}' fme-sortable='true' fme-index='$index' fme-list='array_of_models'  ng-repeat='model in array_of_models' on-drop='onDrop()' fme-not-sortable='!sortable()'>{{model.name}}</li></ul>")
    @compile(@element_not_sortable)(@scope);
    @scope.$digest()  
  
  afterEach ->
    @element.remove()
    @element_not_sortable.remove()

  describe 'draggableAttr', ->
    it 'is draggable by default', ->
      
      element_has_draggable_attribute = false
      angular.forEach @element[0].children[0].attributes, (attribute,key) ->
        if attribute['name'] is 'draggable'
          element_has_draggable_attribute = true
      expect(element_has_draggable_attribute).to.be.true

    it 'is not draggable if it is marked not sortable', ->
      
      element_has_draggable_attribute = false
      angular.forEach @element_not_sortable[0].children[0].attributes, (attribute,key) ->
        if attribute['name'] is 'draggable'
          element_has_draggable_attribute = true
      expect(element_has_draggable_attribute).to.be.false

  describe 'dragstart', ->
    context 'when the event is fired by jquery it uses event.originalEvent',->
      it 'makes the index available to the event handler for future use during draghover, drop, etc', ->

        mockEvent = $.Event('dragstart')
        
        mockEvent.originalEvent = {dataTransfer:{setData: (type,data)-> true}}
        sinon.stub(mockEvent.originalEvent.dataTransfer,'setData')
        
        @element.find('li:first').triggerHandler(mockEvent)
        expect(mockEvent.originalEvent.dataTransfer.setData).to.be.called
        mockEvent.originalEvent.dataTransfer.setData.restore()

    context 'when the event is NOT fired by jquery it uses event',->
      it 'makes the index available to the event handler for future use during draghover, drop, etc', ->

        mockEvent = $.Event('dragstart')
        
        mockEvent.dataTransfer = {setData: (type,data)-> true}
        sinon.stub(mockEvent.dataTransfer,'setData')
        
        @element.find('li:first').triggerHandler(mockEvent)
        expect(mockEvent.dataTransfer.setData).to.be.called
        mockEvent.dataTransfer.setData.restore()

  describe 'dragover', ->
    context 'when the event is fired by jquery it uses event.originalEvent',->
      it 'prevents the default browser action and tells the event to set the drop effect to move', ->
        mockEvent = $.Event('dragover')
        mockEvent.originalEvent = {dataTransfer: {dropEffect: 'something'}}
        sinon.stub(mockEvent,'preventDefault')

        @element.find('li:first').triggerHandler(mockEvent)
        expect(mockEvent.preventDefault).to.be.called
        expect(mockEvent.originalEvent.dataTransfer.dropEffect).to.eq('move')
        expect(@element.find('li:first').hasClass('dropzone')).to.be.true
        
        mockEvent.preventDefault.restore()
    context 'when the event is NOT fired by jquery it uses event',->
      it 'prevents the default browser action and tells the event to set the drop effect to move', ->
        mockEvent = $.Event('dragover')
        mockEvent.dataTransfer = {dropEffect: 'something'}
        sinon.stub(mockEvent,'preventDefault')

        @element.find('li:first').triggerHandler(mockEvent)
        expect(mockEvent.preventDefault).to.be.called
        expect(mockEvent.dataTransfer.dropEffect).to.eq('move')
        expect(@element.find('li:first').hasClass('dropzone')).to.be.true
        
        mockEvent.preventDefault.restore()

    it 'does not set the drop effect when it is the element being dragged', ->
      mockDragStartEvent = $.Event('dragstart')
      mockDragStartEvent.dataTransfer = {setData: (type,data)-> true}
      sinon.stub(mockDragStartEvent.dataTransfer,'setData')

      mockDragOverEvent = $.Event('dragover')
      mockDragOverEvent.dataTransfer = {dropEffect: 'something'}
      sinon.stub(mockDragOverEvent,'preventDefault')
      
      

      @element.find('li:first').triggerHandler(mockDragStartEvent)
      @element.find('li:first').triggerHandler(mockDragOverEvent)

      expect(mockDragOverEvent.dataTransfer.dropEffect).not.to.eq('move')
  describe 'dragleave', ->
    it 'removes the dropzone class from the item', ->
      mockDragOverEvent = $.Event('dragover')
      mockDragOverEvent.dataTransfer = {dropEffect: 'something'}
      sinon.stub(mockDragOverEvent,'preventDefault')
      

      @element.find('li:first').triggerHandler(mockDragOverEvent)
      expect(@element.find('li:first').hasClass('dropzone')).to.be.true

      mockDragLeaveEvent = $.Event('dragleave')
      @element.find('li:first').triggerHandler(mockDragLeaveEvent)
      expect(@element.find('li:first').hasClass('dropzone')).to.be.false

      mockDragOverEvent.preventDefault.restore()

  describe 'drop', ->
    context 'when the first item is dropped on the last item', ->
      it 'reorders the model array such that the first item is last and the last item is second to last {1,2,3} => {2,3,1}', ->
        mockDropEvent = $.Event('drop')
        mockDropEvent.originalEvent = {dataTransfer: {getData: (type)-> true}}
        sinon.stub(mockDropEvent.originalEvent.dataTransfer,'getData').returns('0')
        sinon.stub(@scope,'onDrop')
        

        @element.find('li:last').triggerHandler(mockDropEvent)
        @timeout.flush()
        expect(@element.find('li:last').hasClass('dropzone')).to.be.false
        expect(@scope.onDrop).to.be.called
        expect(@scope.array_of_models[0].name).to.equal('test2')
        expect(@scope.array_of_models[1].name).to.equal('test3')
        expect(@scope.array_of_models[2].name).to.equal('test1')
        @scope.onDrop.restore()
        mockDropEvent.originalEvent.dataTransfer.getData.restore()

    context 'when the last item is dropped on the first item', ->
      it 'reorders the model array such that the last item is first and the first item is second {1,2,3} => {3,1,2}', ->
        mockDropEvent = $.Event('drop')
        mockDropEvent.dataTransfer = {getData: (type)-> true}
        sinon.stub(mockDropEvent.dataTransfer,'getData').returns('2')
        sinon.stub(@scope,'onDrop')
        

        @element.find('li:first').triggerHandler(mockDropEvent)
        @timeout.flush()
        expect(@element.find('li:first').hasClass('dropzone')).to.be.false
        expect(@scope.onDrop).to.be.called
        expect(@scope.array_of_models[0].name).to.equal('test3')
        expect(@scope.array_of_models[1].name).to.equal('test1')
        expect(@scope.array_of_models[2].name).to.equal('test2')
        @scope.onDrop.restore()
        mockDropEvent.dataTransfer.getData.restore()
