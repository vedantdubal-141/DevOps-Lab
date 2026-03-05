_# DevOps Lab

A collection of experiments exploring Linux internals, system configuration, and modern infrastructure tools.

The goal is not just to deploy software, but to understand the layers that make modern systems work — from hardware and firmware up to containers and orchestration.

---

## Learning Roadmap
```
[x] Linux boot process
[ ] Arch Linux installation
[ ] Proot VS Chroot
[ ] chroot termux-setup 
[ ] Docker networking
[ ] Reverse proxy setup
[ ] Kubernetes cluster
```
---
## Tree structure ( current/planned)
```
devops-lab/

linux-internals
  ├ amd64
  |  ├ boot-chain-internals
  |  ├ arch-install
  |  └ arch-install.sh 
  ├ termux
    ├ Proot VS Chroot
    ├ Arch chroot setup 
    └ Arch-Chroot.sh
  

containers
  ├ docker-basics
  ├ jellyfin-container
  └ reverse-proxy

infrastructure
  ├ NAS
  └ monitoring

orchestration
  └ kubernetes
```

## journey

```hardware
↓
firmware
↓
kernel
↓
init system
↓
distribution
↓
containers
↓
services
↓
orchestration
```

## Sections

### Linux Internals

Exploring how Linux actually works under the hood.

* Boot chain: UEFI → Bootloader → Kernel → initramfs → systemd
* Installing Arch Linux manually
* Running Linux environments on Android using chroot

### Containers

Moving from system internals to service deployment.

* Docker basics
* Docker networking
* Containerized services

### Infrastructure Experiments

Running real services and infrastructure components.

* Reverse proxy setup
* Media server (Jellyfin)
* Monitoring and logging

### Orchestration

Understanding distributed systems and cluster management.

* Kubernetes basics
* Container orchestration
