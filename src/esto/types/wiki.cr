require "json"

module Esto::Types
  struct Wiki
    include JSON::Serializable

    getter id : Int32

    @[JSON::Field(key: "created_at", root: "s", converter: Time::EpochConverter)]
    getter created_at : Time

    @[JSON::Field(key: "updated_at", root: "s", converter: Time::EpochConverter)]
    getter updated_at : Time

    getter title : String

    getter body : String

    getter updater_id : Int32

    getter locked : Bool

    getter version : Int32

    forward_missing_to @body
  end
end
