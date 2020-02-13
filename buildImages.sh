docker build --tag="atsistemas:base" --file=dockerfiles/Dockerfile-baseImage .
docker build --tag="atsistemas:api" --file=dockerfiles/Dockerfile-api .
docker build --tag="atsistemas:web" --file=dockerfiles/Dockerfile-web .