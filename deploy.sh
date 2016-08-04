#!/usr/bin/env bash
set -euo pipefail

now="$(date --utc --iso-8601=seconds)"

echo "uploading"
aws s3 cp "$LOCAL_DIR" "s3://$BUCKET/$UPLOAD_DIR-$now/" \
  --recursive \
  --exclude index.html \
  --exclude sw.js \
  --cache-control "max-age=31557600"  # 1 year

aws s3 cp "$LOCAL_DIR/index.html" "s3://$BUCKET/$UPLOAD_DIR-$now/" \
  --cache-control "no-cache, no-store"

aws s3 cp "$LOCAL_DIR/sw.js" "s3://$BUCKET/$UPLOAD_DIR-$now/" \
  --cache-control "no-cache, no-store"

echo "archiving"
aws s3 mv "s3://$BUCKET/$UPLOAD_DIR" "s3://$BUCKET/archive/$UPLOAD_DIR/$now" \
  --recursive

echo "deploying latest"
aws s3 mv "s3://$BUCKET/$UPLOAD_DIR-$now" "s3://$BUCKET/$UPLOAD_DIR" \
  --recursive
