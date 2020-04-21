# README

## 概要

これは、日々自分が食べたものを投稿し、それをフォロワーと共有するダイエットアプリです。

## 本番環境

https://diet-app-2020.herokuapp.com/users/sign_in

[![Deploy](https://www.herokucdn.com/deploy/button.png)](https://heroku.com/deploy)

## 機能一覧

- ユーザー登録・ログイン機能（devise を使用）
- フォロー機能 (Ajax を使用)
- 全ユーザー/フォロワー/フォロイングの一覧表示
- 食事ポストの投稿機能（Ajax を使用）
- 食事ポストの投稿削除機能 (Ajax を使用)
- ポストへの投票(↑/↓)機能の追加
- 自分がフォローしているユーザの投稿一覧表示機能

## TODOs

- フォロワー/フォロイング数の表示
- プロフィールに画像を追加
- ポストへのコメント機能の追加
- DM チャット機能の追加
- Github Action による CI/CD の導入
- Docker の導入
- AWS 上にデプロイ
- UI の洗練

## 使用技術

- Ruby 2.6.3
- Rails 6.0.2
- RSpec
- Heroku
- GitHub, Git

## テスト

- Rspec
  - 単体テスト（モデル）

## ローカル環境での機動方法

```
pg_ctl -D /usr/local/var/postgres start
bundle exec rails s
```
