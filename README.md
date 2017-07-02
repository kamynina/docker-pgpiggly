# Code coverage for Piggly
[![Build Status](https://travis-ci.org/kamynina/docker-pgpiggly.svg?branch=master)](https://travis-ci.org/kamynina/docker-pgpiggly)

Image for getting code coverage of PL/pgsql stored procedures

# How generate report?

1. Trace
```
docker run --rm kamynina/pgpiggly -c trace -h 172.17.0.2 -u example -d example -w example
```
2. Run your tests
3. Generate report and untrace
```
docker run --rm -v /tmp/result:/var/piggly/result kamynina/pgpiggly -c report -h 172.17.0.2 -u example -d example -w example
```
All results put at ```/var/piggly/result``` at container