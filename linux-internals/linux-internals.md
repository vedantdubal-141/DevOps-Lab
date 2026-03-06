# Linux Virtual Filesystems

Understanding Linux internals is not just about the kernel and boot process.
Several special directories inside `/` are **not real files on disk**, but **virtual filesystems created by the kernel at runtime**.

These directories expose kernel information, hardware interfaces, and runtime system state.

They become especially important when working with **chroot environments**, containers, and debugging system internals.

---

## Why Virtual Filesystems Exist

Traditional filesystems like `ext4`, `xfs`, or `btrfs` store data on disk.

Virtual filesystems instead expose **kernel structures as files**.
This follows a core Unix philosophy:

> Everything is a file.

This design allows tools and programs to interact with the kernel using standard file operations.

---

## `/proc` — Process and Kernel Information

`/proc` is a **pseudo-filesystem** that exposes runtime system information.

It allows users and programs to inspect the current state of the system.

Example:

```
/proc/cpuinfo
/proc/meminfo
/proc/uptime
/proc/<pid>/
```

Examples:

```bash
cat /proc/cpuinfo
cat /proc/meminfo
```

These files are **generated dynamically by the kernel**, not stored on disk.

### Why `/proc` Matters

- debugging system behavior
- inspecting running processes
- retrieving kernel statistics

Many system tools rely on `/proc`, including:

```
top
htop
ps
free
```

---

## `/sys` — Kernel Device Interface

`/sys` (also called **sysfs**) exposes information about devices and kernel subsystems.

It provides a structured way to inspect hardware devices managed by the kernel.

Example:

```
/sys/class
/sys/devices
/sys/block
```

You can inspect hardware devices like this:

```bash
ls /sys/class/net
```

This reveals network interfaces managed by the kernel.

### Why `/sys` Matters

- device management
- kernel driver interaction
- hardware inspection

Tools like `udev` rely heavily on `/sys`.

---

## `/dev` — Device Files

In Linux, hardware devices appear as files inside `/dev`.

Examples:

```
/dev/sda
/dev/nvme0n1
/dev/tty
/dev/null
```

Examples:

```bash
ls /dev
```

### Types of Devices

| Type              | Description                             |
| ----------------- | --------------------------------------- |
| Block devices     | Storage devices (SSD, HDD)              |
| Character devices | Serial interfaces, keyboards, terminals |
| Pseudo devices    | Virtual interfaces like `/dev/null`     |

Example:

```
/dev/null
```

Anything written to `/dev/null` disappears.

```bash
echo hello > /dev/null
```

---

## `/run` — Runtime System State

`/run` stores **temporary runtime information created during system operation**.

Examples:

```
/run/systemd
/run/lock
/run/user
```

This directory is usually mounted as a **tmpfs**, meaning it exists only in memory and disappears after reboot.

---

## Why This Matters for Chroot Environments

When entering a **chroot environment**, the new root filesystem does not automatically include these virtual filesystems.

Without them, many tools fail because they expect kernel interfaces to exist.

Typical solution:

```bash
mount --bind /proc /mnt/proc
mount --bind /sys /mnt/sys
mount --bind /dev /mnt/dev
```

These **bind mounts** expose the host system's kernel interfaces inside the chroot environment.

Without them:

- `ps` may fail
- `top` may fail
- package managers may behave incorrectly

This is why setting up these mounts is a **common step in container environments and Linux chroots**.

---

## Connection to Other Sections

This topic connects directly to:

```
linux-internals/boot-chain-internals.md
linux-internals/arch-install.md
arm64(termux-android)/chroot setup
```

Understanding these virtual filesystems explains **why chroot environments need access to `/proc`, `/sys`, and `/dev` to behave like a real Linux system**.

---

## Final Thoughts

Linux exposes much of its internal state through virtual filesystems.

Instead of hidden kernel APIs, Linux provides transparency by representing system state as files.

Once you understand `/proc`, `/sys`, `/dev`, and `/run`, many aspects of system behavior become much easier to reason about.

These interfaces are also foundational for technologies such as:

- containers
- chroot environments
- debugging tools
- system monitoring
