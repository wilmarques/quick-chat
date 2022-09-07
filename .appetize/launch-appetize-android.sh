curl -sS --http1.1 "https://$APPETIZE_API_TOKEN@api.appetize.io/v1/apps/$APPETIZE_PUBLICKEY" \
  -F "file=@build/app/outputs/flutter-apk/app.apk" \
  -F platform=android \
  -F "buttonText=Quick Chat" \
  -F "postSessionButtonText=Quick Chat" \
  > .appetize/upload-metadata.json

gp preview --external "https://appetize.io/embed/$APPETIZE_PUBLICKEY"
