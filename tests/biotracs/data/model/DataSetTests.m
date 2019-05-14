classdef DataSetTests < matlab.unittest.TestCase
    
    properties
    end
    
    methods (Test)
        function testDefaultConstructor(testCase)
            data = biotracs.data.model.DataSet();
            testCase.verifyClass(data, 'biotracs.data.model.DataSet');
            testCase.verifyEqual(data.description, '');
        end
        
        function testCreateYSetFromRowNames(testCase)
            values = [   1,      2.3,    1.2;
                3.3,    1.004,  0.5;
                23,     456,    -1.1;
                34,     657.6,  34.5;
                34,     657.6,  34.5;
                3.3,    1.004,  0.5];
            dataSet = biotracs.data.model.DataSet( values );
            dataSet.setRowName(1, 'Sample:KO_Time:1H_BR:1_AR:1_Seq:123');
            dataSet.setRowName(2, 'Sample:WT_Time:1H_BR:1_AR:1_Seq:125');
            dataSet.setRowName(3, 'Sample:KO_Time:2p5H_BR:1_AR:1_Seq:128');
            dataSet.setRowName(4, 'Sample:WT_Time:2p5H_BR:1_AR:1_Seq:135');
            dataSet.setRowName(5, 'Sample:KOG_Time:1H_BR:1_AR:1_Seq:138');
            dataSet.setRowName(6, 'Sample:KOG_Time:2p5H_BR:1_AR:1_Seq:140');
            dataSet.setColumnNames( {'Paris', 'NY', 'Beijin'} );
            testCase.verifyEqual(dataSet.hasResponses(), false );
            testCase.verifyEqual(dataSet.hasCategoricalResponses(), false );
            
            dataSet.setRowNamePatterns({'Sample'});
            testCase.verifyEqual( dataSet.hasResponses(), false );
            testCase.verifyEqual( dataSet.selectXSet(), dataSet );
            
            YDataSet = dataSet.createYDataSet();
            
            testCase.verifyEqual(...
                YDataSet.data, ...
                [1     0     0
                 0     0     1
                 1     0     0
                 0     0     1
                 0     1     0
                 0     1     0] ...
                );
            
            XYDataSet = dataSet.createXYDataSet();
            
            testCase.verifyEqual(XYDataSet, horzcat(dataSet, YDataSet) );
            testCase.verifyEqual(XYDataSet.selectYSet(), YDataSet);
            testCase.verifyEqual(XYDataSet.selectXSet(), dataSet );
            testCase.verifyEqual(XYDataSet.getVariableNames(), {'Paris', 'NY', 'Beijin'} );
            testCase.verifyEqual(XYDataSet.getResponseNames(), {'Sample:KO', 'Sample:KOG', 'Sample:WT'} );
            testCase.verifyEqual(XYDataSet.getNbColumns(), 6 );
            testCase.verifyEqual(XYDataSet.getNbVariables(), 3 );
            testCase.verifyEqual(XYDataSet.getNbResponses(), 3 );
            testCase.verifyEqual(dataSet.selectXSet().getColumnNames(), {'Paris', 'NY', 'Beijin'} );
            testCase.verifyEqual(XYDataSet.hasResponses(), true );
            testCase.verifyTrue( XYDataSet.selectYSet().hasResponses() )
        end
        
        
        function testCast(testCase)
            data = {   1,      2.3,    1.2;
                3.3,    1.004,  0.5};
            
            dt = biotracs.data.model.DataTable( data );
            dt.setColumnNames({'c1','c2','c3'});
            dt.setRowNames({'r1','r2'});
            
            %cast DataTable -> DataSet
            ds = biotracs.data.model.DataSet.fromDataTable(dt);
            testCase.verifyClass(ds, 'biotracs.data.model.DataSet');
            testCase.verifyEqual(ds.data, cell2mat(dt.data));
            testCase.verifyEqual(ds.columnNames, dt.columnNames);
            testCase.verifyEqual(ds.rowNames, dt.rowNames);
            
            %reverse cast DataSet -> DataTable
            dt2 = biotracs.data.model.DataTable.fromDataSet(ds);
            testCase.verifyEqual(dt2, dt);
            
            
            %cast DataMatrix -> DataSet
            dm = biotracs.data.model.DataMatrix.fromDataTable(dt);
            ds2 = biotracs.data.model.DataSet.fromDataMatrix(dm);
            testCase.verifyEqual(ds, ds2);
            
            %reverse cast DataSet -> DataMatrix
            ds.summary
            
            dm2 = biotracs.data.model.DataMatrix.fromDataSet(ds);
            testCase.verifyEqual(dm, dm2);
        end
        
    end
    
end
