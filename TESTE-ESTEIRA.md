# Instruções - Openshift Pipeline


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
* * Copiar o token e colocar na variavel cluster_admin_token do arquivo deploy_pipeline.yaml
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
* * Use Manual Login to try get token
* * Set CSRF Token
* * Try and Create a new session
* * Get Next CSRF Token
* * Get user Information
* * Set Present Cookie String from User Info Response
* * Check if Quay Organization Exists
* * Set Present Cookie String from Org Check Response
* * Create Quay Organization
* * Set Present Cookie String from Org Creation Response
* * Check if Repository Already Exists
* * Set Cookie String From Repo Check Response
* * Create Repository
* * Set Cookie String From Repo Creation Response
* * Check if Robot Account Already Exists
* * Set Robot Token from Check Response
* * Set Cookie String From Robot Check Response
* * Create Robot Account
* * Set Robot Token from Creating New Robot Account
* * Set Cookie String From Robot Creation
* * Add Robot account permissions to repo
* * Delete any Previously Existing Quay Secret
* * Create Quay Secret in Namespaces that require secret
* * Confirm Quay Secret is Created



# Install CICD 
* Add RoleBinding to the devsecops projects<br>
* Install Gogs ```trocar pelo Gitlab Operator ```
* * ``` 
    Configurar senha 
    oc get pods
    oc rsh <nome do pod >
    su git
    ./gogs admin create-user --name gogs --password gogs --email root@xyz.com.br --admin
    ```
* Install Sonarqube
* Install Reports Repo ``` analisar se mantem ou se sim criar um novo / analisar os parametros informados```
* Get gogs route
* Patch with specific route domain
* Wait for gogs and gogs-postgresql to be running

* Install Nexus
* * ```
      Your admin user password is located in
      /nexus-data/admin.password on the server.
* * Criar um repositorio maven-redhat do tipo proxy no nexus<br>
  relase<br>
  permissive<br>
  https://maven.repository.redhat.com/ga/ <br>
* * No repositorio maven-public associar com o maven-redhat    
    ```
* Check Nexus Route
* Wait for nexus to be running
* Sonarqube Route
* Wait for sonarqube to be running
* Get reports route

# Install Pipelines
Antes de iniciar a instalação do pipeline gerar o token no sonarkube e atualizar o arquivo deploy_pipeline.yaml
Antes de iniciar a instalação do pipeline gerar o token no quay e atualizar o arquivo default/main.yaml

Create OpenShift Objects for Openshift Pipeline Tasks

* argocd-task-sync-and-wait ```
   This task syncs (deploys) an Argo CD application and waits for it to be healthy.
   To do so, it requires the address of the Argo CD server and some form of 
   authentication either a username/password or an authentication token.```
* dependency-report
* git-update-deployment ``` This Task can be used to update image digest in a Git repo using kustomize ```
* maven-settings ``` ConfigMap ```
* rox-image-scan
* rox-deployment-check 
* rox-image-check  

Create OpenShift Objects for Openshift Pipeline Triggers
  - ./templates/trigger-eventlistener.yaml.j2
  - ./templates/trigger-eventlistener-route.yaml.j2
  - ./templates/trigger-gogs-triggerbinding.yaml.j2
  - ./templates/triggertemplate.yaml.j2

Get gogs route

Create OpenShift Objects for Openshift Pipelines Templates
* quarkus-hello-pipeline
* pipeline-build-pvc

Add gogs init taskrun for add pipelines ``` cria conta admin e clona o codigo fonte do github ```

* Quay
* extract quay hostname
* Set Quay hostname
* Wait until Quay Application is Responding
* Create Quay Secret in Namespaces that require secret
* Confirm Quay Secret is Created



# Install Application
Antes de iniciar a instalação do pipeline gerar o token no quay e atualizar o arquivo default/main.yaml
https://docs.redhat.com/en/documentation/red_hat_quay/3.13/html-single/red_hat_quay_api_guide/index#using-the-api
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
pass: XdQRY5ir8C96HNpMax0zLWJGFuOegUtZ - WGRRUlk1aXI4Qzk2SE5wTWF4MHpMV0pHRnVPZWdVdFo=

Acs<br>
user: admin<br>
pass: prOc3rgs@2024# -> cHJPYzNyZ3NAMjAyNCM=

Quay<br>
user: admin
pass: prOc3rgs@2024#

Sonarqube<br>
user: admin
pass: prOc3rgs@2024#

Nexus<br>
user: admin
pass: prOc3rgs@2024#

Gogs<br>
user: gogs
pass: gogs




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

