aws elbv2 create-target-group \
    --name uat-usea2-ops-legacy-apids \
    --protocol HTTP \
    --port 80 \
    --vpc-id vpc-0965f361c571ceb85 \
    --health-check-protocol HTTP \
    --health-check-path / \
    --health-check-interval-seconds 30 \
    --health-check-timeout-seconds 5 \
    --healthy-threshold-count 3 \
    --unhealthy-threshold-count 3 \
    --target-type ip

### How to Use:
1. Save the script to a file, e.g., `create-target-group.sh`.
2. Make the script executable:
   ```sh
   chmod +x create-target-group.sh
   ```
3. Run the script by passing the `VPC ID` and `Target Group Name` as arguments:
   ```sh
   ./create-target-group.sh vpc-xxxxxxxx my-ip-target-group
   ```

### Explanation:
- The script takes two arguments: `VPC ID` and `Target Group Name`.
- It uses the `aws elbv2 create-target-group` command to create the target group with the specified parameters.
- The `--query` and `--output text` flags extract the ARN of the created target group.
- If the target group is created successfully, the script outputs the ARN. Otherwise, it reports an error.

This script is flexible and allows you to dynamically specify the `VPC ID` and `Target Group Name` during execution.

To list all target groups whose names contain the substring `uat`

### If `jq` is installed:
If you prefer using `jq` for more advanced filtering, you can use:

```sh
aws elbv2 describe-target-groups | jq -r '.TargetGroups[] | select(.TargetGroupName | contains("uat")) | .TargetGroupName'
```

### Explanation:
- `jq -r`: Processes the JSON output and returns raw strings.
- `select(.TargetGroupName | contains("uat"))`: Filters target groups whose names contain `uat`.
- `.TargetGroupName`: Extracts only the target group names.

### Example Output:
If there are target groups named `my-uat-target-group`, `uat-backend`, and `production-target-group`, the output will be:

```
my-uat-target-group
uat-backend
```

This command will list only the target groups that have `uat` in their names.