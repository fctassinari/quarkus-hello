# Instruções - Openshift Test Pipeline

# Operators
Red Hat OpenShift Pipelines

Red Hat OpenShift GitOps

Nexus Repository Operator

GitLab
# Install Gitops
Get cluster version<br>
Install GitOps Operator<br>
Install OCP Pipelines Operator<br>
Associar o SA openshift-gitops-argocd-application-controller do projeto openshift-gitops ao projeto da aplicação<br>
Install ArgoCD<br>
Patch the CM of Openshift GitOps to add role admin by default<br>
Add SSO Keycloak in Openshift GitOps by default<br>
Get ArgoCD route<br>
Get argocd password<br>
Add CM for ArgoCD env<br>
Add Secrets for ArgoCD env

# Install CICD Infra
Add RoleBinding to the devsecops projects<br>
Install Gogs<br>
Install nexus<br>
Install sonarqube<br>
Install reports repo<br>
Get gogs route<br>
Patch with specific route domain<br>
Wait for gogs and gogs-postgresql to be running<br>
Check Nexus Route<br>
Wait for nexus to be running<br>
Sonarqube Route<br>
Wait for sonarqube to be running<br>
Get reports route

# Install Pipelines
Create OpenShift Objects for Openshift Pipeline Tasks
* argocd-task-sync-and-wait ```
   This task syncs (deploys) an Argo CD application and waits for it to be healthy.
   To do so, it requires the address of the Argo CD server and some form of 
   authentication either a username/password or an authentication token.```
* dependency-report
* [gatling](https://gatling.io/)
* git-update-deployment ``` This Task can be used to update image digest in a Git repo using kustomize ```
* rox-image-scan
* maven-settings ``` ConfigMap ```
* maven ``` This Task can be used to run a Maven build ```
* rox-deployment-check 
* rox-image-check ``` 
*
*
*
*
*
*
*
*
*
*
*
*
*
*
*


# Recriar Pipeline
0 - Criar projeto tassinari<br>
1 - task-maven.yaml<br>
2 - task-dependency-report.yaml<br>
3 - cm-maven-setings.yaml<br>
4 - pvc-workspace.yaml<br>
5 - hello-quarkus-pipeline.yaml<br>
6 - hello-quarkus-pipelinerun.yaml<br>
7 - Criar um repositorio maven-redhat do tipo proxy no nexus<br>
relase<br>
permissive<br>
https://maven.repository.redhat.com/ga/<br>
8 - Criar um repositorio do mvn-cicd do tipo grupo no nexus e agrupar<br>
maven-central<br>
maven-redhat<br>
9 - Criar um repositorio mvn-release com Version Policy: Mixed<br>
10 - Criar o secret roxsecret dentro do namespace que contem o pipeline<br>
11 - Criar task git-update-deployment


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

