classdef DataFilterTests < matlab.unittest.TestCase
    
    properties
        workingDir = fullfile(biotracs.core.env.Env.workingDir(), '/biotracs/dataproc/DataFilterTests');
    end
    
    methods (Test)
        
        function testFilterColumns(testCase)
            s1 = RandStream.create('mrg32k3a','Seed', 42);
            s0 = RandStream.setGlobalStream(s1);

            offset = 10;
            data1 = normrnd(1,0.5,50,100);
            data2 = normrnd(2,0.1,50,100)+offset;
            data3 = normrnd(1,0.5,50,100)-offset;
            data = [ data1, data2, data3 ];
            dataMatrix = biotracs.data.model.DataMatrix(data);
            
            %nothing will be removed
            filter = biotracs.dataproc.model.DataFilter();
            filter.setInputPortData('DataMatrix', dataMatrix);
            filter.run();
            filteredDataMatrix = filter.getOutputPortData('DataMatrix');
            testCase.verifyEqual(filteredDataMatrix.data, dataMatrix.data);
                        
            %remove columns with mean < 1.5
            filter = biotracs.dataproc.model.DataFilter();
            filter.getConfig()...
                .updateParamValue('MinAverage',1.5);
            filter.setInputPortData('DataMatrix', dataMatrix);
            filter.run();
            filteredDataMatrix = filter.getOutputPortData('DataMatrix');
            testCase.verifyEqual(filteredDataMatrix.data, data2);
            
            %remove columns with mean < offset+10
            filter = biotracs.dataproc.model.DataFilter();
            filter.getConfig()...
                .updateParamValue('MinAverage',offset+10);
            filter.setInputPortData('DataMatrix', dataMatrix);
            filter.run();
            filteredDataMatrix = filter.getOutputPortData('DataMatrix');
            testCase.verifyEmpty(filteredDataMatrix.data);
            
            %remove columns with all values < 3
            filter = biotracs.dataproc.model.DataFilter();
            filter.getConfig()...
                .updateParamValue('MinValue',3);
            filter.setInputPortData('DataMatrix', dataMatrix);
            filter.run();
            filteredDataMatrix = filter.getOutputPortData('DataMatrix');
            testCase.verifyEqual(filteredDataMatrix.data, data2);
            
            %remove columns with std < 0.15
            filter = biotracs.dataproc.model.DataFilter();
            filter.getConfig()...
                .updateParamValue('MinStandardDeviation',0.3);
            filter.setInputPortData('DataMatrix', dataMatrix);
            filter.run();
            filteredDataMatrix = filter.getOutputPortData('DataMatrix');
            testCase.verifyEqual(filteredDataMatrix.data, [data1, data3]);
            
            % Restore random stream
            RandStream.setGlobalStream(s0);
        end
     
        function testFilterRows(testCase)
            s1 = RandStream.create('mrg32k3a','Seed', 42);
            s0 = RandStream.setGlobalStream(s1);
            
            offset = 10;
            data1 = normrnd(1,0.5,50,100);
            data2 = normrnd(2,0.1,50,100)+offset;
            data3 = normrnd(1,0.5,50,100)-offset;
            data = [ data1; data2; data3 ];
            dataMatrix = biotracs.data.model.DataMatrix(data);
            
            %nothing will be removed
            filter = biotracs.dataproc.model.DataFilter();
            filter.getConfig()...
                .updateParamValue('Direction','row');
            filter.setInputPortData('DataMatrix', dataMatrix);
            filter.run();
            filteredDataMatrix = filter.getOutputPortData('DataMatrix');
            testCase.verifyEqual(filteredDataMatrix.data, dataMatrix.data);
                        
            %remove columns with mean < 1.5
            filter = biotracs.dataproc.model.DataFilter();
            filter.getConfig()...
                .updateParamValue('Direction','row')...
                .updateParamValue('MinAverage',1.5);
            filter.setInputPortData('DataMatrix', dataMatrix);
            filter.run();
            filteredDataMatrix = filter.getOutputPortData('DataMatrix');
            testCase.verifyEqual(filteredDataMatrix.data, data2);
            
            %remove columns with mean < offset+10
            filter = biotracs.dataproc.model.DataFilter();
            filter.getConfig()...
                .updateParamValue('Direction','row')...
                .updateParamValue('MinAverage',offset+10);
            filter.setInputPortData('DataMatrix', dataMatrix);
            filter.run();
            filteredDataMatrix = filter.getOutputPortData('DataMatrix');
            testCase.verifyEmpty(filteredDataMatrix.data);
            
            %remove columns with all values < 3
            filter = biotracs.dataproc.model.DataFilter();
            filter.getConfig()...
                .updateParamValue('Direction','row')...
                .updateParamValue('MinValue',3);
            filter.setInputPortData('DataMatrix', dataMatrix);
            filter.run();
            filteredDataMatrix = filter.getOutputPortData('DataMatrix');
            testCase.verifyEqual(filteredDataMatrix.data, data2);
            
            %remove columns with std < 0.3
            filter = biotracs.dataproc.model.DataFilter();
            filter.getConfig()...
                .updateParamValue('Direction','row')...
                .updateParamValue('MinStandardDeviation',0.3);
            filter.setInputPortData('DataMatrix', dataMatrix);
            filter.run();
            filteredDataMatrix = filter.getOutputPortData('DataMatrix');
            testCase.verifyEqual(filteredDataMatrix.data, [data1;data3]);
            
            % Restore random stream
            RandStream.setGlobalStream(s0);
        end
        
    end
    
end