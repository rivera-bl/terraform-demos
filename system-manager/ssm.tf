resource "aws_ssm_parameter" "foo" {
  name  = var.proj_name
  type  = "String"
  value = "Soy un parametro de Parameter Store!"
}

resource "aws_ssm_document" "this" {
  name            = var.proj_name
  document_format = "JSON"
  document_type   = "Command"

  content = <<DOC
{
   "schemaVersion":"2.0",
   "description":"Sample version 2.0 document v2",
   "parameters":{
      "command" : {
        "type": "String",
        "default": "{{ssm:${aws_ssm_parameter.foo.name}}}"
      }
    },
    "mainSteps":[
       {
          "action":"aws:runShellScript",
          "name":"runShellScript",
          "inputs":{
             "runCommand": [
               "echo '{{command}}' > ~/from-ssm-run-command.txt",
               "cat ~/from-ssm-run-command.txt"
            ]
          }
       }
    ]
}
DOC
}
