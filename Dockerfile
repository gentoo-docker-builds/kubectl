# ------------------- builder stage
FROM ghcr.io/gentoo-docker-builds/gendev:latest as builder

# ------------------- emerge
RUN emerge -C sandbox
COPY portage/kubectl.accept_keywords /etc/portage/package.accept_keywords/kubectl
RUN ROOT=/kubectl FEATURES='-usersandbox' emerge sys-cluster/kubectl

# ------------------- empty image
FROM scratch
ENV PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
COPY --from=builder /kubectl /
