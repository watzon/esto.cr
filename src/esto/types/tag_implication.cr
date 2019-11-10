require "json"

module Esto::Types
  struct TagImplication
    include JSON::Serializable

    getter id : Int32

    getter consequent_id : Int32

    getter predicate_id : Int32

    getter pending : Bool = false
  end
end
