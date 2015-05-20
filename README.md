# fme-sortable
A simple html5 angularjs directive for sorting lists via drag and drop

Tested with karma/chai/sinon
#Install
```
bower install fme-sortable
```

#Usage
Inject the module into your angular app
```js
angular.module('your-app',['fme-sortable']
```
Add the directive to an ng-repeat passing the list and index to the direct
```html
<ul>
  <li fme-sortable fme-list='list' fme-index='$index' ng-repeat='item in list'>{{list.name}}</li>
</ul>
```
