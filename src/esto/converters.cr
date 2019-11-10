module Esto::Converters
  module StringArrayConverter
    def self.from_json(value : JSON::PullParser) : Array(String)
      value.read_string.split(' ')
    end

    def self.to_json(value : Array(String), json : JSON::Builder)
      json.string(value.join(' '))
    end
  end

  module IntArrayConverter
    def self.from_json(value : JSON::PullParser) : Array(Int32)
      value.read_string.split(',').reject(&.empty?).map(&.to_i)
    end

    def self.to_json(value : Array(String), json : JSON::Builder)
      json.string(value.join(','))
    end
  end

  module StringDateConverter
    def self.from_json(value : JSON::PullParser) : Time
      Time.parse_utc(value.read_string, "%G-%m-%d %H:%M")
    end

    def self.to_json(value : Time, json : JSON::Builder)
      json.string(value.to_s("%y-%m-%d %H:%M"))
    end
  end
end
