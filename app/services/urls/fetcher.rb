class Urls::Fetcher
  REDIS_URL = ENV.fetch('REDIS_URL', 'redis://127.0.0.1:6379/1').freeze
  include ActiveModel
  include ActiveModel::Validations

  validate :url_presence
  attr_accessor :slug

  def call
    increment_stats
    url
  end

  private

  def url
    return @url if defined? @url

    @url ||= redis_conn.get("#{slug}:url")
  end

  def increment_stats
    redis_conn.incr("#{slug}:stats") if url
  end

  def url_presence
    errors.add :url, 'not found' unless url
  end

  def redis_conn
    @redis_conn ||= Redis.new(url: REDIS_URL)
  end
end
