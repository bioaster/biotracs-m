classdef LoggerTests < matlab.unittest.TestCase
    
    properties
        workingDir = fullfile(biotracs.core.env.Env.workingDir, '/biotracs/core/logger/LoggerTests');
    end
    
    methods (Test)
        
        function testDefaultConstructor(testCase)
            process = biotracs.core.mvc.model.Process();
            c = process.getConfig();
            c.updateParamValue('WorkingDirectory', testCase.workingDir);
            logger = biotracs.core.logger.Logger( process );
            testCase.verifyClass(logger, 'biotracs.core.logger.Logger');
            testCase.verifyEqual(logger.isLogOpen(),false);

            logger.closeLog();
            testCase.verifyEqual(logger.isLogOpen(),false);
            
            logger.setLogFileName('log.txt');
            logger.openLog();
            for i=1:3
                logger.writeLog('Bioaster');
            end
            
            testCase.verifyTrue( isfile(logger.getLogFilePath()) );
            testCase.verifyEqual(logger.isLogOpen(),true);
            logger.closeLog();
            testCase.verifyEqual(logger.isLogOpen(),false);
            
            logger.deleteLog(); %delete file
            testCase.verifyTrue( ~isfile(logger.getLogFilePath()) );
        end
        
    end
    
end
