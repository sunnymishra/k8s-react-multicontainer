# NOTE: $GIT_SHA env variable is already set in the .travis.yml file pointing to the last commit on master branch.

docker build -t sunnymishra0389/multi-client:latest -t sunnymishra0389/multi-client:$GIT_SHA -f ./client/Dockerfile ./client

docker build -t sunnymishra0389/multi-server:latest -t sunnymishra0389/multi-server:$GIT_SHA -f ./server/Dockerfile ./server

docker build -t sunnymishra0389/multi-worker:latest -t sunnymishra0389/multi-worker:$GIT_SHA -f ./worker/Dockerfile ./worker

# NOTE: in .travis.yml file we already did Docker hub login. So docker push will work just fine.

# Notice how we have to push both the tags for each Image 2 times. :latest & :GIT_SHA
docker push sunnymishra0389/multi-client:latest
docker push sunnymishra0389/multi-client:$GIT_SHA

docker push sunnymishra0389/multi-server:latest
docker push sunnymishra0389/multi-server:$GIT_SHA

docker push sunnymishra0389/multi-worker:latest
docker push sunnymishra0389/multi-worker:$GIT_SHA

# NOTE: In .travis.yml we already configured kubectl cli
kubectl apply -f k8s

# Imperative k8s command: manually set Latest image on eacy Deployment object. Reason: we don't use Docker image tag for each new changing Image version, so everytime we run this Script file, it will force pull latest Image from Docker hub, which is what we want.
# NOTE: here "server=" is thename of the Container in our server-deployment.yml file. We are setting our desired image name to this Container name and passing this to the kubectl set image command.
kubectl set image deployments/client-deployment client=sunnymishra0389/multi-client:$GIT_SHA
kubectl set image deployments/server-deployment server=sunnymishra0389/multi-server:$GIT_SHA
kubectl set image deployments/worker-deployment worker=sunnymishra0389/multi-worker:$GIT_SHA