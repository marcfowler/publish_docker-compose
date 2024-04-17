VERSION="$1"
OVERRIDE="$2"
REPO_TOKEN="$3"
GITHUB_REPOSITORY=$(echo "$GITHUB_REPOSITORY" | awk '{print tolower($0)}')

echo "VERSION=$VERSION"
echo "OVERRIDE=$OVERRIDE"

docker login ghcr.io -u "${GITHUB_REF}" -p "${REPO_TOKEN}"

VERSION=$VERSION docker-compose -f docker-compose.yml -f "$OVERRIDE" up --no-start --remove-orphans
IMAGES=$(docker ps -aq)

echo "-------"
echo "IMAGES: $IMAGES"

for IMAGE in $IMAGES; do
    echo "IMAGE: $IMAGE"

    IMAGE_ID=$(docker inspect --format='{{.Image}}' "$IMAGE")
    SERVICE_NAME=$(docker inspect --format '{{ index . "Name" }}' "$IMAGE_ID")

    echo "IMAGE_ID=$IMAGE_ID"
    echo "SERVICE_NAME=$SERVICE_NAME"
    
    NAME=$(basename "${GITHUB_REPOSITORY}").${SERVICE_NAME#/}
    TAG="ghcr.io/${GITHUB_REPOSITORY}/$NAME:$VERSION"

    echo "TAG=$TAG"

    docker tag "$IMAGE_ID" "$TAG"
    docker push "$TAG"
done
