classdef ResponseDataCreatorTests < matlab.unittest.TestCase
    
    properties
        workingDir = fullfile(biotracs.core.env.Env.workingDir(), '/biotracs/dataproc/ResponseDataCreatorTests');
    end
    
    methods (Test)
        
        function testResponseDataCreator1(testCase)
            rowNames = [ repmat({'Group:A_Sex:M'}, 1,5), repmat({'Group:B_Sex:F'},1,5), repmat({'Group:C_Sex:F'},1,5) ];
            dataSet = biotracs.data.model.DataSet( rand(15,20), 'C', rowNames );
            %dataSet.setRowNamePatterns();
            
            creator = biotracs.dataproc.model.ResponseDataCreator();
            creator.getConfig()...
                .updateParamValue('ResponseNames', {'C1', 'C5', 'C13', 'C20'})...
                .updateParamValue('CreateBooleanReponses', false);
            creator.setInputPortData('DataSet', dataSet);
            creator.run();
            
            XYDataSet = creator.getOutputPortData('DataSet');
            testCase.verifyEqual( XYDataSet.getOutputIndexes(), [1, 5, 13, 20] );
            testCase.verifyEqual( XYDataSet.columnNames, dataSet.columnNames );
            testCase.verifyEqual( XYDataSet.rowNames, dataSet.rowNames );
        end
        
        
        function testResponseDataCreator2(testCase)
            rowNames = [ repmat({'Group:A_Sex:M'}, 1,5), repmat({'Group:B_Sex:F'},1,5), repmat({'Group:C_Sex:F'},1,5) ];
            dataSet = biotracs.data.model.DataSet( rand(15,20), 'C', rowNames );
            dataSet.setRowNamePatterns({'Group'});
            
            creator = biotracs.dataproc.model.ResponseDataCreator();
            creator.getConfig()...
                .updateParamValue('CreateBooleanReponses', true);
            creator.setInputPortData('DataSet', dataSet);
            creator.run();
            
            XYDataSet = creator.getOutputPortData('DataSet');
            testCase.verifyEqual( XYDataSet.getOutputIndexes(), [21, 22, 23] );
            testCase.verifyEqual( XYDataSet.columnNames, [dataSet.columnNames, {'Group:A','Group:B','Group:C'}] );
            testCase.verifyEqual( XYDataSet.rowNames, dataSet.rowNames );
            y = [ [true(5,1); false(10,1)], [false(5,1); true(5,1); false(5,1)],  [false(10,1); true(5,1)]];
            testCase.verifyEqual( XYDataSet.selectYSet.data, double(y) );
        end
        
        function testResponseDataCreator3(testCase)
            rowNames = [ repmat({'Group:A_Sex:M'}, 1,5), repmat({'Group:B_Sex:F'},1,5), repmat({'Group:C_Sex:F'},1,5) ];
            dataSet = biotracs.data.model.DataSet( rand(15,20), 'C', rowNames );
            dataSet.setRowNamePatterns({'Group'});
            
            creator = biotracs.dataproc.model.ResponseDataCreator();
            creator.getConfig()...
                .updateParamValue('CreateBooleanReponses', true)...
                .updateParamValue('RowNamePatterns', {'Sex'});
            creator.setInputPortData('DataSet', dataSet);
            creator.run();
            
            XYDataSet = creator.getOutputPortData('DataSet');
            testCase.verifyEqual( XYDataSet.getOutputIndexes(), [21, 22] );
            testCase.verifyEqual( XYDataSet.columnNames, [dataSet.columnNames, {'Sex:F','Sex:M'}] );
            testCase.verifyEqual( XYDataSet.rowNames, dataSet.rowNames );
            y = [ [false(5,1); true(10,1)], [true(5,1); false(10,1)] ];
            testCase.verifyEqual( XYDataSet.selectYSet.data, double(y) );
        end
        
    end
    
end