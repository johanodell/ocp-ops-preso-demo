#!/usr/bin/env bash

#################################
# include the -=magic=-
# you can pass command line args
#
# example:
# to disable simulated typing
# . ../demo-magic.sh -d
#
# pass -h to see all options
#################################
. ./utils/demo-magic.sh
DEMO_PROMPT="${GREEN}➜${CYAN}[openshift]$ ${COLOR_RESET}"
TYPE_SPEED=20
USE_CLICKER=true

# Define colors
BLUE='\033[38;2;102;204;255m' #'\033[38;5;153m' #'\033[0;34m'
GREEN='\033[38;5;41m' #'\033[0;32m'
YELLOW='\033[0;33m'
RESET='\033[0m'

# ------------------------------------
# 1.  SUPPRESS DEPRECATION WARNINGS
# ------------------------------------
oc() {                          # wrapper
    command oc "$@" 2>&1 | sed '/^Warning:/d'
    return ${PIPESTATUS[0]}     # preserve oc’s exit status
}
export -f oc                    # if demo-magic forks subshells

# Function to print lines with color based on their content
print_colored_output() {
    while IFS= read -r line; do
        if [[ $line == skipping:* || $line == included:* ]]; then
            echo -e "${BLUE}${line}${RESET}"
        elif [[ $line == ok:* ]]; then
            echo -e "${GREEN}${line}${RESET}"
        elif [[ $line == changed:* ]]; then
            echo -e "${YELLOW}${line}${RESET}"
        else
            echo "$line"
        fi
    done
}

# Hide the evidence
clear

# Enter the ansible directory
wait
figlet -f starwars -S "demo"| lolcat -a -s 100
wait
redhatsay "Lets deploy the homer microservice in openshift"
wait
pei "tree manifests/simpson"
echo -e "\n"
wait
pei "highlight manifests/simpson/0.simpson-namespace.yaml"
echo -e "\n"
wait
pei "oc apply -f manifests/simpson/0.simpson-namespace.yaml -f manifests/simpson/1.rbac-simpsson.yaml"
echo -e "\n"
wait
echo "As noted i also applied RBAC rules for the namespace. They loook like this" | lolcat
viu images/2.simpson-rbac.png
wait
pei "oc project simpson"
echo -e "\n"
wait
pei "oc get all"
echo -e "\n"
wait
echo "So, now we have an empty namespace, now we can look at the rest" | lolcat
echo -e "\n"
wait
clear
wait
echo "This is waht we will create" | lolcat
viu images/1.homer-ms.png
wait
pei "tree manifests/simpson"
echo -e "\n"
wait
pei "highlight manifests/simpson/3.homer-deployment.yaml"
echo -e "\n"
wait
pei "oc apply -f manifests/simpson/2.homer-configmap.yaml -f manifests/simpson/3.homer-deployment.yaml"
echo -e "\n"
wait
redhatsay "lets see what we got now"
echo -e "\n"
wait
pei "oc get all" 
echo -e "\n"
wait
redhatsay -v "Now when the pod is running, lets deploy the service" 
echo -e "\n"
wait
pei "oc apply -f manifests/simpson/4.homer-service.yaml"
echo -e "\n"
wait
redhatsay "Lets look at this service" 
echo -e "\n"
wait
pei "oc get svc" 
echo -e "\n"
wait
pei "oc describe svc homer-service" 
echo -e "\n"
wait
redhatsay -v "Lets looks at the mechanism of scaling pods and how that works 
with the service" | lolcat
echo -e "\n"
wait
pei "oc scale deployment homer-deployment --replicas=3 -n simpson"
echo -e "\n"
wait
pei "oc get pods"
echo -e "\n"
pei "oc get replicaset"
echo -e "\n"
wait
pei "oc describe svc homer-service"
echo -e "\n"
wait
redhatsay -v "Now we will expose this service outside the cluster by creating a route"
echo -e "\n"
wait
pei "oc apply -f manifests/simpson/5.homer-route.yaml"
echo -e "\n"
wait
pei "oc get route"
echo -e "\n"
wait
echo "lets curl that route" | lolcat
echo -e "\n"
wait
pei "curl -k https://homer-route-simpson.apps.mothershift.codell.io"
echo -e "\n"
wait 
clear
redhatsay "Before we move on i will scale down homer to one pod and
deply the Marge microservice to prepare for upcoming things" 
wait
pei "oc apply -f manifests/simpson/6.marge-consolidated.yaml"
echo -e "\n"
pei "oc scale deployment homer-deployment --replicas=1 -n simpson"
echo -e "\n"
wait
clear
wait
redhatsay -v "Now we will look at some NetworkPolicy 
functionality" | lolcat 
echo -e "\n"
wait
pei "oc apply -f manifests/bouvier/bouvier-namespace.yaml"
echo -e "\n"
wait
pei "oc apply -f manifests/bouvier/"
echo -e "\n"
wait
redhatsay -v "Lets check network connectivity between our apps and projects" | lolcat 
echo -e "\n"
wait
./run-checks.sh
redhatsay -v "As you can see default there is 
no NetworkPolicies applied and traffic is allowed" | lolcat 
echo -e "\n"
wait
redhatsay -v "now lets apply some policies that makes Homer 
persona non grata in Bouviers house" | lolcat 
echo -e "\n"
wait
pei "oc apply -f manifests/netpol/simpson-netpols.yaml -f manifests/netpol/bouvier-netpols.yaml"
echo -e "\n"
wait
redhatsay -v "now lets do the connectivity tests again" | lolcat 
echo -e "\n"
wait
./run-checks.sh
wait
clear
figlet -f starwars -S "end of demo"| lolcat -a -s 100