# Secure Secrets Deployment Using AWS Secrets Manager

## Problem Statement
Storing database passwords and API keys in source code or configuration files
can expose credentials through Git repositories, Docker images, and logs.

## Objective
Retrieve application credentials from AWS Secrets Manager using an EC2 IAM role
instead of hardcoding secret values.

## Architecture
Developer -> GitHub -> GitHub Actions / Jenkins -> Docker Application
Docker Application -> EC2 IAM Role -> AWS Secrets Manager

## Technologies
- AWS EC2, IAM, and Secrets Manager
- Docker and Docker Compose
- Jenkins and GitHub Actions
- Python, Flask, Boto3, and Gunicorn

## Configuration
The local .env file contains AWS_REGION and SECRET_ARN only.
It must not contain database passwords or API keys.
The .env file is excluded from Git.

## Run the Application
```bash
set -a
source .env
set +a
sudo docker compose build
sudo docker compose up -d
sudo docker compose ps
curl -i http://127.0.0.1:8081/health
Expected health response: HTTP 200 with {"status":"healthy"}.

## AWS Permissions
Attach an EC2 IAM role with least-privilege permission to call
secretsmanager:GetSecretValue for the required secret.

Do not store static AWS access keys in the application or container.

## Troubleshooting
- AccessDeniedException: Check IAM policy and secret ARN.
- Unable to locate credentials: Check EC2 role attachment and metadata access.
- Port conflict: Check listening processes and container port mappings.
- Container failure: Run sudo docker compose logs --tail=100 secure-app.

## Root Cause
Hardcoded credentials can be exposed through source control, logs, or images.

## Prevention
- Store credentials in AWS Secrets Manager.
- Use least-privilege IAM roles.
- Exclude .env and private keys from Git.
- Scan repositories for exposed secrets.
- Rotate credentials and monitor access.
- Restrict Jenkins and Docker permissions.

## Limitations
This is a demonstration application. It loads required secret fields but does
not connect to a real database or external API. Production use requires
additional authentication, TLS, monitoring, and tested secret rotation.
