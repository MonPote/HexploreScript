echo Begin the script
echo Get the old instance id
old_instance_id=$(aws ec2 describe-instances --output text --filters "Name=tag-value,Values=meteor" "Name=instance-state-code,Values=0,16" --query 'Reservations[*].Instances[0].InstanceId')
new_instance_id=$(aws ec2 run-instances --image-id ami-2d39803a --security-group-ids sg-c7b745bd --count 1 --instance-type t2.micro --key-name ec2-kideep-dev-key --output text --query 'Instances[0].InstanceId')
aws ec2 disassociate-address --public-ip 52.207.72.166
aws ec2 terminate-instances --instance-ids $old_instance_id
echo begin to wait
aws ec2 wait instance-running --instance-ids $new_instance_id
echo finish to wait
aws ec2 associate-address --instance-id $new_instance_id --public-ip 52.207.72.166
aws ec2 create-tags --resources $new_instance_id --tags 'Key="Name",Value=meteor'
