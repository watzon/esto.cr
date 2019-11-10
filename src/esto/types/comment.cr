require "json"

module Esto::Types
  struct Comment
    include JSON::Serializable

    getter id : Int32

    @[JSON::Field(converter: Esto::Converters::StringDateConverter)]
    getter created_at : Time

    getter post_id : Int32

    getter creator : String

    getter creator_id : Int32

    getter body : String

    getter score : Int32

    forward_missing_to @body
  end
end
