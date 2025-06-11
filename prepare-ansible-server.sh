#!/usr/bin/env bash


#!/bin/bash
set -e
apt update -y
apt install -y python3-pip
python3 -m pip install --upgrade pip
pip install boto3 botocore
