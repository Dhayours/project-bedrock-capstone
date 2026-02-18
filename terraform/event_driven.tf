
############################################
# S3 bucket (private)
############################################
resource "aws_s3_bucket" "assets" {
  bucket        = local.assets_bucket_name
  force_destroy = true

  tags = {
    Project = "barakat-2025-capstone"
  }
}

resource "aws_s3_bucket_public_access_block" "assets" {
  bucket                  = aws_s3_bucket.assets.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

############################################
# Lambda IAM role + basic logging
############################################
resource "aws_iam_role" "asset_processor_exec" {
  name = "${var.lambda_name}-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect    = "Allow"
      Principal = { Service = "lambda.amazonaws.com" }
      Action    = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "asset_processor_basic_logs" {
  role       = aws_iam_role.asset_processor_exec.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

############################################
# Package Lambda from repo-root lambda/handler.py
############################################
data "archive_file" "asset_processor_zip" {
  type        = "zip"
  source_file = "${path.module}/../lambda/handler.py"
  output_path = "${path.module}/../lambda/handler.zip"
}

resource "aws_lambda_function" "asset_processor" {
  function_name = var.lambda_name
  role          = aws_iam_role.asset_processor_exec.arn

  runtime = "python3.12"
  handler = "handler.lambda_handler"

  filename         = data.archive_file.asset_processor_zip.output_path
  source_code_hash = data.archive_file.asset_processor_zip.output_base64sha256
}

############################################
# Allow S3 to invoke Lambda
############################################
resource "aws_lambda_permission" "allow_s3_invoke_asset_processor" {
  statement_id  = "AllowExecutionFromS3AssetsBucket"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.asset_processor.function_name
  principal     = "s3.amazonaws.com"
  source_arn    = aws_s3_bucket.assets.arn
}

############################################
# S3 event notification -> Lambda
############################################
resource "aws_s3_bucket_notification" "assets_notification" {
  bucket = aws_s3_bucket.assets.id

  lambda_function {
    lambda_function_arn = aws_lambda_function.asset_processor.arn
    events              = ["s3:ObjectCreated:*"]
  }

  depends_on = [aws_lambda_permission.allow_s3_invoke_asset_processor]
}

############################################
# Outputs (optional, but nice for grading)
############################################
output "bedrock_assets_bucket" {
  value = aws_s3_bucket.assets.bucket
}

output "bedrock_asset_processor_lambda" {
  value = aws_lambda_function.asset_processor.function_name
}
