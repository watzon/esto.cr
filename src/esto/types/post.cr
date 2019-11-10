require "json"

module Esto::Types
  struct Post
    include JSON::Serializable

    getter id : Int32

    @[JSON::Field(converter: Esto::Converters::StringArrayConverter)]
    getter tags : Array(String) = [] of String

    @[JSON::Field(converter: Esto::Converters::StringArrayConverter)]
    getter locked_tags : Array(String) = [] of String

    getter description : String

    @[JSON::Field(key: "created_at", root: "s", converter: Time::EpochConverter)]
    getter created_at : Time

    getter creator_id : Int32

    getter author : String

    @[JSON::Field(converter: Time::EpochConverter)]
    getter change : Time

    getter source : String?

    getter score : Int32

    getter fav_count : Int32

    getter md5 : String

    getter file_size : Int32

    getter file_url : String

    getter file_ext : String

    getter preview_url : String

    getter preview_width : Int32

    getter preview_height : Int32

    getter sample_url : String

    getter sample_width : Int32

    getter sample_height : Int32

    getter rating : Rating

    getter status : String

    getter width : Int32

    getter height : Int32

    @[JSON::Field(key: "has_comments")]
    getter? comments : Bool

    @[JSON::Field(key: "has_notes")]
    getter? notes : Bool

    @[JSON::Field(key: "has_children")]
    getter? children : Bool

    @[JSON::Field(converter: Esto::Converters::IntArrayConverter)]
    getter children : Array(Int32) = [] of Int32

    getter parent_id : Int32?

    getter artist : Array(String) = [] of String

    getter sources : Array(String) = [] of String
  end
end
