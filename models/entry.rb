class Entry
  attr_accessor :title, :link, :description, :date, :bookmarkcount, :imageurl, :content, :bookmarkurl

  DEFAULT_FILTER_COUNT = 100.freeze

  def initialize(title:, link:, description:, date:, bookmarkcount:, imageurl:, content:, bookmarkurl:)
    @title = title
    @link = link
    @description = description
    @date = date
    @bookmarkcount = bookmarkcount
    @imageurl = imageurl
    @content = content
    @bookmarkurl = bookmarkurl
  end

  # 引数に指定したカウントよりも大きければブックマークカウント数を返却する
  # 小さければ nil を返却する
  # 引数がなければ デフォルトのフィルタ数 をセットして判定する
  def filter(count = DEFAULT_FILTER_COUNT)
    @bookmarkcount.to_i >= count ? @bookmarkcount : nil
  end
end
