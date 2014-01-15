# CasualJacket

![Casual Jacket](http://www.dylanmoranrules.com/gallery_BB/images/BB8_jpg.jpg "Casual Jacket")

Product Import compliment for translating and caching spreadsheets as sets of data operations.

## Configuration

Establish a connection to Redis:

```ruby
CasualJacket.configure do |config|
  config.redis_host = 'your.redis_instance.biz:6379'
end
```

Configuration can also be supplied via YAML file:

```ruby
CasualJacket.load!('path/to/yaml/file')
```

YAML example:

```yaml
redis_host: your.redis_instance.biz:6379
```

## General Usage

Importing a spreadsheet into the cache:

```ruby
handle = "test import"
file   = "/tmp/products.csv"
legend = { "headername" => "translation" }

CasualJacket.cache_operations(handle, file, legend)
```

Retrieve operations from the cache:

```ruby
CasualJacket.operations_for("test_import")
```

## Utility Tasks

`rake wine_lolly` - Invoke a pry session within the CasualJacket module.

## Rails Integration

 - Add `casual_jacket` to your Gemfile
 - Optionally supply `config/casual_jacket.yml`
