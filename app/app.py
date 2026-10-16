import os
from flask import Flask, jsonify

app = Flask(__name__)

@app.get("/")
def home():
    return jsonify(
        project="Olu's Multi-Region Azure Platform",
        region=os.getenv("APP_REGION", "unknown"),
        instance=os.getenv("WEBSITE_INSTANCE_ID", "local"),
        status="running"
    )

@app.get("/health")
def health():
    return jsonify(status="healthy"), 200
