FROM ubuntu:22.04

RUN apt-get update && apt-get install -y --no-install-recommends \
    zsh curl wget openssh-server strace iproute2 dstat tshark lshw usbutils pciutils net-tools vim tcpdump \
      software-properties-common bmon ncdu

# kubectl
RUN curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" \
      -o /usr/local/bin

# helm
RUN curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 \
    && chmod 700 get_helm.sh \
    && ./get_helm.sh
