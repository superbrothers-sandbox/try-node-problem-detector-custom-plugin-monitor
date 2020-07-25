# try-node-problem-detector-custom-plugin-monitor

This repository contains a sample custom plugin for node-problem-detector. The sample custom plugin checks for the presence of the /custom-data/up file on the host.

1. Create a single node cluster

    ```shell
    $ minikube start --vm-driver=virtualbox
    ```

1. Check the kubernetes cluster version

    ```shell
    $ kubectl version
    Client Version: version.Info{Major:"1", Minor:"18", GitVersion:"v1.18.4", GitCommit:"c96aede7b5205121079932896c4ad89bb93260af", GitTreeState:"clean", BuildDate:"2020-06-17T11:41:22Z", GoVersion:"go1.13.9", Compiler:"gc", Platform:"darwin/amd64"}
    Server Version: version.Info{Major:"1", Minor:"18", GitVersion:"v1.18.3", GitCommit:"2e7996e3e2712684bc73f0dec0200d64eec7fe40", GitTreeState:"clean", BuildDate:"2020-05-20T12:43:34Z", GoVersion:"go1.13.9", Compiler:"gc", Platform:"linux/amd64"}
    ```

1. Create the up file on the host beforehand

    ```shell
    $ minikube ssh -- sudo mkdir -p /custom-data
    $ minikube ssh -- sudo touch /custom-data/up
    ```

1. Apply node-problem-detector manifests

    ```shell
    $ kubectl apply -k .
    ```

1. Check the status of a node-problem-detector pod

    ```shell
    $ kubectl get po -n kube-system -l app=node-problem-detector
    NAME                          READY   STATUS    RESTARTS   AGE
    node-problem-detector-fmqq8   1/1     Running   0          2m59s
    ```

1. Check the UpFile condition of minikube node

    ```shell
    $ kubectl get node minikube -o 'jsonpath={.status.conditions[?(@.type=="UpFile")]}{"\n"}'
    map[lastHeartbeatTime:2020-07-25T03:19:34Z lastTransitionTime:2020-07-25T03:19:33Z message:up file exists reason:UpFileExists status:False type:UpFile]
    ```

    You will see the UpFile condition is `False`.

1. Remove the up file on the host

    ```shell
    $ minikube ssh -- sudo rm /custom-data/up
    ```

1. Check the UpFile condition of minikube node

    ```shell
    $ kubectl get node minikube -o 'jsonpath={.status.conditions[?(@.type=="UpFile")]}{"\n"}' -w
    map[lastHeartbeatTime:2020-07-25T03:19:34Z lastTransitionTime:2020-07-25T03:19:33Z message:up file exists reason:UpFileExists status:False type:UpFile]
    map[lastHeartbeatTime:2020-07-25T03:21:34Z lastTransitionTime:2020-07-25T03:21:33Z message:/custom-data/up does not exist reason:UpFileDoesNotExist status:True type:UpFile]
    ```

    You will see the UpFile condition change to `True`.

1. Revert the removed file on the host

    ```shell
    $ minikube ssh -- sudo touch /custom-data/up
    ```

1. Check the UpFile condition of minikube node

    ```shell
    $ kubectl get node minikube -o 'jsonpath={.status.conditions[?(@.type=="UpFile")]}{"\n"}' -w
    map[lastHeartbeatTime:2020-07-25T03:21:34Z lastTransitionTime:2020-07-25T03:21:33Z message:/custom-data/up does not exist reason:UpFileDoesNotExist status:True type:UpFile]
    map[lastHeartbeatTime:2020-07-25T03:22:34Z lastTransitionTime:2020-07-25T03:22:33Z message:up file exists reason:UpFileExists status:False type:UpFile]
    ```

    You will see the UpFile condition return to `False`.
