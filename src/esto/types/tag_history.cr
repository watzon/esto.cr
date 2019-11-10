require "json"

module Esto::Types
  struct TagHistory
    include JSON::Serializable

    getter id : Int32

    getter post_id : Int32

    getter source : String

    @[JSON::Field(converter: Esto::Converters::StringArrayConverter)]
    getter tags : Array(String)
  end
end
