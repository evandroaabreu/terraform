provider "aws" {
  region = "us-east-1"
}

# Criar o tópico SNS
resource "aws_sns_topic" "meu_topico" {
  name = "meu-topico-sns"
}

# Criar a fila SQS
resource "aws_sqs_queue" "minha_fila" {
  name = "minha-fila-sqs"
}

# Criar uma assinatura SQS no SNS (para que SNS publique mensagens na fila)
resource "aws_sns_topic_subscription" "sns_para_sqs" {
  topic_arn = aws_sns_topic.meu_topico.arn
  protocol  = "sqs"
  endpoint  = aws_sqs_queue.minha_fila.arn
}

# Permitir que SNS publique na fila SQS
resource "aws_sqs_queue_policy" "sqs_policy" {
  queue_url = aws_sqs_queue.minha_fila.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect    = "Allow"
        Principal = "*"
        Action    = "sqs:SendMessage"
        Resource  = aws_sqs_queue.minha_fila.arn
        Condition = {
          ArnEquals = {
            "aws:SourceArn" = aws_sns_topic.meu_topico.arn
          }
        }
      }
    ]
  })
}

# Exibir ARN do SNS e URL da SQS no output
output "sns_topic_arn" {
  value = aws_sns_topic.meu_topico.arn
}

output "sqs_queue_url" {
  value = aws_sqs_queue.minha_fila.id
}
