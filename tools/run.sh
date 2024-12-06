podman rmi default-route-openshift-image-registry.apps.cluster-pwtfx.dynamic.redhatworkshops.io/openshift/smt-pipeline-tools:1.0

podman build -f Dockerfile --tag=default-route-openshift-image-registry.apps.cluster-pwtfx.dynamic.redhatworkshops.io/openshift/smt-pipeline-tools:1.0

podman login -u admin  -p $(oc whoami -t) default-route-openshift-image-registry.apps.cluster-pwtfx.dynamic.redhatworkshops.io --tls-verify=false

podman push default-route-openshift-image-registry.apps.cluster-pwtfx.dynamic.redhatworkshops.io/openshift/smt-pipeline-tools:1.0 --tls-verify=false

oc get is -n openshift | grep smt


