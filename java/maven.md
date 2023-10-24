## Update dependency
```sh
mvn versions:use-next-releases
# or
mvn versions:use-latest-releases
```

## Download javadoc (for hover)
```sh
mvn dependency:resolve -Dclassifier=javadoc
```