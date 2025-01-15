![img.png](imagens/smanager.png)

# Introdução
Este projeto visa a criação de um pipeline genérico para atender aplicações java sobre JBoss.

É possivel encontrar aqui a instalação do ferramental e a criação da esteira e suas tasks.

## Contas
- ArgoCD
    - rota: https://openshift-gitops-server-openshift-gitops.apps.cluster-876kv.sandbox2100.opentlc.com/
    - user: admin
    - pass: l1ZoSL9fICDKzjt8HMExYBuwa5GFObc6

- ACS
    - rota: https://central-stackrox.apps.cluster-876kv.sandbox2100.opentlc.com
    - user: admin
    - pass: admin1234

- Quay
    - rota: https://smanager-registry-quay-quay.apps.cluster-876kv.sandbox2100.opentlc.com/
    - user: admin
    - pass: admin1234

- Nexus
  - rota: https://nexus.apps.cluster-876kv.sandbox2100.opentlc.com/
  - user: admin
  - pass: admin1234
  
- Sonarqube
    - rota: https://sonarqube.apps.cluster-876kv.sandbox2100.opentlc.com/
    - user: admin
    - pass: admin1234

- Gogs
    - rota: http://gogs-gogs.apps.cluster-876kv.sandbox2100.opentlc.com/
    - user: gogs
    - pass: gogs



## Clusters
[Produção](https://console-openshift-console.apps.kilpro4820.pro.intra.rs.gov.br/)<br>
[Homologação](https://console-openshift-console.apps.kildes4830.des.intra.rs.gov.br/)
## Pré requisitos
### Ferramentas
- Uma máquina bastion com RHEL 8+
- Openshift Cluster 4.7+
- `oc` binary
- Ansible 2.7+
- Git

* [Install Ansible](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html#installing-ansible-on-rhel-centos-or-fedora)

* [Install Kubernetes Ansible Module](https://docs.ansible.com/ansible/latest/collections/kubernetes/core/k8s_module.html)

```
ansible-galaxy collection install community.kubernetes
pip3 install kubernetes
pip3 install openshift
```

Algumas dependenicas extras do Python:

```
pip3 install jmespath
```

### Projeto

Ajustes básicos
- No arquivo deploy_pipeline.yaml fazer os ajustes básicos
    - company_name
    - pipeline_sufix
    - acs_central_password_base64
        - echo -n admin1234 | base64 R: YWRtaW4xMjM0
    - acs_central_password_plain_text
    - quay_admin_password
- Criar um ServiceAccount e armazernar seu token em sa_cluster_admin_token
  - ```
    Executar /tools/criar-sa-cluster-adim.sh
    oc create sa cluster-admin-sa -n kube-system
    oc adm policy add-cluster-role-to-user cluster-admin -z cluster-admin-sa -n kube-system
    oc create token cluster-admin-sa -n kube-system --duration=999999h
    ```
- cluster_url
- nexus_password


- Criar rota do registry
  - ```
    oc patch configs.imageregistry.operator.openshift.io/cluster --patch '{"spec":{"defaultRoute":true}}' --type=merge
    oc get route -n openshift-image-registry
    ```
    
- Importar a imagem java do repositorio redhat para o registry do OCP<br>
  - Acessar a página do container quarkus
  - ```
    https://catalog.redhat.com/software/containers/ubi9/openjdk-21/6501cdb5c34ae048c44f7814
    ```
    - Seguir as instruções do link no destaque amarelo abaixo, o arquivo gerado colar na pasta tools
      ![img.png](imagens/openjdk-21.png)
    - Executar os comandos oc abaixo:
 
  - ```
    oc create -f 6095290_tassinari-secret-redhat.yaml -n openshift
    oc create -f kube-openjdk-21-pod.yaml -n openshift
    oc import-image ubi9/openjdk-21:1.21-3 --from=registry.redhat.io/ubi9/openjdk-21:1.21-3 --confirm -n openshift
    oc get is -n openshift | grep openjdk-21
    oc delete pod kube-openjdk-21-pod -n openshift
    oc delete secret 6095290-tassinari-pull-secret -n openshift
    ```

# Instalação
## RedHat Openshift Pipelines e RedHat Openshift GitOps
- No bastion autenticar no Openshift de des/hml
  ```
  oc login -u <user> -p <pass> --server=https://apps.cluster-876kv.sandbox2100.opentlc.com:6443
  ```
- No arquivo deployment_pipeline.yaml descomentar o bloco abaixo e executar o arquivo install.sh
  ```
    - name: 'Install Gitops and Pipeline'
      include_role:
        name: "1-ocp4-install-gitops-pipeline"
    ```
  Executar
  ```
  install.sh
  ```
- Create Namespaces  
- Get cluster version
- Create GitOps Operator Group
- Install GitOps Operator
- Get ArgoCD route
- Install OCP Pipelines Operator
- Configurar os Operators GitOps e Pipelines para serem executados nos infra-nodes<br>
  Ajustar no Subscription yaml
  ![img.png](imagens/gitops-pipelines-tolerations.png)
  - ```
    spec:
      channel: latest
      config:
        nodeSelector:
          env: ocp-infra-dev
          node-role.kubernetes.io/infra: ''
        tolerations:
          - effect: NoSchedule
            key: node-role.kubernetes.io/infra
            value: reserved
          - effect: NoExecute
            key: node-role.kubernetes.io/infra
            value: reserved
    ```
 - Pegar a senha do ArgoCD na openshift-gitops / secret / openshift-gitops-cluster para autenticação no console web  
  ![img.png](imagens/argocd-pass.png)


## Advanced Cluster Security for Kubernetes
- No arquivo deployment_pipeline.yaml comentar o bloco anterior, descomentar o bloco abaixo e executar o arquivo install.sh
  - ```
    - name: 'Install the ACS Central'
      include_role:
      name: "2-ocp4-install-acs"
    ```
- Create Namespaces    
- Central
    - Get cluster version
    - Create ACS Central password
    - Install ACS Operator
    - Wait for ACS CRD to exist
    - Wait for ACS Operator to be up and running
    - Create ACS Central
    - Get central route
    - Wait for Central availability
- Secured Cluster
    - Get cluster init bundle
    - Create init-bundle secrets
    - Install Sensor on OpenShift Container Platform
    - Determine number of collectors
- Config Post ACS
    - Get ACS central route
    - Creating ACS Integration with the Openshift Internal Registry

# Install NooBaa
- No arquivo deployment_pipeline.yaml comentar o bloco anterior, descomentar o bloco abaixo e executar o arquivo install.sh
  ```
    - name: 'Install Pipeline'
      include_role:
      name: "3-ocp4-install-noobaa"
    ```
- Get cluster version
- Obtain Channel from Version
- Set Openshift Channel
- Create OpenShift Objects to install Noobaa
  - odf-namespace.yaml.j2
  - operatorgroup-storage.yaml.j2
  - odf-subscription.yaml.j2
- Create Noobaa Object
- Get Default Openshift Storage Class
- Get any other Storage Class
- Use default storage class if it was set
- Try other possible storage class if no defined/default storage class
- Create NooBaa Backing Store
- Patch Bucket Class with Backing Store


# Install Quay
- No arquivo deployment_pipeline.yaml comentar o bloco anterior, descomentar o bloco abaixo e executar o arquivo install.sh
  ```
    - name: 'Install Pipeline'
      include_role:
      name: "4-ocp4-install-quay"
    ```
- install-quay
  - quay-namespace
  - quay-subscription
  - Wait for QuayRegistry CRD to exist
  - Create Quay Registry Object
- configure-quay
  - extract quay hostname
  - Wait until Quay Application is Responding
  - Initialize Quay User
  - Set Output Message from Quay on User Initalize
  - Use API Token to continue Creating
    - Set Quay Access Token
    - Create Quay Organization
    - Create Robot Account
    - Set Robot Token from Creating New Robot Account


- Copirar o robot token e atualizar no 7-install-application/defaults/main.yaml a variavel
  - ```
    quay_robot_token
    ```

- Gerar token no quay e atualizar no deployment_pipeline.yaml a variavel
  - ```
    https://docs.redhat.com/en/documentation/red_hat_quay/3/html-single/red_hat_quay_api_guide/index#creating-oauth-access-token
   
    quay_application_access_token
    ```

## CICD Infra
- No arquivo deployment_pipeline.yaml comentar o bloco anterior, descomentar o bloco abaixo e executar o arquivo install.sh
  ```
    - name: 'Install Pipeline'
      include_role:
      name: "5-ocp4-install-cicd-infra"
    ```
- Create Namespaces
### Sonarqube
- Install sonarqube
- Get sonarqube route
- Wait for sonarqube to be running
    - Acessar o sonarqube e utilizar:<br>
      User: admin<br>
      Pass: admin<br>
      ![img.png](imagens/sonar-login.png)<br>
      Na sequência será solicitado atualizar a senha de administrador<br>
    - Criar token da conta admin <br>
      Clicar em Avatar / My Account / Security<br>
      ![img_1.png](imagens/sonar-token.png)<br>
      Copiar o token e armazenar em deploy_pipeline / sonar_token
  
### Reports
- Install Reports Repo ``` analisar se mantem; se sim criar um novo / analisar os parametros informados```
- Get reports route
- Wait for reports to be running

### Gogs
- Install Gogs ```trocar pelo Gitlab Operator ```
  -  ``` 
      Configurar senha 
      oc get pods
      oc rsh <nome do pod >
      su git
      ./gogs admin create-user --name gogs --password gogs --email root@xyz.com.br --admin

      Criar os repositorios 
      quarkus-hello
      quarkus-hello-config
      Subir codigo fonte
      ```
- Get gogs route
- Patch with specific route domain
- Wait for gogs and gogs-postgresql to be running
- Atualizar a variavel ```repo_url``` no arquivo deploy_pipeline.yaml
### Nexus
- Install Nexus
- Get nexus route
- Check Nexus Route
- Wait for nexus to be running
  -  ```
      Your admin user password is located in
      /nexus-data/admin.password on the server.
   
      oc project nexus
      oc get pods
      oc rsh <nome do pod>
      cat /nexus-data/admin.password 
      ```
- Criar um repositorio maven-redhat do tipo proxy no nexus<br>
  - ```
    relase<br>
    permissive<br>
    https://maven.repository.redhat.com/ga/ <br>
    ```
- No repositorio maven-public associar com o
  - ``` 
    maven-redhat  
    ```    
- Alterar o campo Layout policy do repositorio maven-releases para
  - ```
    permissive<br>
    ```

# Install Pipelines
- No arquivo deployment_pipeline.yaml comentar o bloco anterior, descomentar o bloco abaixo e executar o arquivo install.sh
    ```
    - name: 'Install Pipeline'
      include_role:
      name: "6-ocp4-install-pipeline"
    ```
- Create Namespaces
- pipelines.yaml
    - Get argocd password
    - Add CM for ArgoCD env in namespace
    - Add Secrets for ArgoCD env in namespace
    - Create OpenShift Objects for Openshift Pipeline Tasks
      - task-rox-image-check.yaml.j2
      - task-rox-deployment-check.yaml.j2
      - task-rox-image-scan.yaml.j2
      - task-integration-tests.yaml.j2
      - task-build-quarkus-image.yaml.j2
      - task-argo-sync-and-wait.yaml.j2
      - task-git-update-deployment.yaml.j2
      - task-git-clone.yaml.j2
      - task-maven.yaml.j2
      - cm-maven.yaml.j2
      - task-s2i-java.yaml.j2
      - task-update-release.yaml.j2
      - task-dependency-report.yaml.j2

    - Create OpenShift Objects for Openshift Pipeline Triggers
      - trigger-eventlistener.yaml.j2
      - rt-trigger-eventlistener.yaml.j2
      - triggerbinding-trigger-gogs.yaml.j2
      - triggertemplate.yaml.j2

    - Create OpenShift Objects for Openshift Pipelines Templates
        - generic-pipeline.yaml.j2
        - pipeline-build-pvc.yaml.j2
  
- acs-token-for-pipeline.yaml
    - Get ACS central route
    - Create API token for access from Pipeline to ACS
    - Get API token from response
    - Create ACS API Token secret for using in the pipelines

# Install Application
- No arquivo deployment_pipeline.yaml comentar o bloco anterior, descomentar o bloco abaixo e executar o arquivo install.sh
    ```
    - name: 'Install Application'
      include_role:
      name: "7-install-application"
    ```

- Atualizar o arquivo defaults/main.yaml

- Atualizar o arquivo defaults/main.yaml
    - webhook_secret_token
    - Quay
        - quay_route
        - quay_robot_token<br>
        - quay-application-token
        ![img.png](imagens/quay-app-token-1.png)
        ![img.png](imagens/quay-app-token-2.png)
        ![img.png](imagens/quay-app-token-3.png)
        ![img.png](imagens/quay-app-token-4.png)
        - ATENÇÃO:<br>
          A url do Quay tem um certificado auto assinado desta forma foi necessário ajustar o cluster para poder baixar uma imagem de um repositorio com certificado inválido.<br>
          Editar o image.config.openshift.io
          ```
          oc edit image.config.openshift.io/cluster
          ```
          Acrescescentar o trecho abaixo
          ```
          spec:
            registrySources:
              insecureRegistries:
              - smanager-registry-quay-quay.apps.cluster-876kv.sandbox2100.opentlc.com
          ```
          [Allowing Insecure Registry](https://docs.redhat.com/en/documentation/openshift_container_platform/4.17/html/images/image-configuration#images-configuration-insecure_image-configuration)

- Create Namespaces
- Add a label to enable the secure HTTPS connection to the Eventlistener resource
- Get gogs route
- Create ArgoCD App project
- Create ArgoCD Hml App
- Create ArgoCD Prd App
- Add Gitops Rolebinding
- Add RoleBinding to the pipeline namespace
- Quay
  - Extract quay hostname   
  - Set Quay hostname
  - Wait until Quay Application is Responding
  - Use API Token to continue Creating
    - Create Repository
    - Add Robot account permissions to repo
  - Create Quay Secret in Namespaces that require secret
  - Create Quay Secret in Pipeline Namespace project

# Triggers

Acesse o repositório Git clique nas seguintes opções:
[Creating Webhooks](https://docs.openshift.com/pipelines/1.17/create/creating-applications-with-cicd-pipelines.html#creating-webhooks_creating-applications-with-cicd-pipelines)
1. **Settings > Webhooks > Add webhook**
![img.png](imagens/webhook-1.png)
2. **Payload URL:** *colar a rota do EventListener*
3. **Tipo de Conteudo:** *appication/json*
4. **Secret** *colar o valor da variavel* ***main/webhook_secret_token***
5. **Which events would you like to trigger this webhook?** *Just the push event.*
6. **Active:** *checked*
7. **Add Webhook**
![img.png](imagens/webhook-2.png)


# Info
[RedHat Openshift Pipelines](https://docs.openshift.com/pipelines/1.17/about/about-pipelines.html)

[OpenShift Pipelines Tasks Catalog](https://github.com/openshift/pipelines-catalog)

[Tekton Tasks Catalog](https://github.com/tektoncd/catalog)


# FINITO !!! 


# Próximos passos
- Reports
- Coletar Urls - status.sh
- [Using manual approval in OpenShift Pipelines](https://docs.openshift.com/pipelines/1.17/create/using-manual-approval.html)


