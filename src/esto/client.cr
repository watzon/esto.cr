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

    def tags(
      limit : Int32 = 500,
      page : Int32 = 1,
      order : String | Symbol = :date,
      after_id : Int32 = 0,
      show_empty_tags : Bool = false,
      name : String? = nil,
      name_pattern : String? = nil
    )
      order = order.to_s
      show_empty_tags = show_empty_tags ? 1 : 0

      params = {
        limit: limit, page: page, order: order, after_id: after_id,
        show_empty_tags: show_empty_tags, name: name, name_pattern: name_pattern
      }

      json = get("/tag/index.json", params: params)
      Array(Types::Tag).from_json(json)
    end

    def tag(id : Int32)
      json = get("/tag/show.json", params: {id: id})
      Types::Tag.from_json(json)
    end

    def related_tags(names : String | Array(String), type : String? | Symbol? = nil)
      names = ([names] if names.is_a?(String)).join(" ")
      json = get("/tag/related.json", params: {tags: names, type: type})
      Array(Types::Tag).from_json(json)
    end

    def tag_aliases(
      page : Int32 = 1,
      order : String | Symbol = :aliasedtag,
      query : String? = nil,
      user : String? = nil,
      approved : String? | Symbol? | Bool? = nil,
      forum_post : String? | Symbol? | Bool? = nil
    )
      approved = approved == false ? nil : approved.to_s
      forum_post = forum_post == true ? nil : forum_post.to_s
      params = {page: page, order: order, query: query, user: user, approved: approved, forum_post: forum_post}
      json = get("/tag_alias/index.json", params: params)
      Array(Types::TagAlias).from_json(json)
    end

    def tag_implications(
      page : Int32 = 1,
      order : String | Symbol = :aliasedtag,
      query : String? = nil,
      user : String? = nil,
      approved : String? | Symbol? | Bool? = nil,
      forum_post : String? | Symbol? | Bool? = nil
    )
      approved = approved == false ? nil : approved.to_s
      forum_post = forum_post == true ? nil : forum_post.to_s
      params = {page: page, order: order, query: query, user: user, approved: approved, forum_post: forum_post}
      json = get("/tag_implication/index.json", params: params)
      Array(Types::TagImplication).from_json(json)
    end

    def artists(
      name : String? = nil,
      limit : Int32? = 100,
      order : String | Symbol = :name,
      page : Int32 = 1
    )
      params = {name: name, limit: limit, order: order.to_s, page: page}
      json = get("/artist/index.json", params: params)
      Array(Types::Artist).from_json(json)
    end

    def comment(id : Int32)
      json = get("/comment/show.json", {id: id})
      Types::Comment.from_json(json)
    end

    def comments(
      post_id : Int32? = nil,
      page : Int32 = 1,
      status : String? | Symbol? = nil
    )
      params = {post_id: post_id, page: page, status: status}
      json = get("/comment/index.json", params: params)
      Array(Types::Comment).from_json(json)
    end

    def search_comments(
      query : String,
      results : String | Symbol = :fuzzy,
      date_start : Time? = nil,
      date_end : Time? = nil,
      order : String | Symbol = :date,
      post_id : Int32? = nil,
      page : Int32 = 1,
      user : String? = nil,
      user_id : Int32? = nil,
      status : String | Symbol = :any
    )
      date_start = date_start.to_s("%G-%m-%d") if date_start.is_a?(Time)
      date_end = date_end.to_s("%G-%m-%d") if date_end.is_a?(Time)
      params = {
        query: query, results: results.to_s, date_start: date_start, date_end: date_end,
        order: order.to_s, post_id: post_id, page: page, user: user, user_id: user_id, status: status.to_s
      }
      json = get("/comment/search.json", params: params)
      Array(Types::Comment).from_json(json)
    end

    def blips(
      name : String? = nil,
      body : String? = nil,
      page : Int32 = 1,
      limit : Int32 = 100,
      status : String | Symbol = :any,
      response_to : Int32? = nil
    )
      params = {name: name, body: body, page: page, limit: limit, status: status, response_to: response_to}
      json = get("/blip/index.json")
      Array(Types::Blip).from_json(json)
    end

    def blip(id : Int32)
      json = get("/blip/show.json", {id: id})
      Types::Blip.from_json(json)
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
