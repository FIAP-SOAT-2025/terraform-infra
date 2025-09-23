# Infraestrutura com Terraform para Cluster EKS e API Gateway

Este projeto utiliza Terraform para provisionar uma infraestrutura segura e escalável na AWS, composta por um cluster EKS (Elastic Kubernetes Service) em uma rede privada, exposto de forma segura através de um AWS API Gateway.

## Arquitetura

A arquitetura foi desenhada com o princípio de "segurança em primeiro lugar", isolando a aplicação da internet e controlando o acesso através de um único ponto de entrada gerenciado.

- **Rede (VPC):**
  - **Subnets Privadas:** O cluster EKS e suas instâncias (nós) residem em subnets privadas, sem acesso direto da internet, garantindo que a aplicação fique isolada.
  - **Subnets Públicas:** Contêm os **NAT Gateways**, que permitem que a aplicação em subnets privadas inicie conexões com a internet (para atualizações, etc.), mas bloqueiam conexões iniciadas pela internet.
  - **Internet Gateway:** Fornece acesso à internet apenas para as subnets públicas.

- **Ponto de Entrada (API Gateway):**
  - **AWS API Gateway:** Atua como o único ponto de entrada público para a aplicação. Ele recebe as requisições da internet e as encaminha de forma segura para a aplicação.
  - **VPC Link:** Uma conexão privada e segura é estabelecida entre o API Gateway e o Load Balancer interno da aplicação, garantindo que o tráfego entre eles não passe pela internet pública.

- **Kubernetes (EKS):**
  - **Cluster EKS:** O control plane gerenciado pela AWS e os node groups (workers) são provisionados.
  - **Load Balancer Interno:** A aplicação, quando exposta via serviço Kubernetes, cria um Load Balancer **interno**, acessível apenas de dentro da VPC pelo API Gateway.

- **Armazenamento (EBS CSI):** Configura o addon EBS CSI Driver para permitir o uso de volumes persistentes (EBS).

- **Segurança:**
  - **Security Groups:** As regras são estritamente configuradas para permitir tráfego para a aplicação apenas a partir do API Gateway (via VPC Link).

- **Backend Terraform:** Utiliza um bucket S3 para armazenar o estado (`terraform.tfstate`) e uma tabela DynamoDB para o bloqueio de estado (`state locking`).

## Pré-requisitos

Antes de começar, garanta que você tenha os seguintes pré-requisitos instalados e configurados:

- **Terraform CLI** (versão ~> 1.0)
- **AWS CLI** (versão ~> 2.0)
- **Credenciais da AWS:** Suas credenciais devem estar configuradas localmente.

## Setup Inicial (Bootstrap)

O Terraform precisa de um bucket S3 e uma tabela DynamoDB para gerenciar o estado remoto. **Esses dois recursos devem ser criados manualmente ANTES da primeira execução.**

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

## Como Executar a Infraestrutura

1.  **Inicializar o Terraform:**
    ```bash
    terraform init
    ```

2.  **Planejar as Mudanças:**
    ```bash
    terraform plan
    ```

3.  **Aplicar as Mudanças:**
    ```bash
    terraform apply
    ```

## CI/CD

O workflow de GitHub Actions definido em `.github/workflows/terraform.yml` automatiza os passos de `init`, `plan` e `apply`.

## Outputs

Após a execução do `apply`, o Terraform exibirá saídas (outputs) importantes:

- **`api_gateway_url`**: A URL pública para acessar a aplicação através do API Gateway. Este é o principal ponto de entrada.
- `cluster_name`: O nome do cluster EKS.
- `cluster_endpoint`: O endpoint para se conectar ao cluster (acessível via `kubectl`).
- `vpc_id`: O ID da VPC criada.