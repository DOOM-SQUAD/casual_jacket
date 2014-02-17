# Redis structure for Operations:
#
# redis_conn.set('handle-op_no', 'json garbage')
# { class => "ConsumerClass", attrs => { json_attrs }, message => 'oh snap son' }
#
# '#{handle}-errors' => [list_of_op_ids]
module CasualJacket

  class Operation

    attr_accessor :id, :attributes, :group, :message

    def self.from_redis(redis_hash)
      new(
        redis_hash['id'],
        JSON.parse(redis_hash['attributes']),
        redis_hash['group'],
        redis_hash['message']
      )
    end

    def initialize(id, attributes, group, message=nil)
      @id            = id
      @attributes    = attributes
      @group         = group
      @message       = message
    end

    def to_hash
      {
        'id'         => id,
        'attributes' => attributes.to_json,
        'group'      => group,
        'message'    => message
      }
    end

    def method_missing(method, *args, &block)
      if method =~ /\Avalue_for_/
        @attributes.fetch(method.to_s.gsub('value_for_',''), nil)
      else
        super
      end
    end

  end

end
