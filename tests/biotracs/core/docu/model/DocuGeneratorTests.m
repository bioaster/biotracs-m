classdef DocuGeneratorTests < matlab.unittest.TestCase

    properties
        workingDir = fullfile(biotracs.core.env.Env.workingDir(), '/biotracs/core/docu/DocuGeneratorTests/');
    end
    
    methods (Test)

        function testExample(testCase)
            dataFileSet = biotracs.data.model.DataFileSet();
            
            filePath = fullfile(pwd, '\..\..\..\..\+biotracs\+core\+ability\Parametrable.m');
            dataFileSet.add( biotracs.data.model.DataFile(filePath) );
            
            filePath = fullfile(pwd, '\..\..\..\..\+biotracs\+core\+ability\Comparable.m');
            dataFileSet.add( biotracs.data.model.DataFile(filePath) );
            
            filePath = fullfile(pwd, '\..\..\..\..\+biotracs\+core\+adapter\+model\Adapter.m');
            dataFileSet.add( biotracs.data.model.DataFile(filePath) );
            
            filePath = fullfile(pwd, '\..\..\..\..\+biotracs\+core\+adapter\+model\AdapterConfig.m');
            dataFileSet.add( biotracs.data.model.DataFile(filePath) );
            
            filePath = fullfile(pwd, '\..\..\..\biotracs\core\ability\ParametrableTests.m');
            dataFileSet.add( biotracs.data.model.DataFile(filePath) );
            
            generator = biotracs.core.docu.model.DocuGenerator();
            generator.getConfig()....
                .updateParamValue('WorkingDirectory', testCase.workingDir);
            generator.setInputPortData( 'DataFileSet', dataFileSet  );
            generator.run();
            docuSet = generator.getOutputPortData('DocuSet');

            docuSet.view('Html');
        end

    end
    
end
