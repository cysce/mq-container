ns=default
while [ $# -gt 0 ]; do
  case "$1" in
    --base=*)
      base="${1#*=}"
      ;;
    --ns=*)
      ns="${1#*=}"
      prefix=${ns}-
      ;;
    --host=*)
      host="${1#*=}"
      ;;
    --domain=*)
      domain="${1#*=}"
      ;;
    *)
      printf "***************************\n"
      printf "* Error: Invalid argument $1 .*\n"
      printf "***************************\n"
      exit 1
  esac
  shift
done

printf "***************************\n"
printf "*        PARAMETERS INGRESS ui-games.      *\n"
printf "* base=$base *\n"
printf "* host=$host *\n"
printf "* domain=$domain *\n"
printf "* ns=$ns *\n"
printf "***************************\n"

if [[ $base == '' ]]
then
    printf "*******************************************************************************\n"
    printf "* Error: Invalid argument {base}. --base=/Volumes/DATA/FUTBOL/LA10 \n"
    printf "*******************************************************************************\n"
    exit 1
fi

if [[ $host == '' ]]
then
    printf "*******************************************************************************\n"
    printf "* Error: Invalid argument {base}. missing --host=la10 \n"
    printf "*******************************************************************************\n"
    exit 1
fi

if [[ $domain == '' ]]
then
    printf "*******************************************************************************\n"
    printf "* Error: Invalid argument {base}. missing --domain=villamil.live \n"
    printf "*******************************************************************************\n"
    exit 1
fi


echo 'apiVersion: networking.k8s.io/v1beta1
kind: Ingress
metadata:
  annotations:
    ingress.kubernetes.io/proxy-body-size: "0"
    nginx.ingress.kubernetes.io/proxy-body-size: "0"
    ingress.kubernetes.io/ssl-redirect: "true"
    nginx.ingress.kubernetes.io/force-ssl-redirect: "true"
    nginx.ingress.kubernetes.io/ssl-redirect: "true"
    kubernetes.io/ingress.class: nginx
  name: ibm-mq
spec:
  tls:' > ${base}/temp/ingress.yaml
  

## declare an array variable
##declare -a arr=("cocadmin" "metrodemedellin")

IFS=', ' read -r -a array <<< "$host"

## now loop through the above array
for i in "${array[@]}"
do
   echo "  - hosts:
    - $i.$domain
    secretName: $i-secret" >> ${base}/temp/ingress.yaml
done

echo "  rules:" >> ${base}/temp/ingress.yaml

for i in "${array[@]}"
do
   echo "  - host: $i.$domain
    http:
      paths:
      - path: /
        backend:
          serviceName: ibm-mq
          servicePort: 9443" >> ${base}/temp/ingress.yaml
done

# You can access them using echo "${arr[0]}", "${arr[1]}" also

kubectl -n ${ns} apply -f ${base}/temp/ingress.yaml