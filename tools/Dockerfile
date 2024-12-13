################################################################################
# Esta imagem foi customizada para conter as seguintes ferramentas cli
#
# git
#
# GitOps Cli
#       https://docs.openshift.com/gitops/1.12/installing_gitops/installing-argocd-gitops-cli.html#installing-argocd-gitops-cli
#       https://docs.openshift.com/gitops/1.12/gitops_cli_argocd/configuring-argocd-gitops-cli.html
#       https://docs.openshift.com/gitops/1.12/understanding_openshift_gitops/what-is-gitops.html
#
# Tekton
#       https://docs.openshift.com/pipelines/1.16/tkn_cli/installing-tkn.html
#
# oc    https://docs.openshift.com/container-platform/4.17/cli_reference/openshift_cli/getting-started-cli.html
#       https://docs.openshift.com/container-platform/4.17/cli_reference/openshift_cli/configuring-cli.html
#       Obs: Pegar a url de dowload console Web de sua instalação Openshift
#
# roxctl
#       https://docs.openshift.com/acs/4.6/cli/installing-the-roxctl-cli.html
#
################################################################################
#    Esta imagem 1.0 foi construida com as seguintes versções:
#    Git
#    git version 2.43.5
#
#    ArgoCD
#    argocd: v2.12.3+6b9cd82
#      BuildDate: 2024-09-13T16:22:27Z
#      GitCommit: 6b9cd828c6e9807398869ad5ac44efd2c28422d6
#      GitTreeState: clean
#      GoVersion: go1.21.11 (Red Hat 1.21.11-1.module+el8.10.0+21986+2112108a)
#      Compiler: gc
#      Platform: linux/amd64
#      ExtraBuildInfo: openshift-gitops-version: 1.14.0, release: 116
#
#    Tekton
#    Client version: 0.33.0
#
#    Rox
#    4.6.0
#
#    Oc
#    Client Version: 4.17.0-202410241236.p0.gdde885f.assembly.stream.el9-dde885f
#    Kustomize Version: v5.0.4-0.20230601165947-6ce0bf390ce3
################################################################################
FROM registry.access.redhat.com/ubi9:9.5-1732804088

ENV LANGUAGE='en_US:en'

USER root

RUN yum -y install git wget && \
    wget https://developers.redhat.com/content-gateway/file/pub/openshift-v4/clients/openshift-gitops/1.14.0-116/argocd-linux-amd64.tar.gz && \
    tar xvzf argocd-linux-amd64.tar.gz --no-same-owner && \
    mv argocd /usr/local/bin/argocd && \
    chmod +x /usr/local/bin/argocd && \
    rm -rf argocd-linux-amd64.tar.gz && \
    wget  https://mirror.openshift.com/pub/openshift-v4/clients/pipelines/1.13.0/tkn-linux-amd64.tar.gz && \
    tar xzvf tkn-linux-amd64.tar.gz --no-same-owner && \
    mv opc /usr/local/bin/ &&  \
    mv tkn /usr/local/bin/ && \
    mv tkn-pac /usr/local/bin/ && \
    rm -rf tkn-linux-amd64.tar.gz && \
    arch="$(uname -m | sed "s/x86_64//")"; arch="${arch:+-$arch}" && \
    curl -L -f -o roxctl "https://mirror.openshift.com/pub/rhacs/assets/4.6.0/bin/Linux/roxctl${arch}" && \
    chmod +x roxctl && \
    mv roxctl /usr/local/bin/ && \
    wget https://downloads-openshift-console.apps.cluster-9vms9.dynamic.redhatworkshops.io/amd64/linux/oc.tar && \
    tar xvf oc.tar && \
    chmod +x oc && \
    mv oc /usr/local/bin/ && \
    rm -rf oc.tar && \
    oc completion bash > oc_bash_completion &&  \
    mv oc_bash_completion /etc/bash_completion.d/ && \
    echo "------------------" &&  \
    echo "Git " && \
    git --version && \
    echo "ArgoCD " && \
    argocd version --client && \
    echo "Tekton " && \
    tkn version && \
    echo "Rox " && \
    roxctl version && \
    echo "Oc " && \
    oc version




