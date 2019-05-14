%"""
%Unit tests for biotracs.dataproc.*
%* Date: 2017
%* Author:  D. A. Ouattara
%* License: BIOASTER License
%
%Omics Hub, Bioinformatics team
%BIOASTER Technology Research Institute (http://www.bioaster.org)
%"""

function testDataproc( cleanAll )
    if nargin == 0 || cleanAll
        clc; close all force;
        restoredefaultpath();
    end
    addpath('../../')
    autoload( ...
        'PkgPaths', {fullfile(pwd, '../../../../')}, ...
        'Dependencies', {...
            'biotracs-m', ...
        }, ...
        'Variables',  struct(...
        ) ...
    );

    %% Tests
    import matlab.unittest.TestSuite;
    Tests = TestSuite.fromFolder('./', 'IncludingSubfolders', true);

%     Tests = TestSuite.fromFile('./model/DataStandardizerTests.m');
%     Tests = TestSuite.fromFile('./model/DataStatsCalculatorTests.m');
%     Tests = TestSuite.fromFile('./model/EffectRemoverTests.m');
%     Tests = TestSuite.fromFile('./model/DataNormalizerTests.m');
%     Tests = TestSuite.fromFile('./model/DataSelectorTests.m');
%     Tests = TestSuite.fromFile('./model/DataFilterTests.m');
%     Tests = TestSuite.fromFile('./model/DataMergerTests.m');
%     Tests = TestSuite.fromFile('./model/ResponseDataCreatorTests.m');
%     Tests = TestSuite.fromFile('./model/SubsamplerTests.m');
%     Tests = TestSuite.fromFile('./model/FeatureGrouperTests.m');
%     Tests = TestSuite.fromFile('./model/VennDiagramTests.m');


    
    Tests.run();
end
