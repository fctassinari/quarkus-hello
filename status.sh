echo "  ## GOGS Server - Username/Password: gogs/gogs ##  "
GOGS=$(oc get route -n cicd gogs -o jsonpath='{.spec.host}')
echo "http://$GOGS"
echo "  "

echo "  ## Nexus Server - Username/Password: admin/admin123 ##  "
NEXUS=$(oc get route -n cicd nexus -o jsonpath='{.spec.host}')
echo "https://$NEXUS"
echo "  "

echo "  ## Sonarqube Server - Username/Password: admin/admin ##  "
SONARQUBE=$(oc get route -n cicd sonarqube -o jsonpath='{.spec.host}')
echo "https://$SONARQUBE"
echo "  "

echo "  ## Reports Server - Username/Password: reports/reports ##  "
REPORTS=$(oc get route -n cicd reports-repo -o jsonpath='{.spec.host}')
echo "http://$REPORTS"
echo "  "

echo "  ## ACS/Stackrox Server - Username/Password: admin/stackrox ##  "
ACS=$(oc get route -n stackrox central -o jsonpath='{.spec.host}')
echo "https://$ACS"
echo "  "

echo "  ## ArgoCD Server - Username/Password: admin/[DEX] ##  "
ARGO=$(oc get route -n openshift-gitops openshift-gitops-server -o jsonpath='{.spec.host}')
echo "https://$ARGO"
echo "  "
