classdef SubsamplerTests < matlab.unittest.TestCase

    properties
        workingDir = fullfile(biotracs.core.env.Env.workingDir(), '/spectra/dataproc/SubsamplerTests');
    end
    
    methods (Test)
        
        function testPassingData(testCase)
            filePath = '../testdata/metabolites.xlsx';
            dataMatrix = biotracs.data.model.DataMatrix.import( filePath );
            subsampler = biotracs.dataproc.model.Subsampler();
            subsampler.setInputPortData('DataMatrix', dataMatrix);
            subsampler.run();
            sampledDataMatrix = subsampler.getOutputPortData('DataMatrix');
            testCase.verifyEqual( dataMatrix, sampledDataMatrix );
        end
        
        function testSubsampling(testCase)
            filePath = '../testdata/metabolites.xlsx';
            dataMatrix = biotracs.data.model.DataMatrix.import( filePath );
            [m, n] = getSize(dataMatrix);
            
            subsampler = biotracs.dataproc.model.Subsampler();
            subsampler.setInputPortData('DataMatrix', dataMatrix);
            subsampler.getConfig()...
                .updateParamValue('SubsamplingRatio',0.5);
            subsampler.run();
            sampledDataMatrix = subsampler.getOutputPortData('DataMatrix');

            testCase.verifyEqual( getSize(sampledDataMatrix), [m/2, n] );
            testCase.verifyTrue( all(ismember(sampledDataMatrix.rowNames, dataMatrix.rowNames)) );
            testCase.verifyEqual( sampledDataMatrix.columnNames, dataMatrix.columnNames );
        end
     
        
        function testSubsamplingWithGroups(testCase)
            filePath = '../testdata/metabolites.xlsx';
            dataMatrix = biotracs.data.model.DataMatrix.import( filePath );
            [m, n] = getSize(dataMatrix);
            
            subsampler = biotracs.dataproc.model.Subsampler();
            subsampler.setInputPortData('DataMatrix', dataMatrix);
            subsampler.getConfig()...
                .updateParamValue('SubsamplingRatio',0.5)...
                .updateParamValue('GroupingSchema','Group');
            subsampler.run();
            sampledDataMatrix = subsampler.getOutputPortData('DataMatrix');
            
            grpStrat = biotracs.data.helper.GroupStrategy(sampledDataMatrix.rowNames, {'Group'});
            [logIdx] = grpStrat.getSlicesIndexes();
            
            nbGroup = 5;
            grpSize = (m/nbGroup) * 0.5;
            testCase.verifyEqual( sum(logIdx), [grpSize, grpSize, grpSize, grpSize, grpSize] );
            
            testCase.verifyEqual( getSize(sampledDataMatrix), [m/2, n] );
            testCase.verifyTrue( all(ismember(sampledDataMatrix.rowNames, dataMatrix.rowNames)) );
            testCase.verifyEqual( sampledDataMatrix.columnNames, dataMatrix.columnNames );
        end
        
    end
    
end