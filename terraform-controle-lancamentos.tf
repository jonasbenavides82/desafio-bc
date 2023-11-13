resource "aws_dynamodb_table" "controle_lancamentos" {
  name         = "ControleLancamentosTable"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "operacao"
  range_key    = "timestamp"
  attribute {
    name = "timestamp"
    type = "S"
  }
  attribute {
    name = "operacao"
    type = "S"
  }
}

resource "aws_lambda_function" "controle_lancamentos_lambda" {
  filename         = "controle_lancamentos.zip"
  function_name    = "controle-lancamentos"
  role             = aws_iam_role.lambda_exec.arn
  handler          = "main.lambda_handler"
  runtime          = "python3.8"
  source_code_hash = filebase64("controle_lancamentos.zip")

  environment {
    variables = {
      DYNAMODB_TABLE_NAME = aws_dynamodb_table.controle_lancamentos.name
    }
  }
}

resource "aws_api_gateway_rest_api" "controle_lancamentos_api" {
  name        = "ControleLancamentosAPI"
  description = "API para controle de lançamentos"
}

resource "aws_api_gateway_resource" "controle_lancamentos_resource" {
  rest_api_id = aws_api_gateway_rest_api.controle_lancamentos_api.id
  parent_id   = aws_api_gateway_rest_api.controle_lancamentos_api.root_resource_id
  path_part   = "controle-lancamentos"
}

resource "aws_api_gateway_method" "controle_lancamentos_method" {
  rest_api_id   = aws_api_gateway_rest_api.controle_lancamentos_api.id
  resource_id   = aws_api_gateway_resource.controle_lancamentos_resource.id
  http_method   = "POST"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "controle_lancamentos_integration" {
  rest_api_id             = aws_api_gateway_rest_api.controle_lancamentos_api.id
  resource_id             = aws_api_gateway_resource.controle_lancamentos_resource.id
  http_method             = aws_api_gateway_method.controle_lancamentos_method.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.controle_lancamentos_lambda.invoke_arn
}

resource "aws_api_gateway_deployment" "controle_lancamentos_deployment" {
  depends_on = [aws_api_gateway_integration.controle_lancamentos_integration]

  rest_api_id = aws_api_gateway_rest_api.controle_lancamentos_api.id
  stage_name  = "dev"
}

