module Esto
  class Error < Exception; end

  class Error::Forbidden < Error; end

  class Error::NotFound < Error; end

  class Error::InvalidRecord < Error; end

  class Error::UserThrottled < Error; end

  class Error::ResourceLocked < Error; end

  class Error::AlreadyExists < Error; end

  class Error::InvalidParameters < Error; end

  class Error::InternalServerError < Error; end

  class Error::BadGateway < Error; end

  class Error::ServiceUnavailable < Error; end

  class Error::UnknownError < Error; end

  class Error::ConnectionTimeout < Error; end

  class Error::SSLHandshakeFailed < Error; end
end
