# ------------------- builder stage
FROM ghcr.io/gentoo-docker-builds/gendev:latest as builder

# ------------------- emerge
RUN emerge -C sandbox
COPY portage/kubectl.accept_keywords /etc/portage/package.accept_keywords/kubectl
RUN ROOT=/kubectl FEATURES='-usersandbox' emerge sys-cluster/kubectl

# ------------------- shrink
#RUN ROOT=/kubectl emerge --quiet -C \
#      app-admin/*\
#      sys-apps/* \
#      sys-kernel/* \
#      virtual/* 

# ------------------- empty image
FROM scratch
ENV PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
COPY --from=builder /kubectl /
