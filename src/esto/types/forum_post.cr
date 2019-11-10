require "json"

module Esto::Types
  struct ForumPost
    include JSON::Serializable

    getter id : Int32

    getter creator : String

    getter creator_id : Int32

    getter body : String

    getter title : String

    forward_missing_to @body
  end
end
