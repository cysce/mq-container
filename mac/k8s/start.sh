#!/bin/bash
ns=default
while [ $# -gt 0 ]; do
  case "$1" in
     --dev*)
      env=dev
      ;;
    --install*)
      env=install
      ;;
    --juancho*)
      basei=/Volumes/DATA/CYSCE/BROKER
      host=mq
      domain=cysce.com
      ;;
    --base=*)
      basei="${1#*=}"
      ;;
    --host=*)
      host="${1#*=}"
      ;;
    --domain=*)
      domain="${1#*=}"
      ;;
    --mailpass=*)
      mailpass="${1#*=}"
      ;;
    --ns=*)
      ns="${1#*=}"
      ;;
    --mail=*)
      mail="${1#*=}"
      ;;
    *)
      printf "***************************\n"
      printf "* Error: Invalid argument $1 .*\n"
      printf "***************************\n"
      exit 1
  esac
  shift
done

if [[ $env == '' ]]
then
    printf "*******************************************************************************\n"
    printf "* Error: Invalid argument. missing --insntall or --dev or --test or --prd  \n"
    printf "*******************************************************************************\n"
    exit 1
fi

if [[ $basei == '' ]]
then
    printf "*******************************************************************************\n"
    printf "* Error: Invalid argument. missing --base=/Volumes/DATA/FUTBOL/LA10 \n"
    printf "*******************************************************************************\n"
    exit 1
fi

if [[ $host == '' ]]
then
    printf "*******************************************************************************\n"
    printf "* Error: Invalid argument. missing --host=la10 \n"
    printf "*******************************************************************************\n"
    exit 1
fi

if [[ $domain == '' ]]
then
    printf "*******************************************************************************\n"
    printf "* Error: Invalid argument. missing --domain=villamil.live \n"
    printf "*******************************************************************************\n"
    exit 1
fi


printf "***************************\n"
printf "*        PARAMETERS ibm-mq.      *\n"
printf "* ns=$ns *\n"
printf "* env=$env *\n"
printf "* base=$basei *\n"
printf "* host=$host *\n"
printf "* domain=$domain *\n"
printf "***************************\n"

base=${basei}/mq-container/mac

rm -rf ${base}/temp
mkdir ${base}/temp
cat ${base}/k8s/${env}/deployment.template | sed "s#<HOST>#$host.$domain#g" > ${base}/temp/deployment01.template
cat ${base}/temp/deployment01.template | sed "s#<PATH>#$basei#g" > ${base}/temp/deployment02.template

cp ${base}/temp/deployment02.template ${base}/temp/deployment.yaml


kubectl -n ${ns} apply -f ${base}/temp/deployment.yaml

${base}/k8s/ingress.sh --ns=${ns} --base=${base} --host=$host --domain=$domain
