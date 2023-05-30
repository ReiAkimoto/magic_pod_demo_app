#!/bin/bash -e

# (-eで、コマンドがエラーになった行で処理を終了させる)


# magicpod-apiクライアントの最新版を現在のディレクトリにダウンロード・解凍

OS=mac # Windowsはwindows、Linuxはlinux
APIKEY=a799525582024edbdca34ea2fede6d717321d442 # https://app.magicpod.com/accounts/api-token/よりコピーする
FILENAME=magicpod-api-client # 任意のファイル名

curl -L "https://app.magicpod.com/api/v1.0/magicpod-clients/api/${OS}/latest/" -H "Authorization: Token ${APIKEY}" --output ${FILENAME}.zip

unzip -fq ${FILENAME}.zip



# MagicPodで使う各種環境変数を設定。

# セキュリティのため、MAGICPOD_API_TOKENはCircleCIの環境変数で設定
export MAGICPOD_API_TOKEN=${APIKEY}

export MAGICPOD_ORGANIZATION=MagicPod10

export MAGICPOD_PROJECT=DemoApp




# 先ほど作成したappファイルをMagicPodにアップロードして、FILE_NOを取得

APP_PATH=/Users/rei/magicpod_created_app/Build/Products/Debug-iphonesimulator/magic_pod_demo_app.app
FILE_NO=$(./magicpod-api-client upload-app -a ${APP_PATH})




# 先ほどアップロードしたアプリと、設定番号の設定を使ってテスト一括実行

TEST_SETTING_NUMBER=8
./magicpod-api-client batch-run -S ${TEST_SETTING_NUMBER} -s "{\"app_file_number\":\"${FILE_NO}\"}"


# テストが成功した場合はアップロードしたアプリは削除(任意)

if [ $? = 0 ]; then

  ./magicpod-api-client delete-app -a ${FILE_NO}

fi