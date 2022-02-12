Instances within the same VPC can connect to one another via their private IP addresses, as such it is possible to connect to an instance in a private subnet from an instance in a public subnet; otherwise known as a bastion host. Amazon instances use SSH keys for authentication.

esto crea dos instancias ec2 y sus redes, para que la instancia en la subnet publica reciba trafico de internet, y que la instancia de la red privada solo reciba trafico del sg de la instancia en la red publica. hemos agregado el cidr de la subnet privada al sg publico para poder hacer llamadas desde la instancia privada a la instancia publica, sin embargo puede que esto no sea necesario ya que en teoria todo el trafico que entra a una instancia puede salir, es decir que si la instancia publica inicia una llamada a la instancia privada, la instancia privada debería poder responder a esta solicitud automaticamente

TODO:

- solucionar que no obtenemos info en el Flow Log
- sería ideal encontrar una forma de crear dos instancias y sólo cambiar un parametro de una de ellas, para ser DRY, sin embargo si esto no es posible nos repetimos y creamos los dos resources manualmente en terraform
- una vez entregado el lab hacer la prueba con una instancia RDS, como nos conectaremos a esta instancia?
