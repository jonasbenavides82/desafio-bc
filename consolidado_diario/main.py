import json
from datetime import datetime
from boto3.dynamodb.conditions import Key
import boto3

dynamodb = boto3.resource("dynamodb")
table_name = "ControleLancamentosTable"
table = dynamodb.Table(table_name)


def lambda_handler(event, context):
    return event
    today = datetime.now().date().isoformat()

#    try:
    teste="2023-11-10"
    response = table.query(
        KeyConditionExpression=Key("operacao").eq(f"venda#{teste}")
    )

    total = 0
    for item in response.get("Items",[]):
        total += float(item.get("valor",0))
    

    return {"statusCode": 200, "body": json.dumps({"saldo_diario": total})}

#    except Exception as e:
#        return {"statusCode": 500, "body": json.dumps(str(e))}
