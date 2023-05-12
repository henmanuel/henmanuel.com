echo "Enter domain app: "
read APPName

if [ -z "$APPName" ]
then
      echo "Domain app is required"
      exit 1
fi

echo "Enter the name of environment: Default -> dev"
read Environment

Dot="."
Hyphen="-"

if [[ $Environment == "dev" ]]; then
  echo "The option chosen is dev"
elif [[ $Environment == "qa" ]]; then
  echo "The option chosen is qa"
elif [[ $Environment == "prod" ]]; then
  echo "The option chosen is prod"
  Environment=""
  Hyphen=""
  Dot=""
else
  echo "The option chosen is not valid, the default option is dev"
  Environment="dev"
fi

echo "Enter the name of the region: Default -> us-east-1"
read Region

if [ -z "$Region" ]
then
      Region="us-east-1"
fi

StackName=${APPName/./-}
TemplateName=${APPName}.template
BucketName=${Environment}${Dot}${APPName}-deploy
DeploymentBucketName=${Environment}${Dot}${APPName}-deploy

brew install awscli
aws s3api create-bucket --bucket "$BucketName" --region us-east-1
sam deploy -t "$TemplateName" --stack-name "${Environment}${Hyphen}${StackName}" --s3-bucket "$DeploymentBucketName" --region $Region --capabilities CAPABILITY_IAM CAPABILITY_AUTO_EXPAND CAPABILITY_NAMED_IAM --parameter-overrides AppName="$APPName" Environment="$Environment" Region="$Region"
aws s3 sync ../../src s3://"${Environment}${Dot}${APPName}"
