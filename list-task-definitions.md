---

# AWS ECS Task Definition Scripts

This document provides scripts and AWS CLI commands to list and filter AWS ECS task definitions in the `us-east-2` region that contain the string `uat` in their names. It also ensures that only the **latest version** of each task definition family is returned.

---

## Script: Filter Latest Versions of Task Definitions

This script retrieves all task definitions containing `uat` in their names, extracts the latest version for each task definition family, and prints the results.

### Script Code

```bash
#!/bin/bash

# Get all task definitions containing "uat"
task_definitions=$(aws ecs list-task-definitions --region us-east-2 --output json | jq -r '.taskDefinitionArns[] | select(contains("uat"))')

# Extract unique families and their latest versions
declare -A latest_versions
for arn in $task_definitions; do
  family=$(echo "$arn" | awk -F: '{sub(/:[0-9]+$/, "", $0); print $0}')
  version=$(echo "$arn" | awk -F: '{print $NF}')
  if [[ -z "${latest_versions[$family]}" || "${latest_versions[$family]}" -lt "$version" ]]; then
    latest_versions[$family]=$version
  fi
done

# Print the latest version for each family
for family in "${!latest_versions[@]}"; do
  echo "$family:${latest_versions[$family]}"
done
```

### How It Works
1. **List Task Definitions**:
   - The `aws ecs list-task-definitions` command lists all task definitions in the `us-east-2` region.
   - The `jq` command filters task definitions whose ARNs contain the string `uat`.

2. **Extract Latest Versions**:
   - The script iterates through the filtered task definitions.
   - It extracts the task definition family name and version number.
   - It keeps track of the latest version for each family using an associative array.

3. **Print Results**:
   - The script prints the latest version of each task definition family.

---

## CLI Command: Filter and Sort Task Definitions

This AWS CLI command lists all task definitions containing `uat` in their names, sorts them by version, and extracts the latest version for each family.

### Command

```bash
aws ecs list-task-definitions --region us-east-2 --output json | \
jq -r '.taskDefinitionArns[] | select(contains("uat"))' | \
sort -V | \
awk -F: '{family=$0; sub(/:[0-9]+$/, "", family); versions[family]=$0} END {for (f in versions) print versions[f]}'
```

### How It Works
1. **List Task Definitions**:
   - The `aws ecs list-task-definitions` command lists all task definitions in the `us-east-2` region.

2. **Filter Task Definitions**:
   - The `jq` command filters task definitions whose ARNs contain the string `uat`.

3. **Sort by Version**:
   - The `sort -V` command sorts the task definitions by version number.

4. **Extract Latest Versions**:
   - The `awk` command groups task definitions by family name and keeps only the latest version for each family.

---

## Example Output

For the following task definitions:
```
arn:aws:ecs:us-east-2:123456789012:task-definition/uat-task:1
arn:aws:ecs:us-east-2:123456789012:task-definition/uat-task:2
arn:aws:ecs:us-east-2:123456789012:task-definition/uat-task:3
arn:aws:ecs:us-east-2:123456789012:task-definition/uat-app:1
arn:aws:ecs:us-east-2:123456789012:task-definition/uat-app:2
```

The output will be:
```
arn:aws:ecs:us-east-2:123456789012:task-definition/uat-task:3
arn:aws:ecs:us-east-2:123456789012:task-definition/uat-app:2
```

---

## Prerequisites
- **AWS CLI**: Ensure the AWS CLI is installed and configured with the necessary permissions.
- **`jq`**: Install `jq` for JSON parsing (e.g., `sudo apt install jq` on Ubuntu).
- **`awk` and `sort`**: These are standard Unix tools available on most systems.

---

## Usage
1. Save the script to a file (e.g., `filter_task_definitions.sh`).
2. Make the script executable:
   ```bash
   chmod +x filter_task_definitions.sh
   ```
3. Run the script:
   ```bash
   ./filter_task_definitions.sh
   ```

---

## Notes
- Replace `us-east-2` with your desired AWS region if necessary.
- Ensure the AWS CLI is configured with the correct credentials and permissions to access ECS resources.

---
