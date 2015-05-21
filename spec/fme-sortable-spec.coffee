#= require spec_helper.coffee

describe 'fmeSortable', ->
  beforeEach inject ($rootScope, $compile, $timeout) ->
    @timeout = $timeout
    @scope = $rootScope.$new()
    @compile = $compile
    @scope.fmeOnDrop = ->
      false
    @scope.sortable = ->
      false
    @scope.array_of_models = [{name:'test1'},{name:'test2'},{name:'test3'}]
    @element = angular.element("<ul><li id='item_{{$index}}' fme-sortable='true'  index='$index' list='array_of_models'  ng-repeat='model in array_of_models' on-drop='onDrop()'>{{model.name}}</li></ul>")

    @element_not_sortable = angular.element("<ul><li id='item_not_sortable_{{$index}}' fme-sortable='true'  index='$index' list='array_of_models'  ng-repeat='model in array_of_models' on-drop='onDrop()' not-sortable='!sortable()'>{{model.name}}</li></ul>")
    
  
  afterEach ->
    @element.remove()
    @element_not_sortable.remove()

  describe 'draggableAttr', ->
    it 'is draggable by default', ->
      @compile(@element)(@scope);
      @scope.$digest()
      element_has_draggable_attribute = false
      angular.forEach @element[0].children[0].attributes, (attribute,key) ->
        if attribute['name'] is 'draggable'
          element_has_draggable_attribute = true
      expect(element_has_draggable_attribute).to.be.true

    it 'is not draggable if it is marked not sortable', ->
      @compile(@element_not_sortable)(@scope);
      @scope.$digest()
      element_has_draggable_attribute = false
      angular.forEach @element_not_sortable[0].children[0].attributes, (attribute,key) ->
        if attribute['name'] is 'draggable'
          element_has_draggable_attribute = true
      expect(element_has_draggable_attribute).to.be.false

  describe 'dragstart', ->
    it 'makes the index available to the event handler for future use during draghover, drop, etc', ->
      mockEvent = $.Event('dragstart')
      mockEvent.originalEvent = {dataTransfer:{setData: (type,data)-> true}}
      sinon.stub(mockEvent.originalEvent.dataTransfer,'setData')
      
      @element.appendTo('body')
      @compile(@element)(@scope);
      @scope.$digest()

      first_item = @element.find('li:first')
      first_item.triggerHandler(mockEvent)
      expect(mockEvent.originalEvent.dataTransfer.setData).to.be.called
      mockEvent.originalEvent.dataTransfer.setData.restore()

  describe 'dragover', ->
    it 'prevents the default browser action and tells the event to set the drop effect to move', ->
      mockEvent = $.Event('dragover')
      mockEvent.originalEvent = {dataTransfer:{dropEffect: 'something'}}
      sinon.stub(mockEvent,'preventDefault')
      
      
      @element.appendTo('body')
      @compile(@element)(@scope);
      @scope.$digest()

      first_item = @element.find('li:first')
      first_item.triggerHandler(mockEvent)
      expect(mockEvent.preventDefault).to.be.called
      expect(mockEvent.originalEvent.dataTransfer.dropEffect).to.eq('move')
      expect(first_item.hasClass('dropzone')).to.be.true
      
      mockEvent.preventDefault.restore()

    it 'does not set the drop effect when it is the element being dragged', ->
      mockDragStartEvent = $.Event('dragstart')
      mockDragStartEvent.originalEvent = {dataTransfer:{setData: (type,data)-> true}}
      sinon.stub(mockDragStartEvent.originalEvent.dataTransfer,'setData')

      mockDragOverEvent = $.Event('dragover')
      mockDragOverEvent.originalEvent = {dataTransfer:{dropEffect: 'something'}}
      sinon.stub(mockDragOverEvent,'preventDefault')
      
      @element.appendTo('body')
      @compile(@element)(@scope);
      @scope.digest

      first_item = @element.find('li:first')
      first_item.triggerHandler(mockDragStartEvent)
      first_item.triggerHandler(mockDragOverEvent)

      expect(mockDragOverEvent.originalEvent.dataTransfer.dropEffect).not.to.eq('move')
  describe 'dragleave', ->
    it 'removes the dropzone class from the item', ->
      mockDragOverEvent = $.Event('dragover')
      mockDragOverEvent.originalEvent = {dataTransfer:{dropEffect: 'something'}}
      sinon.stub(mockDragOverEvent,'preventDefault')
      
      @element.appendTo('body')
      @compile(@element)(@scope);
      @scope.$digest()

      first_item = @element.find('li:first')
      first_item.triggerHandler(mockDragOverEvent)
      expect(first_item.hasClass('dropzone')).to.be.true

      mockDragLeaveEvent = $.Event('dragleave')
      first_item.triggerHandler(mockDragLeaveEvent)
      expect(first_item.hasClass('dropzone')).to.be.false

      mockDragOverEvent.preventDefault.restore()

  describe 'drop', ->
    context 'when the first item is dropped on the last item', ->
      it 'reorders the model array such that the first item is last and the last item is second to last {1,2,3} => {2,3,1}', ->
        mockDropEvent = $.Event('drop')
        mockDropEvent.originalEvent = {dataTransfer:{getData: (type)-> true}}
        sinon.stub(mockDropEvent.originalEvent.dataTransfer,'getData').returns('0')
        sinon.stub(@scope,'fmeOnDrop')
        
        @element.appendTo('body')
        @compile(@element)(@scope);
        @scope.$digest()

        last_item = @element.find('li:last')
        last_item.triggerHandler(mockDropEvent)
        @timeout.flush()
        expect(last_item.hasClass('dropzone')).to.be.false
        expect(@scope.fmeOnDrop).to.be.called
        expect(@scope.array_of_models[0].name).to.equal('test2')
        expect(@scope.array_of_models[1].name).to.equal('test3')
        expect(@scope.array_of_models[2].name).to.equal('test1')
        @scope.fmeOnDrop.restore()
        mockDropEvent.originalEvent.dataTransfer.getData.restore()

    context 'when the last item is dropped on the first item', ->
      it 'reorders the model array such that the last item is first and the first item is second {1,2,3} => {3,1,2}', ->
        mockDropEvent = $.Event('drop')
        mockDropEvent.originalEvent = {dataTransfer:{getData: (type)-> true}}
        sinon.stub(mockDropEvent.originalEvent.dataTransfer,'getData').returns('2')
        sinon.stub(@scope,'fmeOnDrop')
        
        @element.appendTo('body')
        @compile(@element)(@scope);
        @scope.$digest()

        first_item = @element.find('li:first')
        first_item.triggerHandler(mockDropEvent)
        @timeout.flush()
        expect(first_item.hasClass('dropzone')).to.be.false
        expect(@scope.fmeOnDrop).to.be.called
        expect(@scope.array_of_models[0].name).to.equal('test3')
        expect(@scope.array_of_models[1].name).to.equal('test1')
        expect(@scope.array_of_models[2].name).to.equal('test2')
        @scope.fmeOnDrop.restore()
        mockDropEvent.originalEvent.dataTransfer.getData.restore()
