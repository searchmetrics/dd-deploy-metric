# dd-deploy-metric
Script to send deploy metric to Datadog
## How to use the script in your CI/CD pipeline
To use the script in your repository you will need to configure environment variables and add the script lines to your CI configuration.
### Configure environment variables
First configure the variables DD_CLIENT_API_KEY, SERVICE, PROJECT AND BU. You can do this using the following methods:

**Travis CI**

You can follow the documentation to add variables using the repository settingsL
https://docs.travis-ci.com/user/environment-variables/#defining-variables-in-repository-settings

### Execute the script
To execute the script, you can use git clone followed by bash dd-deploy-metric/dd-deploy-metric.sh command.

**Travis CI**

In travis we can add the following a after_script to be executed. It will run after every deploy (or script if you don't have deploy section) stages and only if success:
```yaml
after_script:
    - git clone https://github.com/searchmetrics/dd-deploy-metric.git && bash dd-deploy-metric/dd-deploy-metric.sh
```
In case you want to ensure this step only runs on specific branch, like main, you can use the following test:
```yaml
after_script:
    - if [ "$TRAVIS_BRANCH" = "main" ] && [ "$TRAVIS_PULL_REQUEST" = "false" ]; then git clone https://github.com/searchmetrics/dd-deploy-metric.git ; bash dd-deploy-metric/dd-deploy-metric.sh; fi
```
> By checking TRAVIS_PULL_REQUEST equals false avoids execution on PRs as Travis sets TRAVIS_BRANCH to the target branch on PRs.

If you use Jobs stages, you need to set it as the last stage, otherwise it will run for every stage of your pipeline:
```yaml
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
```yaml
after_script:
    - git clone --branch v0.1 https://github.com/searchmetrics/dd-deploy-metric.git && bash dd-deploy-metric/dd-deploy-metric.sh
```

You will find complete examples in the (simple-cicd-configuration.yml) and (jobs-cicd-configuration.yml).
