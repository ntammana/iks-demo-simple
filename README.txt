                           _________________

                            SIMPLE IKS DEMO

                              Sam Halpern
                           _________________


Table of Contents
_________________

1. Required tools for this lab
.. 1. You will need all of the following installed or set up before being able to complete the lab
.. 2. Installing the IBM Cloud CLI & Container Service Plug-in
.. 3. Installing Kubectl: The Kubernetes CLI
.. 4. Installing Docker
2. Complete the following tasks at /least/ 45 minutes before
.. 1. Provision your own FREE (free) cluster on IBM's cloud
.. 2. Create a container registry namespace
.. 3. Point your kubectl to your cluster





1 Required tools for this lab
=============================

1.1 You will need all of the following installed or set up before being able to complete the lab
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

  + an ibm cloud account
  + kubectl
  + Docker
  + ibm cloud cli
  + ibm cloud container registry plug-in
  + ibm cloud kubernetes service plug-in


1.2 Installing the IBM Cloud CLI & Container Service Plug-in
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

  + [follow these instructions for your system]
  + log in to ibm cloud with `ibmcloud login' (or `ibmcloud login --sso'
    if you have a federated ID)
  + run `ibmcloud plugin install kubernetes-service' to install the
    container service plug-in for the cli
    - kubernetes service plug-in is invoked using `ibmcloud ks
      <command>'
  + now run `ibmcloud plugin install container-registry'
    - container registry commands are invoked using `ibmcloud cr
      <command>'


[follow these instructions for your system]
<https://cloud.ibm.com/docs/cli?topic=cloud-cli-getting-started>


1.3 Installing Kubectl: The Kubernetes CLI
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

  + This part of the process is system dependent! Click the link below
    that describes your operating system for detailed installation
    instructions.
    - [linux]
    - [mac os]
    - [windows]
  + make sure you read all of the instructions.
  + run `kubectl version' when you think you're done to see if you did
    it right!


[linux]
<https://kubernetes.io/docs/tasks/tools/install-kubectl/#install-kubectl-on-linux>

[mac os]
<https://kubernetes.io/docs/tasks/tools/install-kubectl/#install-kubectl-on-macos>

[windows]
<https://kubernetes.io/docs/tasks/tools/install-kubectl/#install-kubectl-on-windows>


1.4 Installing Docker
~~~~~~~~~~~~~~~~~~~~~

  + go [here] and select your os to follow instructions to install
    docker on your system.
  + you do not need to create a docker account.


[here] <https://docs.docker.com/v17.09/engine/installation/>


2 Complete the following tasks at /least/ 45 minutes before
===========================================================

2.1 Provision your own FREE (free) cluster on IBM's cloud
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

  + after logging in to your cli all you have to do is run `ibmcloud ks
    cluster-create --name <FUN CLUSTER NAME HERE>'
  + check and see if you you're cluster is provisioning: `ibmcloud ks
    clusters'
  + if it still says "pending" or something other than "normal" under
    the _STATE_ field don't worry! provisioning a cluster takes a little
    time (thats why you need to do this a few minutes ahead of time)


2.2 Create a container registry namespace
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

  + this will give us a place to put our container image so we can
    deploy it (don't worry if you don't know what that means right now,
    it will become clear later)
  + create your namespace with `ibmcloud cr namespace-add <EXCITING
    NAMESPACE NAME HERE>'
  + later on you're going to need to specify the region in which your
    container registry is running, to get this information run `ibmcloud
    cr region'
    - this will be used to tell docker which registry to push our image
      to by building a path like `<region>.icr.io/<namespace>/<image
      name>:<tag>'


2.3 Point your kubectl to your cluster
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

  + once your cluster is done provisioning we need to point kubectl
    towards it by setting the $KUBECONFIG environemtn variable.
  + to do this run `ibmcloud ks cluster config --cluster <cluster name
    or id here>'. If you forgot your clusters name/id remember you can
    get that information from `ibmcloud ks clusters'.
  + copy and paste the `export' line that is returned.
  + verify that you're set up properly by checking the result of `echo
    $KUBECONFIG'
