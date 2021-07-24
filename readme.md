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