################################################################################
# Esta imagem foi customizada para conter as seguintes ferramentas cli
#
# git
# GitOps Cli
#       https://docs.openshift.com/gitops/1.12/installing_gitops/installing-argocd-gitops-cli.html#installing-argocd-gitops-cli
#       https://docs.openshift.com/gitops/1.12/gitops_cli_argocd/configuring-argocd-gitops-cli.html
#
# oc
# roxctl
#
################################################################################
FROM registry.access.redhat.com/ubi9:9.5-1732804088

ENV LANGUAGE='en_US:en'

USER root

#RUN yum -y install git && \
#    git --version
RUN  curl -O https://developers.redhat.com/content-gateway/file/pub/openshift-v4/clients/openshift-gitops/1.14.0-116/argocd-linux-amd64.tar.gz && \
    tar xvzf argocd-linux-amd64.tar.gz && \
    mv argocd /usr/local/bin/argocd && \
    chmod +x /usr/local/bin/argocd && \
    argocd version --client


