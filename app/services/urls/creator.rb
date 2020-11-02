class Urls::Creator
  REDIS_URL = ENV.fetch('REDIS_URL', 'redis://127.0.0.1:6379/1').freeze
  include ActiveModel
  include ActiveModel::Validations

  attr_accessor :url, :slug, :base_url

  def call
    store

    URI(base_url) + "/urls/#{slug}"
  end

  private

  def store
    return if stored_slug

    redis_conn.set("#{slug}:url", url)
    redis_conn.set("#{slug}:stat", 0)
    redis_conn.set(url, slug)
  end

  def slug
    @slug ||= stored_slug || SecureRandom.urlsafe_base64(5)
  end

  def stored_slug
    @stored_slug ||= redis_conn.get(url)
  end

  def redis_conn
    @redis_conn ||= Redis.new(url: REDIS_URL)
  end
end
