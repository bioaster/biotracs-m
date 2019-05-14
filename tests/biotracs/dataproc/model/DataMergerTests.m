classdef DataMergerTests < matlab.unittest.TestCase
    
    properties
        workingDir = fullfile(biotracs.core.env.Env.workingDir(), '/spectra/dataproc/DataMergerTests');
    end
    
    methods (Test)
        
        function testVertmerge( testCase )
            data1 = {'abc',  2.3,    1.2;
                3.3,    1.004,  0.5;
                3.3,     'oui',    -1.1;
                {1,'b'},     657.6,  34.5};
            dataTable1 = biotracs.data.model.DataTable( data1 );
            dataTable1.setColumnNames({'Paris', 'NY', 'NYandBrussels'});
            dataTable1.setRowNames({'Q1', 'Q2', 'Q3', 'Q4'});
            
            data2 = {'abcef',  2.3,    1.2;
                pi,    1.2, 1.5;
                3.3,     '@',    pi/4};
            dataTable2 = biotracs.data.model.DataTable( data2 );
            dataTable2.setColumnNames({'Paris', 'NY', 'NYandBrussels'});
            dataTable2.setRowNames({'Q11', 'Q20', 'Q34'});
            
            merger = biotracs.dataproc.model.DataMerger();
            merger.resizeInput(2);
            merger.setInputPortData('DataTable#1', dataTable1);
            merger.setInputPortData('DataTable#2', dataTable2);
            merger.getConfig()...
                .updateParamValue('Direction', 'column');
            merger.run();
            mergedDataTable = merger.getOutputPortData('DataTable');
            
            testCase.verifyEqual( mergedDataTable.columnNames, {'Paris', 'NY', 'NYandBrussels'} );
            testCase.verifyEqual( mergedDataTable.rowNames, {'Q1', 'Q2', 'Q3', 'Q4', 'Q11', 'Q20', 'Q34'} );
            testCase.verifyEqual( mergedDataTable.data, vertcat(dataTable1.data(:,[1,2,3]), dataTable2.data(:,[1,2,3])) );

            %test errors
            dataTable2.setColumnNames({'Paris', 'NY', 'NYandBrussels2'});
            try
                merger.reset();
                merger.setInputPortData('DataTable#1', dataTable1);
                merger.setInputPortData('DataTable#2', dataTable2);
                merger.run();
                error('SPECTRA:UnexpectedError','An error was expected');
            catch exception
                testCase.verifyEqual( exception.identifier, 'BIOTRACS:DataTable:ColumnNameMismatchs' );
            end
        end
        
        function testHorzmerge( testCase )
            data1 = {'abc',  2.3;
                3.3,    1.004;
                3.3,     'oui';
                {1,'b'},     657.6};
            dataTable1 = biotracs.data.model.DataTable( data1 );
            dataTable1.setColumnNames({'Paris', 'NY'});
            dataTable1.setRowNames({'Q4', 'Q2', 'Q3', 'Q1'});
            
            data2 = {'abcef',  2.3, 1.23;
                pi,    1.2, 34;
                2.3,     '~', 'oui';
                3.3,     '@', 'pi'};
            dataTable2 = biotracs.data.model.DataTable( data2 );
            dataTable2.setColumnNames({'London', 'Berlin', 'Shanghai'});
            dataTable2.setRowNames({'Q4', 'Q1', 'Q3', 'Q2'});
            
            merger = biotracs.dataproc.model.DataMerger();
            merger.resizeInput(2);
            merger.setInputPortData('DataTable#1', dataTable1);
            merger.setInputPortData('DataTable#2', dataTable2);
            merger.getConfig()...
                .updateParamValue('Direction', 'row');
            merger.run();
            mergedDataTable = merger.getOutputPortData('DataTable');
            
            testCase.verifyEqual( mergedDataTable.columnNames, {'Paris', 'NY', 'London', 'Berlin', 'Shanghai'} );
            testCase.verifyEqual( mergedDataTable.rowNames, {'Q1', 'Q2', 'Q3', 'Q4'} );
            testCase.verifyEqual( mergedDataTable.data, horzcat(dataTable1.data([4,2,3,1],:), dataTable2.data([2,4,3,1],:)) );
            
            summary(mergedDataTable);
            
            %test errors
            dataTable2.setRowNames({'Q4', 'Q100', 'Q3', 'Q2'});
            try
                merger.reset();
                merger.setInputPortData('DataTable#1', dataTable1);
                merger.setInputPortData('DataTable#2', dataTable2);
                merger.run();
                error('SPECTRA:UnexpectedError','An error was expected')
            catch err
                testCase.verifyEqual( err.identifier, 'BIOTRACS:DataTable:RowNameMismatchs' );
            end
        end
        
        function testHorzmergeForce( testCase )
            data1 = {'abc',  2.3;
                3.3,    1.004;
                3.3,     'oui';
                {1,'b'},     657.6};
            dataTable1 = biotracs.data.model.DataTable( data1 );
            dataTable1.setColumnNames({'Paris', 'NY'});
            dataTable1.setRowNames({'Q4', 'Q2', 'Q3', 'Q0'});
            
            data2 = {'abcef',  2.3, 1.23;
                pi,    1.2, 34;
                2.3,     '~', 'oui';
                3.3,     '@', 'pi'};
            dataTable2 = biotracs.data.model.DataTable( data2 );
            dataTable2.setColumnNames({'London', 'Berlin', 'Shanghai'});
            dataTable2.setRowNames({'Q4', 'Q5', 'Q3', 'Q2'});
            
            merger = biotracs.dataproc.model.DataMerger();
            merger.resizeInput(2);
            merger.setInputPortData('DataTable#1', dataTable1);
            merger.setInputPortData('DataTable#2', dataTable2);
            merger.getConfig()...
                .updateParamValue('Direction', 'row')...
                .updateParamValue('Force', true);
            merger.run();
            mergedDataTable = merger.getOutputPortData('DataTable');
            
            testCase.verifyEqual( mergedDataTable.columnNames, {'Paris', 'NY', 'London', 'Berlin', 'Shanghai'} );
            testCase.verifyEqual( mergedDataTable.rowNames, {'Q2', 'Q3', 'Q4'} );
            testCase.verifyEqual( mergedDataTable.data, horzcat(dataTable1.data([2,3,1],:), dataTable2.data([4,3,1],:)) );
            
            summary(mergedDataTable);
            
            %test errors
            dataTable2.setRowNames({'Q4', 'Q100', 'Q3', 'Q2'});
            try
                merger.reset();
                merger.getConfig()...
                    .updateParamValue('Force', false);
                merger.setInputPortData('DataTable#1', dataTable1);
                merger.setInputPortData('DataTable#2', dataTable2);
                merger.run();
                error('SPECTRA:UnexpectedError','An error was expected')
            catch err
                err.message
                testCase.verifyEqual( err.identifier, 'BIOTRACS:DataTable:RowNameMismatchs' );
            end
        end
        
        function testResourceSetOfDataTable( testCase )
            data1 = {'abc',  2.3;
                3.3,    1.004;
                3.3,     'oui';
                {1,'b'},     657.6};
            dataTable1 = biotracs.data.model.DataTable( data1 );
            dataTable1.setColumnNames({'Paris', 'NY'});
            dataTable1.setRowNames({'Q4', 'Q2', 'Q3', 'Q0'});
            
            data2 = {'abcef',  2.3, 1.23;
                pi,    1.2, 34;
                2.3,     '~', 'oui';
                3.3,     '@', 'pi'};
            dataTable2 = biotracs.data.model.DataTable( data2 );
            dataTable2.setColumnNames({'London', 'Berlin', 'Shanghai'});
            dataTable2.setRowNames({'Q4', 'Q5', 'Q3', 'Q2'});
            
            r = biotracs.core.mvc.model.ResourceSet();
            r.add(dataTable1)...
                .add(dataTable2);
            
            merger = biotracs.dataproc.model.DataMerger();
            merger.setInputPortData('DataTable', r);
            merger.getConfig()...
                .updateParamValue('Direction', 'row')...
                .updateParamValue('Force', true);
            merger.run();
            mergedDataTable = merger.getOutputPortData('DataTable');
            
            testCase.verifyEqual( mergedDataTable.columnNames, {'Paris', 'NY', 'London', 'Berlin', 'Shanghai'} );
            testCase.verifyEqual( mergedDataTable.rowNames, {'Q2', 'Q3', 'Q4'} );
            testCase.verifyEqual( mergedDataTable.data, horzcat(dataTable1.data([2,3,1],:), dataTable2.data([4,3,1],:)) );
        end
        
    end
    
end