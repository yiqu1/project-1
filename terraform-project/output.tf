output "aws_s3-name" {
  value = aws_s3_bucket.buckets.arn
}

output "azurerm_virtual_machine-id" {
  value = azurerm_virtual_machine.main.id
}