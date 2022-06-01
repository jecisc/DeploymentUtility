# Deployment Utility

I am a project providing a facade to help deploy pharo projects

- [Installation](#installation)
- [Documentation](#documentation)
- [Version management](#version-management)
- [Smalltalk versions compatibility](#smalltalk-versions-compatibility)
- [Contact](#contact)

## Installation

To install the project in your Pharo image execute:

```Smalltalk
    Metacello new
    	githubUser: 'jecisc' project: 'DeploymentUtility' commitish: 'v1.x.x' path: 'src';
    	baseline: 'DeploymentUtility';
    	load
```

To add it to your baseline:

```Smalltalk
    spec
    	baseline: 'DeploymentUtility'
    	with: [ spec repository: 'github://jecisc/DeploymentUtility:v1.x.x/src' ]
```

Note that you can replace the #v1.x.x by another branch such as #development or a tag such as #v1.0.0, #v1.? or #v1.1.?.


## Documentation

This project aim to implement all the deployment utilities explained in the [Pharo Wiki](https://github.com/pharo-open-documentation/pharo-wiki/blob/master/General/DeployYourPharoApplication.md).

Check the class side of DUFacade for more information.


## Version management 

This project use semantic versioning to define the releases. This means that each stable release of the project will be assigned a version number of the form `vX.Y.Z`. 

- **X** defines the major version number
- **Y** defines the minor version number 
- **Z** defines the patch version number

When a release contains only bug fixes, the patch number increases. When the release contains new features that are backward compatible, the minor version increases. When the release contains breaking changes, the major version increases. 

Thus, it should be safe to depend on a fixed major version and moving minor version of this project.

## Smalltalk versions compatibility

| Version 	| Compatible Pharo versions 		|
|-------------	|---------------------------	|
| 1.x.x       	| Pharo 70, 80, 90, 10				|

## Contact

If you have any questions or problems do not hesitate to open an issue or contact cyril (a) ferlicot.me 
