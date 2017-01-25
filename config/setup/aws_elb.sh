aws elb create-load-balancer-policy \
  --load-balancer-name load-balancer \
  --policy-name EnableProxyProtocol  \
  --policy-type-name ProxyProtocolPolicyType \
  --policy-attributes AttributeName=ProxyProtocol,AttributeValue=True

aws elb set-load-balancer-policies-for-backend-server \
  --load-balancer-name load-balancer \
  --instance-port 443 \
  --policy-names EnableProxyProtocol

aws elb describe-load-balancers \
  --load-balancer-name load-balancer
