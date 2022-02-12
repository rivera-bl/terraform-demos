this creates a user following best practices
so the user has no permission but uses roles that delegate the permissions

USAGE

1. install keybase
2. follow https://wiki.archlinux.org/title/Keybase_(Espa%C3%B1ol)#Registro_/_Inicio_de_sesi%C3%B3n
3. run terraform apply
4. terraform output console-password | base64 --decode --ignore-garbage | keybase pgp decrypt
5. you can now log into the console with the output of the previous command
6. create a new aws profile with: aws configure --profile demo
7. verify you can access the cli with this user with: aws sts get-caller-identity --profile demo
8. run source ~/.local/bin/assumerole (este script ejecuta aws sts assume-role y parsea el json con jq y exporta las llaves y el token como variables de entorno)
9. aws sts get-caller-identity
10. aws ec2 describe-instances --query "Reservations[*].Instances[*].[VpcId, InstanceId, ImageId, InstanceType]" (comprobar que no de permission denied) 
11. unset AWS_ACCESS_KEY_ID AWS_SECRET_ACCESS_KEY AWS_SESSION_TOKEN (si necesitamos borrar las variables)
13. assume an IAM role to obtain temporary credentials 
14. use an aws managed policy 
15. for customer managed policies save them on a single repository only for the policy files

DUDAS

where to save the files and how to retrieve them? for example the customner managed policies should be on their own repository, make into a module? (this a question more in the terraform related way)

TODO

[x] incoporar keybase para entregar las keys
[ ] darle una duración especifica a la sesión (esto se hace en la definición del rol?)
[ ] cómo revocar una sesión?
[ ] agregar MFA a la creación del usuario

RESOURCES

https://docs.aws.amazon.com/IAM/latest/UserGuide/best-practices.html#delegate-using-roles
https://docs.aws.amazon.com/IAM/latest/UserGuide/access_policies_managed-vs-inline.html#aws-managed-policies
https://docs.aws.amazon.com/IAM/latest/UserGuide/id_credentials_temp_request.html
