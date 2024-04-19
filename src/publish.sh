VERSION="$1"
COMPOSE_FILE="$2"
REPO_TOKEN="$3"
NAMING_CONVENTION="$4"
GITHUB_REPOSITORY=$(echo "$GITHUB_REPOSITORY" | awk '{print tolower($0)}')

echo "VERSION=$VERSION"
echo "COMPOSE_FILE=$COMPOSE_FILE"
echo "NAMING_CONVENTION=$NAMING_CONVENTION"

docker login ghcr.io -u "${GITHUB_REF}" -p "${REPO_TOKEN}"

VERSION=$VERSION docker-compose -f docker-compose.yml -f "$COMPOSE_FILE" up --no-start --remove-orphans
IMAGES=$(docker ps -aq)

echo "-------"
echo "IMAGES: $IMAGES"

for IMAGE in $IMAGES; do
    echo "IMAGE: $IMAGE"

    SERVICE_NAME=$(docker inspect --format '{{ index . "Name" }}' "$IMAGE")
    IMAGE_ID=$(docker inspect --format='{{.Image}}' $IMAGE)

    echo "SERVICE_NAME=$SERVICE_NAME"
    echo "IMAGE_ID=$IMAGE_ID"

    if [ "$NAMING_CONVENTION" = "short" ]; then
        NAME=${SERVICE_NAME#/}
    else
        NAME=$(basename "${GITHUB_REPOSITORY}").${SERVICE_NAME#/}
    fi
    
    TAG="ghcr.io/${GITHUB_REPOSITORY}/$NAME:$VERSION"

    echo "TAG=$TAG"

    docker tag "$IMAGE_ID" "$TAG" --label org.opencontainers.image.source=https://github.com/$GITHUB_REPOSITORY
    docker push "$TAG"
done
