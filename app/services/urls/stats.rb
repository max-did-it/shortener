class Urls::Stats
  REDIS_URL = ENV.fetch('REDIS_URL', 'redis://127.0.0.1:6379/1').freeze
  include ActiveModel
  include ActiveModel::Validations

  validate :url_presence
  attr_accessor :slug
  
  def call
    fetch_stats
  end

  private

  def fetch_stats
    redis_conn.get("#{slug}:stats")
  end

  def url
    return @url if defined? @url

    @url ||= redis_conn.set("#{slug}:url", url)
  end

  def url_presence
    !!url
  end

  def redis_conn
    @redis_conn ||= Redis.new(url: REDIS_URL)
  end
end