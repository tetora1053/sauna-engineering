# WHAT

- クローラーで取得した画像から予約開始日時等を抽出してLINEに通知するシステム

# HOW

- クローラーのプログラム：golang
- クローラー実行基盤：Amazon ECS / Fargate or AWS Batch
- クローリングのスケジューラー：Amazon EventBridge or AWS Batch
- 画像ストレージ：Amazon S3
- 画像解析：Amazon Rekognition
- 画像解析実行トリガー：S3への保存
- 解析結果の保存先：Amazon S3 or Amazon DynamoDB
- 通知プログラム実行基盤：AWS Lambda
- 通知先：LINE
- Lambdaランタイム：NodeJS
- Lambdaスクリプト開発言語：TypeScript
- 通知トリガー：解析結果の保存
- インフラコード管理：AWS CDK / AWS SAM
