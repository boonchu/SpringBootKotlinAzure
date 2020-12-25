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

- Push image

az acr login -n acr0myapp485959
./gradlew jib
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
```
