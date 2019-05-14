%"""
%Unit tests for biotracs.data.*
%* Date: 2016
%* Author:  D. A. Ouattara
%* License: BIOASTER License
%
%Omics Hub, Bioinformatics team
%BIOASTER Technology Research Institute (http://www.bioaster.org)
%"""

function testData( cleanAll )
    if nargin == 0 || cleanAll
        clc; close all;
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
    
    %Tests = TestSuite.fromFile('./model/DataObjectTests.m');
    %Tests = TestSuite.fromFile('./model/DataTableTests.m');
    %Tests = TestSuite.fromFile('./model/DataMatrixTests.m');
    %Tests = TestSuite.fromFile('./model/DataSetTests.m');
    %Tests = TestSuite.fromFile('./model/DataFileTests.m');
    %Tests = TestSuite.fromFile('./model/SignalTests.m');
    %Tests = TestSuite.fromFile('./model/SignalSetTests.m');
    %Tests = TestSuite.fromFile('./model/ExtDataTableTests.m');
    %Tests = TestSuite.fromFile('./model/MetaTableTests.m');
    %Tests = TestSuite.fromFile('./helper/GroupStrategyTests.m');

    Tests.run();
end