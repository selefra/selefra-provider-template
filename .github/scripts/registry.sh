#!/usr/bin/env bash

set -e

basepath=$(cd `dirname $0`; pwd)
cd $basepath/
sedi=(-i)
case "$(uname)" in
  # For macOS, use two parameters
  Darwin*) sedi=(-i "")
esac

version=v${1}
time=$(date "+%Y-%m-%d")
if [ -f "provider/REPLACE-ME-TO-YOUR-PROVIDER-NAME/metadata.yaml" ];then
  VERSION=`cat provider/REPLACE-ME-TO-YOUR-PROVIDER-NAME/metadata.yaml | grep 'latest-version' | awk -F ' ' '{print $2}'`
else
  VERSION="REPLACE-ME-TO-YOUR-PROVIDER-NAME"
  mkdir -p provider/REPLACE-ME-TO-YOUR-PROVIDER-NAME
fi
FOR=`cat selefra-provider-REPLACE-ME-TO-YOUR-PROVIDER-NAME* | awk -F '_' '{print $3,$4}' | awk -F '.' '{print $1}' |  sed "s# #_#g"`
if [ -d "provider/REPLACE-ME-TO-YOUR-PROVIDER-NAME/$version" ];then rm -rf provider/REPLACE-ME-TO-YOUR-PROVIDER-NAME/$version ; else echo "OK!"; fi && cp -r provider/template/version1 provider/REPLACE-ME-TO-YOUR-PROVIDER-NAME/$version

for f in $FOR; do
  echo "$f"
  darwin_arm64=`cat selefra-provider-REPLACE-ME-TO-YOUR-PROVIDER-NAME* | grep darwin_arm64 | awk -F ' ' '{print $1}'`
  darwin_amd64=`cat selefra-provider-REPLACE-ME-TO-YOUR-PROVIDER-NAME* | grep darwin_amd64 | awk -F ' ' '{print $1}'`
  windows_amd64=`cat selefra-provider-REPLACE-ME-TO-YOUR-PROVIDER-NAME* | grep windows_amd64 | awk -F ' ' '{print $1}'`
  linux_amd64=`cat selefra-provider-REPLACE-ME-TO-YOUR-PROVIDER-NAME* | grep linux_amd64 | awk -F ' ' '{print $1}'`
  linux_arm64=`cat selefra-provider-REPLACE-ME-TO-YOUR-PROVIDER-NAME* | grep linux_arm64 | awk -F ' ' '{print $1}'`
  windows_arm64=`cat selefra-provider-REPLACE-ME-TO-YOUR-PROVIDER-NAME* | grep windows_arm64 | awk -F ' ' '{print $1}'`
  sed "${sedi[@]}" "s#{{.PackageName}}#selefra-provider-REPLACE-ME-TO-YOUR-PROVIDER-NAME#g" provider/REPLACE-ME-TO-YOUR-PROVIDER-NAME/$version/supplement.yaml
  sed "${sedi[@]}" "s#{{.Source}}#https://github.com/selefra/selefra-provider-REPLACE-ME-TO-YOUR-PROVIDER-NAME#g" provider/REPLACE-ME-TO-YOUR-PROVIDER-NAME/$version/supplement.yaml
  sed "${sedi[@]}" "s#{{.CheckSumLinuxARM64}}#${linux_arm64}#g" provider/REPLACE-ME-TO-YOUR-PROVIDER-NAME/$version/supplement.yaml
  sed "${sedi[@]}" "s#{{.CheckSumLinuxAMD64}}#${linux_amd64}#g" provider/REPLACE-ME-TO-YOUR-PROVIDER-NAME/$version/supplement.yaml
  sed "${sedi[@]}" "s#{{.CheckSumWindowsARM64}}#${windows_arm64}#g" provider/REPLACE-ME-TO-YOUR-PROVIDER-NAME/$version/supplement.yaml
  sed "${sedi[@]}" "s#{{.CheckSumWindowsAMD64}}#${windows_amd64}#g" provider/REPLACE-ME-TO-YOUR-PROVIDER-NAME/$version/supplement.yaml
  sed "${sedi[@]}" "s#{{.CheckSumDarwinARM64}}#${darwin_arm64}#g" provider/REPLACE-ME-TO-YOUR-PROVIDER-NAME/$version/supplement.yaml
  sed "${sedi[@]}" "s#{{.CheckSumDarwinAMD64}}#${darwin_amd64}#g" provider/REPLACE-ME-TO-YOUR-PROVIDER-NAME/$version/supplement.yaml
done

if [[ "$VERSION" != "$version" ]]; then
  cp provider/template/metadata.yaml provider/template/metadata.yaml.bak
  sed "${sedi[@]}" "s#{{.ProviderName}}#REPLACE-ME-TO-YOUR-PROVIDER-NAME#g" provider/template/metadata.yaml
  sed "${sedi[@]}" "s#{{.LatestVersion}}#${version}#g" provider/template/metadata.yaml
  sed "${sedi[@]}" "s#{{.LatestUpdated}}#${time}#g" provider/template/metadata.yaml
  sed "${sedi[@]}" "s#{{.Introduction}}#A Selefra provider for REPLACE-ME-TO-YOUR-PROVIDER-NAME .#g" provider/template/metadata.yaml
  sed "${sedi[@]}" "s#{{.ProviderVersion}}#${version}#g" provider/template/metadata.yaml
  sed "${sedi[@]}" '6d' provider/template/metadata.yaml
  if [ -f "provider/REPLACE-ME-TO-YOUR-PROVIDER-NAME/metadata.yaml" ];then
    sed -n '/^ /p' provider/REPLACE-ME-TO-YOUR-PROVIDER-NAME/metadata.yaml >> provider/template/metadata.yaml
  fi
  echo "  - ${version}" >> provider/template/metadata.yaml
  cat provider/template/metadata.yaml > provider/REPLACE-ME-TO-YOUR-PROVIDER-NAME/metadata.yaml
  mv provider/template/metadata.yaml.bak provider/template/metadata.yaml
fi
