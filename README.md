# Infraestrutura Base com Terraform para Cluster EKS

Este projeto utiliza Terraform para provisionar a infraestrutura de rede e o cluster EKS (Elastic Kubernetes Service) na AWS. A arquitetura é projetada para ser segura, com os recursos de computação isolados em uma rede privada.

## Arquitetura

A infraestrutura provisionada por este módulo consiste nos seguintes componentes:

- **Rede (VPC):**
  - **Subnets Privadas:** Onde o cluster EKS e suas instâncias (nós) residem, sem acesso direto da internet.
  - **Subnets Públicas:** Contêm os **NAT Gateways**.
  - **NAT Gateways:** Permitem que os recursos nas subnets privadas iniciem conexões com a internet (para atualizações, etc.), mas bloqueiam conexões iniciadas pela internet.
  - **Internet Gateway:** Fornece acesso à internet apenas para as subnets públicas.

- **Kubernetes (EKS):**
  - **Cluster EKS:** Provisiona o control plane gerenciado pela AWS e os node groups (instâncias EC2 que servirão como workers) nas subnets privadas.

- **Armazenamento (EBS CSI):** Configura o addon EBS CSI Driver para permitir o uso de volumes persistentes (EBS) pelo cluster.

- **Segurança:**
  - **Security Groups:** Define as regras de segurança para a comunicação interna do cluster e para o tráfego de saída via NAT Gateway.

- **Backend Terraform:** Utiliza um bucket S3 para armazenar o estado (`terraform.tfstate`) e uma tabela DynamoDB para o bloqueio de estado (`state locking`).

> A exposição da aplicação para a internet (criação de Load Balancers, API Gateway, etc.) é de responsabilidade de outros módulos (ex: `api`).

## Pré-requisitos

- **Terraform CLI** (versão ~> 1.0)
- **AWS CLI** (versão ~> 2.0)
- **Credenciais da AWS** configuradas.

## Setup Inicial (Bootstrap)

O bucket S3 e a tabela DynamoDB para o backend do Terraform devem ser criados manualmente antes da primeira execução.

1.  **Criar o Bucket S3:**
    ```bash
    aws s3api create-bucket --bucket terraform-state-tc3-g38-lanchonete-infra --region us-east-1
    ```

2.  **Criar a Tabela DynamoDB:**
    ```bash
    aws dynamodb create-table \
        --table-name "terraform-state-lock-table" \
        --attribute-definitions AttributeName=LockID,AttributeType=S \
        --key-schema AttributeName=LockID,KeyType=HASH \
        --provisioned-throughput ReadCapacityUnits=5,WriteCapacityUnits=5 \
        --region us-east-1
    ```

## Como Executar

1.  **Inicializar:**
    ```bash
    terraform init
    ```

2.  **Planejar:**
    ```bash
    terraform plan
    ```

3.  **Aplicar:**
    ```bash
    terraform apply
    ```

## Outputs

Após a execução, o Terraform exibirá saídas importantes para serem usadas por outros pipelines:

- `cluster_name`: O nome do cluster EKS.
- `cluster_endpoint`: O endpoint para se conectar ao cluster (acessível via `kubectl`).
- `vpc_id`: O ID da VPC criada.
