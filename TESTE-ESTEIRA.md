# Instruções - Openshift Pipeline

# Pré Instalação 
- No arquivo deploy_pipeline.yaml fazer os ajustes básicos
- - company_name
- - acs_central_password_base64 
- - - echo -n xpto | base64 R: eHB0bw==
- - acs_central_password_plain_text
- - quay_admin_password
- - sa_cluster_admin (criar)
- - - oc create sa cluster-admin-sa -n kube-system
- - - oc adm policy add-cluster-role-to-user cluster-admin -z cluster-admin-sa -n kube-system
- - sa_cluster_admin_token (copiar token)
- - - oc create token cluster-admin-sa -n kube-system --duration=999999h
- - cluster_url
- - nexus_password

# Install Gitops
- Install GitOps Operator
- Install OCP Pipelines Operator
- Add ClusterRoleBinding to the openshift-gitops-controller
- Install ArgoCD
- Add SSO Keycloak in Openshift GitOps by default
- Get argocd password
- Add CM for ArgoCD env in namespace  "{{ pipeline_namespace }}"
- Add Secrets for ArgoCD env in namespace  "{{ pipeline_namespace }}"

* * Config Gitops ``` Cria a aplicação dentro do Argo CD ```
* argocd-quarkus-hello-project.yaml
* argocd-app-dev.yaml.j2

# Install the ACS Central
* Antes de instalar o ACS criar uma conta de servico (SA) e gerar seu token
* * oc create sa cluster-admin-sa -n kube-system
* * oc adm policy add-cluster-role-to-user cluster-admin -z cluster-admin-sa -n kube-system
* * oc create token cluster-admin-sa --duration=999999h -n kube-system
* * Copiar o token e colocar na variavel sa_cluster_admin_token do arquivo deploy_pipeline.yaml
* Central
* * Create ACS namespace
* * Create ACS Central password
* * Install ACS Operator
* * Wait for ACS Operator to be up and running
* * Create ACS Central
* * Get central route
* * Wait for Central availability
* Secured Cluster
* * Get cluster init bundle
* * Create init-bundle secrets
* * Install Sensor on OpenShift Container Platform
* * Determine number of collectors

* * Config Post ACS
* Create API token for access from Pipeline to ACS
* Create ACS API Token secret for using in the pipelines
* Get secrets in namespace
* Extract secret name using regex
* Display secret name
* Get token in the secret for the sa pipeline and decode
* Define the token secret decoded
* Creating ACS Integration with the Openshift Internal Registry
* * ``` é preciso criar uma conta de servico te tenha acesso ao registry - post-ci.yaml```

# Install Quay
* install-quay
* * quay-namespace
* * quay-subscription
* * Wait for QuayRegistry CRD to exist
* * Create Quay Registry Object
* configure-quay
* * extract quay hostname
* * Wait until Quay Application is Responding
* * Initialize Quay User
* * Set Output Message from Quay on User Initalize
* * Use API Token to continue Creating
* * * Set Quay Access Token
* * * Check if Quay Organization Exists
* * * Create Quay Organization
* * * Check if Repository Already Exists
* * * Create Repository
* * * Check if Robot Account Already Exists
* * * Set Robot Token from Check Response
* * * Create Robot Account
* * * Set Robot Token from Creating New Robot Account
* * * Add Robot account permissions to repo
* * Delete any Previously Existing Quay Secret
* * Create Quay Secret in Namespaces that require secret
* * Confirm Quay Secret is Created



# Install CICD Infra

* Install sonarqube
* * ```
    pegar sonar_token e atualizar o deploy_pipeline
    ```
* Get sonarqube route
* Wait for sonarqube to be running
* Install Reports Repo ``` analisar se mantem; se sim criar um novo / analisar os parametros informados```
* Get reports route
* Wait for reports to be running
* Install Gogs ```trocar pelo Gitlab Operator ```
*  ``` 
    Configurar senha 
    oc get pods
    oc rsh <nome do pod >
    su git
    ./gogs admin create-user --name gogs --password gogs --email root@xyz.com.br --admin
    ```
* Get gogs route
* Patch with specific route domain
* Wait for gogs and gogs-postgresql to be running
* Install Nexus
*  ```
      Your admin user password is located in
      /nexus-data/admin.password on the server.
   
      oc project nexus
      oc get pods
      oc rsh <nome do pod>
      cat /nexus-data/admin.password
    ```
* Get nexus route
* Criar um repositorio maven-redhat do tipo proxy no nexus<br>
* ```
  relase<br>
  permissive<br>
  https://maven.repository.redhat.com/ga/ <br>
  ```
* No repositorio maven-public associar com o    ``` maven-redhat  ```    
* Recriar o repositorio maven-releases do tipo hosted
*   ```
      relase<br>
      permissive<br>
      ```
* Check Nexus Route
* Wait for nexus to be running


# Install Pipelines
Antes de iniciar a instalação do pipeline gerar o token no sonarkube e atualizar o arquivo deploy_pipeline.yaml
Antes de iniciar a instalação do pipeline gerar o token no quay e atualizar o arquivo default/main.yaml

- pipelines.yaml
  * Get argocd password
  * Add CM for ArgoCD env in namespace
  * Add Secrets for ArgoCD env in namespace
  * Create OpenShift Objects for Openshift Pipeline Tasks
     - task-update-release.yaml.j2
     - task-argo-sync-and-wait.yaml.j2
     - task-build-quarkus-image.yaml.j2
     - task-dependency-report.yaml.j2
     - task-git-update-deployment.yaml.j2
     - cm-maven.yaml.j2
     - clustertask-rox-deployment-check.yaml.j2
     - clustertask-rox-image-check.yaml.j2
     - clustertask-rox-image-scan.yaml.j2

  * Create OpenShift Objects for Openshift Pipeline Triggers
    - trigger-eventlistener.yaml.j2
    - trigger-eventlistener-route.yaml.j2
    - trigger-gogs-triggerbinding.yaml.j2
    - triggertemplate.yaml.j2

  * Create OpenShift Objects for Openshift Pipelines Templates
    - generic-pipeline.yaml.j2
    - pipeline-build-pvc.yaml.j2

- acs-token-for-pipeline.yaml
  - Get ACS central route
  - Store central route as a fact
  - Create API token for access from Pipeline to ACS
  - Get API token from response
  - Create ACS API Token secret for using in the pipelines

- secret-quay.yaml
  - Extract quay hostname
  - Wait until Quay Application is Responding
  - Create Quay Secret in Namespaces that require secret
  - Confirm Quay Secret is Created


# Install Application
Antes de iniciar a instalação do pipeline gerar o token no quay e atualizar o arquivo deploy_pipeline.yaml <br>
https://docs.redhat.com/en/documentation/red_hat_quay/3.13/html-single/red_hat_quay_api_guide/index#using-the-api <br>
https://docs.redhat.com/en/documentation/red_hat_quay/3.13/html-single/red_hat_quay_api_guide/index#creating-oauth-access-token

* Atualizar o arquivo defaults/main.yaml
* Create Namespaces
* Gogs
* * Get gogs route
* * Create OpenShift Objects for App project
* * * argocd-app-project.yaml.j2
* * * argocd-app-dev.yaml.j2
* * * rb-gitops.yaml.j2
* Pipeline
* * Add RoleBinding to the  "{{ pipeline_namespace }}" namespace
* Quay
* * extract quay hostname
* * Set Quay hostname
* * Wait until Quay Application is Responding
* * Use API Token to continue Creating
* * * Create Repository
* * * Add Robot account permissions to repo
* * Create Quay Secret in Namespaces that require secret
* * Confirm Quay Secret is Created





# Contas
ArgoCD<br>
user: admin<br>
pass: AixwT7nmyGCZX4P9EoM8eUqWKDgQhlt1

Acs<br>
user: admin<br>
pass: xpto -> cHJPYzNyZ3NAMjAyNCM=

Quay<br>
user: admin
pass: xpto

Sonarqube<br>
user: admin
pass: xpto

Nexus<br>
user: admin
pass: xpto

Gogs<br>
user: gogs
pass: gogs
------------------------------------------
Mostrar 
Url: 
   ArgoCD
   ACS
   Quay
   Gogs
   Nexus
   Sonarqube
   Report


Passwd:
   ArgoCD
   ACS
   Quay
   Gogs
   Nexus
   Sonarqube

---------------------------

# Importar a imagem java do repositorio redhat para o registry do OCP<br>
```
oc patch configs.imageregistry.operator.openshift.io/cluster --patch '{"spec":{"defaultRoute":true}}' --type=merge
oc get route -n openshift-image-registry

podman pull registry.access.redhat.com/ubi9/openjdk-21:1.21-3
podman tag 30c246f28867 default-route-openshift-image-registry.apps.cluster-pwtfx.dynamic.redhatworkshops.io/openshift/openjdk-21:1.21-3
podman login -u admin -p $(oc whoami -t) default-route-openshift-image-registry.apps.cluster-pwtfx.dynamic.redhatworkshops.io --tls-verify=false
podman push default-route-openshift-image-registry.apps.cluster-pwtfx.dynamic.redhatworkshops.io/openshift/openjdk-21:1.21-3 --tls-verify=false
```








.






######################################################################################################################################################
outra coisa

## 1- Deploy da aplicação com Pipeline:

1. Altere para o perfil de desenvolvedor
2. Selecione o menu +Add;
3. Em "**Project: All Projects**" clicar em "**Create Project**";
    1. Name: **"<"suas iniciais">"-tst-pipeline**
4. Clicar em "**+Add > Git Repository > Import from Git**";
5. Preencha os dados solicitados:
    - **Git Repo URL:** *insira a url do projeto tst-pipeline*;
    - **Git type:** *GitHub*
    - Clique em **Show advanced Git options**
        - **Git Reference:** *master*
        - **Context dir:** */*
    - **Import Strategy:** *Builder Image > Java > Red Hat OpenJDK 11 (UBI 8)*
    - **Appplication name:** *"<suas iniciais">"-pipeline-app*
    - **Name:** *"<suas iniciais">"-pipeline*
    - **Resources:** *Deployment*
    - **Pipelines:** *Add pipeline*
    - **Target port:** *8080*
    - **Create a route to the Application:** Desmarcar;
    - **Resource limits:** Cilcar;
    - No formulario que será aberto, preencha com os seguintes valores:
        - CPU -> Request = 20 milicores;
        - CPU -> Limit = 50 milicores;
        - Memory -> Request = 70 Mi;
        - Memory -> Limit = 150 Mi;
    - Clique no botão "Create";
   >
   >- Aguarde o processo de construção (build) e escalação da aplicação (0 para 1).
   >- Acompanhe os logs da execução em: **Pipelines > "<suas iniciais">"-pipeline > Task status**;
   >- Clique em **Topology** ;
   >- Clique em cima do circulo azul da sua aplicação **"<suas iniciais">"-pipeline**;
   >- Explore as opções apresentadas (Details, Resources, Observe);

## 2 - Crie uma rota HTTP para a aplicação:
1. Clique em **Project** no menu esquerdo do console;
2. Clique em **Route > Create Route**, e preencha conforme abaixo:
    - **Name**: rt-pipeline
    - **Hostname**:  *<"suas iniciais>"-pipeline.<dominio openshift>*
    - **Path:** */*
    - **Service**: *<"nome do serviço>"*
    - **Target port**: *8080 -> 8080 (TCP)*
    - Clicar em **Create**;
    - Acesse a rota em seu navegador;
    - Anote a rota em um bloco de notas;

## 3 - Crie uma rota HTTPS para a aplicação:
1. Clique em **Project** no canto esquerdo do console;
2. Clique em **Route** > **Create Route**, e preencha conforme abaixo:
    - **Name**: rt-sec-pipeline
    - **Hostname**: *<"suas iniciais>"-sec-pipeline.<dominio openshift>*
    - **Service**: *<"nome do serviço>"*
    - **Target port**: 8080 -> 8080 (TCP)
    - Marque o checkbox **Secure Route**;
    - **TLS termination**: Edge
    - **Insecure traffic**: Redirect
    - Clicar em **Create**;
    - Acesse a rota em seu navegador;
    - Tente acessar a rota como HTTP e veja o comportamento do "Redirect";

## 4 - Adicionar Trigger/Webhook no Pipeline:

1. Clique em **Topology** e abra a URL do Container chamado *"Triggers"*
2. Copie a URL;
3. Acesse o repositório no Gogs e clique nas seguintes opções:
    1. **Settings > Webhooks > Add webhook**
    2. **Payload URL:** *colar a url do Trigger copiada no passo anterior
    3. **Tipo de Conteudo:** *appication/json*
    4. **Secret** *deixar em branco*
    5. **Which events would you like to trigger this webhook?** *Just the push event.*
    6. **Active:** *checked*
    7. **Add Webhook**

## 5 - Teste de Trigger com o Webhook do Gogs:

#### Passos para teste:

Acessar o repositorio no Gogs.

1. Acessar o arquivo **"/src/main/java/br/com/smananager/hello/HelloApplication.java"**.
2. Clicar no Lapis para editar o arquivo
3. Alterar a **linha 14** substituindo a frase *"Hello World"* por *"Ola Mundo"*
4. Após essa alteração clique no botão **"Commit changes"**;
5. No console do OCP, voce pode acompahar a Pipeline iniciando um novo build e deploy da nova versão da Aplicação;

