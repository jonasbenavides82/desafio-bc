import json
from datetime import datetime

import boto3

dynamodb = boto3.resource("dynamodb")
table_name = "ControleLancamentosTable"
table = dynamodb.Table(table_name)


def lambda_handler(event, context):
    body = json.loads(event["body"])

    # Validar entrada - Certifique-se de ter 'tipo' (débito ou crédito) e 'valor'

    lancamento = {
        "timestamp": datetime.now().isoformat(),
        "tipo": body["tipo"],
        "valor": body["valor"],
        "operacao": F"venda#2023-11-10"
    }

    table.put_item(Item=lancamento)

    response = {
        "statusCode": 200,
        "body": json.dumps("Lançamento registrado com sucesso!"),
    }

    return response
