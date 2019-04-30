# Biotracs project

The biotracs project is an effort for standardizing bioinformatics workflows implementations. 
Biotracs framework is based on the PRISM (Process-Resource Interfacing SysteM) architecture. It provides a library that allows to model computational workflows and ensure process traceability. 
It allows expert developpers and non-expert users to implements, use and share their analyses while ensuring traceability in their computational processes.
Initiated at BIOASTER, the biotracs project is today open to the community in order to bring this architecture to the whole bioformatics community. 

To contribute to the project, please refer to following rules. Thanks :-).

## Coding conventions

Coding conventions are best coding practices that developer must follow to share their work. As biotracs is based on the PRISM (Process-Resource Interfacing SysteM) architecture, it is not language specific.
It can therefore implemented in any language. Each language-specific inmplementation of biotracs must adopt language-specific coding conventions.

### Matlab coding conventions

### Python coding conventions

## Git versionning rules

This section describes the practices rules to fork and version biotracs applications. It is based on standard practices as explained at https://nvie.com/posts/a-successful-git-branching-model/

Please also refer to https://nvie.com/posts/a-successful-git-branching-model/


### Branch structures

  * master branch
    * master-{tag_number}
    * master-{tag_number}
    * ...
    *  master-{tag_number}
   
  * develop branch
    * feature-{branch_name}
    * feature-{branch_name}
    * ...
    * feature-{branch_name}
   
  * release branch
    * release-{tag_number}
    * release-{tag_number}
    * ...
    * release-{tag_number}

  * hotfix branch
    * fix-{tag_number}
    * fix-{tag_number}
    * ...
    * fix-{tag_number}
   

### Git naming coventions

All the above-presneted branch, feature and htofix names must used as naming convention

 * master tags must be numbered according to the current release, eg.: `master-1.0` is related to the `release-1.0`
 * feature branches must be named unanbigously and concisely, e.g. `feature-create_app_controller`, `feature-filtering_data`
 * realase tags must be numbered, eg.: `release-1.0` or `release-2019a`
 * hotfix tags must be numbered, eg: `fix-1.2`, `fix-1.2.1`

 
### Versioning convention

Versionning convention is only for releases, htofixes, master tags (e.g. `master-1.2.1a`, `hotfix-1.2`)

* numbering: `marjor[.minor-level-1[.minor-level-2[.letter]]]`
   * required: `major` is the number of the major relase/hotfix
   * optional: `minor-level-1` is the level-1 number of the minor release/hotfix
   * optional: `minor-level-2` is the level-2 number of the minor release/hotfix
   * optional: `letter` must be a or b (i.e. a for alpha, b for beta)

* numbering with year: `yyyy`.`letter`
    * `yyyy` is the year
    * `letter` must be a, b (i.e. a for alpha, b for beta)
   

### Why?


Master branch 
-------------

No development is allowed on the master branch. 
This branch is not shared with external users (the release branch is devoted for that purpose).

 
Develop branch
--------------

Only for development. 
Features branches are used to develop new features. After a feature development is completed, it is merged back with the develop branch.
Feature branches are nether merged with the release branch
 
 
Release branch
--------------

The release branch is created from the develop branch. It is only used to share the code with external users in production mode.
The project only used codes in the realase branch at a well-defined given tag
 
 * No development is allowed on this branch.
 * Only pull operation is allowed
 * No push operation is allowed

 
Hotfix branch
-------------

Only used to fix particular bugs in the master branch.
Htofixes are propagated to the develop branch and then to the release branch
 
 
Enjoy!