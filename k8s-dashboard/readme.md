If you are using Docker Desktop's built-in Kubernetes, below are the steps for setting up the admin dashboard:

1. Grab the most current YAML config path from the install instructions from this link:

https://github.com/kubernetes/dashboard#install

2. We will need to download the YAML config file locally from the link given above Github path, so we can edit it (make sure you are copying the most current URL from the official Github repo - do not rely on the version shown in the examples below).

GitBash on Windows command:

curl https://raw.githubusercontent.com/kubernetes/dashboard/v2.2.0/aio/deploy/recommended.yaml > kubernetes-dashboard.yaml

PowerShell on Windows command:

Invoke-RestMethod -Uri https://raw.githubusercontent.com/kubernetes/dashboard/v2.2.0/aio/deploy/recommended.yaml -Outfile kubernetes-dashboard.yaml

3. Open up the downloaded file in your code editor and use CMD+F or CTL+F to find the args. Add the following two lines underneath --auto-generate-certificates:

    args:
      - --auto-generate-certificates
      - --enable-skip-login
      - --disable-settings-authorizer

4. Run the following command inside the directory where you downloaded the dashboard manifest file a few steps ago:

kubectl apply -f kubernetes-dashboard.yaml

5. Start the server by running the following command:

kubectl proxy

6. You can now access the dashboard by visiting:

http://localhost:8001/api/v1/namespaces/kubernetes-dashboard/services/https:kubernetes-dashboard:/proxy/

7. You will be presented with a login screen:

8. Click the "SKIP" link next to the SIGN IN button.

9. You should now be redirected to the Kubernetes Dashboard:

Important! The only reason we are bypassing RBAC Authorization to access the Kubernetes Dashboard is that we are running our cluster locally. You would never do this on a public-facing server like Digital Ocean and would need to refer to the official docs to get the dashboard setup.

If you wish to instead create a sample user, you can follow the instructions here:

https://github.com/kubernetes/dashboard/blob/master/docs/user/access-control/creating-sample-user.md