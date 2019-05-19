# BioTracs

This is the core BioTracs frameworks for MATLAB users.

Visit the official BioTracs Website at https://bioaster.github.io/biotracs/

![BioTracs framework](https://bioaster.github.io/biotracs/static/img/biotracs-framework.png)

# Learn more about the BioTracs project

To learn more about the BioTracs project, please refers to https://github.com/bioaster/biotracs

# Usage

Please refer to the documentation at https://bioaster.github.io/biotracs/documentation

* The `autoload.m` file is available in the directory `./tests/`
* When calling `autoload()` function, the argument `PkgPaths` refers to the list directory paths containing all the BioTracs applications. It however is recommended to keep all the applications in the same directory.

```matlab
% file main.m
% This test file uses the Atlas application to 
% perform principal component analysis
%--------------------------------------------------

addpath('/path/to/atoload.m/');
pkgDir = fullfile('/path/to/package/dir/');
autoload( ...
	'PkgPaths', { pkgDir }, ...
	'Dependencies', {...
		'biotracs-m-atlas', ...
	}, ...
	'Variables',  struct(...
	) ...
);
	
% Perform PCA
dataSet = biotracs.data.model.DataSet.import('/path/to/dataset.csv');
pca = biotracs.atlas.model.PCALearner();
pca.setInputPortData('DataSet', dataSet);

%three principal components; center-scale data (unit-variate normalization)
pca.getConfig()...
	.updateParamValue('NbComponents', 3)...
	.updateParamValue('Center', true)...
	.updateParamValue('Scale', 'uv')...
	.updateParamValue('WorkingDir', '/path/to/pca/workingdir');

%% run
pca.run();
result = process.getOutputPortData('result');
result.view('ScorePlot');

%display score matrix
result.get('XScores').summary();
```

# License

BIOASTER license https://github.com/bioaster/biotracs/blob/master/LICENSE