module Esto
  enum Rating
    Safe
    Questionable
    Explicit

    def self.new(pull : JSON::PullParser) : Rating
      char = pull.read_string[0]
      case char
      when "q"
        Rating::Questionable
      when "e"
        Rating::Explicit
      else
        Rating::Safe
      end
    end

    def to_json(json : JSON::Builder)
      json.string(value.to_s[0].downcase)
    end
  end
end
