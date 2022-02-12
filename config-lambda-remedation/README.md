esto crea un bucket de s3 donde almacena los zip del codigo que utilizaran las lambda que crean los stack de CF
la idea es tener dos config rules para:

1. alertar cuando los bucket de s3 no posean lifecycle rules
2. autoremediar los recursos que alerta config al observar los eventos captados por cloudtrail

RECURSOS

s3 bucket
cloudtrail trail
cloudformation stacks

DUDAS

?cómo listar los recursos que crea cf desde terraform
