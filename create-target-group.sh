#!/bin/bash

# Check if required arguments are provided
if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <VPC_ID> <TARGET_GROUP_NAME>"
    exit 1
fi

# Assign arguments to variables
VPC_ID=$1
TARGET_GROUP_NAME=$2

# Create the Target Group
TARGET_GROUP_ARN=$(aws elbv2 create-target-group \
    --name $TARGET_GROUP_NAME \
    --protocol HTTP \
    --port 80 \
    --vpc-id $VPC_ID \
    --health-check-protocol HTTP \
    --health-check-path / \
    --health-check-interval-seconds 30 \
    --health-check-timeout-seconds 5 \
    --healthy-threshold-count 3 \
    --unhealthy-threshold-count 3 \
    --target-type ip \
    --query 'TargetGroups[0].TargetGroupArn' \
    --output text)

# Check if the target group was created successfully
if [ $? -eq 0 ]; then
    echo "Target Group created successfully!"
    echo "Target Group ARN: $TARGET_GROUP_ARN"
else
    echo "Failed to create Target Group."
    exit 1
fi