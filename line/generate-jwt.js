/*
  チャネルアクセストークン取得用JWT作成スクリプト
 */

import jose from "node-jose";
import fs from "fs";
import { SSMClient, GetParameterCommand } from "@aws-sdk/client-ssm";

const client = new SSMClient();

async function getParam(name) {
  const command = new GetParameterCommand({
    Name: name,
    WithDecryption: true,
  });
  return (await client.send(command)).Parameter.Value;
}

// アサーション署名キーID
const kid = await getParam("/sauna-engineering/line/channel/tetora1053/k-id");

// チャネルID
const channelId = await getParam(
  "/sauna-engineering/line/channel/tetora1053/channel-id"
);
const iss = channelId;
const sub = channelId;

const privateKey = JSON.parse(fs.readFileSync("../ops/key-pair/private.key"));

// キーIDを秘密鍵に追加
privateKey.kid = kid;

const header = `
{
    alg: "RS256",
    typ: "JWT",
    kid: "${kid}"
}
`;

const payload = `
{
    iss: "${iss}",
    sub: "${sub}",
    aud: "https://api.line.me/",
    exp: Math.floor(new Date().getTime() / 1000) + 60 * 30,
    token_exp: 60 * 60 * 24 * 30
}
`;

jose.JWS.createSign({ format: "compact", fields: header }, privateKey)
  .update(JSON.stringify(payload))
  .final()
  .then((result) => {
    console.log(result);
  });
