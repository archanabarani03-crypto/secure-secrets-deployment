#!/usr/bin/env bash
set -euo pipefail

: "${AWS_REGION:?Set AWS_REGION}"
: "${SECRET_ARN:?Set SECRET_ARN}"

echo "Checking AWS identity..."
aws sts get-caller-identity --query Arn --output text

echo "Checking Secrets Manager access..."

ACTUAL_ARN=$(aws secretsmanager get-secret-value \
  --secret-id "$SECRET_ARN" \
  --region "$AWS_REGION" \
  --query ARN \
  --output text)

if [[ "$ACTUAL_ARN" != "$SECRET_ARN" ]]; then
  echo "ERROR: Returned secret ARN does not match the expected ARN."
  exit 1
fi

echo "Secrets Manager access verified."
