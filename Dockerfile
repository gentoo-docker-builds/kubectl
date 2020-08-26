# ------------------- builder stage
FROM gentoo/stage3-amd64 as builder
ENV FEATURES="-mount-sandbox -ipc-sandbox -network-sandbox -pid-sandbox -usersandbox"

# ------------------- portage tree
COPY --from=gentoo/portage:latest /var/db/repos/gentoo /var/db/repos/gentoo

# ------------------- emerge
RUN emerge -C sandbox
RUN echo 'sys-cluster/kubernetes USE="kubectl -hardened -kube-apiserver -kube-controller-manager -kube-proxy -kube-scheduler -kubeadm -kubelet"' >> /etc/portage/package.use/kubectl
RUN ROOT=/kubectl emerge sys-cluster/kubernetes


# ------------------- shrink
RUN ROOT=/kubectl emerge --quiet -C \
      app-admin/*\
      sys-apps/* \
      sys-kernel/* \
      virtual/* 

# ------------------- empty image
FROM scratch
COPY --from=builder /kubectl /