import json
import os

import boto3
from botocore.exceptions import BotoCoreError, ClientError
from flask import Flask, jsonify

app = Flask(__name__)

AWS_REGION = os.environ.get("AWS_REGION", "ap-south-1")
SECRET_ARN = os.environ.get("SECRET_ARN")

if not SECRET_ARN:
    raise RuntimeError("SECRET_ARN environment variable is required")


def load_secrets():
    client = boto3.client(
        "secretsmanager",
        region_name=AWS_REGION
    )

    try:
        response = client.get_secret_value(
            SecretId=SECRET_ARN
        )

        values = json.loads(response["SecretString"])

        required = [
            "db_username",
            "db_password",
            "api_key"
        ]

        if any(not values.get(key) for key in required):
            raise RuntimeError(
                "Required secret fields are missing"
            )

        return values

    except (ClientError, BotoCoreError, ValueError):
        raise RuntimeError(
            "Secret retrieval failed. Check IAM permissions "
            "and the secret format."
        ) from None


secrets = load_secrets()


@app.route("/")
def home():
    return jsonify({
        "application": "Secure Secrets Demo",
        "status": "running",
        "secret_source": "AWS Secrets Manager"
    })


@app.route("/health")
def health():
    return jsonify({
        "status": "healthy"
    }), 200


@app.route("/secret-check")
def secret_check():
    return jsonify({
        "credentials_loaded": True
    }), 200
