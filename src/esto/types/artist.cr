require "json"

module Esto::Types
  struct Artist
    include JSON::Serializable

    getter id : Int32

    getter name : String

    @[JSON::Field(converter: Esto::Converters::StringArrayConverter)]
    getter other_names : Array(String)

    getter group_name : String

    getter urls : Array(String)

    @[JSON::Field(key: "is_active")]
    getter? active : Bool

    getter version : Int32

    getter updater_id : Int32

    def ==(other : String)
      @name == other
    end
  end
end
