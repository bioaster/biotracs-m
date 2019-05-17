classdef DataSelectorTests < matlab.unittest.TestCase
    
    properties
        workingDir = fullfile(biotracs.core.env.Env.workingDir(), '/biotracs/dataproc/DataSelectorTests');
    end
    
    methods (Test)
        function testSelectByRowOrColumn(testCase)
%             return;
            data1 = {'abc',  2.3, 3;
                3.3,    1.004, 'rr';
                3.3,     'oui', 7.5;
                {1,'b'},     657.6, 89};
            dataTable1 = biotracs.data.model.DataTable( data1 );
            dataTable1.setColumnNames({'Paris', 'NY', 'Beirut'});
            dataTable1.setRowNames({'Q4', 'Q2', 'Q3', 'Q0'});
            
            process = biotracs.dataproc.model.DataSelector();
            c = process.getConfig();
            process.setInputPortData('DataTable',dataTable1);
            c.updateParamValue('SelectOrRemove','select');
            c.updateParamValue('Direction','row');
            c.updateParamValue('ListOfNames', {'Q4','Q0'});
            c.updateParamValue('WorkingDirectory',testCase.workingDir);
            process.run();
            resultSelectByRow = process.getOutputPortData('DataTable');
            %resultSelectByRow.summary
            testCase.verifyEqual( resultSelectByRow.rowNames, {'Q4', 'Q0'} );
            testCase.verifyEqual( resultSelectByRow.data, data1([1,4], :) );
            
            process = biotracs.dataproc.model.DataSelector();
            c = process.getConfig();
            process.setInputPortData('DataTable',dataTable1);
            c.updateParamValue('SelectOrRemove','select');
            c.updateParamValue('Direction','column');
            c.updateParamValue('ListOfNames', {'Paris', 'NY'});
            c.updateParamValue('WorkingDirectory',testCase.workingDir);
            process.run();
            resultSelectByColumn = process.getOutputPortData('DataTable');
            testCase.verifyEqual( resultSelectByColumn.columnNames, {'Paris', 'NY'} );
            testCase.verifyEqual( resultSelectByColumn.data, data1(:,[1,2]) );
            %resultSelectByColumn.summary
        end
        
        function testRemoveByRowOrColumn(testCase)
%             return;
            data1 = {'abc',  2.3, 3;
                3.3,    1.004, 'rr';
                3.3,     'oui', 7.5;
                {1,'b'},     657.6, 89};
            dataTable1 = biotracs.data.model.DataTable( data1 );
            dataTable1.setColumnNames({'Paris', 'NY', 'Beirut'});
            dataTable1.setRowNames({'Q4', 'Q2', 'Q3', 'Q0'});
            
            process = biotracs.dataproc.model.DataSelector();
            c = process.getConfig();
            process.setInputPortData('DataTable', dataTable1);
            c.updateParamValue('SelectOrRemove','remove');
            c.updateParamValue('Direction','row');
            c.updateParamValue('ListOfNames', {'Q4','Q0'});
            c.updateParamValue('WorkingDirectory',testCase.workingDir);
            process.run();
            resultRemoveByRow = process.getOutputPortData('DataTable');
            %resultRemoveByRow.summary
            testCase.verifyEqual( resultRemoveByRow.rowNames, {'Q2', 'Q3'} );
            testCase.verifyEqual( resultRemoveByRow.data, data1([2,3], :) );
            
            process = biotracs.dataproc.model.DataSelector();
            c = process.getConfig();
            process.setInputPortData('DataTable',dataTable1);
            c.updateParamValue('SelectOrRemove','remove');
            c.updateParamValue('Direction','column');
            c.updateParamValue('ListOfNames', {'Beirut'});
            c.updateParamValue('WorkingDirectory',testCase.workingDir);
            process.run();
            resultRemoveByColumn = process.getOutputPortData('DataTable');
            %resultRemoveByColumn.summary
            testCase.verifyEqual( resultRemoveByColumn.columnNames, {'Paris', 'NY'} );
            testCase.verifyEqual( resultRemoveByColumn.data, data1(:, [1,2]) );
        end
        
        function testSelectSelectedVariable(testCase)
            data1 = {1, 5, 2.3, 3, 54, 5, 6;
                3.3, 54, 26, 9, 25, 26, 1.004 ;
                3.3, 69, 78, 36, 14, 76, 7.5;
                1, 58, 9, 15, 67, 657.6, 89;
                25, 8, 9, 5, 65, 89, 72;
                3, 96, 5, 86, 64, 98, 24};
            dataTable1 = biotracs.data.model.DataTable( data1 );
            dataTable1.setColumnNames({'M1_T1_Pos', 'M1_T2_Neg', 'M2_T2_Neg', 'M3_T3_Pos','M3_T4_Pos', 'M4_T4_Neg', 'M5_T6_Neg'});
            dataTable1.setRowNames({'S1', 'S2', 'S3', 'B1',  'QC1', 'QC2'});
            
            data2 = {'1.000000000e+02',	'1.541108666e-01',	'1.541108666e-01',	'2.200000000e+02';
                '9.900000000e+01',	'1.197394868e-01',	'1.197394868e-01',	'5.420000000e+02'};    
            dataTable2 = biotracs.data.model.DataTable( data2 );
            dataTable2.setColumnNames({'Path', 'AbsWeight', 'Weight', 'VariableIndex'});
            dataTable2.setRowNames({'M1_T1_Pos', 'M2_T2_Neg'});
            
            data3 = {'9.700000000e+01',	'7.128617201e-02',	'-7.128617201e-02'	,'4.340000000e+02';
                '9.300000000e+01',	'1.285918571e-01',	'-1.285918571e-01',	'2.270000000e+02'};
            dataTable3 = biotracs.data.model.DataTable( data3 );
            dataTable3.setColumnNames({'Path', 'AbsWeight', 'Weight', 'VariableIndex'});
            dataTable3.setRowNames({ 'M3_T3_Pos', 'M4_T4_Neg'});
            
            rs = biotracs.core.mvc.model.ResourceSet();
            rs.add(dataTable2);
            rs.add(dataTable3);
            
            process = biotracs.dataproc.model.DataSelector();
            c = process.getConfig();
            process.setInputPortData('DataTable', dataTable1);
            process.setInputPortData('SelectedVariableResourceSet', rs);
            c.updateParamValue('SelectOrRemove','select');
            c.updateParamValue('Direction','column');
            c.updateParamValue('WorkingDirectory',testCase.workingDir);
            process.run();
            resultVariableSelect = process.getOutputPortData('DataTable');

            testCase.verifyEqual( resultVariableSelect.columnNames, {'M1_T1_Pos', 'M2_T2_Neg', 'M3_T3_Pos', 'M4_T4_Neg'} );
            testCase.verifyEqual( resultVariableSelect.data, data1(:, [1,3,4,6]) );

        end
    end
    
end