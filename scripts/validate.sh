#!/usr/bin/env bash
set -euo pipefail

required_files=(
  "Dockerfile"
  "docker-compose.yml"
  "requirements.txt"
  "app/app.py"
  "config/.env.example"
)

echo "Checking required project files..."

for file in "${required_files[@]}"; do
  if [[ ! -f "$file" ]]; then
    echo "ERROR: Missing required file: $file"
    exit 1
  fi
  echo "OK: $file"
done

echo
echo "Checking Python syntax..."
python3 -m py_compile app/app.py

echo "Python syntax check passed."

echo
echo "Checking Docker Compose configuration..."
docker compose config --quiet

echo "Docker Compose configuration is valid."
echo
echo "Validation completed successfully."
