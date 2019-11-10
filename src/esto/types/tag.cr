require "json"

module Esto::Types
  struct Tag
    include JSON::Serializable

    getter id : Int32

    getter name : String

    getter count : Int32

    getter type : TagType

    getter type_locked : Bool = false

    def ==(other : String)
      @name == other
    end
  end
end
