# fme-sortable
A simple html5/angularjs directive for sorting lists via drag and drop

Tested with karma/chai/sinon
#Install
```
bower install fme-sortable
```
Inject the module into your angular app
```js
angular.module('your-app',['fme-sortable'])
```
#Developer Info
- git hooks do not git pushed to github
- So, run 
``` cp git-hooks/. .git/hooks/. ```
- Don't forget to run ```npm install and bower install```
- when you are happy with everything submit a new tag ```git tag -a v1.0.2 -m 'Added new callback for onDragStart'``` ```git --tags push origin --tags```
  - This is necessary to get your changes when the users run bower install or bower update 
#Usage
Add the directive to an ng-repeat passing the list and index to the direct
```html
<ul>
  <li fme-sortable fme-list='list' 
      fme-index='$index' 
      ng-repeat='item in list'>
      {{list.name}}
  </li>
</ul>
```

#Additional Options
##fme-on-drop
Callback triggered after dropping the item
```html
<ul>
  <li fme-sortable 
      fme-list='list' 
      fme-index='$index' 
      fme-on-drop='myOnDropFunction()'
      ng-repeat='item in list'>
      {{list.name}}
  </li>
</ul>
```
##fme-not-sortable
Callback triggered after dropping the item
```html
<ul>
  <li fme-sortable 
      fme-list='list' 
      fme-index='$index' 
      fme-not-sortable='myFunctionToDetermineIfThingsAreNotSortable()' 
      ng-repeat='item in list'>
      {{list.name}}
  </li>
</ul>
```

##Run the tests locally
  - Install HomeBrew
    ```ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"```
  - Install npm
    ```brew install node```
  - Install Karma
    ```npm install karma```
  - Run Karma tests
    ```karma start karma.conf.js```
