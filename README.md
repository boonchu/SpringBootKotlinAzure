#### Build and Push Images

  * Use local database

```
- Pull code
git clone https://github.com/gotamafandy/SpringBootKotlinAzure.git
cd SpringBootKotlinAzure

- Switch to 'local database' properties

### > src/main/resources/application.properties 

spring.profiles.active=docker

./gradlew clean build
mkdir -p build/dependency && (cd build/dependency; jar -xf ../libs/*.jar)

- Run docker
docker-compose up -d 

- Perform a smoke test

curl -X POST http://localhost:8090/api/users -H "Content-Type: application/json" \
  -d "{\"name\":\"Fandy Gotama\",\"phone\":\"+62816521323\"}"

```

  * Use MySQL database

```
- Setup 'MySQL'

Use Portal

- Setup 'Azure Container Registry'

Use terraform

# Get the id of the service principal configured for AKS
CLIENT_ID=$(az aks show -g devops-qa -n myapp485959 --query "servicePrincipalProfile.clientId" --output tsv)

# Get the ACR registry resource id
ACR_ID=$(az acr show -g devops-qa -n acr0myapp485959 --query "id" --output tsv)

# Create role assignment
echo "CLIENT_ID = ${CLIENT_ID}"
echo "ACR_ID    = ${ACR_ID}"
az role assignment create --assignee $CLIENT_ID --role acrpull --scope $ACR_ID

- Switch to 'azure database' properties

### > src/main/resources/application-azure.properties
- Update username and database name and database end point

### > src/main/resources/application.properties 

spring.profiles.active=azure

./gradlew clean build

- test with docker-compose
docker-compose up -d

- Push image

az acr login -n acr0myapp485959
./gradlew jib

- Change 'Connection Security' in database

  * Add existing vnet that need to access database
  * Turn off TLS SSL

- Perform a smoke test

curl -X POST http://localhost:8090/api/users -H "Content-Type: application/json" \
  -d "{\"name\":\"Fandy Gotama\",\"phone\":\"+62816521323\"}"

- Run MySQLDB Test

$ mysql -u fandygotama@db0myapp485959 -p -h db0myapp485959.mysql.database.azure.com
Enter password: 
Welcome to the MySQL monitor.  Commands end with ; or \g.
Your MySQL connection id is 65061
Server version: 5.6.47.0 MySQL Community Server (GPL)

Copyright (c) 2000, 2020, Oracle and/or its affiliates. All rights reserved.

Oracle is a registered trademark of Oracle Corporation and/or its
affiliates. Other names may be trademarks of their respective
owners.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

mysql> use adrenadev_tutorial;
Reading table information for completion of table and column names
You can turn off this feature to get a quicker startup with -A

Database changed
mysql> select * from users;
+----+--------------+--------------+
| id | name         | phone        |
+----+--------------+--------------+
|  1 | Fandy Gotama | +62816521323 |
+----+--------------+--------------+
1 row in set (0.00 sec)

mysql> exit
Bye

- Shutdown smoke test

docker-compose down --rmi all

- Push image

./gradlew clean build
./gradlew jib
```

  * Deploy to AKS

```
- Login AKS
az aks get-credentials -g devops-qa -n myapp485959

- Deploy service with internal LB
  https://docs.microsoft.com/en-us/azure/aks/internal-lb

- Deployment
  https://kubernetes.io/docs/tasks/run-application/run-stateless-application-deployment/

kubectl apply -f deployment.yml 

kubectl get ep 
NAME                 ENDPOINTS                         AGE
adrenadev-tutorial   10.17.1.20:8080,10.17.1.32:8080   112s

kubectl get pods,svc,deploy
NAME                                      READY   STATUS    RESTARTS   AGE
pod/adrenadev-tutorial-646d44fff7-krc55   1/1     Running   0          3m41s
pod/adrenadev-tutorial-646d44fff7-qqjq7   1/1     Running   0          3m41s

NAME                         TYPE           CLUSTER-IP   EXTERNAL-IP   PORT(S)        AGE
service/adrenadev-tutorial   LoadBalancer   10.2.0.253   10.17.1.37    80:32436/TCP   3m41s

NAME                                 READY   UP-TO-DATE   AVAILABLE   AGE
deployment.apps/adrenadev-tutorial   2/2     2            2           3m41s


- Validate POST

curl -X POST http://10.17.1.37/api/users -H "Content-Type: application/json" \
     -d "{\"name\":\"Fandy Gotama\",\"phone\":\"+628111111111\"}"

{"id":2,"name":"Fandy Gotama","phone":"+628111111111"}

- Validate GET

curl http://10.17.1.37/api/users -H "Content-Type: application/json" | jq
[
  {
    "id": 1,
    "name": "Fandy Gotama",
    "phone": "+62816521323"
  },
  {
    "id": 2,
    "name": "Fandy Gotama",
    "phone": "+628111111111"
  }
]

```
