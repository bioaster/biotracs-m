%"""
%Unit tests for biotracs.core.adapter.*
%* Date: 2016
%* Author: D. A. Ouattara
%* License: BIOASTER License
%
%Omics Hub, Bioinformatics team
%BIOASTER Technology Research Institute (http://www.bioaster.org)
%"""
function testAdapter( cleanAll )
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
    
    %Tests = TestSuite.fromFile('./model/FileExporterTests.m');
    %Tests = TestSuite.fromFile('./model/ViewExporterTests.m');
    %Tests = TestSuite.fromFile('./model/CollectAdapterTests.m');
    %Tests = TestSuite.fromFile('./model/MuxTests.m');
    %Tests = TestSuite.fromFile('./model/DemuxTests.m');
    %Tests = TestSuite.fromFile('./model/FileDispatcherTests.m');
    %Tests = TestSuite.fromFile('./model/FileImporterTests.m');
    %Tests = TestSuite.fromFile('./model/MergerTests.m');
    %Tests = TestSuite.fromFile('./model/InputSwitchTests.m');
    %Tests = TestSuite.fromFile('./model/OutputSwitchTests.m');

    Tests.run;
end