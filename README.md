# pd_devops_bootstrap

This cookbook uses a lot of source code from the Nordstrom ChefDK_Bootstrap cookbook which can be found [here.](https://github.com/Nordstrom/chefdk_bootstrap)

As per the Nordstrom cookbook please make sure to have Powershell 4.0 or greater if you are a Windows user and regardless of system please make sure that your proxy settings are correct.

One of the key ways that this cookbook differs from the Nordstrom cookbook is that you can select what you would like to install. The simplest way to facilitate this is through the angular app [here.](https://github.bedbath.com/pipedream/pd_devops_bootstrap_site)

If you would like to bypass using the app then you must export the recipes you would like run to an environment variable GE_DEVOPS_BOOTSTRAP_SELECTIONS.

```
Unix example:
export pd_devops_bootstrap_SELECTIONS=pd_devops_bootstrap::chrome,pd_devops_bootstrap::iterm2
```

```
Windows example:
$env:GeDevopsBootstrapSelections = "pd_devops_bootstrap::chrome,pd_devops_bootstrap::iterm2"
```

Then download the appropriate bootstrap script and execute it.

######Notes:
Ubuntu, Centos, and Rhel are currently under development.
