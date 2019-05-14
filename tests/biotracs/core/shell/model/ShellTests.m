classdef ShellTests < matlab.unittest.TestCase

    properties
        workingDir = fullfile(biotracs.core.env.Env.workingDir, '/biotracs/core/shell/ShellTests/');
    end

    methods (Test)
        
        function testShell(testCase)
            shell = biotracs.core.shell.model.Shell(); 
            config = shell.getConfig();
            config.createParam('Weight', 1.234, 'Constraint', biotracs.core.constraint.IsPositive());
            config.createParam('Destination', 'http://url.fr', 'Constraint', biotracs.core.constraint.IsPath());
            config.createParam('Location', 8, 'Constraint', biotracs.core.constraint.IsBetween([0,10]));

            config.createParam('TimeRange', []);
            config.createParam('MSLevel');
            config.createParam('PeackPicking', 'true', 'Constraint', biotracs.core.constraint.IsText());
            config.createParam('IntensityThreshold', 100, 'Constraint', biotracs.core.constraint.IsGreaterThan(0));

            config.optionSet.addElements(...
                'InputFilePath',        biotracs.core.shell.model.Option('"%s"'), ...
                'TimeRange',            biotracs.core.shell.model.Option('--filter "scanTime %s"'), ...
                'MSLevel',              biotracs.core.shell.model.Option('--filter "msLevel %s"'), ...
                'PeackPicking',         biotracs.core.shell.model.Option('--filter "peakPicking %s"'), ...
                'IntensityThreshold',   biotracs.core.shell.model.Option('--filter  "threshold absolute %d most-intense"') ...
                );
            
            % test 1
            optStruct = config.formatOptionsAsStruct();
            f = fieldnames(optStruct);
            testCase.verifyEqual( length(f), 5 );
            testCase.verifyEqual( optStruct.PeackPicking.name, 'filter' );
            testCase.verifyEqual( optStruct.PeackPicking.value, 'true' );
            testCase.verifyEqual( optStruct.PeackPicking.command, '--filter "peakPicking true"' );
            
            testCase.verifyEqual( optStruct.IntensityThreshold.name, 'filter' );
            testCase.verifyEqual( optStruct.IntensityThreshold.value, '100' );
            testCase.verifyEqual( optStruct.IntensityThreshold.command, '--filter  "threshold absolute 100 most-intense"' );
            
            % test 2
            optStr = config.formatOptionsAsString();
            testCase.verifyEqual( optStr, '--filter "peakPicking true" --filter  "threshold absolute 100 most-intense"' );
            
            optStruct = config.formatOptionsAsStruct( 'OptionsToUse', {'IntensityThreshold'} );
            f = fieldnames(optStruct);
            testCase.verifyEqual( length(f), 1 );
            testCase.verifyEqual( optStruct.IntensityThreshold.name, 'filter' );
            testCase.verifyEqual( optStruct.IntensityThreshold.value, '100' );
            testCase.verifyEqual( optStruct.IntensityThreshold.command, '--filter  "threshold absolute 100 most-intense"' );
            
            
            optStr = config.formatOptionsAsString( 'OptionsToUse', {'IntensityThreshold'} );
            testCase.verifyEqual( optStr, '--filter  "threshold absolute 100 most-intense"' );
            
            config.exportParams( [testCase.workingDir, 'text.xml'], 'DisplayContent', true );
        end
        
        
        function testShellWithSpecialChar(testCase)
            shellProcess = biotracs.core.shell.model.Shell(); 
            config = shellProcess.getConfig();
            config.createParam('Weight', 1.234, 'Constraint', biotracs.core.constraint.IsPositive());
            config.createParam('Destination', 'http://url.fr', 'Constraint', biotracs.core.constraint.IsPath());
            config.createParam('Location', 8, 'Constraint', biotracs.core.constraint.IsBetween([0,10]));

            config.createParam('TimeRange', []);
            config.createParam('MSLevel');
            config.createParam('PeackPicking', 'true', 'Constraint', biotracs.core.constraint.IsText());
            config.createParam('IntensityThreshold', 100, 'Constraint', biotracs.core.constraint.IsGreaterThan(0));

            config.optionSet.addElements(...
                'PeackPicking',         biotracs.core.shell.model.Option('--algorithm:filter "peakPicking %s"'), ...
                'IntensityThreshold',   biotracs.core.shell.model.Option('--filter  "threshold absolute %d most-intense"') ...
                );
            
            % test 1
            optStruct = config.formatOptionsAsStruct();
            f = fieldnames(optStruct);
            testCase.verifyEqual( length(f), 2 );
            testCase.verifyEqual( optStruct.PeackPicking.name, 'algorithm:filter' );
            testCase.verifyEqual( optStruct.PeackPicking.value, 'true' );
            testCase.verifyEqual( optStruct.PeackPicking.command, '--algorithm:filter "peakPicking true"' );
            
            testCase.verifyEqual( optStruct.IntensityThreshold.name, 'filter' );
            testCase.verifyEqual( optStruct.IntensityThreshold.value, '100' );
            testCase.verifyEqual( optStruct.IntensityThreshold.command, '--filter  "threshold absolute 100 most-intense"' );
        end
        
    end
    
end
