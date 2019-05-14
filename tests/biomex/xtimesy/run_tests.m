% MS testing script
% Copyrights, Bioaster 2014
% D. A. Ouattara, Aug. 2014

try
    clearAll;
catch
    clc; clear; close all force;
end

addpath( [pwd, '/../../'] );

commons  = {'Biocode'};
externals = {};

[commonPath] = autoload( commons, externals, true);
import matlab.unittest.TestSuite;

%% Compile mex file
mex( ...
    '-output', [commonPath,'/Framework/+biomex/+xtimesy/xtimesy'], ...
    ['-I', commonPath,'/Framework/+biomex/'], ...
    [commonPath, '/Framework/+biomex/xtimesy.cpp'], ...
    [commonPath, '/Framework/+biomex/matrix.cpp'] ...
);

%% Base tests
Tests = TestSuite.fromFolder('./', 'IncludingSubfolders', true);
Tests.run;
