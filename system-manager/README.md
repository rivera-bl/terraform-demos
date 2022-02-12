1. Crear 2 instancias linux y disponibilizarlas en SSM
2. Generar un parametro en Parameter Store
3. Ejecutar un Run command haciendo referencia al parametro

aws ssm describe-instance-information --region "us-east-1"
  (demoran tiempo en ser reconocidas por SSM)

aws ssm send-command \
  --document-name diplomado-arq-lab4 \
  --targets Key=tag:Name,Values=diplomado-arq-lab4 \
  --region "us-east-1"

https://console.aws.amazon.com/systems-manager/run-command/complete-commands
