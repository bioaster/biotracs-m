# BioTracs

This is the core BioTracs frameworks for MATLAB users.

Visit the official BioTracs Website at https://bioaster.github.io/biotracs/

![BioTracs framework](https://bioaster.github.io/biotracs/static/img/biotracs-framework.png)

# Learn more about the BioTracs project

To learn more about the BioTracs project, please refers to https://github.com/bioaster/biotracs

# Usage

Please refer to the documentation at https://bioaster.github.io/biotracs/documentation


```matlab
%file main.m
%-----------------------------------------
addpath('/path/to/autoload.m')

%% load the biotracs framework
%pkgdir: the directory with the all biotracs git repo are downloaded
autoload( ...
	'PkgPaths', {'/path/to/pkgdir'}, ...
	'Dependencies', {...
		'biotracs-m-atlas', ...
	}, ...
	'Variables',  struct(...
	) ...
);
	
%% perform PCA analysis
dataSet = biotracs.data.model.DataSet.import('/path/to/dataset.csv');
pca = biotracs.atlas.model.PCALearner();
pca.setInputPortData('DataSet', dataSet);

%three principal components; center-scale data (unit-variate normalization)
pca.getConfig()...
	.updateParamValue('NbComponents', 3)...
	.updateParamValue('Center', true)...
	.updateParamValue('Scale', 'uv');

%% run
pca.run();
result = process.getOutputPortData('result');
result.view('ScorePlot');

%display score matrix
result.get('XScores').summary()
```

# License

BIOASTER license https://github.com/bioaster/biotracs/blob/master/LICENSE