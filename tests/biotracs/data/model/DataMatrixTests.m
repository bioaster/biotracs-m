classdef DataMatrixTests < matlab.unittest.TestCase

    properties
        workingDir = fullfile(biotracs.core.env.Env.workingDir(), '/biotracs/data/DataMatrixTests');
    end
    
    methods (Test)
        function testDefaultConstructor(testCase)
            data = biotracs.data.model.DataMatrix();
            testCase.verifyClass(data, 'biotracs.data.model.DataMatrix');
            testCase.verifyEqual(data.description, '');
            process = biotracs.core.mvc.model.Process();
            data.setProcess( process );
            testCase.verifyEqual(data.process, process);
        end
        
        
       function testConstructorWithAttributes(testCase)
            process = biotracs.core.mvc.model.Process();
            values = [   1,      2.3,    1.2; 
                            3.3,    1.004,  0.5; 
                            23,     456,    -1.1; 
                            34,     657.6,  34.5];
            dataMatrix = biotracs.data.model.DataMatrix( values );

            dataMatrix.setColumnName(1, 'input_c1');
            dataMatrix.setColumnName(3, 'Blank_output_c1_c3');
            
            dataMatrix.setProcess(process);
            dataMatrix.setDescription('Short description');
            testCase.verifyClass(dataMatrix, 'biotracs.data.model.DataMatrix');
            testCase.verifyEqual(dataMatrix.description, 'Short description');
            testCase.verifyEqual(dataMatrix.process, process);
            testCase.verifyEqual(dataMatrix.data, values);            
            
            
            %tags
            testCase.verifyEqual( dataMatrix.getDataByColumnTag({'input', 'yes'}) , zeros(4,0));
             
            dataMatrix.setColumnTag( 2, 'input', 'yes' );
            t = dataMatrix.getColumnTag(2);
            testCase.verifyEqual( t.input, 'yes');
            
            testCase.verifyEqual( dataMatrix.getDataByColumnTag({'input', 'yes'}) , values(:,2));
            testCase.verifyEqual( dataMatrix.getDataByColumnTag({'input', '~yes'}) , values(:,[1,3]));
            
            %transpose
            
            tDataMatrix = dataMatrix.transpose();
            testCase.verifyEqual( tDataMatrix.getNbRows(), 3 );
            testCase.verifyEqual( tDataMatrix.getNbColumns(), 4 );
            testCase.verifyEqual( tDataMatrix.getRowName(1), 'input_c1' );
            testCase.verifyEqual( tDataMatrix.getDataByRowName('c1'), values(:,[1,3])', 'AbsTol', 1e-9 );
       end
       
       
       function testImportXLSFile(testCase)
           file = strcat(pwd,'/../testdata/DataTable/DataTable.xlsx');
           
           dm = biotracs.data.model.DataMatrix.import( file, 'WorkingDirectory', [testCase.workingDir, '/ImportXLSFile'] );
           
           testCase.verifyEqual( dm.getNbRows(), 5 );
           testCase.verifyEqual( dm.getNbColumns(), 46 );
           testCase.verifyEqual( dm.getColumnName(2), 'ADP' );
           testCase.verifyEqual( dm.getRowName(3), 'C3' );
           
           testCase.verifyEqual( dm.data(1,1), 0.46693657744473, 'AbsTol', 1e-12 );
           testCase.verifyEqual( dm.data(2,9), 1.76968620244058, 'AbsTol', 1e-12 );
       end
       
       function testSelect(testCase)
           data =[      1.2,  2.3,    1.2; 
                            3.3,    1.004,  0.5; 
                            3.3,     0,    -1.1; 
                            pi,     657.6,  34.5 ];
           
           dataMatrix = biotracs.data.model.DataMatrix( data );
           dataMatrix.setColumnNames({'Paris', 'NY', 'NY and Brussels'});
           dataMatrix.setRowNames({'Health', 'Diet', 'Health and Diet', 'Medication'});
           
           
           %select records where values of colum('Paris') > 3.15
           selectedData =[    3.3,    1.004,  0.5; 
                            3.3,     0,    -1.1 ];
           selectedDataMatrix = biotracs.data.model.DataMatrix( selectedData );
           selectedDataMatrix.setColumnNames({'Paris', 'NY', 'NY and Brussels'});
           selectedDataMatrix.setRowNames({'Diet', 'Health and Diet'});
           testCase.verifyEqual( dataMatrix.select('WhereColumns', 'Paris', 'GreaterThan', 3.15), selectedDataMatrix );
           
           %select records where value of colum('NY' or 'NY and Brussels') < 1.01
           testCase.verifyEqual( dataMatrix.select('WhereColumns', 'NY', 'LessThan', 1), selectedDataMatrix );
           
           %less_than
           %select records where value of colum('NY' or 'NY and Brussels') < -1
           selectedData =[ 3.3,     0,    -1.1 ];
           selectedDataMatrix = biotracs.data.model.DataMatrix( selectedData );
           selectedDataMatrix.setColumnNames({'Paris', 'NY', 'NY and Brussels'});
           selectedDataMatrix.setRowNames({'Health and Diet'});
           testCase.verifyEqual( dataMatrix.select('WhereColumns', 'NY', 'LessThan', -1), selectedDataMatrix );
           
           %equals
           %select records where value of colum('NY') == 657.6
           selectedData =[ pi,     657.6,  34.5 ];
           selectedDataMatrix = biotracs.data.model.DataMatrix( selectedData );
           selectedDataMatrix.setColumnNames({'Paris', 'NY', 'NY and Brussels'});
           selectedDataMatrix.setRowNames({'Medication'});
           testCase.verifyEqual( dataMatrix.select('WhereColumns', '^NY$', 'EqualTo', 657.6), selectedDataMatrix );
           
           %between
           selectedData =[  3.3,    1.004,  0.5; 
                            3.3,     0,    -1.1;  ];
           selectedDataMatrix = biotracs.data.model.DataMatrix( selectedData );
           selectedDataMatrix.setColumnNames({'Paris', 'NY', 'NY and Brussels'});
           selectedDataMatrix.setRowNames({'Diet', 'Health and Diet'});
           testCase.verifyEqual( dataMatrix.select('WhereColumns', '^NY$', 'Between', [-1, 2]), selectedDataMatrix );
       end
       
       function testSelectByRow(testCase)
           data =[      1.2,  2.3,    1.2; 
                            3.3,    1.004,  0.5; 
                            3.3,     0,    -1.1; 
                            pi,     657.6,  34.5 ];
           
           dataMatrix = biotracs.data.model.DataMatrix( data );
           dataMatrix.setColumnNames({'Paris', 'NY', 'NY and Brussels'});
           dataMatrix.setRowNames({'Health', 'Diet', 'Health and Diet', 'Medication'});
           
           
           %query sub-table NY
           dataHealth =[      1.2,  2.3,    1.2; 
                            3.3,     0,    -1.1];
           dataMatrixHealth = biotracs.data.model.DataMatrix( dataHealth );
           dataMatrixHealth.setColumnNames({'Paris', 'NY', 'NY and Brussels'});
           dataMatrixHealth.setRowNames({'Health', 'Health and Diet'});
           
           testCase.verifyEqual( dataMatrix.selectByRowName( '.*' ), dataMatrix )
           testCase.verifyEqual( dataMatrix.selectByRowName( 'Health' ), dataMatrixHealth )
           
           
           testCase.verifyEqual( dataMatrix.select('FilterByRowName', 'Health'), dataMatrixHealth );
           testCase.verifyEqual( dataMatrix.select('FilterByRowName', 'Health$').getData(), dataHealth(1,:) );
       end
       
       function testTranspose(testCase)
           data =[      1.2,  2.3,    1.2; 
                            3.3,    1.004,  0.5; 
                            3.3,     0,    -1.1; 
                            pi,     657.6,  34.5 ];
            
            dataMatrix = biotracs.data.model.DataMatrix( data );
            dataMatrix.setColumnNames({'Paris', 'NY', 'NY and Brussels'});
            dataMatrix.setRowNames({'Q1', 'Q2', 'Q3', 'Q4'});
            
            dataMatrix.setColumnTag(1, 'groupIndex', 1)...
                    .setColumnTag(1, 'groupName', 'SingleCity')...
                    .setColumnTag(2, 'groupIndex', 1)...
                    .setColumnTag(2, 'groupName', 'SingleCity')...
                    .setColumnTag(3, 'groupIndex', 2)...
                    .setColumnTag(3, 'groupName', 'DoubleCity');
           
           dataMatrix.setRowTag(3, 'gender', 'M');
           
           tDataMatrix = dataMatrix.transpose();
           testCase.verifyClass( tDataMatrix, 'biotracs.data.model.DataMatrix' );
           testCase.verifyEqual( tDataMatrix.getData(), transpose(dataMatrix.getData) );
           testCase.verifyEqual( tDataMatrix.getRowNames(), dataMatrix.getColumnNames() );
           testCase.verifyEqual( tDataMatrix.getColumnNames(), dataMatrix.getRowNames() );
           testCase.verifyEqual( tDataMatrix.getColumnTags(), dataMatrix.getRowTags() );
           testCase.verifyEqual( tDataMatrix.getRowTags(), dataMatrix.getColumnTags() );
       end
       
       function testOtherConstructor(testCase)
           data = {   1,      2.3,    1.2; 
                      3.3,    1.004,  0.5};
           
           dt = biotracs.data.model.DataTable( data );
           dt.setColumnNames({'c1','c2','c3'});
           dt.setRowNames({'r1','r2'});
           
           %cast DataTable -> DataMatrix
           dm = biotracs.data.model.DataMatrix.fromDataTable(dt);
           testCase.verifyClass(dm, 'biotracs.data.model.DataMatrix');
           testCase.verifyEqual(dm.data, cell2mat(dt.data));
           testCase.verifyEqual(dm.columnNames, dt.columnNames);
           testCase.verifyEqual(dm.rowNames, dt.rowNames);
           
           %reverse cast DataMatrix -> DataTable
           dt2 = biotracs.data.model.DataTable.fromDataMatrix(dm);
           testCase.verifyEqual(dt2, dt);
       end
       
       function testStandardize(testCase)
           data =[      1.2,  2.3,    1.2;
               3.3,    1.004,  0.5;
               3.3,     0,    -1.1;
               pi,     657.6,  34.5 ];
           
           dataMatrix = biotracs.data.model.DataMatrix( data );
           dataMatrix.setColumnNames({'Paris', 'NY', 'NY and Brussels'});
           dataMatrix.setRowNames({'Q1', 'Q2', 'Q3', 'Q4'});
           
           mdata = bsxfun(@minus, data, mean(data));
           sdata = bsxfun(@times, data, 1./std(data));
           
           stdD = dataMatrix.standardize('Center', true, 'Scale', 'none');
           testCase.verifyEqual(stdD.data, mdata);
           
           stdD = dataMatrix.standardize('Center', false, 'Scale', 'uv');
           testCase.verifyEqual(stdD.data, sdata);
 
           stdD = dataMatrix.standardize('Center', true, 'Scale', 'uv');
           testCase.verifyEqual(stdD.data, bsxfun(@times, mdata, 1./std(mdata)));
       end
       
       function testMeanStd(testCase)
           data =[      1.2,  2.3,    1.2;
               3.3,    1.004,  0.5;
               3.3,     0,    -1.1;
               pi,     657.6,  34.5 ];
           
           dataMatrix = biotracs.data.model.DataMatrix( data );
           dataMatrix.setColumnNames({'Paris', 'NY', 'NY and Brussels'});
           dataMatrix.setRowNames({'Q1', 'Q2', 'Q3', 'Q4'});

           %mean
           d = dataMatrix.mean();
           testCase.verifyEqual(d.data, mean(data, 1));
           testCase.verifyEqual(d.getColumnNames(), {'Paris', 'NY', 'NY and Brussels'});
           testCase.verifyEqual(d.getRowNames(), {'Mean'});
           
           d = dataMatrix.mean('Direction', 'column');
           testCase.verifyEqual(d.data, mean(data, 1));
           testCase.verifyEqual(d.getColumnNames(), {'Paris', 'NY', 'NY and Brussels'});
           testCase.verifyEqual(d.getRowNames(), {'Mean'});
           
           d = dataMatrix.mean('Direction', 'row');
           testCase.verifyEqual(d.data, mean(data, 2));
           testCase.verifyEqual(d.getColumnNames(), {'Mean'});
           testCase.verifyEqual(d.getRowNames(), {'Q1', 'Q2', 'Q3', 'Q4'});
           
           d = dataMatrix.mean('Direction', 'row');
           testCase.verifyEqual(d.data, mean(data, 2));
           testCase.verifyEqual(d.getColumnNames(), {'Mean'});
           testCase.verifyEqual(d.getRowNames(), {'Q1', 'Q2', 'Q3', 'Q4'});
           
           %std
           d = dataMatrix.std();
           testCase.verifyEqual(d.data, std(data, 0, 1));
           testCase.verifyEqual(d.data, std(data));
           testCase.verifyEqual(d.getColumnNames(), {'Paris', 'NY', 'NY and Brussels'});
           testCase.verifyEqual(d.getRowNames(), {'Std'});
           
           d = dataMatrix.std('Direction', 'column');
           testCase.verifyEqual(d.data, std(data, 0, 1));
           testCase.verifyEqual(d.getColumnNames(), {'Paris', 'NY', 'NY and Brussels'});
           testCase.verifyEqual(d.getRowNames(), {'Std'});
           
           d = dataMatrix.std('Direction', 'row');
           testCase.verifyEqual(d.data, std(data, 0, 2));
           testCase.verifyEqual(d.getColumnNames(), {'Std'});
           testCase.verifyEqual(d.getRowNames(), {'Q1', 'Q2', 'Q3', 'Q4'});
           
           d = dataMatrix.std('Direction', 'row');
           testCase.verifyEqual(d.data, std(data, 0, 2));
           testCase.verifyEqual(d.getColumnNames(), {'Std'});
           testCase.verifyEqual(d.getRowNames(), {'Q1', 'Q2', 'Q3', 'Q4'});
           
           d = dataMatrix.std('Unbiased', false);
           testCase.verifyEqual(d.data, std(data, 1, 1));
           testCase.verifyEqual(d.getColumnNames(), {'Paris', 'NY', 'NY and Brussels'});
           testCase.verifyEqual(d.getRowNames(), {'Std'});
           
           d = dataMatrix.std('Unbiased', false, 'Direction', 'row');
           testCase.verifyEqual(d.data, std(data, 1, 2));
           testCase.verifyEqual(d.getColumnNames(), {'Std'});
           testCase.verifyEqual(d.getRowNames(), {'Q1', 'Q2', 'Q3', 'Q4'});
       end
       
       function testSort(testCase)
            d = [16     2     3
                5    11    10
                9     7     6
                4    14    15];
            dm = biotracs.data.model.DataMatrix(d);
            dm.setRowNames({'a','b','c','d'});
            dm.setRowTag(3, 'oui', 1);
            dm.setRowTag(1, 'non', pi);
            dm.setColumnNames({'c1','c2','c3'});
            
            sdm = dm.sortRows();
            expectedData = [4    14    15
                            5    11    10
                            9     7     6
                            16     2     3];
            
           testCase.verifyEqual(sdm.data, expectedData);
           testCase.verifyEqual(sdm.rowNames, {'d'  'b'  'c'  'a'});
           testCase.verifyEqual(sdm.columnNames, dm.columnNames);
           testCase.verifyEqual(sdm.getRowTag(3), struct('oui',1));
           testCase.verifyEqual(sdm.getRowTag(4), struct('non',pi));
           testCase.verifyEqual(sdm.getRowTag(1), []);
       end
        
       function testCorr(testCase)
           x = randn(30,4);
           y = randn(30,2);
           
           dx = biotracs.data.model.DataMatrix(x,'CX','RX');
           dy = biotracs.data.model.DataMatrix(y,'CY','RY');
           
           [dr,dp] = corr(dx,dy);
           [r,p] = corr(x,y);
           dr.summary();
           dp.summary();
           
           testCase.verifyEqual(dr.data, r);
           testCase.verifyEqual(dp.data, p);
           testCase.verifyEqual(dr.rowNames, dx.columnNames);
           testCase.verifyEqual(dr.columnNames, dy.columnNames);
       end
       
       
       function testExportAsCsv( testCase )
           x = randn(30,4);           
           d1 = biotracs.data.model.DataMatrix(x,'CX','RX');
           d1.export( fullfile(testCase.workingDir, 'data.csv') );
           d2 = biotracs.data.model.DataMatrix.import( fullfile(testCase.workingDir, 'data.csv') );
           
           d1.summary();
           d2.summary();
           
           testCase.verifyEqual(d1.rowNames, d2.rowNames);
           testCase.verifyEqual(d1.columnNames, d2.columnNames);
           testCase.verifyEqual(d1.data, d2.data, 'AbsTol', 1e-9);
       end
       
       function testSortByRowNames( testCase )
            data = {
                2.5,  2.3,    1.2;
                3.3,    1.004,  0.5;
                3.3,     12345,    -1.1;
                0,     657.6,  34.5
                };
            dataTable = biotracs.data.model.DataTable( data );
            colNames = {'Paris', 'NY', 'NYandBrussels'};
            rowNames = {'Q3', 'Q7', 'Q6', 'Q1'};
            dataTable.setColumnNames(colNames);
            dataTable.setRowNames(rowNames);
            
            sdata = {
                0,     657.6,  34.5;
                2.5,  2.3,    1.2;
                3.3,     12345,    -1.1;
                3.3,    1.004,  0.5;
                };
            
            dataTable2 = dataTable.sortByRowNames();
            
            summary(dataTable)
            summary(dataTable2)
            
            testCase.verifyEqual( dataTable2.data, sdata );
            testCase.verifyEqual( dataTable2.columnNames, colNames );
            testCase.verifyEqual( dataTable2.rowNames, {'Q1', 'Q3', 'Q6', 'Q7'} );
       end
        
    end
    
end
