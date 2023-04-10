
<p style="color:blue"><strong> Click here to test the execution in terminal</strong></p>

```execute-1
echo "Hello, Welcome to Partner workshop session"
```


<p style="color:blue"><strong> Click here to check the AZ version</strong></p>

```execute
az --version
```

<p style="color:blue"><strong> Click here to check the kubectl version</strong></p>

```execute
kubectl version
```

<p style="color:blue"><strong> Set environment variable </strong></p>

```execute-all
export SESSION_NAME={{ session_namespace }}
```

###### Check below repo to view the workload content: 

```dashboard:open-url
url: https://gitea-tapdemo.tap.tanzupartnerdemo.com/tapdemo-user/tanzu-java-web-app
```

######  The instrcutoer will provide you with the Azure and Tanzunet credentails and the AZ login command


###### Create Kubernetes cluster with 3 nodes and it should take around 5-10 mins to complete, please wait for it to deploy successfully. 
 
```execute
az aks create --resource-group tapdemo-cluster-RG --name {{ session_namespace }}-cluster --subscription a3ac57b4-348f-471f-9938-9cf757e2d033 --node-count 3 --enable-addons monitoring --generate-ssh-keys --node-vm-size Standard_B8ms -z 1 --enable-cluster-autoscaler --min-count 3 --max-count 3
```

<p style="color:blue"><strong> Get credentials of cluster"{{ session_namespace }}-cluster" </strong></p>

```execute
az aks get-credentials --resource-group tapdemo-cluster-RG --name {{ session_namespace }}-cluster
```
  
<p style="color:blue"><strong> Docker login to image repo </strong></p>

```execute
docker login tapworkshopoperators.azurecr.io -u tapworkshopoperators -p $DOCKER_REGISTRY_PASSWORD
```

<p style="color:blue"><strong> Check if the current context is set to "{{ session_namespace }}-cluster" </strong></p>

```execute
kubectl config get-contexts
```

![Cluster Context](images/prepare-1.png)

<p style="color:blue"><strong> Create a namespace </strong></p>

```execute
kubectl create ns tap-install
```

<p style="color:blue"><strong> Set environment variable </strong></p>

![Env](images/prepare-2.png)

```execute
export INSTALL_BUNDLE=registry.tanzu.vmware.com/tanzu-cluster-essentials/cluster-essentials-bundle@sha256:2354688e46d4bb4060f74fca069513c9b42ffa17a0a6d5b0dbb81ed52242ea44
export INSTALL_REGISTRY_HOSTNAME=registry.tanzu.vmware.com
```

```execute
pivnet login --api-token=$PIVNET_TOKEN
```
<p style="color:blue"><strong> Download Cluster essentials </strong></p>
 
```execute
pivnet download-product-files --product-slug='tanzu-cluster-essentials' --release-version='1.4.0' --product-file-id=1407185
``` 
<p style="color:blue"><strong> Un tar the cluster essentians to tanzu-cluster-essential directory </strong></p>
 
```execute
tar -xvf tanzu-cluster-essentials-linux-amd64-1.4.0.tgz -C $HOME/tanzu-cluster-essentials
```
 
```execute
cd $HOME/tanzu-cluster-essentials
```

<p style="color:blue"><strong> Install cluster essentials in {{ session_namespace }}-cluster  </strong></p>

```execute
./install.sh -y
```
<p style="color:blue"><strong> move Kapp to /usr/local/bin  </strong></p>
 
```execute
sudo cp $HOME/tanzu-cluster-essentials/kapp /usr/local/bin/kapp
```
 
![Cluster Essentials](images/prepare-3.png)
 
<p style="color:blue"><strong> Install Tanzu CLI  </strong></p> 

```execute 
 cd $HOME/tanzu
```
 
```execute
 pivnet download-product-files --product-slug='tanzu-application-platform' --release-version='1.4.0' --product-file-id=1404618
```
 
```execute 
 tar -xvf tanzu-framework-linux-amd64-v0.25.4.1.tar -C $HOME/tanzu
```
 
```execute 
 export TANZU_CLI_NO_INIT=true
```
 

 
```execute 
 sudo install cli/core/v0.25.4/tanzu-core-linux_amd64 /usr/local/bin/tanzu
```
 
```execute 
 tanzu version
``` 
 
```execute 
 tanzu plugin install --local cli all
```
 
```execute
 tanzu plugin list
```
 
<p style="color:blue"><strong> Create tap-registry secret </strong></p>

```execute
sudo tanzu secret registry add tap-registry --username tapworkshopoperators --password $DOCKER_REGISTRY_PASSWORD --server tapworkshopoperators.azurecr.io --export-to-all-namespaces --yes --namespace tap-install
```

![Secret Tap Registry](images/prepare-4.png)

```execute
kubectl create secret docker-registry registry-credentials --docker-server=tapworkshopoperators.azurecr.io --docker-username=tapworkshopoperators --docker-password=$DOCKER_REGISTRY_PASSWORD -n tap-install
```

![Secret Registry Credentials](images/prepare-5.png)

<p style="color:blue"><strong> Verify the pods in kapp-controller namespace  and secretgen-controller </strong></p>

```execute
kubectl get pods -n kapp-controller
```

```execute
kubectl get pods -n secretgen-controller
```
<p style="color:blue"><strong> Copy the tap-values.yaml and auto-heal.sh file" </strong></p>

```execute
cp /opt/workshop/tap-values.yaml $HOME/tap-values.yaml
```
```execute
cp /opt/workshop/autoheal.sh $HOME/autoheal.sh
```

<p style="color:blue"><strong> Changes to tap values file" </strong></p>

```execute
sed -i -r "s/password-registry/$DOCKER_REGISTRY_PASSWORD/g" $HOME/tap-values.yaml
```

```execute
sed -i -r "s/password-registry/$DOCKER_REGISTRY_PASSWORD/g" $HOME/autoheal.sh
```

```execute
sed -i -r "s/SESSION_NAME/$SESSION_NAME/g" $HOME/tap-values.yaml
```
```execute
sed -i -r "s/tap1.3\/tap-demo/tap14/g" $HOME/tap-values.yaml
``` 
