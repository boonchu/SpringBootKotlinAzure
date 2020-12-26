GRADLEW = ./gradlew

all: run

run: build test
	@docker-compose up -d

.PHONY: build clean stage deploy-image
build:
	@sed -i -E 's/spring.profiles.active=azure/spring.profiles.active=docker/' src/main/resources/application.properties
	$(GRADLEW) clean build
	@mkdir -p build/dependency && (cd build/dependency; jar -xf ../libs/*.jar)
	@docker-compose build

test:
	@curl -sq -X POST http://localhost:8090/api/users -H "Content-Type: application/json" \
		-d "{\"name\":\"Fandy Gotama\",\"phone\":\"+62816521323\"}" | jq
	@curl -sq -X GET http://localhost:8090/api/users -H "Content-Type: application/json" | jq

deploy:
	@sed -i -E 's/spring.profiles.active=docker/spring.profiles.active=azure/' src/main/resources/application.properties
	$(GRADLEW) clean build
	@mkdir -p build/dependency && (cd build/dependency; jar -xf ../libs/*.jar)
	@docker-compose build

stage: deploy
	@docker-compose up -d

deploy-image: deploy
	@az acr login -n acr0myapp485959
	./gradlew jib

clean:
	@docker-compose down --rmi all
	$(GRADLEW) clean 
	$(RM) build
