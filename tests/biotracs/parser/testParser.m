%"""
%Unit tests for biotracs.parser.*
%* Date: Aug. 2014
%* Author:  D. A. Ouattara
%* License: BIOASTER License
%
%Omics Hub, Bioinformatics team
%BIOASTER Technology Research Institute (http://www.bioaster.org)
%"""

function testParser( cleanAll )
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
    %Tests = TestSuite.fromFile('./model/TableParserTests.m');
    Tests.run();
end