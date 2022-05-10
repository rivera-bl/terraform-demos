macie does analysis only on S3 buckets
en teoria deberiamos poder remediar cualquier finding que haga sobre los datos de los objetos de S3 al encriptarlos
revisar si encriptar por kms o s3


TODO

[x] levantar macie en terraform a partir del cf stack ejemplo de aws
[x] ejecutar el job
[x] encriptar el bucket
[ ] solucionar que la remediacion no funciona
  - llave kms?
[ ] permitir la decriptación a un unico usuario/servicio a través de una bucket policy
[ ] crear la remediacion

DUDAS

?cómo ejecutar terraform en dos pasos? uno para la evaluación y otro para la remediación
  esto no se puede, para que este proyecto funcione con terraform la remediacion debe ser automatica, maybe with a lambda? podriamos documentar el proceso observando los eventos de cloudtrail

RECURSOS

https://github.com/aws-samples/amazon-macie-demo-with-sample-data
https://dev.to/aws-builders/protect-s3-buckets-with-aws-macie-16gm

LEARNT

para dar cumplimiento a las normas de seguridad y, ya que en S3 server side encryption es AWS quien tiene el control sobre la llave privada, sólo el servicio que utilice la data, a través de IAM, debería tener los permisos para desencriptar los archivos

presentar esto como un escenario de 1: mala configuración, 2: cómo escanear la informacion, 3: cómo remediar (mencionar de todas formas que si manejaramos nuestra infra con terraform se podría forzar a que la información se encripte (esto puede ser incluso hecho directamente en S3 a través de una bucket policy?)e incluso de qué manera
