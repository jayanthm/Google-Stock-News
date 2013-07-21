require 'open-uri'
require 'multi_json'

class GoogleNewsParser
  attr_reader :articles
  def initialize(stock)
    @articles = []
    google_finance_news(stock).each { |news_hash| 
      @articles << GoogleNewsArticle.new(news_hash[:a].first) if !news_hash[:a].nil?
    }
  end
  
	def google_finance_news(stock)
    json = open(google_finance_news_uri(stock)).read
    MultiJson.use(:gson).load(json, :symbolize_keys => true)[:clusters]
	end
  
  def google_finance_news_uri(stock)
    'http://www.google.com/finance/company_news?q=' + stock.to_s + '&output=json'
  end
end

class GoogleNewsArticle
  attr_reader :title, :url, :source, :sample
  def initialize(news_hash)
    @title = news_hash[:t]
    @url = news_hash[:u]
    @source = news_hash[:s]
    @sample = news_hash[:sp]
  end
end