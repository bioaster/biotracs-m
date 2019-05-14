classdef DataTableTests < matlab.unittest.TestCase
    
    properties
        workingDir = fullfile(biotracs.core.env.Env.workingDir(), '/biotracs/data/DataTableTests');
    end
 
    methods (Test)
        function testDefaultConstructor(testCase)
            data = biotracs.data.model.DataTable();
            testCase.verifyClass(data, 'biotracs.data.model.DataTable');
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
            
            dataTable = biotracs.data.model.DataTable();
            dataTable.setDataFromArray( values );
            dataTable.setProcess(process);
            dataTable.setDescription('Short description');
            testCase.verifyClass(dataTable, 'biotracs.data.model.DataTable');
            testCase.verifyEqual(dataTable.description, 'Short description');
            testCase.verifyEqual(dataTable.process, process);
            testCase.verifyEqual( cell2mat(dataTable.getData()), values);
            
            testCase.verifyEqual( dataTable.getNbRows() , 4 );
            testCase.verifyEqual( dataTable.getNbColumns() , 3 );
            testCase.verifyEqual( dataTable.getRowTags() , cell(1,4) );
            testCase.verifyEqual( dataTable.getColumnTags() , cell(1,3) );
            
            %tags
            testCase.verifyEqual( dataTable.getDataByColumnTag({'input', 'yes'}) , cell(4,0) );
            
            dataTable.setColumnTag( 2, 'input', 'yes' );
            t = dataTable.getColumnTag(2);
            testCase.verifyEqual( t.input, 'yes');
            
            testCase.verifyEqual( cell2mat(dataTable.getDataByColumnTag({'input', 'yes'})) , values(:,2) ) ;
            testCase.verifyEqual( cell2mat(dataTable.getDataByColumnTag({'input', '~yes'})) , values(:,[1,3]) );
        end
        
        
        function testColumnName(testCase)

            values = [   1,      2.3,    1.2;
                3.3,    1.004,  0.5;
                23,     456,    -1.1;
                34,     657.6,  34.5];
            
            dataTable = biotracs.data.model.DataTable();
            dataTable.setDataFromArray( values );
            
            dataTable.setColumnName(1, 'input_c1');
            dataTable.setColumnName(3, 'Blank_output_c1_c3');
            
            testCase.verifyEqual( dataTable.getNbRows(), 4 );
            testCase.verifyEqual( dataTable.getNbColumns(), 3 );
            testCase.verifyEqual( cell2mat(dataTable.getDataByColumnName('c1')), values(:,[1,3]), 'AbsTol', 1e-9 );
        end
        
        function testGetByName(testCase)

            data = {    'abc',  2.3,    1.2;
                3.3,    1.004,  0.5;
                3.3,     'oui',    -1.1;
                {1,'b'},     657.6,  34.5};
            
            dataTable = biotracs.data.model.DataTable( data );
            dataTable.setColumnNames({'Paris', 'NY', 'NY and Brussels'});
            dataTable.setRowNames({'Q1', 'Q2', 'Q3', 'Q4'});
            
            testCase.verifyEqual( dataTable.getDataByRowAndColumnName( 'Q1', 'Paris' ), {'abc'} );
            testCase.verifyEqual( dataTable.getDataByRowAndColumnName( 'Q1', 'NY.*' ), {2.3, 1.2} );
        end
        
        function testSelect(testCase)

            data = {      'abc',  2.3,    1.2;
                3.3,    1.004,  0.5;
                3.3,     'oui',    -1.1;
                {1,'b'},     657.6,  34.5};
            
            dataTable = biotracs.data.model.DataTable( data );
            dataTable.setColumnNames({'Paris', 'NY', 'NY and Brussels'});
            dataTable.setRowNames({'Q1', 'Q2', 'Q3', 'Q4'});
            
            dataTable.setColumnTag(1, 'groupIndex', 1)...
                .setColumnTag(1, 'groupName', 'SingleCity')...
                .setColumnTag(2, 'groupIndex', 1)...
                .setColumnTag(2, 'groupName', 'SingleCity')...
                .setColumnTag(3, 'groupIndex', 2)...
                .setColumnTag(3, 'groupName', 'DoubleCity');
            
            testCase.verifyEqual( dataTable.getNbRows(), 4 );
            
            %query all tables
            testCase.verifyEqual( dataTable.select(), dataTable )
            
            %query sub-table NY
            dataNY = {      2.3,    1.2;
                1.004,  0.5;
                'oui',    -1.1;
                657.6,  34.5};
            
            dataTableNY = biotracs.data.model.DataTable( dataNY );
            dataTableNY.setColumnNames({'NY', 'NY and Brussels'});
            dataTableNY.setRowNames({'Q1', 'Q2', 'Q3', 'Q4'});
            dataTableNY.setColumnTag(1, 'groupIndex', 1)...
                .setColumnTag(1, 'groupName', 'SingleCity')...
                .setColumnTag(2, 'groupIndex', 2)...
                .setColumnTag(2, 'groupName', 'DoubleCity');
            
            
            testCase.verifyEqual( dataTable.selectByColumnName( 'NY' ), dataTableNY );
            testCase.verifyEqual( dataTable.selectByColumnIndexes( [2,3] ), dataTableNY )
            
            
            %query sub-table NY$
            testCase.verifyEqual( dataTable.selectByColumnName( 'NY' ), dataTableNY.selectByColumnName( 'NY' ) );
            testCase.verifyEqual( dataTable.selectByColumnName( 'NY$' ), dataTableNY.selectByColumnName( 'NY$' ) );
            testCase.verifyEqual( dataTable.selectByColumnName( 'NY$' ).getNbColumns(), 1 );
            
            %invariant selections
            testCase.verifyEqual( dataTable.select('WhereColumns', '.*'), dataTable );
            testCase.verifyEqual( dataTable.select('MatchAgainst', '.*'), dataTable );
            testCase.verifyEqual( dataTable.select('WhereColumns', '.*', 'MatchAgainst', '.*'), dataTable );
            
            testCase.verifyEqual( dataTable.select('WhereColumns', 'NY', 'MatchAgainst', '.*', 'FilterByColumnName', 'NY'), dataTableNY );
            testCase.verifyEqual( dataTable.select('MatchAgainst', '.*', 'FilterByColumnName', 'NY'), dataTableNY );
            
            %match values
            testCase.verifyEqual( dataTable.select('WhereColumns', '^NY$', 'EqualTo', 1.004).getData(), { 3.3, 1.004,  0.5 } );
            testCase.verifyEqual( dataTable.select('WhereColumns', '^Par.*', 'EqualTo', 3.3).getData(), { 3.3, 1.004,  0.5; 3.3, 'oui', -1.1 } );
            testCase.verifyEqual( dataTable.select('WhereColumns', '^NY$|Paris', 'EqualTo', 1.004).getData(), { 3.3, 1.004,  0.5 } );
            
            %filter by colname
            testCase.verifyEqual( dataTable.select('MatchAgainst', '.*', 'FilterByColumnName', 'NY'), dataTable.select('FilterByColumnName', 'NY') );
            testCase.verifyEqual( dataTable.select('MatchAgainst', '.*', 'FilterByColumnName', 'NY'), dataTableNY.select('FilterByColumnName', 'NY', 'MatchAgainst', '.*') );
            testCase.verifyEqual( dataTable.select('MatchAgainst', '.*', 'FilterByColumnName', 'NY$'), dataTableNY.select('FilterByColumnName', 'NY$', 'MatchAgainst', '.*') );
            
            %filter by tags
            dataTableFiltered = biotracs.data.model.DataTable( data(:,[1,2]) );
            dataTableFiltered.setColumnNames({'Paris', 'NY'});
            dataTableFiltered.setRowNames({'Q1', 'Q2', 'Q3', 'Q4'});
            dataTableFiltered.setColumnTag(1, 'groupIndex', 1)...
                .setColumnTag(1, 'groupName', 'SingleCity')...
                .setColumnTag(2, 'groupIndex', 1)...
                .setColumnTag(2, 'groupName', 'SingleCity');
            testCase.verifyEqual( dataTable.select('WhereColumns', 'NY', 'MatchAgainst', '.*', 'FilterByColumnTag', {'groupName', 'SingleCity'}), dataTableFiltered );
            testCase.verifyEqual( dataTable.select('WhereColumns', 'NY', 'MatchAgainst', '.*', 'FilterByColumnTag', {'groupName', '~DoubleCity'}), dataTableFiltered );
        end
        
        function testSelectByRow(testCase)

            data = {      'abc',  2.3,    1.2;
                3.3,    1.004,  0.5;
                3.3,     'oui',    -1.1;
                {1,'b'},     657.6,  34.5};
            
            dataTable = biotracs.data.model.DataTable( data );
            dataTable.setColumnNames({'Paris', 'NY', 'NY and Brussels'});
            dataTable.setRowNames({'Health', 'Diet', 'Health and Diet', 'Medication'});
            
            
            %query sub-table NY
            dataHealth = {      'abc',  2.3,    1.2;
                3.3,     'oui',    -1.1};
            dataTableHealth = biotracs.data.model.DataTable( dataHealth );
            dataTableHealth.setColumnNames({'Paris', 'NY', 'NY and Brussels'});
            dataTableHealth.setRowNames({'Health', 'Health and Diet'});
            
            testCase.verifyEqual( dataTable.selectByRowName( '.*' ), dataTable )
            testCase.verifyEqual( dataTable.selectByRowName( 'Health' ), dataTableHealth )
            
            
            testCase.verifyEqual( dataTable.select('FilterByRowName', 'Health'), dataTableHealth );
            testCase.verifyEqual( dataTable.select('FilterByRowName', 'Health$').getData(), dataHealth(1,:) );
        end
        
        function testRemoveByRow(testCase)

            data = {      'abc',  2.3,    1.2;
                3.3,    1.004,  0.5;
                3.3,     'oui',    -1.1;
                {1,'b'},     657.6,  34.5};
            
            dataTable = biotracs.data.model.DataTable( data );
            dataTable.setColumnNames({'Paris', 'NY', 'NY and Brussels'});
            dataTable.setRowNames({'Health', 'Medication', 'Health and Diet', 'Medication and Sport'});
            %query sub-table NY
            dataNotHealth = {       3.3,    1.004,  0.5;
                {1,'b'},     657.6,  34.5};
            dataTableNotHealth = biotracs.data.model.DataTable( dataNotHealth );
            dataTableNotHealth.setColumnNames({'Paris', 'NY', 'NY and Brussels'});
            dataTableNotHealth.setRowNames({'Medication', 'Medication  and Sport'});
            
            testCase.verifyTrue( dataTable.removeByRowName( '.*' ).hasEmptyData() )
            testCase.verifyEqual( dataTable.removeByRowName( 'Health' ).data, dataTableNotHealth.data )
            
            testCase.verifyEqual( dataTable.select('FilterByRowName', 'Medication').data, dataTableNotHealth.data );
            testCase.verifyEqual( dataTable.select('FilterByRowName', 'Sport$').getData(), dataNotHealth(2,:) );
        end
        
        function testHorzcat(testCase)

            data1 = {'abc',  2.3,    1.2;
                3.3,    1.004,  0.5;
                3.3,     'oui',    -1.1;
                {1,'b'},     657.6,  34.5};
            dataTable1 = biotracs.data.model.DataTable( data1 );
            dataTable1.setColumnNames({'Paris', 'NY', 'NY and Brussels'});
            dataTable1.setRowNames({'Q1', 'Q2', 'Q3', 'Q4'});
            
            data2 = {'abcef',  4.3;
                pi,    0;
                3.3,     'non';
                {'b'},     [1,2]};
            dataTable2 = biotracs.data.model.DataTable( data2 );
            dataTable2.setColumnNames({'Abidjan', 'Beijin'});
            dataTable2.setRowNames({'Q1', 'Q2', 'Q10', 'Q11'});
            
            cdata = horzcat(data1,data2);
            expectedDataTable = biotracs.data.model.DataTable( cdata );
            expectedDataTable.setColumnNames({'Paris', 'NY', 'NY and Brussels','Abidjan', 'Beijin'});
            expectedDataTable.setRowNames({'Q1', 'Q2', 'Q3', 'Q4'});
            
            horzcatDataTable = dataTable1.horzcat( dataTable2 );
            testCase.verifyEqual( horzcatDataTable, expectedDataTable );
        end
        
        function testVertcat(testCase)

            data1 = {'abc',  2.3,    1.2;
                3.3,    1.004,  0.5;
                3.3,     'oui',    -1.1;
                {1,'b'},     657.6,  34.5};
            dataTable1 = biotracs.data.model.DataTable( data1 );
            dataTable1.setColumnNames({'Paris', 'NY', 'NY and Brussels'});
            dataTable1.setRowNames({'Q1', 'Q2', 'Q3', 'Q4'});
            
            data2 = {'abcef',  2.3,    1.2;
                pi,    1.2, 1.5;
                3.3,     '@',    pi/4};
            dataTable2 = biotracs.data.model.DataTable( data2 );
            dataTable2.setColumnNames({'Paris', 'NY', 'Beijin'});
            dataTable2.setRowNames({'Q11', 'Q20', 'Q34'});
            
            cdata = vertcat(data1,data2);
            expectedDataTable = biotracs.data.model.DataTable( cdata );
            expectedDataTable.setColumnNames({'Paris', 'NY', 'NY and Brussels'});
            expectedDataTable.setRowNames({'Q1', 'Q2', 'Q3', 'Q4', 'Q11', 'Q20', 'Q34'});
            
            vertcatDataTable = dataTable1.vertcat( dataTable2 );
            testCase.verifyEqual( vertcatDataTable, expectedDataTable );
        end
        
        function testTranspose(testCase)

            data = {      'abc',  2.3,    1.2;
                3.3,    1.004,  0.5;
                3.3,     'oui',    -1.1;
                {1,'b'},     657.6,  34.5};
            
            dataTable = biotracs.data.model.DataTable( data );
            dataTable.setColumnNames({'Paris', 'NY', 'NY and Brussels'});
            dataTable.setRowNames({'Q1', 'Q2', 'Q3', 'Q4'});
            
            dataTable.setColumnTag(1, 'groupIndex', 1)...
                .setColumnTag(1, 'groupName', 'SingleCity')...
                .setColumnTag(2, 'groupIndex', 1)...
                .setColumnTag(2, 'groupName', 'SingleCity')...
                .setColumnTag(3, 'groupIndex', 2)...
                .setColumnTag(3, 'groupName', 'DoubleCity');
            
            dataTable.setRowTag(3, 'gender', 'M');
            
            tDataTable = dataTable.transpose();
            testCase.verifyClass( tDataTable, 'biotracs.data.model.DataTable' );
            testCase.verifyEqual( tDataTable.getData(), transpose(dataTable.getData) );
            testCase.verifyEqual( tDataTable.getRowNames(), dataTable.getColumnNames() );
            testCase.verifyEqual( tDataTable.getColumnNames(), dataTable.getRowNames() );
            testCase.verifyEqual( tDataTable.getColumnTags(), dataTable.getRowTags() );
            testCase.verifyEqual( tDataTable.getRowTags(), dataTable.getColumnTags() );
        end
        
        function testCopyConstructor(testCase)

            data = {   1,      2.3,    1.2;
                3.3,    1.004,  0.5;
                23,     456,    -1.1; };
            
            do = biotracs.data.model.DataObject( data );
            
            %cast DataObject -> DataTable
            dt = biotracs.data.model.DataTable.fromDataObject(do);
            testCase.verifyClass(dt, 'biotracs.data.model.DataTable');
            testCase.verifyEqual(dt.data, data);
            dt.setColumnNames({'c1','c2','c3'});
            
            %reverse cast DataTable -> DataObject
            do2 = biotracs.data.model.DataObject.fromDataTable(dt);
            testCase.verifyEqual(do2, do);
        end
        
        function testExportAsCsv( testCase )

            data = {  'Snow',      'Oui',    'Non';
                'OVNI',    'John',  'UFO';
                'Robot',     'Naruto',    'Winter is comming!'; };
            d1 = biotracs.data.model.DataTable(data,'CX','RX');
            d1.setRowTag(1, 'a', {'oui'});
            d1.setRowTag(1, 'b', {'oui','non'});
            
            d1.setColumnTag(2,'Paris', {'France','UE'});
            d1.setColumnTag(2,'NY', {'US','America'});
            
            d1.export( fullfile(testCase.workingDir, 'data.csv'), 'Delimiter', ',' );
            d2 = biotracs.data.model.DataTable.import( ...
                fullfile(testCase.workingDir, 'data.csv'), ...
                'Delimiter', ',');
            
            d1.summary();
            d2.summary();
  
            testCase.verifyEqual(d2.getProcess().getConfig().getParamValue('Delimiter'), ',');
            testCase.verifyEqual(d1.rowNames, d2.rowNames);
            testCase.verifyEqual(d1.columnNames, d2.columnNames);
            testCase.verifyEqual(d1.data, d2.data);

            testCase.verifyEqual(d2.getRowTag(1), struct('a',{{'oui'}}, 'b', {{'oui';'non'}}));
            testCase.verifyEqual(d2.getRowTag(2), struct('a',[], 'b', []));
            
            testCase.verifyEqual(d2.getColumnTag(1), struct('Paris', [], 'NY', []));
            testCase.verifyEqual(d2.getColumnTag(2), struct('Paris', {{'France';'UE'}}, 'NY', {{'US';'America'}}));
        end
        
        function testSortByRowNames( testCase )

            data = {
                'abc',  2.3,    1.2;
                3.3,    1.004,  0.5;
                3.3,     'oui',    -1.1;
                {1,'b'},     657.6,  34.5
                };
            dataTable = biotracs.data.model.DataTable( data );
            colNames = {'Paris', 'NY', 'NYandBrussels'};
            rowNames = {'Q3', 'Q7', 'Q6', 'Q1'};
            dataTable.setColumnNames(colNames);
            dataTable.setRowNames(rowNames);
            
            sdata = {
                {1,'b'},     657.6,  34.5;
                'abc',  2.3,    1.2;
                3.3,     'oui',    -1.1;
                3.3,    1.004,  0.5;
                };
            
            dataTable2 = dataTable.sortByRowNames();
            
            summary(dataTable)
            summary(dataTable2)
            
            testCase.verifyEqual( dataTable2.data, sdata );
            testCase.verifyEqual( dataTable2.columnNames, colNames );
            testCase.verifyEqual( dataTable2.rowNames, {'Q1', 'Q3', 'Q6', 'Q7'} );
        end
        
        function testSortByColumnNames( testCase )

            data = {
                'abc',  2.3,    1.2;
                3.3,    1.004,  0.5;
                3.3,     'oui',    -1.1;
                {1,'b'},     657.6,  34.5
                };
            dataTable = biotracs.data.model.DataTable( data );
            colNames = {'Paris', 'Abidjan', 'NYandBrussels'};
            rowNames = {'Q3', 'Q7', 'Q6', 'Q1'};
            dataTable.setColumnNames(colNames);
            dataTable.setRowNames(rowNames);
            
            sdata = {
                2.3,    1.2, 'abc';
                1.004,  0.5,    3.3;
                'oui',  -1.1,    3.3;
                657.6,  34.5,  {1,'b'}
                };
            
            dataTable2 = dataTable.sortByColumnNames();
            
            summary(dataTable)
            summary(dataTable2)
            
            testCase.verifyEqual( dataTable2.data, sdata );
            testCase.verifyEqual( dataTable2.columnNames, {'Abidjan', 'NYandBrussels', 'Paris'} );
            testCase.verifyEqual( dataTable2.rowNames, {'Q3', 'Q7', 'Q6', 'Q1'} );
        end
        
        
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
            
            mergedDataTable = dataTable1.vertmerge( dataTable2 );
            
            testCase.verifyEqual( mergedDataTable.columnNames, {'Paris', 'NY', 'NYandBrussels'} );
            testCase.verifyEqual( mergedDataTable.rowNames, {'Q1', 'Q2', 'Q3', 'Q4', 'Q11', 'Q20', 'Q34'} );
            testCase.verifyEqual( mergedDataTable.data, vertcat(dataTable1.data(:,[1,2,3]), dataTable2.data(:,[1,2,3])) );
            
            %summary(mergedDataTable)
            
            %test errors
            dataTable2.setColumnNames({'Paris', 'NY', 'NYandBrussels2'});
            try
                mergedDataTable = dataTable1.vertmerge( dataTable2 );
                error('BIOTRACS:UnexpectedError', 'An error was expected');
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
            
            mergedDataTable = dataTable1.horzmerge( dataTable2 );
            
            testCase.verifyEqual( mergedDataTable.columnNames, {'Paris', 'NY', 'London', 'Berlin', 'Shanghai'} );
            testCase.verifyEqual( mergedDataTable.rowNames, {'Q1', 'Q2', 'Q3', 'Q4'} );
            testCase.verifyEqual( mergedDataTable.data, horzcat(dataTable1.data([4,2,3,1],:), dataTable2.data([2,4,3,1],:)) );
            
            summary(mergedDataTable);
            
            %test errors
            dataTable2.setRowNames({'Q4', 'Q100', 'Q3', 'Q2'});
            try
                mergedDataTable = dataTable1.horzmerge( dataTable2 );
                error('BIOTRACS:UnexpectedError', 'An error was expected')
            catch exception
                testCase.verifyEqual( exception.identifier, 'BIOTRACS:DataTable:RowNameMismatchs' );
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
            
            mergedDataTable = dataTable1.horzmerge( dataTable2, 'Force', true );
            
            testCase.verifyEqual( mergedDataTable.columnNames, {'Paris', 'NY', 'London', 'Berlin', 'Shanghai'} );
            testCase.verifyEqual( mergedDataTable.rowNames, {'Q2', 'Q3', 'Q4'} );
            testCase.verifyEqual( mergedDataTable.data, horzcat(dataTable1.data([2,3,1],:), dataTable2.data([4,3,1],:)) );
            
            summary(mergedDataTable);
            
            %test errors
            dataTable2.setRowNames({'Q4', 'Q100', 'Q3', 'Q2'});
            try
                mergedDataTable = dataTable1.horzmerge( dataTable2 );
                error('BIOTRACS:UnexpectedError', 'An error was expected')
            catch exception
                testCase.verifyEqual( exception.identifier, 'BIOTRACS:DataTable:RowNameMismatchs' );
            end
        end
        
        function testSelectRowByTags(testCase)
            data1 = {'abc',  2.3;
                3.3,    1.004;
                3.3,     'oui';
                {1,'b'},     657.6};
            dataTable1 = biotracs.data.model.DataTable( data1 );
            dataTable1.setColumnNames({'Paris', 'NY'});
            dataTable1.setRowNames({'Q4', 'Q2', 'Q3', 'Q0'});
            rtags = {'Name1', 'Name2', 'Name3', 'Name4'};
            ctags = {'City1', 'City2'};
            for i= 1: length(dataTable1.rowNames)
                dataTable1.setRowTag(i, 'OriginalName', rtags(i));
            end
            for i= 1: length(dataTable1.columnNames)
                dataTable1.setColumnTag(i, 'OriginalName', ctags(i));
            end
            
            datatag = {   'abc',  2.3 };
            dataTableTag = biotracs.data.model.DataTable( datatag );
            idx = dataTable1.getRowIndexesByTag({'OriginalName','Name1'});
            testCase.verifyEqual( idx, 1 );
            datTableSelectByRowTag = dataTable1.selectByRowTag({'OriginalName','Name1'});
            testCase.verifyEqual(datTableSelectByRowTag.data, dataTableTag.data);
            dataTable1.removeByRowTag({'OriginalName', 'Name1'})
        end
        
        function testRemoveByColumnIndexes(testCase)
            data1 = {'abc',  2.3,5,9;
                3.3,    1.004, 2 , 9;
                3.3,     'oui', 'non', 'oui';
                {1,'b'},     657.6, 5.2, 9.2;
                1,2,3,4};
            dataTable1 = biotracs.data.model.DataTable( data1 );
            dataTable1.setColumnNames({'Paris', 'NY', 'Brussels', 'Beirut'});
            dataTable1.setRowNames({'Q5', 'Q4', 'Q2', 'Q3', 'Q0'});

            dataColRemoved = {'abc',  5;
                3.3,     2;
                3.3,      'non', ;
                {1,'b'},      5.2
                1,3};
            dataTableColumnRemoved = biotracs.data.model.DataTable( dataColRemoved );
            dataTableRemoveByColIndexes = dataTable1.removeByColumnIndexes([2,4]);
            testCase.verifyEqual(dataTableRemoveByColIndexes.data, dataTableColumnRemoved.data);

        end
        
        
        function testRemoveRowColumnByTags(testCase)
            data1 = {'abc',  2.3;
                3.3,    1.004;
                3.3,     'oui';
                {1,'b'},     657.6};
            dataTable1 = biotracs.data.model.DataTable( data1 );
            dataTable1.setColumnNames({'Paris', 'NY'});
            dataTable1.setRowNames({'Q4', 'Q2', 'Q3', 'Q0'});
            rtags = {'Name1', 'Name2', 'Name3', 'Name4'};
            ctags = {'City1', 'City2'};
            for i= 1: length(dataTable1.rowNames)
                dataTable1.setRowTag(i, 'OriginalName', rtags(i));
            end
            for i= 1: length(dataTable1.columnNames)
                dataTable1.setColumnTag(i, 'OriginalName', ctags(i));
            end
            
            dataRowremoved = {3.3,    1.004;
                3.3,     'oui';
                {1,'b'},     657.6};
            dataTableRowRemoved = biotracs.data.model.DataTable( dataRowremoved );
            dataColRemoved = {'abc';
                3.3;
                3.3;
                {1,'b'}};
            dataTableColumnRemoved = biotracs.data.model.DataTable( dataColRemoved );

            dataTableRemoveByRowTag = dataTable1.removeByRowTag({'OriginalName','Name1'});
            dataTableRemoveByColTag = dataTable1.removeByColumnTag({'OriginalName','City2'});

            testCase.verifyEqual(dataTableRemoveByRowTag.data, dataTableRowRemoved.data);
            testCase.verifyEqual(dataTableRemoveByColTag.data, dataTableColumnRemoved.data);

        end
        

    end
    
%     methods(Static)
%         
%         %% Create a DataTable
%         d1 = biotracs.data.model.DataMatrix( [1, 2; 3,4] );
%         d1.setColumnNames({'C1','C2'});
%         d1.setRowNames({'C1','C2'});
%         d1.summary();
%         
%         d2 = biotracs.data.model.DataTable( ...
%             {'k', 'b', 3; 'd', 'e', pi}, ...
%             {'Tokyo', 'Abidjan', 'Paris'}, ...
%             {'Beijin', 'NY'} );
%         d2.summary();
%     end
    
end
