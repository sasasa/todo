require 'net/http'
require 'uri'
require 'json'
require 'logger'

class GetWebAPI
  attr_accessor :response

  # http://mogulla3.com:4567
  # { param1: 'foo', param2: 'bar baz' , param3: 'あ' }
  def initialize(url, parameters, log)
    # [ロガー]
    # カレントディレクトリのwebapi.logというファイルに出力
    logger = log || Logger.new('log/development.log')
    
    # [クエリパラメータ]
    # URI.encode_www_formを使って「application/x-www-form-urlencoded」形式の文字列に変換
    # 文字列はURLエンコードされた形式に変換（半角スペースの"+"への変換等）
    #
    # （変換例）
    # 'bar baz' => 'bar+baz'
    # 'あ' => '%E3%81%82'
    params = URI.encode_www_form(parameters)
    
    # [URI]
    # URI.parseは与えられたURIからURI::Genericのサブクラスのインスタンスを返す
    # -> 今回はHTTPプロトコルなのでURI::HTTPクラスのインスタンスが返される
    #
    # オブジェクトからは以下のようにして構成要素を取得できる
    # uri.scheme => 'http'
    # uri.host   => 'mogulla3.com'
    # uri.port   => 4567
    # uri.path   => ''
    # uri.query  => 'param1=foo&param2=bar+baz&param3=%E3%81%82'
    uri = URI.parse("#{url}?#{params}")
    
    begin
      # [GETリクエスト]
      # Net::HTTP.startでHTTPセッションを開始する
      # 既にセッションが開始している場合はIOErrorが発生
      response = Net::HTTP.start(uri.host, uri.port) do |http|
        # Net::HTTP.open_timeout=で接続時に待つ最大秒数の設定をする
        # タイムアウト時はTimeoutError例外が発生
        http.open_timeout = 5
    
        # Net::HTTP.read_timeout=で読み込み1回でブロックして良い最大秒数の設定をする
        # デフォルトは60秒
        # タイムアウト時はTimeoutError例外が発生
        http.read_timeout = 10
    
        # Net::HTTP#getでレスポンスの取得
        # 返り値はNet::HTTPResponseのインスタンス
        http.get(uri.request_uri)
      end
    
      # [レスポンス処理]
      # 2xx系以外は失敗として終了することにする
      # ※ リダイレクト対応できると良いな..
      #
      # ステータスコードに応じてレスポンスのクラスが異なる
      # 1xx系 => Net::HTTPInformation
      # 2xx系 => Net::HTTPSuccess
      # 3xx系 => Net::HTTPRedirection
      # 4xx系 => Net::HTTPClientError
      # 5xx系 => Net::HTTPServerError
      case response
      # 2xx系
      when Net::HTTPSuccess
        # [JSONパース処理]
        # JSONオブジェクトをHashへパースする
        # JSON::ParserErrorが発生する可能性がある
        self.response = JSON.parse(response.body)
      # 3xx系
      when Net::HTTPRedirection
        # リダイレクト先のレスポンスを取得する際は
        # response['Location']でリダイレクト先のURLを取得してリトライする必要がある
        logger.warn("Redirection: code=#{response.code} message=#{response.message}")
      else
        logger.error("HTTP ERROR: code=#{response.code} message=#{response.message}")
      end
    
    # [エラーハンドリング]
    # 各種処理で発生しうるエラーのハンドリング処理
    # 各エラーごとにハンドリング処理が書けるようにrescue節は小さい単位で書く
    # (ここでは全て同じ処理しか書いていない)
    rescue IOError => e
      logger.error("---IOError-------#{e.message}")
    rescue TimeoutError => e
      logger.error("---TimeoutError-------#{e.message}")
    rescue JSON::ParserError => e
      logger.error("---JSON::ParserError-------#{e.message}")
    rescue => e
      logger.error("---------#{e.message}")
    end
  end
end