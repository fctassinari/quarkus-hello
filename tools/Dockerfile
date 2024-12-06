################################################################################
# Esta imagem foi customizada para conter as seguintes ferramentas cli
#
# git
# GitOps Cli
#       https://docs.openshift.com/gitops/1.12/installing_gitops/installing-argocd-gitops-cli.html#installing-argocd-gitops-cli
#       https://docs.openshift.com/gitops/1.12/gitops_cli_argocd/configuring-argocd-gitops-cli.html
#       https://docs.openshift.com/gitops/1.12/understanding_openshift_gitops/what-is-gitops.html
#
# Tekton
#       https://docs.openshift.com/pipelines/1.16/tkn_cli/installing-tkn.html
# oc
# roxctl
#
################################################################################
FROM registry.access.redhat.com/ubi9:9.5-1732804088

ENV LANGUAGE='en_US:en'

USER root

#RUN yum -y install git wget && \
#    git --version && \
#    wget https://developers.redhat.com/content-gateway/file/pub/openshift-v4/clients/openshift-gitops/1.14.0-116/argocd-linux-amd64.tar.gz && \
#    tar xvzf argocd-linux-amd64.tar.gz --no-same-owner&& \
#    mv argocd /usr/local/bin/argocd && \
#    chmod +x /usr/local/bin/argocd && \
#    argocd version --client

RUN yum install -y wget &&  \
    wget  https://mirror.openshift.com/pub/openshift-v4/clients/pipelines/1.13.0/tkn-linux-amd64.tar.gz && \
    tar xzvf argocd-linux-amd64.tar.gz \
    mv opc /usr/local/bin/ &&  \
    mv tkn /usr/local/bin/ && \
    mv tkn-pac /usr/local/bin/ && \
    tkn version



