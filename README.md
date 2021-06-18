# mediawiki-get-heading-contents
MediaWikiで、ページタイトルと見出し名を指定したとき、その項目内容にあたるHTMLタグ群を抜き出して表示するスクリプト

## 使用方法

1. リポジトリに下記ファイルconfig.plを追加する。
```Perl:config.pl
use utf8

{
    "site" => {
        # MediaWikiサイトのエンドポイント
        "api_url" => "https://ja.wikipedia.org/w/api.php",
        # Page名
        "page_title" => "Perl",
        # 見出しタイトル
        "heading_title" => "Hello world"
    },

    # User情報（ログイン不要な場合はこの欄は省略可能）
    "user" => {
        # User名
        "name" => XXX,
        # パスワード
        "password" => XXX
    },

    # ページ検索用のキーワード. find.plで使用
    "find_word" => "Perl"
}
```

2. 

```bash
perl main.pl
```

### login.pl

ログイン機能の調査用に、login.plファイルも作成した。
config.pl記入のあとに、次のコマンドを叩く。
```
perl login.pl
```

### find.pl

ページ検索用スクリプト。1件しか情報を取得しない
