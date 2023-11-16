Certamente, vou adicionar mais detalhes ao README para fornecer informações mais específicas sobre a execução local e outras considerações importantes:

```markdown
# Controle de Fluxo de Caixa

Este projeto é uma solução na AWS para ajudar um comerciante a controlar seu fluxo de caixa diário, registrando lançamentos e gerando relatórios consolidados diários.

## Estrutura do Projeto

O projeto é dividido em duas partes principais: Controle de Lançamentos e Consolidado Diário.

### Controle de Lançamentos

O controle de lançamentos é responsável por registrar débitos e créditos. Utiliza o AWS Lambda e DynamoDB.

#### Configuração

- **Função Lambda:** `controle_lancamentos_lambda`
- **Endpoint da API:** `POST /controle-lancamentos`

#### Como Usar

Envie uma requisição POST para o endpoint da API com o seguinte formato JSON:

```json
{
  "tipo": "credito",
  "valor": 100.00
}
```

### Consolidado Diário

O consolidado diário gera um relatório consolidado diário do fluxo de caixa. Utiliza o AWS Lambda e DynamoDB.

#### Configuração

- **Função Lambda:** `consolidado_diario_lambda`
- **Endpoint da API:** `GET /consolidado-diario`

#### Como Usar

Envie uma requisição GET para o endpoint da API para obter o saldo consolidado diário.

## Configuração e Implantação

1. Certifique-se de ter o Terraform instalado.
2. Execute `terraform init` para inicializar o projeto.
3. Execute `terraform apply` para criar os recursos na AWS.

## Executando Localmente (para Desenvolvimento)

1. Instale as dependências do Lambda listadas no arquivo `requirements.txt`.
2. Configuração do DynamoDB Local:
    - Instale o [DynamoDB Local](https://docs.aws.amazon.com/amazondynamodb/latest/developerguide/DynamoDBLocal.DownloadingAndRunning.html).
    - Execute o DynamoDB Local em segundo plano: `java -Djava.library.path=./DynamoDBLocal_lib -jar DynamoDBLocal.jar -sharedDb`
3. Configure as variáveis de ambiente para apontar para o DynamoDB Local nas funções Lambda (consulte os arquivos `terraform-controle-lancamentos.tf` e `terraform-consolidado-diario.tf`).
4. Execute as funções Lambda localmente para desenvolvimento.

## Contribuições

Contribuições são bem-vindas! Sinta-se à vontade para enviar pull requests e relatar problemas.

