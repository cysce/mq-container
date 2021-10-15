ns=default
while [ $# -gt 0 ]; do
  case "$1" in
    --ns=*)
      ns="${1#*=}"
      ;;
    *)
      printf "***************************\n"
      printf "* Error: Invalid argument $1 .*\n"
      printf "***************************\n"
      exit 1
  esac
  shift
done


kubectl -n ${ns} delete ingress ibm-mq
kubectl -n ${ns} delete service ibm-mq
kubectl -n ${ns} delete deployment ibm-mq
kubectl -n ${ns} delete pvc ibm-mq
kubectl -n ${ns} delete pv ibm-mq
kubectl -n ${ns} delete secret ibm-mq