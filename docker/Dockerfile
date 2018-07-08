FROM centos7-bootable

MAINTAINER RJ Bergeron <rbergero@gmail.com>

# install packages
RUN yum -y install centos-release-qemu-ev && \
    yum -y install libvirt-daemon virt-install kvm libvirt-daemon-driver-network firewalld bridge-utils libvirt-daemon-kvm libvirt-daemon-driver-qemu \
                   && \
    yum clean all && rm -rf /var/cache/yum && \
    find / -type d \( -name proc -o -name sys \) -prune -o -iname \*.rpmnew -exec rm {} \;

# sysctl files
ADD /sysctl.d /etc/sysctl.d

# modprobe files
ADD /modprobe.d /etc/modprobe.d

# systemd-networkd files
ADD /systemd-network /etc/systemd/network
RUN find /etc/systemd/network -type f -exec chmod a+r {} \;

# udev rules (for bridge control)
ADD /udev-rules.d /etc/udev/rules.d

# reconfigure firewalld for vmm
RUN firewall-offline-cmd --new-zone vmm && \
    firewall-offline-cmd --zone vmm --add-interface vmm && \
    firewall-offline-cmd --direct --add-rule eb filter FORWARD 0 --logical-in vmm -j DROP && \
    firewall-offline-cmd --direct --add-rule eb filter FORWARD 1 --logical-out vmm -j DROP && \
    firewall-offline-cmd --zone vmm --add-service dhcp && \
    firewall-offline-cmd --zone vmm --add-service ntp && \
    firewall-offline-cmd --zone vmm --add-service http && \
    firewall-offline-cmd --zone vmm --add-port 3493/tcp

# reconfigure dnsmasq
RUN mkdir -p "/etc/systemd/system/dnsmasq.service.d" && ln -sf /lib/systemd/system/dnsmasq.service "/etc/systemd/system/multi-user.target.wants/dnsmasq.service"
ADD dnsmasq.conf /etc/dnsmasq.conf
ADD dnsmasq.service.d /

# reconfigure libvirt networking
ADD libvirt-networks /etc/libvirt/qemu/networks

# systemd services for tmux autoconsole
ADD systemd-system /etc/systemd/system
RUN ln -sf /etc/systemd/system/tmux-console.service /etc/systemd/system/multi-user.target.wants/tmux-console.service

# libvirt hook for tmux autoconsole
ADD libvirt-hook-qemu /etc/libvirt/hooks/qemu

# disable libvirt network autostarts
# rm -f /etc/libvirt/qemu/networks/autostart/*
