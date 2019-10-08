
# Table of Contents

1.  [Required tools for this lab](#org4603281)
    1.  [You will need all of the following installed or set up before being able to complete the lab](#org337c887)
    2.  [Installing the IBM Cloud CLI & Container Service Plug-in](#org7d96927)
    3.  [Installing Kubectl: The Kubernetes CLI](#org00df1ab)
    4.  [Installing Docker](#org1035341)
2.  [Complete the following tasks at *least* 45 minutes before](#org5a221b4)
    1.  [Provision your own FREE (free) cluster on IBM's cloud](#provision)
    2.  [Create a container registry namespace](#org5e9ddd3)
    3.  [Point your kubectl to your cluster](#org8665b52)
3.  [Exploring Docker](#org81959e6)
4.  [Creating a Custom Image](#orgaeda04c)
5.  [Orchestrating Containers with Kubernetes](#org4303e23)



<a id="org4603281"></a>

# Required tools for this lab


<a id="org337c887"></a>

## You will need all of the following installed or set up before being able to complete the lab

-   an ibm cloud account
-   kubectl
-   Docker
-   ibm cloud cli
-   ibm cloud container registry plug-in
-   ibm cloud kubernetes service plug-in


<a id="org7d96927"></a>

## Installing the IBM Cloud CLI & Container Service Plug-in

-   [follow these instructions for your system](https://cloud.ibm.com/docs/cli?topic=cloud-cli-getting-started)
-   log in to ibm cloud with `ibmcloud login` (or `ibmcloud login --sso` if you have a federated ID)
-   run `ibmcloud plugin install kubernetes-service` to install the container service plug-in for the cli
    -   kubernetes service plug-in is invoked using `ibmcloud ks <command>`
-   now run `ibmcloud plugin install container-registry`
    -   container registry commands are invoked using `ibmcloud cr <command>`


<a id="org00df1ab"></a>

## Installing Kubectl: The Kubernetes CLI

-   This part of the process is system dependent! Click the link below that describes your operating system for detailed installation instructions.
    -   [linux](https://kubernetes.io/docs/tasks/tools/install-kubectl/#install-kubectl-on-linux)
    -   [mac os](https://kubernetes.io/docs/tasks/tools/install-kubectl/#install-kubectl-on-macos)
    -   [windows](https://kubernetes.io/docs/tasks/tools/install-kubectl/#install-kubectl-on-windows)
-   make sure you read all of the instructions.
-   run `kubectl version` when you think you're done to see if you did it right!


<a id="org1035341"></a>

## Installing Docker

-   go [here](https://docs.docker.com/v17.09/engine/installation/) and select your os to follow instructions to install docker on your system.
-   you do not need to create a docker account.


<a id="org5a221b4"></a>

# Complete the following tasks at *least* 45 minutes before


<a id="provision"></a>

## Provision your own FREE (free) cluster on IBM's cloud

-   after logging in to your cli all you have to do is run `ibmcloud ks cluster-create --name <CLUSTER NAME HERE>`
-   check and see if you you're cluster is provisioning: `ibmcloud ks clusters`
-   if it still says "pending" or something other than "normal" under the <span class="underline">STATE</span> field don't worry! provisioning a cluster takes a little time (thats why you need to do this a few minutes ahead of time)


<a id="org5e9ddd3"></a>

## Create a container registry namespace

-   this will give us a place to put our container image so we can deploy it (don't worry if you don't know what that means right now, it will become clear later)
-   create your namespace with `ibmcloud cr namespace-add <EXCITING NAMESPACE NAME HERE>`
-   later on you're going to need to specify the region in which your container registry is running, to get this information run `ibmcloud cr region`
    -   this will be used to tell docker which registry to push our image to by building a path like `<region>.icr.io/<namespace>/<image name>:<tag>`


<a id="org8665b52"></a>

## Point your kubectl to your cluster

-   once your cluster is done provisioning we need to point kubectl towards it by setting the $KUBECONFIG environemtn variable.
-   to do this run `ibmcloud ks cluster config --cluster <cluster name or id here>`. If you forgot your clusters name/id remember you can get that information from `ibmcloud ks clusters`.
-   copy and paste the `export` line that is returned.
-   verify that you're set up properly by checking the result of `echo $KUBECONFIG`


<a id="org81959e6"></a>

# Exploring Docker

So, you've downloaded the Docker CLI and now you're ready to get your toes wet with container technology, where do you begin? Pull up your terminal and lets start small: type `docker version` to make sure that our CLI is installed and up to date. Lets try something a little more exciting: 

`docker run ubuntu ps -ef`.

Running this command will do several things. First `docker run` does a `docker pull` to download the Ubuntu image from Dockers public image repository to your machine. Since no version was specified in the `docker run` command docker will grab the image tagged as "Latest" in its repository. Once the image is downloaded the container is created and then started up. For anyone who is not aware, the `ps` command is a common command that shows the currently running processes on a Unix (or Unix-like) machine. That in mind, its worth noting that the only process we see when we ask our Ubuntu container to run `ps -ef` is&#x2026; the command itself. Try running the same command locally and see what your output is. This does an excellent job illustrating the concept of process isolation which is the cornerstone of containerised architecture.

Lets try something else. This time in your terminal type

`docker container run -t ubuntu top`

the `top` process gives us information on the processes running on a Unix/Unix-like machine. Its a lot like running Task Manager on a Wondows PC. The `-t` flag creates a pseudo-TTY which emulates the the terminal as we would see it inside the Ubuntu container running `top`. Again, the only process we see is the command we told our container to run. If you exit your TTY session and type `docker container ls` you'll see our container! Its sittin there, running `top`, just like we told it to. Docker allows us to "enter" our containers using the `docker container exec...` command, so lets try it:

`docker container exec -it bash`

Now you're running a bash shell in a container running Ubuntu from a local shell  terminal running on your host operating system&#x2026; Anyways! Play around! Try typing bash commands, delete stuff, break your container &#x2013; it doesn't matter because we can just delete it and spin it up again, exactly like it was before. To clean up after ourselves lets run `docker container stop <containerID>` and then `docker system prune` to take out the garbage.


<a id="orgaeda04c"></a>

# Creating a Custom Image

Now that we have familiarized ourselves with containers and Docker a little bit lets try doing something a little more useful, lets create our own custom Docker image out of an API that we make ourselves! Building a custom image is as simple as creating an object known as a Dockerfile and then running the proper `docker build` command.

The dockerfile is a human readable instruction list that will tell Docker what we want and how we want it. At its heart it is nothing more than a list of commands that are very similar to those you might run when creating your own local environment. In this repository is an example of a Dockerfile, lets take a look:

    FROM python:3.7
    RUN useradd sam
    WORKDIR /home/app
    
    # get the requirements
    COPY requirements.txt requirements.txt
    RUN pip3 install -r requirements.txt
    
    # using gunicorn as my production server
    RUN pip3 install gunicorn
    
    # copy the application
    COPY app app
    COPY app.py boot.sh ./
    RUN chmod +x boot.sh
    ENV FLASK_APP app.py
    
    # Set ownership and change user
    RUN chown -R sam:sam ./
    USER sam
    
    # Run the app with port 5000 exposed on the container
    EXPOSE 5000
    ENTRYPOINT ["./boot.sh"]

Every Dockerfile must begin by declaring the base container image using the `FROM` statement. In line 1 we're telling Docker to begin building our application on an image of Python version 3.7. Everything after that is moving files from local directories to the container image, installing dependencies, creating a user other than root user (for security reasons NEVER run your applications as root), and finally telling the image how it should start running our api (by running `./boot.sh`). Once you've assembled your Dockerfile you can create your image by running `docker build -t <image-name>:<tag> .` the `-t` flag allows us to name and Tag our image and the `.` tells docker to look in the current directory for a file named Dockerfile to give it instructions. And thats it! if you type `docker image ls` you'll see your shiny new image sitting pretty on your local machine. Wanna see it work? Try `docker run --name <name your container> -p 8000:5000 --rm <image-name>:<tag>`. I'm using the `--name` tag to give our container a custom name instead of using the randomly generated one Docker assigns by defaul. `-p` publishes our container and moves traffic from localhost:8000 to container port 5000 (the port our flask api will be looking at). Finally I used the optional `--rm` flag, this will simply clean up after us once we're done running the container. Now open a browser and go to localhost:8000 and you should see our web app!


<a id="org4303e23"></a>

# Orchestrating Containers with Kubernetes

Creating a custom image and then running a container from it is pretty cool. But what if you wanted deploy your api? You could do this manually but as your applciation grows and becomes a more complicated stack of concurrently running containers this task starts to feel a little daunting. Not to mention when you start thinking about scaling up or down or trying to make a resource "highly available". Luckily, container orchestrators exist. Broadly speaking and orchestrator is any service which helps automate the configuration, coordination and management of a containers lifecycle. This could include but is not limited to things such as cluster management, scheduling, service discovery and replication.

There are quite a few different tools which offer orchestration services but for today it will be useful to focus on one: Kubernetes. Kuberenetes (Kube, k8s) is an open source container orchestrator developed by Google which can provision, manage and scale applications. Before going into how to deploy our API with Kube it is really important to note that Kubernetes on its own is *NOT* a production ready tool. It needs to integrate with underlying platforms to provide the infrastructure, storage, etc. for your application. Its also lacks a production ready operation view, controls and pre-built catalogues. But thats why there are managed Kube services from companies like IBM, Amazon, and Microsoft. In fact on this guide I will be using IBM's Kubernetes service (IKS) to deploy and manage my application. Lets begin.

First we need to make sure all of our tools are properly installed and up to date. Type `kubectl version` to check this. Next, login to your ibmcloud account (if you havent already) with `ibmcloud login`. Now lets look at our clusters. If you haven't already followed [these](#provision) steps to create your own free IKS cluster then go ahead and do so now! Try `ibmcloud ks clusters` to show every cluster provisioned in your account. In order to use the `kubectl` CLI we need to tell it which cluster it needs to manage. To do this we set the `$KUBECONFIG` variable in our terminal session to the value returned by the `ibmclous ks cluster config <cluster-name>`. Once `$KUBECONFIG` is defined we're ready to make the magic happen

Now we need to define our desired state for our deployment. This is done using a declaritive framework in yaml format. These yaml files will describe what we want and then kubernetes will do everything in its power to reconcile this desired state with the actual, real-world status.

    apiVersion: extensions/v1beta1
    kind: Deployment
    metadata:
      name: iks-demo-1
    spec:
      replicas: 3
      selector:
        matchLabels:
          app: iks-demo
      template:
        metadata:
          labels:
            app: iks-demo
        spec:
          containers:
            - name: iks-demo
              image: us.icr.io/iks-101/iks-demo:latest
              imagePullPolicy: Always
              ports:
                - name: http-server
                  containerPort: 5000

The above yaml will tell kubectl to do several things for us. To begin with it will choose an API version (v1beta1) and then choose a service kind, in this case Deployment. Next we named our deployment iks-demo-1 and then stated we want 3 replicas. We label our app and then tell kubernetes which docker image it will use as a template. This can be a local or (as is my case) remote repository. Then we tell kube which port it should allow traffic to go to on our container. `kubectl create -f deployment.yaml` will read our deployment file and then create the deployment we asked it to! Type `kubectl get pods` to see your application pods.

This is great but what if we want our friends and families to access our sweet, new web applciation? Normally we'd have to configure some form of ingress (maybe set up nginx) but with kubernetes its as simple as creating a service to load balance to our 3 replicas and binding that service to our deployment.

    apiVersion: v1
    kind: Service
    metadata:
      name: iks-demo-1
    spec:
      type: LoadBalancer
      ports:
      - port: 3000
        targetPort: http-server
      selector:
        app: iks-demo

This is done in a very similar way to how we created our deployment! This time, however, our yaml defines the kind as a Service and that service is defined as a type LoadBalancer. We tell it to select the deployment labeled iks-demo and thats all! `kubectl create -f service.yaml` and we're done.

Now if we go to <cluster-ip>:<service-port> we can see our web app! To get the cluster ip type `ibmcloud ks workers <cluster-name>` and then take note of the public ip. The port can be found by typing `kubectl get services`. And thats it!

