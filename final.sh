#!/bin/bash
host1=$1
host2=$2
host3=$3
proxy=$4
ssh ubuntu@$host1 git clone https://github.com/harshvardhan1998/k8s.git
ssh ubuntu@$host1  chmod +x k8s/k8s.sh
ssh ubuntu@$host1 sudo su -c /home/ubuntu/k8s/k8s.sh root
ssh ubuntu@$host1 sudo su -c whoami root


ssh ubuntu@$host2 git clone https://github.com/harshvardhan1998/k8s.git
ssh ubuntu@$host2  chmod +x k8s/k8s.sh
ssh ubuntu@$host2 sudo su -c /home/ubuntu/k8s/k8s.sh root
ssh ubuntu@$host2 sudo su -c whoami root

ssh ubuntu@$host3 git clone https://github.com/harshvardhan1998/k8s.git
ssh ubuntu@$host3  chmod +x k8s/k8s.sh
ssh ubuntu@$host3 sudo su -c /home/ubuntu/k8s/k8s.sh root
ssh ubuntu@$host3 sudo su -c whoami root


ssh ubuntu@$host1 sudo kubeadm init --control-plane-endpoint $proxy:6443 --upload-certs --pod-network-cidr=10.244.0.0/16 |  grep -m1  certificate-key > a.sh
ssh ubuntu@$host1 mkdir -p $HOME/.kube
ssh ubuntu@$host1 sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
ssh ubuntu@$host1 sudo chown $(id -u):$(id -g) $HOME/.kube/config
ssh ubuntu@$host1 kubeadm token create --print-join-command | grep -m1 kubeadm > b.sh
ssh ubuntu@$host1 echo -n $(cat b.sh) > b.sh
ssh ubuntu@$host1 cat a.sh >> b.sh


scp  b.sh ubuntu@$host2:/home/ubuntu
ssh ubuntu@$host2 chmod +x b.sh
ssh ubuntu@$host2  sudo /home/ubuntu/b.sh 
ssh ubuntu@$host2 mkdir -p $HOME/.kube
ssh ubuntu@$host2 sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
ssh ubuntu@$host2 sudo chown $(id -u):$(id -g) $HOME/.kube/config


scp  b.sh ubuntu@$host3:/home/ubuntu
ssh ubuntu@$host3 chmod +x b.sh
ssh ubuntu@$host3  sudo /home/ubuntu/b.sh
ssh ubuntu@$host3 mkdir -p $HOME/.kube
ssh ubuntu@$host3 sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
ssh ubuntu@$host3 sudo chown $(id -u):$(id -g) $HOME/.kube/config



ssh ubuntu@$host1 kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/2140ac876ef134e0ed5af15c65e414cf26827915/Documentation/kube-flannel.yml
ssh ubuntu@$host1 kubectl taint nodes --all node-role.kubernetes.io/master-

