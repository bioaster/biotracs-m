classdef ExtDataTableTests < matlab.unittest.TestCase
    
    properties
        workingDir = fullfile(biotracs.core.env.Env.workingDir(), '/biotracs/data/ExtDataTableTests');
    end

    methods (Test)
        
        function testDefaultConstructor(testCase)
            data = biotracs.data.model.ExtDataTable();
            testCase.verifyClass(data, 'biotracs.data.model.ExtDataTable');
            testCase.verifyEqual(data.description, '');
            process = biotracs.core.mvc.model.Process();
            data.setProcess( process );
            testCase.verifyEqual(data.process, process);
        end
        
        
        function testImportMetaboFile(testCase)
            extDataTable = biotracs.data.model.ExtDataTable.import( '../testdata/ExtendedData/Metabo.csv', 'NbHeaderLines', 1 );
            testCase.verifyClass(extDataTable.get('MAP'), 'biotracs.data.model.DataTable');
            testCase.verifyEqual(getSize(extDataTable.get('MAP')), [28,4]);
            testCase.verifyEqual(extDataTable.get('MAP').data{1,2}, 'MyProject/BlankSolv_H2O-ACN-IPA_20170210_002.featureXML');
            summary(extDataTable, 'Deep', true);

            extDataTable.export( [ testCase.workingDir, 'MetaboFile1' ] );
            extDataTable.export( [ testCase.workingDir, 'MetaboFile2.tar' ] );
            extDataTable.export( [ testCase.workingDir, 'MetaboFile3.xlsx' ] );
        end
        
        function testImportProteoFile(testCase)
            extDataTable = biotracs.data.model.ExtDataTable.import( '../testdata/ExtendedData/Proteo.csv', 'NbHeaderLines', 1 );
            summary(extDataTable, 'Deep', false);
        end
        
        
%         function testHugeFileOnNetwork(testCase)
%             tic
%             filePath = 'C:\BIOASTER\Workspace2\HeBoo_BA007\BA007-WP1-WP3-UTEC07-01\Analyses\Exactive\20170328_batch1_clin_samples_pos\Bioapps\OpenMs\07-TextExporter\1022-J15_B1_pos_20170328_076.csv';
%             extDataTable = biotracs.data.model.ExtDataTable.import( filePath, 'NbHeaderLines', 1 );
%             summary(extDataTable, 'Deep', false);
%             toc
%         end
 
    end
    
end
