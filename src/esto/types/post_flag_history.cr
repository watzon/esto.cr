require "json"

module Esto::Types
  struct PostFlagHistory
    include JSON::Serializable

    getter id : Int32

    getter post_id : Int32

    @[JSON::Field(converter: Time::EpochConverter)]
    getter created_at : Time

    getter reason : String

    getter user_id : Int32
  end
end
