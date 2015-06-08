# Latest Fedora
FROM fedora:22
MAINTAINER Takuya ASADA <syuu@cloudius-systems.com>

# install packages for OSv
RUN dnf -y install qemu-system-x86 qemu-img curl

# install capstan
RUN curl https://raw.githubusercontent.com/cloudius-systems/capstan/master/scripts/download | bash

# download redis-memonly
RUN /root/bin/capstan pull cloudius/osv-redis-memonly
RUN cp /root/.capstan/repository/cloudius/osv-redis-memonly/osv-redis-memonly.qemu /root/osv-redis-memonly.qcow2
RUN rm -rf ~/bin

# run VM
CMD ["/usr/bin/qemu-system-x86_64", "-nographic", "-m", "1024", "-smp", "2", "-device", "virtio-blk-pci,id=blk0,bootindex=0,drive=hd0", "-drive", "file=/root/osv-redis-memonly.qcow2,if=none,id=hd0,aio=native,cache=none", "-device", "virtio-rng-pci", "-netdev", "user,id=un0,net=192.168.122.0/24,host=192.168.122.1", "-device", "virtio-net-pci,netdev=un0", "-redir", "tcp:6379::6379"]
