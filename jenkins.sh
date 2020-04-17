echo "building image"
cp ./credentials/test_env/settings.env .env
echo "" >> .env && cat ./credentials/shared/versions.env >> .env

/usr/local/bin/docker-compose pull
/usr/local/bin/docker-compose down --volumes
/usr/local/bin/docker-compose run --entrypoint ./build.sh equipment-ui
/usr/local/bin/docker-compose build image
/usr/local/bin/docker-compose down --volumes

docker login -u="$DOCKER_USERNAME" -p="$DOCKER_PASSWORD"

echo "pushing image for dev/test instance"
docker tag openlmismz/equipment-ui:latest openlmismz/equipment-ui:${version}
docker push openlmismz/equipment-ui:${version}

rm -Rf ./credentials
rm -f .env