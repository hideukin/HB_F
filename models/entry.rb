# frozen_string_literal: true

# エントリークラス
# RSS フィードのエントリー
class Entry
  attr_accessor :title, :link, :description, :date, :bookmarkcount
  attr_accessor :imageurl, :content, :bookmarkurl

  DEFAULT_FILTER_COUNT = 100

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

  # 引数に指定したカウントよりも小さければ true を返却する
  # 引数がなければ デフォルトのフィルタ数 をセットして判定する
  def count_under?(count = DEFAULT_FILTER_COUNT)
    @bookmarkcount.to_i < count
  end
end
