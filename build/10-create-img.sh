source ./build.ini
docker container rm -f $ctn_name
docker image rm -f $ctn_img
DOCKER_BUILDKIT=1 docker build -t $ctn_img .

