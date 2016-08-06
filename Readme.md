# Create Docker Machine

```
docker-machine -D create  \
  --driver amazonec2 \
  --amazonec2-instance-type t2.medium \
  --amazonec2-region us-east-1 \
  --amazonec2-retries 10 \
  --amazonec2-root-size 50 \
  --amazonec2-subnet-id subnet-16fda04e \
  --amazonec2-vpc-id vpc-3a41f55d \
  --amazonec2-zone d \
  app.production
```

```
docker-machine --storage-path docker/machine ls
docker-machine --storage-path docker/machine env app.production
eval $(docker-machine --storage-path docker/machine env app.production)
```