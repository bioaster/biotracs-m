classdef ProcessTests < matlab.unittest.TestCase

    properties
        workingDir = fullfile( biotracs.core.env.Env.workingDir(), '/biotracs/core/mvc/ProcessTests' );
    end

    methods (Test)
        
        function testDefaultConstructor(testCase)
            process = biotracs.core.mvc.model.Process();
            testCase.verifyClass(process, 'biotracs.core.mvc.model.Process');
            testCase.verifyEqual(process.label, 'biotracs.core.mvc.model.Process');
            testCase.verifyClass(process.config, 'biotracs.core.mvc.model.ProcessConfig');
            testCase.verifyEqual(process.getClassName(), 'biotracs.core.mvc.model.Process');
        end

        function testRunEmulate(testCase)
            process = biotracs.core.mvc.model.Process();
            process.setInputSpecs({...
                struct(...
                'name', 'Input',...
                'class', 'biotracs.core.mvc.model.Resource' ...
                )}...
            );
        
            process.setOutputSpecs({...
                struct(...
                'name', 'Output',...
                'class', 'biotracs.core.mvc.model.Resource' ...
                )}...
            );
        
            testCase.verifyFalse(process.isReady());
            
            process.setInputPortData('Input', biotracs.core.mvc.model.Resource);
            testCase.verifyTrue(process.isReady());
            
            process.emulate();
            process.getConfig()...
                .updateParamValue('WorkingDirectory', testCase.workingDir)
            [path] = process.getPaths();
            
            testCase.verifyEqual(path, {process});
            testCase.verifyTrue(process.isReady());
            testCase.verifyTrue(process.isStarted());
            testCase.verifyTrue(process.isEnded());
        end
       
        
        function testNextPrev(testCase)
            process = biotracs.core.mvc.model.Process();
            [ next ] = process.getNext();
            testCase.verifyEmpty(next);
            
            [ prev ] = process.getPrevious();
            testCase.verifyEmpty(prev);
            
            testCase.verifyTrue(process.isSource());
            testCase.verifyTrue(process.isSink());
        end
        
    end
    
end
