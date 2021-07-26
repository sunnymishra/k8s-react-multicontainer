Execute following command in our Google cloud console Shell, to install Helm v2 Instead of using older Helm as used in Udemy course:

curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3
chmod 700 get_helm.sh
./get_helm.sh

Link to more readup material:

https://helm.sh/docs/intro/install/#from-script

2. Skip the commands run in the following lectures:

- Helm Setup, 
- Kubernetes Security with RBAC, 
- Assigning Tiller a Service Account, and 
- Ingress-Nginx with Helm. 
You should still watch these lectures and they contain otherwise useful info. 

3. Install Ingress-Nginx:

In your Google Cloud Console run the following:

$ helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
$ helm install my-release ingress-nginx/ingress-nginx


IMPORTANT: If you get an error such as chart requires kubeVersion: >=1.16.0-0.....

You may need to manually upgrade your cluster to at least the version specified:

$ gcloud container clusters upgrade  YOUR_CLUSTER_NAME --master --cluster-version 1.16

This should not be a long term issue since Google Cloud should handle this automatically:

https://cloud.google.com/kubernetes-engine/docs/how-to/upgrading-a-cluster

Link to the docs:

https://kubernetes.github.io/ingress-nginx/deploy/#using-helm

----------------------
In .travis.yml make sure to change this script so that Testcase exits after success and don't cause our builds to fail.:

    script:
      - docker run USERNAME/react-test npm test -- --coverage

To use the CI flag and remove coverage:

    script:
      - docker run -e CI=true USERNAME/react-test npm test
------------------------
Travis cli login inside ruby:2.4 container in local laptop to encrypt Google IAM user's credentials JSON file will fail with "iv undefined" errors. To avoid it do following:

Create a Personal Github Token for Travis:

https://docs.github.com/en/free-pro-team@latest/github/authenticating-to-github/creating-a-personal-access-token

Setup the scope with Travis permissions:

https://docs.travis-ci.com/user/github-oauth-scopes/#repositories-on-httpstravis-cicom-private-and-public

The login command will now look like this:

travis login --github-token YOUR_GITHUB_SECRET_TOKEN --com

When you encrypt the Google IAM user's credentials JSON file, you must pass the same --com flag you used to log in:

travis encrypt-file google_iam_service_account_creds.json -r sunnymishra/k8s-react-multicontainer --com
 

-------------------------
Installing Travis inside a Docker container requires Ruby v2.4. Command:

docker run -it -v $(pwd):/app ruby:2.4 sh

With this version, we will no longer be passing the --no-rdoc or --no-ri flags when installing Travis. The command will simply be:

gem install travis 
-------------------------
When adding the name variable to the postgres-deployment.yaml file, instead of using the following:

    env:
      - name: PGPASSWORD

Change to:

    env:
      - name: POSTGRES_PASSWORD

DO NOT update the server deployment's environment variables. This update only applies to the postgres-deployment.yaml
---------------------------
Ingress Update "this.state.seenIndexes.map is not a function" / 404 errors
ingress-service.yaml config file.

v1beta1 API

Note - this API version will only be supported through Kubernetes v1.22. Scroll further down for the v1 version.

Four lines need to be updated and one line needs to be added:

    apiVersion: networking.k8s.io/v1beta1
    # UPDATE THE API
    kind: Ingress
    metadata:
      name: ingress-service
      annotations:
        kubernetes.io/ingress.class: nginx
        nginx.ingress.kubernetes.io/use-regex: 'true'
        # ADD THIS LINE ABOVE
        nginx.ingress.kubernetes.io/rewrite-target: /$1
        # UPDATE THIS LINE ABOVE
    spec:
      rules:
        - http:
            paths:
              - path: /?(.*)
              # UPDATE THIS LINE ABOVE
                backend:
                  serviceName: client-cluster-ip-service
                  servicePort: 3000
              - path: /api/?(.*)
              # UPDATE THIS LINE ABOVE
                backend:
                  serviceName: server-cluster-ip-service
                  servicePort: 5000

Kubernetes v1 API:

Documentation link for reference: https://kubernetes.io/docs/concepts/services-networking/ingress/

    apiVersion: networking.k8s.io/v1
    kind: Ingress
    metadata:
      name: ingress-service
      annotations:
        kubernetes.io/ingress.class: "nginx"
        nginx.ingress.kubernetes.io/use-regex: "true"
        nginx.ingress.kubernetes.io/rewrite-target: /$1
    spec:
      rules:
        - http:
            paths:
              - path: /?(.*)
                pathType: Prefix
                backend:
                  service:
                    name: client-cluster-ip-service
                    port:
                      number: 3000
              - path: /api/?(.*)
                pathType: Prefix
                backend:
                  service:
                    name: server-cluster-ip-service
                    port:
                      number: 5000


---------------------------
In the docker-compose.yml file of "Worker" service, include the Redis host and port as environment variables, Otherwise, you will get a "Calculated Nothing Yet" error message.
	worker:
		environment:
		  - REDIS_HOST=redis
		  - REDIS_PORT=6379
	  
In the docker-compose.yml file of "Client" service, be sure to include the stdin_open: true configuration. Otherwise, you will get a "React App exited with Code 0" error in your terminal when we attempt to start up the application.

  client:
    stdin_open: true
    build:
      dockerfile: Dockerfile.dev
      context: ./client
---------------
Change from below:
	FROM node:alpine

to this:
	FROM node:14.14.0-alpine
---------------
The default.conf should now look like this:

    server {
      listen 3000;
     
      location / {
        root /usr/share/nginx/html;
        index index.html index.htm;
        try_files $uri $uri/ /index.html;
      }
    }
----------------
inside .travis.yml change required for Jest library to work with Create React App
    script:
      - docker run USERNAME/react-test npm test -- --coverage

instead should be:
    script:
      - docker run -e CI=true USERNAME/react-test npm test