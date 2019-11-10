require "json"

module Esto::Types
  struct User
    include JSON::Serializable

    getter id : Int32

    getter name : String

    getter level : Int32

    @[JSON::Field(converter: Esto::Converters::StringDateConverter)]
    getter created_at : Time

    getter avatar_id : Int32?

    getter stats : Stats

    getter artist_tags : Array(String)

    struct Stats
      include JSON::Serializable

      getter post_count : Int32

      getter del_post_count : Int32

      getter edit_count : Int32

      getter favorite_count : Int32

      getter wiki_count : Int32

      getter forum_post_count : Int32

      getter note_count : Int32

      getter comment_count : Int32

      getter blip_count : Int32

      getter set_count : Int32

      getter pool_update_count : Int32

      getter pos_user_records : Int32

      getter neutral_user_records : Int32

      getter neg_user_records : Int32
    end
  end
end
