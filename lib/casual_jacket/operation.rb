# Redis structure for Operations:
#
# redis_conn.set('handle-op_no', 'json garbage')
# { class => "ConsumerClass", attrs => { json_attrs }, message => 'oh snap son' }
#
# '#{handle}-errors' => [list_of_op_ids]
module CasualJacket

  class Operation

    attr_accessor :id, :consumer_name, :attributes, :message

    def self.from_json(id, json_string)
      hash = JSON.parse(json_string)
      new(id, hash['consumer_name'], hash['attributes'], hash['message'])
    end

    def initialize(id, consumer_name, attributes, message=nil)
      @id            = id
      @consumer_name = consumer_name
      @attributes    = attributes
      @message       = message
    end

    def to_json
      to_hash.to_json
    end

    def to_hash
      {
        'consumer_name' => consumer_name,
        'attributes'    => attributes,
        'message'       => message
      }
    end

    def method_missing(method, *args, &block)
      if method =~ /\Avalue_for_/
        @attributes.fetch(method.to_s.gsub('value_for_',''))
      else
        super
      end
    rescue KeyError
      super
    end

  end

end