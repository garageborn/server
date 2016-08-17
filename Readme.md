# Server

### Local Setup

```
brew install docker docker-compose docker-machine direnv
echo 'eval "$(direnv hook bash)"' >> ~/.bashrc
direnv allow
```

### Host Setup

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
# Disable Transparent Huge Pages (THP)
https://docs.mongodb.com/manual/tutorial/transparent-huge-pages/

# Increase TCP backlog
sudo bash -c "echo 'net.core.somaxconn=1024' >> /etc/sysctl.conf"

# Enable overcommit
sudo bash -c "echo 'overcommit_memory=1' >> /etc/sysctl.conf"

# Swap
sudo /bin/dd if=/dev/zero of=/mnt/swap bs=1M count=4096
sudo chown root:root /mnt/swap
sudo chmod 600 /mnt/swap
sudo /sbin/mkswap -f /mnt/swap
sudo /sbin/swapon /mnt/swap
sudo bash -c "echo '/mnt/swap swap swap defaults 0 0' >> /etc/fstab"
```

### Use it

```
docker-machine --storage-path docker/machine ls
docker-machine --storage-path docker/machine env app.production
eval $(docker-machine --storage-path docker/machine env app.production)
```
