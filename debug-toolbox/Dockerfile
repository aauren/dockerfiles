FROM ubuntu:22.04

RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    zsh curl wget openssh-server strace iproute2 dstat tshark lshw usbutils pciutils net-tools vim tcpdump \
      software-properties-common bmon ncdu less containerd git build-essential file jq

# Install brew
RUN /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" \
    && /bin/bash -c "(echo; echo 'eval "'"'"$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"'"'"') >> /root/.bashrc"

# various additional brew utilities
RUN /home/linuxbrew/.linuxbrew/bin/brew install kubectl nerdctl cri-tools helm
