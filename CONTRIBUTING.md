# How to contribute?

To contribute to the core project or to biotracs applications, please refer to following rules. Thanks :-).

## Coding conventions

Coding conventions are good coding practices that developers must follow to share their works. As biotracs is based on the PRISM (Process-Resource Interfacing SysteM) architecture, it is not language specific.
It can therefore be implemented in any other language. Each language-specific inmplementation of biotracs must therefore adopt language-specific coding conventions.


Above all language-specific conventions, the developer is *strongly* invited to carefully read the book *Clean Code: A Handbook of Agile Software Craftsmanship* of Robert C. Martin to adopt professional software development attitudes.
* https://fr.wikipedia.org/wiki/Robert_C._Martin
* https://www.pdfdrive.com/clean-code-e38664751.html 
* https://www.investigatii.md/uploads/resurse/Clean_Code.pdf

Other readings related to agile test-driven and behavior-driven developpments (TDD/BDD):
* https://en.wikipedia.org/wiki/Test-driven_development


These coding conventions are fundamental to capture the state-of-mind behind PRISM and biotracs-related implementations.

### Matlab coding conventions

The minimal structure a Matlab biotracs application is:

* `+biotracs/`
  Contains the matlab library
* `assets/`
  Contains web library (css, js, ...). This folder is automatically copied in the view directories when HTML views are generated
* `backcomp/`
  Contains backward compatibility files (e.g. R2017a, R2017b, ...). This folder is automatically detected and loaded depending on the current version of Matlab. Please add here required .m files or packages if you use an unsupported version of Matlab.
* `externs/`
  Contains extern library on which the module depends. This folder is automatically detected and loaded.
* `tests/`
  Contains unit testing scripts
* `package.json`
  Contains the metadata of the package (i.e. application). Please see below. 
  The minimal informations are the dependencies. Recommended supplementary information are the name, version and description of the package.
* `CHANGELOG`
* `CONTRIBUTING.md`
* `DESCRIPTION.md`
* `LICENSE`
* `README.md`

The official coding convention adopted is the same as adoped by Mathworks (R). Please refers

### Python coding conventions

The minimal structure a Python biotracs application is:

* `biotracs/`
  The biotracs python module
* `assets/`
  Contains web library (css, js, ...). This folder is automatically copied in the view directories when HTML views are generated
* `backcomp/`
  Contains backward compatibility files (e.g. 3.5, 3.4) automatically detected and loaded depending on the current version of Python. Please add here required .py files or modules if you use an unsupported version of Python.
* `externs/`
  Contains extern library on which the module depends. This folder is automatically detected and loaded.
* `tests/`
  Contains unit testing scripts
* `package.json`
  Contains the metadata of the package (i.e. application). Please see below. 
  The minimal informations are the dependencies. Recommended supplementary information are the name, version and description of the package.
* `CHANGELOG`
* `CONTRIBUTING.md`
* `DESCRIPTION.md`
* `LICENSE`
* `README.md`

### File package.json

The package.json file describes the *direct* biotracs dependencies of the current package. 
When loading a package, its `package.json` file is automatically parsed and all its dependencies are also loaded. 

For example, consider a biotracs application (called `biotracs-m-app-red`) with the following `package.json` file:


```json
{
	"name"			: "biotracs-m-app-red",
	"description"	: "My red biotracs application",
	"version"		: "0.1",
	"dependencies"	: [
		"biotracs-m-app-blue",
		"biotracs-m-app-green"
	],
}
```

Suppose that for the biotracs application `biotracs-m-app-blue` we have the following `package.json` file;
 
```json
{
	"name"			: "biotracs-m-app-blue",
	"description"	: "My blue biotracs application",
	"version"		: "0.1",
	"dependencies"	: [
		"biotracs-m-app-purple",
		"biotracs-m-app-black"
	],
}
```

Then, the packages `biotracs-m-app1-purple` and `biotracs-m-app-black` will automatically be loaded when loading the package `biotracs-m-app-red`. 
This hierarchical loading of packages simplify the implementation of applications. Indeed, only *direct* depdencies are required. Also, when a dependency is provided several times, it is loaded only once.


## Git versionning rules

This section describes the practices rules to fork and version biotracs applications. It is based on standard practices as explained at https://nvie.com/posts/a-successful-git-branching-model/

Please also refer to https://nvie.com/posts/a-successful-git-branching-model/

### Branch structures

* master branch
    * `master-{tag_number}`
    * `master-{tag_number}`
    * `...`
    * `master-{tag_number}`
* develop branch
    * `feature-{branch_name}`
    * `feature-{branch_name}`
    * `...`
    * `feature-{branch_name}`
* release branch
    * `release-{tag_number}`
    * `release-{tag_number}`
    * `...`
    * `release-{tag_number}`
* hotfix branch
    * `fix-{tag_number}`
    * `fix-{tag_number}`
    * `...`
    * `fix-{tag_number}`
   
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

#### Master branch 

No development is allowed on the master branch. 
This branch is not shared with external users (the release branch is devoted for that purpose).
 
#### Develop branch

Only for development. 
Features branches are used to develop new features. After a feature development is completed, it is merged back with the develop branch.
Feature branches are nether merged with the release branch
 
#### Release branch

The release branch is created from the develop branch. It is only used to share the code with external users in production mode.
The project only used codes in the realase branch at a well-defined given tag
 
* No development is allowed on this branch.
* Only pull operation is allowed
* No push operation is allowed

#### Hotfix branch

Only used to fix particular bugs in the master branch.
Htofixes are propagated to the develop branch and then to the release branch
 
 
Thank you for your contribution :-).