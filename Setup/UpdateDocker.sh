
echo "Creating Docker Image"
docker build -t 'ubuntu:14.04' - < Dockerfile
echo "Retrieving Installed Docker Images"
docker images
