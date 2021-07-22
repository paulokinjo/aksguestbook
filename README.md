# aksguestbook

# Github

```bash
echo "# aksguestbook" >> README.md
git init
git add README.md
git commit -m "first commit"
git branch -M main
git remote add origin git@github.com:paulokinjo/aksguestbook.git
git push -u origin main
```


# Azure
<a href="https:/​/​portal.​azure.​com">Azure Portal</a>

## Creating Service Principal
```bash
az ad sp create-for-rbac --name="<ServicePrincipal name>" --role="Contributor" --scopes="/subscriptions/<subscription Id>"
```

# <a href="IaC/terraform">IaC - Terraform</a>