[![wercker status](https://app.wercker.com/status/ff788e3e0eb4b14e7c3363fb0f64789e/m/master "wercker status")](https://app.wercker.com/project/bykey/ff788e3e0eb4b14e7c3363fb0f64789e)

## step-wait-for-build

This steps will poll the wercker API until a dependent project isnt building anymore.
If this build and your dependent build are both in the process of being built, this step will wait for the dependent build to finish.

You will need to create a personal API access token for wercker

Example:

    build:
      steps:
        - nhumrich/wait-for-build:
            application: NAME_OF_APP
            owner: NAME_OF_APP_OWNER
            token: WERCKER_API_TOKEN

if this was to be used on nhumrich/blog you would use:


    build:
      steps:
        - nhumrich/wait-for-build:
            application: blog
            owner: nhumrich
            token: WERCKER_API_TOKEN



