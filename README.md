# fme-sortable
A simple html5 angularjs directive for sorting lists via drag and drop

Tested with karma/chai/sinon
#Install
```
bower install fme-sortable
```
Inject the module into your angular app
```js
angular.module('your-app',['fme-sortable'])
```

#Usage
Add the directive to an ng-repeat passing the list and index to the direct
```html
<ul>
  <li fme-sortable fme-list='list' fme-index='$index' ng-repeat='item in list'>{{list.name}}</li>
</ul>
```

#Additional Options
##fme-on-drop
Callback triggered after dropping the item
```html
<ul>
  <li fme-sortable fme-list='list' fme-index='$index' fme-on-drop='myOnDropFunction()' ng-repeat='item in list'>{{list.name}}</li>
</ul>
```
##fme-not-sortable
Callback triggered after dropping the item
```html
<ul>
  <li fme-sortable fme-list='list' fme-index='$index' fme-not-sortable='myFunctionToDetermineIfThingsAreNotSortable()' ng-repeat='item in list'>{{list.name}}</li>
</ul>
```
