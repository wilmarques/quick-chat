export APPETIZE_API_TOKEN=tok_5ng3zynszmcb7535pzf7zfpnja

curl -sS --http1.1 "https://$APPETIZE_API_TOKEN@api.appetize.io/v1/apps/$APPETIZE_PUBLICKEY" \
  -F "file=@/workspace/template-flutter/build/app/outputs/flutter-apk/app.apk" \
  -F platform=android \
  -F "buttonText=Start App" \
  -F "postSessionButtonText=Start App" \
  > .appetize.json

          APPETIZE_PUBLICKEY=$(jq -r .publicKey .appetize.json)
          gp env "APPETIZE_PUBLICKEY=$APPETIZE_PUBLICKEY"
          export APPETIZE_PUBLICKEY
          gp preview "https://appetize.io/embed/$APPETIZE_PUBLICKEY?device=pixel4&autoplay=true"
