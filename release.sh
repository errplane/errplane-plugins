#!/usr/bin/env bash

if ! which aws > /dev/null 2>&1; then
    echo "Please install awscli see https://github.com/aws/aws-cli for more details"
    exit 1
fi

if [ $# -eq 0 ]; then
    current_vesion=`git tag | sort -V | tail -n1`
    version=${current_vesion#v}
    version=`echo $version | awk 'BEGIN {FS="."}; {print $1 "." ++$2}'`
else
    version=$1
fi

git tag v$version
git push origin --tags
filename=plugins.$version.tar.gz
git archive HEAD -o $filename
AWS_CONFIG_FILE=~/aws.conf aws s3 put-object --bucket errplane-agent --key $filename --body $filename --acl public-read
rm $filename
