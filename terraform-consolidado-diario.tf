resource "aws_lambda_function" "consolidado_diario_lambda" {
  filename         = "consolidado_diario.zip"
  function_name    = "consolidado-diario"
  role             = aws_iam_role.lambda_exec.arn
  handler          = "main.lambda_handler"
  runtime          = "python3.8"
  source_code_hash = filebase64("consolidado_diario.zip")

  environment {
    variables = {
      DYNAMODB_TABLE_NAME = "ControleLancamentosTable"
    }
  }
}

resource "aws_api_gateway_rest_api" "consolidado_diario_api" {
  name        = "ConsolidadoDiarioAPI"
  description = "API para consolidado diário"
}

resource "aws_api_gateway_resource" "consolidado_diario_resource" {
  rest_api_id = aws_api_gateway_rest_api.consolidado_diario_api.id
  parent_id   = aws_api_gateway_rest_api.consolidado_diario_api.root_resource_id
  path_part   = "consolidado-diario"
}

resource "aws_api_gateway_method" "consolidado_diario_method" {
  rest_api_id   = aws_api_gateway_rest_api.consolidado_diario_api.id
  resource_id   = aws_api_gateway_resource.consolidado_diario_resource.id
  http_method   = "GET"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "consolidado_diario_integration" {
  rest_api_id             = aws_api_gateway_rest_api.consolidado_diario_api.id
  resource_id             = aws_api_gateway_resource.consolidado_diario_resource.id
  http_method             = aws_api_gateway_method.consolidado_diario_method.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.consolidado_diario_lambda.invoke_arn
}

resource "aws_api_gateway_deployment" "consolidado_diario_deployment" {
  depends_on = [aws_api_gateway_integration.consolidado_diario_integration]

  rest_api_id = aws_api_gateway_rest_api.consolidado_diario_api.id
  stage_name  = "prod"
}

