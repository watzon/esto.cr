require "json"

module Esto::Types
  # TODO: Figure out a better way to handle this. Maybe with discriminators.
  struct Ticket
    include JSON::Serializable

    getter id : Int32

    getter type : String

    getter status : String

    @[JSON::Field(key: "created_at", root: "s", converter: Time::EpochConverter)]
    getter created_at : Time

    @[JSON::Field(key: "updated_at", root: "s", converter: Time::EpochConverter)]
    getter updated_at : Time

    getter user : Int32

    getter username : String

    getter reported_comment : Int32?

    getter reported_post : Int32?

    getter reported_user : Int32?

    getter reason : String
  end
end
