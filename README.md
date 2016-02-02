#puppet-elasticsearch

Puppet manifest to install and configure elasticsearch

## This module has been deprecated in favour of https://github.com/elastic/puppet-elasticsearch, the official one.

[![Build Status](https://secure.travis-ci.org/icalvete/puppet-elasticsearch.png)](http://travis-ci.org/icalvete/puppet-elasticsearch)

##Actions:

* Install and configure [elasticsearch](http://www.elasticsearch.org/)
* Setup a cluster with unicast discovery
* Tunning template for [logstash](http://logstash.net/) indexes.
* Maintenance for [logstash](http://logstash.net/) indexes

##Requires:

* [hiera](http://docs.puppetlabs.com/hiera/1/index.html)
* common::down_resource from https://github.com/icalvete/puppet-common

* Recomended 
  + Indices maintenance needs php so ... https://github.com/icalvete/puppet-php5

##Authors:

Israel Calvete Talavera <icalvete@gmail.com>
