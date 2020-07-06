# README

## 概要

Ruby on Railsで実装された、日々の食事記録を投稿できるSNSアプリです。

## 本番環境

https://diet-app-2020.herokuapp.com

## ローカル環境での機動方法

```
pg_ctl -D /usr/local/var/postgres start
bundle exec rails s
```

## ローカル環境でのテスト走らせ方

```
bundle exec rspec
```


## 技術選定

### 仕様言語とミドルウェア
- Ruby on Rails (Ruby=2.7.0, Rails=6.0.2)
- HTML(erb), SCSS, JavaScript
- PostgreSQL
- Heroku


### 使用ライブラリ

Ruby

|ライブラリ名|使用用途|
|----|----|
|devise|認証機能のために使用|
|omniauth|Facebook認証のためにdeviseとともに使用|
|cocoon|cocoon-js(JSライブラリ)とともに、ネストされたモデルのフォーム作成のために使用|
|counter_culture|あるレコードに関連するレコードの個数や値の集計(カウンターキャッシュ)機能のために使用|
|rubocop|ローカル環境でのコードの静的解析のために使用|
|rspec|モデル層のテストのために使用|
|factory_bot_rails|rspecでダミーのモデルのインスタンスを作成するために使用|

#### CSS

|ライブラリ名|使用用途|
|----|----|
|bootstrap|デザインテンプレートとして使用|

#### JavaScript

|ライブラリ名|使用用途|
|----|----|
|jquery|Ajax通信のためなどに使用|
|flatpickr|カレンダーから日時を選択するUIのために使用|
|cocoon-js|cocoon(gem)とともに、ネストされたモデルのフォーム作成のために使用|



## 機能一覧

- パスワード認証/Facebook認証の2種類のサインアップ/ログイン機能
- 食事ポスト(最低1つ以上の食品目で構成される)の投稿機能/投稿削除機能
- 他人の食事ポストへの投票(いいね/悪いね)機能
- ユーザー間のフォロー機能
- 自分がフォローしているユーザの投稿を表示するフィード機能

## DB設計

#### usersテーブル

|カラム名|型|その他|
|----|----|----|
|name|||
|amount|||
|calory|||
|meal_post_id|||
|created_at|||
|updated_at||||

#### meal_postsテーブル

|カラム名|型|その他|
|----|----|----|
|content|||
|time|||
|user_id|||
|created_at|||
|updated_at|||
|total_calories|||
|food_items_count|||
|food_items_with_calories_count|||
|created_at|||
|updated_at|||

#### relationshipsテーブル

|カラム名|型|その他|
|----|----|----|
|follower_id||
|followed_id||
|created_at|||
|updated_at|||

#### votesテーブル

|カラム名|型|その他|
|----|----|----|
|user_id|||
|meal_post_id|||
|is_upvote|||
|created_at|||
|updated_at|||



## 苦労した点、開発の軌跡

### [# ログイン機構、User 間の Follow 機能、MealPost の投稿機能の追加 #1](https://github.com/kudojp/diet-app/pull/1)

- 最初の実装。この PR 時点では、機能的にはほぼ Rails チュートリアルに近かった。
- 認証には devise を用いた。メールアドレスとパスワードでログイン。
- asset pipeline を使わず、webpack を導入した。
- datetimepicker でカレンダーを表示するのに苦戦した

### [# Voting(投票機能)の追加 #2](https://github.com/kudojp/diet-app/pull/2)

- 仕様設計は[ここ](https://github.com/kudojp/diet-app/pull/2#issue-392782081)
- Voting はいいね(+1)と悪いね(-1)の２種類があり、自分の投稿に投票できない
- 各 MealPost の合計得点に関して時間がかかりすぎるので counter_culture を使うべきだった(後の FoodItem の実装以降導入)

### [# MealPost から[Up|Down]Voters 一覧を、User から[|Un]favorite MealPosts の一覧を見れるようにする #11](https://github.com/kudojp/diet-app/pull/11)

- あるユーザーが[いいね|悪いね]した投稿一覧、ある投稿を[いいね|悪いね]したユーザ一覧をかえすエンドポイントを実装した。肝は[ここ](https://github.com/kudojp/diet-app/pull/11/files#diff-0185a9df92260be0d1b3fc746cb6264b)と[ここ](https://github.com/kudojp/diet-app/pull/11/files#diff-4676c008b11a5480d73d4a6de01e45b9)。

  ```
  class MealPost < ApplicationRecord
    has_many :votes, dependent: :destroy	  has_many :votes, dependent: :destroy
    has_many :upvotes, -> { where(is_upvote: true) }, class_name: 'Vote'
    has_many :upvoters, through: :upvotes, source: :user
    ......
  end
  ```

### [# facebook 認証によるサインインとログイン機能の追加 #4](https://github.com/kudojp/diet-app/pull/4)

- 仕様設計は[ここ](https://github.com/kudojp/diet-app/pull/4#issue-405645108)
- 従来の devise を用いたメールアドレスとパスワードでのログイン形式に加え、ominiauth による Facebook 認証を加えた。
- 本システムでは以下の認証システムをとる

  1.  `FacebookでLogin`ボタンを押下
  2.  Facebook にリダイレクトされ、そこでログインかつ許可ボタンを押下。
  3.  アプリにリダレクトされる。この時点で、認可されて得られる(provider, uid)に対応する User が存在すれば自動的にその User としてログインされ、ホームへ飛ばされる。User が存在しない場合は Login されずにホームへ飛ばされる。

- このために
  1. `OmniauthCallbacksController`と`FacebookUsersController`の 2 つのコントローラを実装した
  2. User テーブルに`provider`と`uid`の２カラムを付け足した(`provider`には`facebook`という文字列が収納される。これは後に Google などの他の外部認証を加えることを想定して作ったカラムである)
- この PR 時点では、 Facecbook 認証では Facebook の認可サーバから取ってきた`provider`と`uid`に合致する列が users テーブルにが存在すれば認証完了、としていた。
- この PR 時点では Facecbook 認証したユーザは password 設定ができない。故に profile や password 更新ができない。これらは以下の PR で直された。

### [# Facebook 認証で登録した User が後からパスワードを設定できるようにする #8](https://github.com/kudojp/diet-app/pull/8)

- 上の PR の続き。仕様設計は[ここ](https://github.com/kudojp/diet-app/pull/8#issue-407352113)
- やったことは主に 3 つ
  1. facebook 認証で登録したユーザーが後から password を設定することができるようにする
  2. 現在の profile 更新ページを 2 つに分ける。これは、身長体重などは password なしで変更できるようにし、password に関しては現在の password 入力が求めるため。
  3. UI の再構成をした。

### [# MealPost のサブ項目として FoodItem を追加する #13](https://github.com/kudojp/diet-app/pull/13)

- 仕様設計は[ここ](https://github.com/kudojp/diet-app/pull/13#issue-409025615)、時間かかったのは[ここ](https://github.com/kudojp/diet-app/pull/13#issuecomment-629778398)と[ここ](https://github.com/kudojp/diet-app/pull/13#issuecomment-629842322)
- MealPost の has_nested_attributes_for で FoodItem モデルを実装した
- cocoon gem を使用することで、FoodItems のフォームの数を柔軟に加減できる UI を構築した。最初にページをロードした時は FoodItem のフォームは 3 つ表示されているが、、(➕) ボタンを押すことでフォームの数を増やしたり、(✖︎) ボタンを押すことでフォームの数を減らしたりできるようにした
- FoodItem はそれぞれカロリー値を入力できる(必須ではない)。MealPost ではそれに属する FoodItems のカロリーの総和を`15kcal+`といった形式で表示する。(`+`はその MealPost に属する全ての FoodItem にカロリーが入力されている場合のみ省略される)これを実現するため、counter_culture gem を導入し、 meal_posts テーブルに`total_calories` `food_items_count` `food_items_with_calories_count`という 3 つのカラムを付け加えた。

## その他

<details><summary>TODOs</summary><div>

### 機能の TODOs

- Google 認証でのサインイン、ログイン機能
- フォロワー/フォロイング数の表示
- プロフィールに画像を追加
- ポストへのコメント機能の追加
- DM チャットやビデオ通話機能の追加

### 環境開発向上のための TODOs

- Github Action による CI/CD の導入
- Docker の導入
- AWS 上にデプロイ
- UI の洗練

</div></details>
