#!/bin/bash

versionString=$(grep -E 'spec.version.*=' TXQuestionManager.podspec)
versionNumber=$(tr -cd [^0-9.] <<<"$versionString")
version=$(echo "$versionNumber" | sed 's/^\.//')

echo 'versionString'=$versionString
echo 'versionNumber'=$versionNumber
echo 'version'=$version

git add .
git commit -m $version
git push origin main
git tag $version
git push origin main --tags

# pod spec lint ./TXQuestionManager.podspec --verbose --allow-warnings
pod trunk push ./TXQuestionManager.podspec --verbose --use-libraries --allow-warnings
