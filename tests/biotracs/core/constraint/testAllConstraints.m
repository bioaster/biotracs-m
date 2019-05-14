%"""
%Unit tests for biotracs.core.constraint.*
%* Date: 2017
%* Author: D. A. Ouattara
%* License: BIOASTER License
%
%Omics Hub, Bioinformatics team
%BIOASTER Technology Research Institute (http://www.bioaster.org)
%"""
function testAllConstraints( cleanAll )
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

    %% Base tests
    import matlab.unittest.TestSuite;
    Tests = TestSuite.fromFolder('./', 'IncludingSubfolders', true);
    Tests.run;
    
end