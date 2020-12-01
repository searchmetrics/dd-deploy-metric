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

In travis we can add the following line to be executed right after the deployment step/script:
```yaml
deploy:
  - skip_cleanup: true
    provider: script
    script:
    - bash deploy.sh
    - git clone https://github.com/searchmetrics/dd-deploy-metric.git && bash dd-deploy-metric/dd-deploy-metric.sh
```
In case you want to ensure this step only runs on specific branch, like main, you can use the following test:
```yaml
deploy:
  - skip_cleanup: true
    provider: script
    script:
    - bash deploy.sh
    - if [ "$TRAVIS_BRANCH" = "main" ] && [ "$TRAVIS_PULL_REQUEST" = "false" ]; then git clone https://github.com/searchmetrics/dd-deploy-metric.git ; bash dd-deploy-metric/dd-deploy-metric.sh; fi
```
> By checking TRAVIS_PULL_REQUEST equals false avoids execution on PRs as Travis sets TRAVIS_BRANCH to the target branch on PRs.

Another option is to checkout an specific branch or tag:
```yaml
deploy:
  - skip_cleanup: true
    provider: script
    script:
    - bash deploy.sh
    - git clone --branch v0.1 https://github.com/searchmetrics/dd-deploy-metric.git && bash dd-deploy-metric/dd-deploy-metric.sh
```
