require 'nokogiri'
require 'open-uri'
require 'rss'
require 'sinatra'
require 'sinatra/reloader'
require 'slim'

require_relative 'models/entry'

USER_AGENT = 'Mozilla/5.0 (Windows NT 6.3; Trident/7.0; rv 11.0) like Gecko'.freeze
FILTER_COUNT_ALL = 250
FILTER_COUNT_IT = 100
HOTENTRY_URL = 'http://b.hatena.ne.jp/hotentry.rss'.freeze
IT_URL = 'http://b.hatena.ne.jp/hotentry/it.rss'.freeze
@hotentry_url = url('all')
@it_url = url('it')

# routing
get '/' do
  slim :index
end

get '/all' do
  filter_rss(HOTENTRY_URL, params[:threshold]&.to_i)
  get_feed_url request.url
  slim :'all/index'
end

get '/it' do
  filter_rss(IT_URL, params[:threshold]&.to_i)
  get_feed_url request.url
  slim :'it/index'
end

get '/all/feed' do
  filter_rss(HOTENTRY_URL, params[:threshold]&.to_i)
  maker_feed(HOTENTRY_URL)

  content_type 'application/xml'
  @feed.to_s
end

get '/it/feed' do
  filter_rss(IT_URL, params[:threshold]&.to_i)
  maker_feed(IT_URL)

  content_type 'application/xml'
  @feed.to_s
end

# フィードのURLを生成する
# @feed_url: フィード用のURL
def get_feed_url(url)
  @feed_url = url.include?('?') ? url.gsub!(/\?/, '/feed?') : url.gsub!(/$/, '/feed')
end

# 対象となるはてなブックマーク RSS フィードから指定したブックマークカウントでフィルタを行う
# uri: 対象の RSS FEED URI
# filter_count: ブックマークカウント
# @rss: エントリーの配列
def filter_rss(uri, filter_count)
  @rss = get_rss_nokogiri uri
  @rss.delete_if { |entry| entry.bookmarkcount.to_i < filter_count.to_i }
end

# 引数のコンテンツに対し、画像タグとフレームタグを追加する
# content: 対象のコンテンツ
# bookmarkurl: はてなブックマーク URI
# return: 加工したコンテンツ
def create_content(content, bookmarkurl)
  cite = '<cite><img src="' + bookmarkurl + '" /></cite>'
  iframe = '<iframe src="' + bookmarkurl + '" width="100%" height="100%"></iframe>'
  cite + content + iframe
end

# 引数の URI に対するはてなブックマークの URI を返却する
# uri: 対象の URI
# return: 対象 URI のはてなブックマーク URI
def create_bookmarkurl(uri)
  if uri.include?('https://')
    uri.sub!(/https:\/\//, 'http://b.hatena.ne.jp/entry/s/')
  elsif uri.include?('http://')
    uri.sub!(/http:\/\//, 'http://b.hatena.ne.jp/entry/')
  end
  uri
end

# XML からエントリーに必要な項目を取得し、エントリー情報にマッピングし、配列を返却する
# item_nodes: item の XML(パース済)
# return: エントリー情報の配列
def map_rss_entry(item_nodes)
  rss = []
  item_nodes.each do |item|
    bookmarkurl = create_bookmarkurl(item.css('link').text)
    content = create_content(item.css('content|encoded').text, bookmarkurl)
    entry = Entry.new( \
      title: item.css('title').text \
    , link: item.css('link').text \
    , description: item.css('description').text \
    , date: item.css('dc|date').text \
    , bookmarkcount: item.css('hatena|bookmarkcount').text.to_i \
    , imageurl: item.css('hatena|imageurl').text \
    , content: content \
    , bookmarkurl: bookmarkurl \
    )
    rss.push entry
  end
  rss
end

# 引数の URI から RSS エントリー情報を取得する
# uri: 対象の RSS FEED URI
# @xml_doc: nokogiri でパースした結果
# return: エントリー情報の配列
def get_rss_nokogiri(uri)
  # open-uriにユーザーエージェントをセット
  opt = { 'User-Agent' => USER_AGENT }

  @xml_doc = Nokogiri::XML.parse(open(uri, opt))

  item_nodes = @xml_doc.css('//item')
  map_rss_entry item_nodes
end

# 引数の URI から RSS フィードを生成する
# uri: 対象の RSS FEED URI
# @feed: 生成したフィード
def maker_feed(uri)
  channel_nodes = @xml_doc.css('//channel')
  @feed = RSS::Maker.make('atom') do |maker|
    maker.channel.title = channel_nodes.css('title').text
    maker.channel.description = channel_nodes.css('description').text
    maker.channel.link = uri
    maker.channel.about = uri
    maker.channel.author = 'hatebu_feed'
    maker.channel.date = Time.now
    maker.image.title = 'hatebu_feed'
    maker.image.url = url('logo.png')

    maker.items.do_sort = true

    @rss.each do |entry|
      item = maker.items.new_item
      item.title = entry.title
      item.link = entry.link
      item.date = entry.date
      item.description = entry.content
    end
  end
end
