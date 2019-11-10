require "halite"

module Esto
  class Client

    @client : Halite::Client

    @last_request : Time?

    def initialize(
      endpoint : String = "https://e621.net",
      user_agent : String = "Esto Crystal #{Esto::VERSION}"
    )
      @client = Halite::Client.new(endpoint: endpoint, headers: {"User-Agent" => user_agent})
    end

    def post(id : Int32 | String)
      params = id.is_a?(Int32) ? {id: id} : {md5: id}
      json = get("/post/show.json", params: params)
      Types::Post.from_json(json)
    end

    def posts(
      limit : Int32 = 320,
      before_id : Int32? = nil,
      page : Int32? = nil,
      tags : Array(String)? = nil
    )
      params = {limit: limit, before_id: before_id, page: page, tags: tags}
      json = get("/post/index.json", params: params)
      Array(Types::Post).from_json(json)
    end

    def post_tags(id : Int32 | String)
      params = id.is_a?(Int32) ? {id: id} : {md5: id}
      json = get("/post/tags.json", params: params)
      Array(Types::Tag).from_json(json)
    end

    def check_post_md5(md5 : String)
      json = get("/post/check_md5.json", params: {md5: md5})
      parsed = JSON.parse(json)
      parsed["post_id"]?.try &.as_i
    end

    def popular_posts(by)
      path = case by.to_s
        when "week"
          "/post/popular_by_week.json"
        when "month"
          "/post/popular_by_month.json"
        else
          "/post/popular_by_day.json"
        end

      json = get(path)
      Array(Types::Post).from_json(json)
    end

    def request(method, path, *, params = nil, form = nil)
      options = Halite::Options.new(params: params, form: form)
      prevent_flood
      response = @client.request(method, path, options)
      handle_error(response)
      response.body
    end

    {% for method in %w[get post put patch delete] %}
      def {{method.id}}(path, *, params = nil, form = nil)
        request({{method}}, path, params: params, form: form)
      end
    {% end %}

    private def prevent_flood
      if last_request = @last_request
        since = Time.local - last_request
        ms = since.total_milliseconds

        if ms < 1000
          sleep ms.milliseconds
        end
      end

      @last_request = Time.local
    end

    private def handle_error(response : Halite::Response)
      case response.status_code
      when 403
        raise Error::Forbidden.new
      when 404
        raise Error::NotFound.new
      when 420
        raise Error::InvalidRecord.new
      when 421
        raise Error::UserThrottled.new
      when 422
        raise Error::ResourceLocked.new
      when 423
        raise Error::AlreadyExists.new
      when 424
        raise Error::InvalidParameters.new
      when 500
        raise Error::InternalServerError.new
      when 502
        raise Error::BadGateway.new
      when 503
        raise Error::ServiceUnavailable.new
      when 520
        raise Error::UnknownError.new
      when 522, 524
        raise Error::ConnectionTimeout.new
      when 525
        raise Error::SSLHandshakeFailed.new
      end
    end

  end
end
