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

## AKS
```bash
az aks get-credentials -g rg-guestbook --name aksguestbook
```

## Creating Service Principal
```bash
az ad sp create-for-rbac --name="<ServicePrincipal name>" --role="Contributor" --scopes="/subscriptions/<subscription Id>"
```

# <a href="IaC/terraform">IaC - Terraform</a>

# Node Pool
```bash
  az aks nodepool update --disable-cluster-autoscaler \
     -g rg-guestbook --cluster-name aksguestbook --name default
```

```bash
   az aks nodepool scale --node-count 2 -g rg-guestbook \
     --cluster-name aksguestbook --name default
```

# K8S Cluster AGIC integration
```bash
export appgwId=$(az network application-gateway \
  show -n agic-appgateway -g rg-agic -o tsv --query "id")

az aks enable-addons -n aksguestbook \
  -g rg-guestbook -a ingress-appgw \
  --appgw-id $appgwId

export nodeResourceGroup=$(az aks show -n aksguestbook \
  -g rg-guestbook -o tsv --query "nodeResourceGroup")

export aksVnetName=$(az network vnet list \
  -g $nodeResourceGroup -o tsv --query "[0].name")

export aksVnetId=$(az network vnet show -n $aksVnetName \
          -g $nodeResourceGroup -o tsv --query "id")

az network vnet peering create \
          -n AppGWtoAKSVnetPeering -g rg-agic \
          --vnet-name agic-vnet --remote-vnet $aksVnetId \
          --allow-vnet-access

export appGWVnetId=$(az network vnet show -n agic-vnet \
          -g rg-agic -o tsv --query "id")

az network vnet peering create \
    -n AKStoAppGWVnetPeering -g $nodeResourceGroup \
    --vnet-name $aksVnetName --remote-vnet $appGWVnetId --allow-vnet-access
```

# Helm
```bash
$ curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3
$ chmod 700 get_helm.sh
$ ./get_helm.sh
```

> helm repo add bitnami https://charts.bitnami.com/bitnami

> helm install handsonakswp bitnami/wordpress 

```bash
helm status wp
echo Username: user
echo Password: $(kubectl get secret --namespace default wp-wordpress
-o jsonpath="{.data.wordpress-password}" | base64 -d)
```

## Clean up
```bash
helm delete wp
kubectl delete pvc --all
kubectl delete pv --all
```

# Help
```bash
while true; do
         curl -m 1 http://<EXTERNAl-IP>/;
         sleep 5;
done
```