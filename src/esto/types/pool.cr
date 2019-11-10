require "json"

module Esto::Types
  struct PostPool
    include JSON::Serializable

    getter id : Int32

    getter name : String

    @[JSON::Field(key: "created_at", root: "s", converter: Time::EpochConverter)]
    getter created_at : Time

    @[JSON::Field(key: "updated_at", root: "s", converter: Time::EpochConverter)]
    getter updated_at : Time

    getter user_id : Int32

    @[JSON::Field(key: "is_locked")]
    getter? locked : Bool

    getter post_count : Int32
  end
end
