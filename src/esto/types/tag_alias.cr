require "json"

module Esto::Types
  struct TagAlias
    include JSON::Serializable

    getter id : Int32

    getter name : String

    getter alias_id : Int32

    getter pending : Bool = false

    def ==(other : String)
      @name == other
    end
  end
end
