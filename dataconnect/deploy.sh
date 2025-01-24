#!/bin/bash

# Set your project ID
PROJECT_ID="earnit-e983d"
INSTANCE_NAME="earnit2-fdc"
DATABASE_NAME="fdcdb"
SERVICE_NAME="earnit2"
REGION="us-central1"

# Enable required APIs
gcloud services enable \
    sqladmin.googleapis.com \
    cloudresourcemanager.googleapis.com \
    firebase.googleapis.com \
    firebasedatabase.googleapis.com

# Create Cloud SQL instance if it doesn't exist
if ! gcloud sql instances describe $INSTANCE_NAME > /dev/null 2>&1; then
    echo "Creating Cloud SQL instance..."
    gcloud sql instances create $INSTANCE_NAME \
        --database-version=POSTGRES_14 \
        --region=$REGION \
        --tier=db-f1-micro \
        --root-password=YOUR_PASSWORD_HERE
fi

# Create database if it doesn't exist
if ! gcloud sql databases describe $DATABASE_NAME --instance=$INSTANCE_NAME > /dev/null 2>&1; then
    echo "Creating database..."
    gcloud sql databases create $DATABASE_NAME --instance=$INSTANCE_NAME
fi

# Create Firebase Data Connect service if it doesn't exist
if ! gcloud firebase dataconnect services describe $SERVICE_NAME --location=$REGION > /dev/null 2>&1; then
    echo "Creating Firebase Data Connect service..."
    gcloud firebase dataconnect services create $SERVICE_NAME \
        --location=$REGION \
        --project=$PROJECT_ID
fi

# Deploy Data Connect configuration
echo "Deploying Data Connect configuration..."
firebase dataconnect:deploy 