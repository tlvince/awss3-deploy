#!/usr/bin/env bash
set -euo pipefail

now="$(gdate --utc --iso-8601=seconds)"

echo "uploading"
aws s3 cp "$LOCAL_DIR" "s3://$BUCKET/$UPLOAD_DIR-$now/" \
  --recursive \
  --exclude index.html \
  --cache-control "max-age=31557600"  # 1 year

aws s3 cp "$LOCAL_DIR/index.html" "s3://$BUCKET/$UPLOAD_DIR-$now/" \
  --cache-control "no-cache, no-store"

echo "archiving"
aws s3 mv "s3://$BUCKET/$UPLOAD_DIR" "s3://$BUCKET/archive/$UPLOAD_DIR/$now" \
  --recursive

echo "deploying latest"
aws s3 mv "s3://$BUCKET/$UPLOAD_DIR-$now" "s3://$BUCKET/$UPLOAD_DIR" \
  --recursive
