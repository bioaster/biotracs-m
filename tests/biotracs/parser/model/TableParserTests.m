classdef TableParserTests < matlab.unittest.TestCase

    properties
        workingDir = fullfile(biotracs.core.env.Env.workingDir() , '/biotracs/parser/SignalParserTests');
    end

    methods (Test)
        
        function testParseFile(testCase)
            file = strcat(pwd,'/../testdata/xls/Fingerprinting_Binning_Light.xlsx');
            process = biotracs.parser.model.TableParser();
            c = process.getConfig();
            c.updateParamValue('WorkingDirectory',testCase.workingDir);
            process.setInputPortData( 'DataFile', biotracs.data.model.DataFile(file) );
            process.run();
            dataTable = process.getOutputPortData('ResourceSet').getAt(1);
            
            %--------------------------------------------------------------
            % DataMatrix
            dataMatrix = dataTable.toDataMatrix(); %parser.getDataAsDataMatrix();
            testCase.verifyEqual(dataMatrix.getLabel(), 'Fingerprinting_Binning_Light');
            
            colNames = dataMatrix.getColumnNames();
            testCase.verifyEqual(length(colNames), 13);
            testCase.verifyEqual(colNames{1}, 'Var1');
            testCase.verifyEqual(colNames{2}, 'x01HS_RT1P');
            testCase.verifyEqual(colNames{4}, 'x8_9975');
            testCase.verifyEqual(colNames{5}, 'HSRT_1P');
            testCase.verifyEqual(colNames{12}, 'A8_9895');
            testCase.verifyEqual(colNames{13}, 'Last');
            
            rowNames = dataMatrix.getRowNames();
            testCase.verifyEqual(length(rowNames), 22);
            testCase.verifyEqual(rowNames{1}, 'D1_ex1_p1.cnx');
            testCase.verifyEqual(rowNames{22}, 'P2_ex2_p1.cnx');
            
            testCase.verifyEqual(dataMatrix.getNbRows(), 22);
            testCase.verifyEqual(dataMatrix.getNbColumns(), 13);
 
            testCase.verifyEqual(dataMatrix.data(1,1), 1);
            testCase.verifyEqual(...
                dataMatrix.data(1,1:6), ...
                [1,0.000054401,-0.000019205,-0.000020115,-0.000036891,-0.000047842]...
             );
            
            %--------------------------------------------------------------
            % DataTable
            testCase.verifyEqual(dataTable.getLabel(), 'Fingerprinting_Binning_Light');
            colNames = dataTable.getColumnNames();
            testCase.verifyEqual(length(colNames), 13);
            testCase.verifyEqual(colNames{1}, 'Var1');
            testCase.verifyEqual(colNames{4}, 'x8_9975');
            testCase.verifyEqual(colNames{12}, 'A8_9895');
            testCase.verifyEqual(colNames{13}, 'Last');
            
            testCase.verifyEqual(dataTable.data(1,1), {1});
            testCase.verifyEqual(...
                dataTable.data(1,1:6), ...
                {1,0.000054401,-0.000019205,-0.000020115,-0.000036891,-0.000047842}...
             );
        end
        
        
        function testParseFolder(testCase)
            folder = strcat(pwd,'/../testdata/xls/');
            process = biotracs.parser.model.TableParser();
            c = process.getConfig();
            c.updateParamValue('WorkingDirectory',testCase.workingDir);
            process.setInputPortData( 'DataFile', biotracs.data.model.DataFile(folder) );
            process.run();
            
            % xlsx import testing
            % based on reatable function
            dataTable = process.getOutputPortData('ResourceSet').getAt(1);
            testCase.verifyEqual(dataTable.getLabel(), 'Fingerprinting_Binning_Light');
            [m,n] = getSize(dataTable);
            testCase.verifyEqual(n, 13);
            testCase.verifyEqual(m, 22);
            
            colNames = dataTable.getColumnNames();
            testCase.verifyEqual(length(colNames), 13);
            testCase.verifyEqual(colNames{1}, 'Var1');   
            testCase.verifyEqual(colNames{4}, 'x8_9975');
            testCase.verifyEqual(colNames{12}, 'A8_9895');
            testCase.verifyEqual(colNames{13}, 'Last');
            
            testCase.verifyEqual(dataTable.data(1,1), {1});
            testCase.verifyEqual(...
                dataTable.data(1,1:6), ...
                {1,0.000054401,-0.000019205,-0.000020115,-0.000036891,-0.000047842}...
             );
         
            % csv import testing
            % based on faster custom function (no implicit data conversion,
            % variable namve, row name check)
            dataTable = process.getOutputPortData('ResourceSet').getAt(2);
            testCase.verifyEqual(dataTable.getLabel(), 'Fingerprinting_Binning_Tiny');
            [m,n] = getSize(dataTable);
            testCase.verifyEqual(n, 13);
            testCase.verifyEqual(m, 13);
            colNames = dataTable.getColumnNames();

            testCase.verifyEqual(length(colNames), 13);
            testCase.verifyEqual(colNames{1}, '');
            testCase.verifyEqual(colNames{4}, '8.9975');
            testCase.verifyEqual(colNames{12}, 'A8.9895');
            testCase.verifyEqual(colNames{13}, 'Last');
            
            testCase.verifyEqual(dataTable.data(1,1), {'1'});
            testCase.verifyEqual(...
                dataTable.data(1,1:6), ...
                {'1','0.000054401','-0.000019205','-0.000020115','-0.000036891','-0.000047842'}...
             );
        end
        
        function testParseFolderAsDataset(testCase)
            folder = strcat(pwd,'/../testdata/xls/');
            process = biotracs.parser.model.TableParser();
            c = process.getConfig();
            c.updateParamValue('WorkingDirectory',testCase.workingDir);
            c.updateParamValue('TableClass', 'biotracs.data.model.DataSet');
            process.setInputPortData( 'DataFile', biotracs.data.model.DataFile(folder) );
            process.run();

            % xlsx import testing
            % based on reatable function
            dataSet = process.getOutputPortData('ResourceSet').getAt(1);
            
            testCase.verifyEqual(dataSet.getLabel(), 'Fingerprinting_Binning_Light');
            [m,n] = getSize(dataSet);
            
            testCase.verifyClass(dataSet, 'biotracs.data.model.DataSet');
            testCase.verifyEqual(n, 13);
            testCase.verifyEqual(m, 22);
            
            colNames = dataSet.getColumnNames();
            testCase.verifyEqual(length(colNames), 13);
            testCase.verifyEqual(colNames{1}, 'Var1');   
            testCase.verifyEqual(colNames{4}, 'x8_9975');
            testCase.verifyEqual(colNames{12}, 'A8_9895');
            testCase.verifyEqual(colNames{13}, 'Last');
            
            testCase.verifyEqual(dataSet.data(1,1), 1);
            testCase.verifyEqual(...
                dataSet.data(1,1:6), ...
                [1,0.000054401,-0.000019205,-0.000020115,-0.000036891,-0.000047842]...
             );
         
            % csv import testing
            % based on faster custom function (no implicit data conversion,
            % variable namve, row name check)
            dataSet = process.getOutputPortData('ResourceSet').getAt(2);
            testCase.verifyEqual(dataSet.getLabel(), 'Fingerprinting_Binning_Tiny');
            [m,n] = getSize(dataSet);
            testCase.verifyEqual(n, 13);
            testCase.verifyEqual(m, 13);
            colNames = dataSet.getColumnNames();

            testCase.verifyEqual(length(colNames), 13);
            testCase.verifyEqual(colNames{1}, '');
            testCase.verifyEqual(colNames{4}, '8.9975');
            testCase.verifyEqual(colNames{12}, 'A8.9895');
            testCase.verifyEqual(colNames{13}, 'Last');
            
            testCase.verifyEqual(dataSet.data(1,1), 1);
            testCase.verifyEqual(...
                dataSet.data(1,1:6), ...
                [1,0.000054401,-0.000019205,-0.000020115,-0.000036891,-0.000047842]...
             );
        end

    end
    
end
