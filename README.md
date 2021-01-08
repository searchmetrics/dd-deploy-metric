# dd-deploy-metric
Script to send deploy metric to Datadog
## How to use the script in your CI/CD pipeline
To use the script in your repository you will need to configure environment variables and add the script lines to your CI configuration.

### Travis CI/CD configuration 

#### Configure environment variables
First configure the variables DD_CLIENT_API_KEY, SERVICE, PROJECT AND BU. 
> SERVICE, PROJECT AND BU, should be in lowercase. The BU value should be stansdarized and can be confirmed with the PI team. 

To add the variables use the following methods:

You can follow the documentation to add variables using the repository settingsL
https://docs.travis-ci.com/user/environment-variables/#defining-variables-in-repository-settings

#### Execute the script
To execute the script, you can use git clone followed by bash dd-deploy-metric/dd-deploy-metric.sh command.

In travis we can add the following a after_script to be executed. It will run after every deploy (or script if you don't have deploy section) stages and only if success:
```YAML
after_script:
    - git clone https://github.com/searchmetrics/dd-deploy-metric.git && bash dd-deploy-metric/dd-deploy-metric.sh
```
In case you want to ensure this step only runs on specific branch, like main, you can use the following test:
```YAML
after_script:
    - if [ "$TRAVIS_BRANCH" = "main" ] && [ "$TRAVIS_PULL_REQUEST" = "false" ]; then git clone https://github.com/searchmetrics/dd-deploy-metric.git ; bash dd-deploy-metric/dd-deploy-metric.sh; fi
```
> By checking TRAVIS_PULL_REQUEST equals false avoids execution on PRs as Travis sets TRAVIS_BRANCH to the target branch on PRs.

If you use Jobs stages, you need to set it as the last stage, otherwise it will run for every stage of your pipeline:
```YAML
jobs:
  include:
    - stage: Build
      script: echo building...
    - stage: Deploy
      script: echo deploying...
    - stage: Send Deploy metrics
      if: (NOT type IN (pull_request)) AND (branch = master)
      script:
      - git clone https://github.com/searchmetrics/dd-deploy-metric.git
      - bash dd-deploy-metric/dd-deploy-metric.sh
```

Another option is to checkout an specific branch or tag:
```YAML
after_script:
    - git clone --branch v0.1 https://github.com/searchmetrics/dd-deploy-metric.git && bash dd-deploy-metric/dd-deploy-metric.sh
```

You will find complete examples in the [simple-cicd-configuration.yml](simple-cicd-configuration.yml) and [jobs-cicd-configuration.yml](jobs-cicd-configuration.yml).

### GitHub Actions CI/CD configuration

#### Check environment variables
Ensure that the global secret environment variable *DD_CLIENT_API_KEY* is defined in the repository [howto](https://docs.github.com/en/free-pro-team@latest/actions/reference/encrypted-secrets) 
Add additional step to the CI/CD workflow configuration (with the proper environment variables PROJECT, SERVICE, BU values )

#### Add execution script to the workflow

Add the last step tp your build
```YAML
      - name: Report deployment to the Datadog
        env:
          DD_CLIENT_API_KEY: ${{ secrets.DD_CLIENT_API_KEY }}
          SERVICE: <SERVICE NAME>
          PROJECT: <PROJECT NAME>
          BU: <BUSINESS UNIT>
        if: ${{ success() }}
        run: git clone https://github.com/searchmetrics/dd-deploy-metric.git && bash dd-deploy-metric/dd-deploy-metric.sh
```
Ensure that the script is executed only after a deployment is done to the production.
To check the branch you can add additional condition eg:
```YAML
 if: ${{ success() }} && github.ref == 'refs/heads/master' 
```

You will find complete examples in the [github-action-cicd-example.yml](github-action-cicd-example.yml)
