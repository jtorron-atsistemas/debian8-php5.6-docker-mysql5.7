docker build --tag="atsistemas:base" --file=Dockerfile-baseImage .
docker build --tag="atsistemas:api" --file=Dockerfile-api .
docker build --tag="atsistemas:web" --file=Dockerfile-web .