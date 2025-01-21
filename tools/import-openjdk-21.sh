oc create -f 6095290_tassinari-secret-redhat.yaml -n openshift
oc create -f kube-openjdk-21-pod.yaml -n openshift
oc import-image ubi9/openjdk-21:1.21-3 --from=registry.redhat.io/ubi9/openjdk-21:1.21-3 --confirm -n openshift
oc get is -n openshift | grep openjdk-21
oc delete pod kube-openjdk-21-pod -n openshift
oc delete secret 6095290-tassinari-pull-secret -n openshift

