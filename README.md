# fluent-plugin-anchore

[Fluentd](https://fluentd.org/) input plugin to do something.

TODO: write description for you plugin.

## Installation

### RubyGems

```
$ gem install fluent-plugin-anchore
```

### Bundler

Add following line to your Gemfile:

```ruby
gem "fluent-plugin-anchore"
```

And then execute:

```
$ bundle
```

## Configuration

You can generate configuration template:

```
$ fluent-plugin-config-format input anchore
```

Example configuration

```
<source>
    @type anchore
    url http://enterprise:8080
    username admin
    password foobar
    headers {
        "headerone": "value",
        "headertwo": "value"
    }
</source>

# Use this for testing
#<match anchore-sbom>
#    @type stdout
#</match>

# Use the dedot filter for sboms, some of the names have dots in them
<filter anchore-sbom>
  @type             dedot
  de_dot            true
  de_dot_separator  _
  de_dot_nested     true
</filter>

<match anchore>
    @type elasticsearch
#    logstash_format true
    host elasticsearch #(optional; default="localhost")
    port 9200 #(optional; default=9200)
    user elastic
    password secret
    scheme https
    ca_file /some/path.ca
    index_name fluentd #(optional; default=fluentd)
    type_name fluentd #(optional; default=fluentd)
</match>

<match anchore-sbom>
    @type elasticsearch
#    logstash_format true
    host elasticsearch #(optional; default="localhost")
    port 9200 #(optional; default=9200)
    user elastic
    password secret
    scheme https
    ca_file /some/path.ca
    index_name fluentd-sbom #(optional; default=fluentd)
    type_name fluentd-sbom #(optional; default=fluentd)
</match>

<match anchore-vulns>
    @type elasticsearch
#    logstash_format true
    host elasticsearch #(optional; default="localhost")
    port 9200 #(optional; default=9200)
    user elastic
    password secret
    scheme https
    ca_file /some/path.ca
    index_name fluentd-vulns #(optional; default=fluentd)
    type_name fluentd-vulns #(optional; default=fluentd)
</match>
```

## Copyright

* Copyright(c) 2023- Josh Bressers
* License
  * Apache License, Version 2.0
