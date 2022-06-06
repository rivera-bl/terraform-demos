# NOTES

Current state lets us deploy pods. But t2.micro is way too small because it can Schedule only 4Pods, which are already used by: core-dns, aws-node, kube-proxy.
  *After updating the Instance Type to m5.large it kept the configuration of the previous instance, meaning that the temporal pod we tried to run was running already.

https://stackoverflow.com/questions/64965832/aws-eks-only-2-pod-can-be-launched-too-many-pods-error

# TODO

[ ] update kubeconfig automatically
[ ] stress nodes to test autoscaling
  gotta connect/hit the instances in the private subnets
  so i guess we have to deploy a load balancer for public http access
