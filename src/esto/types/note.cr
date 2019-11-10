require "json"

module Esto::Types
  struct Note
    include JSON::Serializable

    getter id : Int32

    @[JSON::Field(key: "created_at", root: "s", converter: Time::EpochConverter)]
    getter created_at : Time

    @[JSON::Field(key: "updated_at", root: "s", converter: Time::EpochConverter)]
    getter updated_at : Time

    getter creator_id : Int32

    getter x : Int32

    getter y : Int32

    getter width : Int32

    getter height : Int32

    @[JSON::Field(key: "is_active")]
    getter? active : Bool

    getter post_id : Int32

    getter body : String

    getter version : Int32

    forward_missing_to @body
  end
end
