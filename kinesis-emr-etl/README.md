STEPS

1. create a twitter developer account https://developer.twitter.com/en/docs/developer-portal/overview
2. copia las keys de twitter a un notepad
3. pip install tweepy
4. aws s3 sync s3://diplomado-arq-lab2-app .
5. python twitterproduce.py
6. en aws console data streams podremios ver los graficos de los tweets que van llegando
7. ssh -i ~/.ssh/diplomado hadoop@<master-endpoint>
8. aws s3 sync s3://diplomado-arq-lab2-app/s3base/emr .
9. spark-submit --packages org.apache.spark:spark-streaming-kinesis-asl_2.11:2.4.4 spark.py

TODO

[x] maquina EC2
[x] rol AmazonS3FullAccess para la instancia EC2
[x] bucket S3 tweets capturados en el data stream
[x] bucket S3 archivos .py
[x] pasar las credenciales a la app de python mediante un archivo de variables
[x] rol en ec2 que permita conectarse con kinesis
[x] user_data que instale lo necesario en la EC2 (por alguna razón no hace el paso de pip install tweepy)
[x] rol en kinesis delivery stream que permita conectarse con kinesis streams como source y un bucket s3 como destination
[x] kinesis leer el data stream desde el delivery stream
[ ] convertir el codigo de la ec2 que obtenemos desde s3 en una lambda
[x] crear el cluster de EMR sin logging,software spark,c4.large,3,no cluster scaling,enable auto-termination
[ ] cambiar archivos a utilizar por EMR
[ ] crear bucket de destino de procesamientos de EMR (sería mejor utilizar el mismo para ambas tareas no?)
[ ] crear carpeta en el bucket de streams: streams,resume

LEARNT

you can export aws_iam_policy_document to json, so why force to use templates? theres a tool that can convert json to aws_iam_policy_document so the circle is complete https://github.com/flosell/iam-policy-json-to-terraform

KNOWN ISSUES

the EMR cluster takes about 8 minutes to be ready

the emr python code needs the exact file name to be processed, so you gotta do the streaming first, copy the file name from S3, and then run the cluster, and the script

gotta add the connecto from anywhere port 22 to the master ec2 security group

sometimes terraform or aws when creating an instance right after creating a role (on the same plan) it cant finds the role, so it fails with a Invidalid Iam Instance Profile Name https://github.com/hashicorp/terraform/issues/15341 if we just wait a while and rerun terraform apply it launche the instance with the role properly

a very similar error cant be fixed with the creation of the aws_kinesis_firehose_delivery_stream, it errors out cause the aws_iam_role aint created first, only workaround is to run a second terraform apply aws_kinesis_firehose_delivery_stream and exclude it from the first
