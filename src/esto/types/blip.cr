require "json"

module Esto::Types
  struct Blip
    include JSON::Serializable

    getter id : Int32

    getter response : Int32?

    getter user : String

    getter user_id : Int32

    getter body : String

    forward_missing_to @body
  end
end
