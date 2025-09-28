# Infraestrutura Terraform para tc3-g38-lanchonete

Este projeto contém o código Terraform para provisionar a infraestrutura para o projeto **tc3-g38-lanchonete** na AWS.

## Descrição

Este código Terraform cria a seguinte infraestrutura:

*   Uma **VPC** com sub-redes públicas e privadas em duas zonas de disponibilidade.
*   Um **Internet Gateway** para as sub-redes públicas e um **NAT Gateway** para as sub-redes privadas.
*   Um **cluster EKS (Elastic Kubernetes Service)** com um grupo de nós gerenciado.
*   Um **API Gateway** (API HTTP) para expor serviços.
*   Um **VPC Link** para conectar o API Gateway a recursos privados.
*   Um **bucket S3** para armazenar o estado do Terraform.
*   Um **bucket S3** para o código Lambda.
*   Um **AWS Load Balancer Controller** instalado via Helm.

## Recursos da AWS

Os principais recursos da AWS criados por este projeto são:

*   `aws_vpc`
*   `aws_subnet`
*   `aws_internet_gateway`
*   `aws_nat_gateway`
*   `aws_eip`
*   `aws_route_table`
*   `aws_security_group`
*   `aws_eks_cluster`
*   `aws_eks_node_group`
*   `aws_apigatewayv2_api`
*   `aws_apigatewayv2_stage`
*   `aws_apigatewayv2_vpc_link`
*   `aws_s3_bucket`
*   `helm_release` (para o AWS Load Balancer Controller)

## Pré-requisitos

*   [Terraform](https://www.terraform.io/downloads.html) (versão ~> 1.19.0)
*   Uma [conta da AWS](https://aws.amazon.com/premiumsupport/knowledge-center/create-and-activate-aws-account/) com as permissões necessárias.
*   [AWS CLI](https://aws.amazon.com/cli/) configurado com suas credenciais.

## Como Usar

1.  **Clone o repositório:**
    ```bash
    git clone <https://github.com/FIAP-SOAT-2025/terraform-infra>
    cd infra
    ```

2.  **Inicialize o Terraform:**
    ```bash
    terraform init
    ```

3.  **Revise o plano:**
    ```bash
    terraform plan
    ```

4.  **Aplique as alterações:**
    ```bash
    terraform apply
    ```

5.  **Destrua a infraestrutura:**
    ```bash
    terraform destroy
    ```

## Entradas

| Nome                 | Descrição                               | Tipo   | Padrão                 |
| -------------------- | ----------------------------------------- | ------ | ---------------------- |
| `aws_region`         | A região da AWS para implantar os recursos.   | `string` | `us-east-1`            |
| `projectName`        | O nome do projeto.                  | `string` | `tc3-g38-lanchonete`   |
| `cidr_vpc`           | O bloco CIDR para a VPC.               | `string` | `10.1.0.0/16`          |
| `tags`               | Um mapa de tags para atribuir a todos os recursos. | `map`    | `{ Name = "tc3-g38-lanchonete" }` |
| `node_instance_type` | Tipo de instância EC2 para os nós de trabalho do EKS. | `string` | `t3.medium`            |

## Saídas

| Nome                        | Descrição                             |
| --------------------------- | --------------------------------------- |
| `api_gateway_id`            | ID do API Gateway.                  |
| `api_gateway_url`           | URL do API Gateway.                 |
| `cluster_name`              | Nome do cluster EKS.                |
| `cluster_endpoint`          | Endpoint do cluster EKS.            |
| `cluster_security_group_id` | ID do grupo de segurança do cluster EKS.   |
| `vpc_id`                    | ID da VPC.                          |
| `private_subnet_ids`        | IDs das sub-redes privadas.             |
| `aws_region`                | Região da AWS.                             |
| `vpc_link_id`               | ID do VPC Link.                     |

## Módulos

### s3

Este projeto possui um módulo local no diretório `s3/` que cria dois buckets S3:

*   `lambda-code-tc3`: Para armazenar o código Lambda.
*   `terraform-state-tc3-g38-lanchonete`: Para armazenar o estado do Terraform do módulo `infra`.