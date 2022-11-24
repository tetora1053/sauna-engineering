#!/bin/bash

# jwt取得
JWT=$(
  aws ssm get-parameter \
    --name /sauna-engineering/line/channel/tetora1053/jwt \
    --with-decryption --query 'Parameter.Value' \
    --output text
)

# アクセストークン生成
RES=$(
  curl -v -X POST https://api.line.me/oauth2/v2.1/token \
    -H 'Content-Type: application/x-www-form-urlencoded' \
    --data-urlencode 'grant_type=client_credentials' \
    --data-urlencode 'client_assertion_type=urn:ietf:params:oauth:client-assertion-type:jwt-bearer' \
    --data-urlencode "client_assertion=${JWT}"
)
TOKEN=$(echo ${RES} | jq -r '.access_token')

# 通知先ID（UserID / GroupID）
SEND_TO=$(
  aws ssm get-parameter \
    --name /sauna-engineering/line/channel/tetora1053/send-to \
    --with-decryption --query 'Parameter.Value' \
    --output text
)

# LINE通知
curl -v -X POST https://api.line.me/v2/bot/message/push \
  -H 'Content-Type: application/json' \
  -H "Authorization: Bearer ${TOKEN}" \
  -d "{
      \"to\": \"${SEND_TO}\",
      \"messages\":[
          {
              \"type\":\"text\",
              \"text\":\"予約がはじまるよ！\"
          }
      ]
  }"
