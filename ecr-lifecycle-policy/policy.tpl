{
    "rules": [
        {
            "rulePriority": 1,
            "description": "Keep only ten images, expire all others",
            "selection": {
                "tagStatus": "any",
                "countType": "imageCountMoreThan",
                "countNumber": 10
            },
            "action": {
                "type": "expire"
            }
        }
    ]
}
