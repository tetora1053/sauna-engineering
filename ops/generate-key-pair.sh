#!/bin/bash
#
# クライアントアサーション署名用の鍵ペア生成
# 鍵ファイルはGit管理しない
# 事前にjwxインストール必要
# https://github.com/lestrrat-go/jwx.git
# 

SCRIPT_DIR=$(cd $(dirname $0); pwd)
KEY_DIR=${SCRIPT_DIR}/key-pair
jwx jwk generate --type RSA --keysize 2048 --template '{"alg":"RS256","use":"sig"}' > ${KEY_DIR}/private.key
jwx jwk format --public-key ${KEY_DIR}/private.key > ${KEY_DIR}/public.key
