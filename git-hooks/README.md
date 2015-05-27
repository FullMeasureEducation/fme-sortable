##USAGE

You really only need these if you are developing on the fme-sortable directive

```mv git-hooks .git/hooks/.```

you may need to run chmod +x against each of these files

##What it does
- Before every commit the pre-commit script runs the karma tests, moves a coverage report to the root directory, compiles the coffescript. 

- Immediately after every commit the post-commit script appends the files changed by the pre-commit script  to the previous commit 

- After every pull it runs npm install and bower install if their respective json files have changed