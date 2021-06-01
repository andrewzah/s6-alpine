set positional-arguments := true

@build BASE_VERSION:
  docker build . \
    --build-arg "BASE_VERSION=$1" \
    -t "andrewzah/base-alpine:$1"

@push BASE_VERSION:
  just build $1
  docker push "andrewzah/base-alpine:$1"
