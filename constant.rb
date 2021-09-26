# frozen_string_literal: true

class Constant
  USER_AGENT = 'Mozilla/5.0 (Windows NT 6.3; Trident/7.0; rv 11.0) like Gecko'

  ### はてなブックマーク カテゴリ
  CATEGORY = {
    all: '総合',
    general: '一般',
    social: '世の中',
    economics: '政治と経済',
    life: '暮らし',
    knowledge: '学び',
    it: 'テクノロジー',
    fun: 'おもしろ',
    entertainment: 'エンタメ',
    game: 'アニメとゲーム'
  }.freeze

  ### はてなブックマーク フィードURL
  # 人気総合
  ALL_URL = 'https://b.hatena.ne.jp/hotentry.rss'
  # 一般
  GENERAL_URL = 'https://b.hatena.ne.jp/hotentry/general.rss'
  # 世の中
  SOCIAL_URL = 'https://b.hatena.ne.jp/hotentry/social.rss'
  # 政治と経済
  ECONOMICS_URL = 'https://b.hatena.ne.jp/hotentry/economics.rss'
  # 暮らし
  LIFE_URL = 'https://b.hatena.ne.jp/hotentry/life.rss'
  # 学び
  KNOWLEDGE_URL = 'https://b.hatena.ne.jp/hotentry/knowledge.rss'
  # テクノロジー
  IT_URL = 'https://b.hatena.ne.jp/hotentry/it.rss'
  # おもしろ
  FUN_URL = 'https://b.hatena.ne.jp/hotentry/fun.rss'
  # エンタメ
  ENTERTAINMENT_URL = 'https://b.hatena.ne.jp/hotentry/entertainment.rss'
  # アニメとゲーム
  GAME_URL = 'https://b.hatena.ne.jp/hotentry/game.rss'
end
