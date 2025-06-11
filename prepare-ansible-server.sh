#!/bin/bash
set -e
echo "[+] Updating system..."
apt update -y
echo "[+] Installing Python dependencies..."
apt install -y python3-pip python3-boto3 python3-botocore