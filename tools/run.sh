REGISTRY=default-route-openshift-image-registry.apps.cluster-9vms9.dynamic.redhatworkshops.io

podman rmi $REGISTRY/openshift/pipeline-tools:1.0

podman build -f Dockerfile --tag=$REGISTRY/openshift/pipeline-tools:1.0

podman login -u admin  -p $(oc whoami -t) $REGISTRY --tls-verify=false

podman push $REGISTRY/openshift/pipeline-tools:1.0 --tls-verify=false

oc get is -n openshift | grep pipeline-tools


