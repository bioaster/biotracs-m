%"""
%Unit testing for biotracs.core.mvc.*
%* Date: 2015
%* Author:  D. A. Ouattara
%* License: BIOASTER License
%
%Omics Hub, Bioinformatics team
%BIOASTER Technology Research Institute (http://www.bioaster.org)
%"""

function testMvc( cleanAll )
    if nargin == 0 || cleanAll
        clc; close all force;
        restoredefaultpath();
    end
    addpath('../../../')
    autoload( ...
        'PkgPaths', {fullfile(pwd, '../../../../../')}, ...
        'Dependencies', {...
            'biotracs-m', ...
        }, ...
        'Variables',  struct(...
        ) ...
    );

    %% Tests
    import matlab.unittest.TestSuite;
    Tests = TestSuite.fromFolder('./', 'IncludingSubfolders', true);
    %Tests = TestSuite.fromFile('./model/ProcessTests.m');
    %Tests = TestSuite.fromFile('./model/WorkflowTests.m');
    %Tests = TestSuite.fromFile('./model/IteratorTests.m');
    
    Tests.run();
end