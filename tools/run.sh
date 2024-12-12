podman rmi default-route-openshift-image-registry.apps.cluster-xbmk6.dynamic.redhatworkshops.io/openshift/xpto-pipeline-tools:1.0

podman build -f Dockerfile --tag=default-route-openshift-image-registry.apps.cluster-xbmk6.dynamic.redhatworkshops.io/openshift/xpto-pipeline-tools:1.0

podman login -u admin  -p $(oc whoami -t) default-route-openshift-image-registry.apps.cluster-xbmk6.dynamic.redhatworkshops.io --tls-verify=false

podman push default-route-openshift-image-registry.apps.cluster-xbmk6.dynamic.redhatworkshops.io/openshift/xpto-pipeline-tools:1.0 --tls-verify=false

oc get is -n openshift | grep xpto


