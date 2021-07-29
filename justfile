alpine_version := '3.12'

build v=alpine_version:
  docker build . \
    --build-arg="BASE_VERSION={{v}}" \
    -t "andrewzah/base-alpine:{{v}}"

buildall:
  just build 3.12
  just build 3.13

pushall:
  docker push "andrewzah/base-alpine:3.12"
  docker push "andrewzah/base-alpine:3.13"
