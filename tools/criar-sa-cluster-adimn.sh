oc create sa cluster-admin-sa -n kube-system
oc adm policy add-cluster-role-to-user cluster-admin -z cluster-admin-sa -n kube-system
oc create token cluster-admin-sa -n kube-system --duration=999999h