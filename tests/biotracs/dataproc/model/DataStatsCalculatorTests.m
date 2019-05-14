classdef DataStatsCalculatorTests < matlab.unittest.TestCase
    
    properties
        workingDir = fullfile(biotracs.core.env.Env.workingDir(), '/spectra/dataproc/DataStatsCalculatorTests');
    end
    
    methods (Test)
        
        function testCenterScaleColumns(testCase)
            %create random data
            ncols = 5000; nrows = 20;
            mu = 1; sigma = 2;
            data = normrnd(mu,sigma,nrows,ncols);
            data(10:20,:) = normrnd(mu+3,sigma*1.5,11,ncols);
            rownames = strcat('City:Paris_Rep:', arrayfun(@num2str, 1:nrows,'UniformOutput',false));
            colnames = strcat('F', arrayfun(@num2str, 1:ncols,'UniformOutput',false));
            dataMatrix = biotracs.data.model.DataMatrix(data, colnames, rownames);

            %check that data are not standardized
            testCase.verifyNotEqual( mean(dataMatrix.data,1), zeros(1, dataMatrix.getNbColumns()) );
            testCase.verifyNotEqual( std(dataMatrix.data,0,1), ones(1, dataMatrix.getNbColumns()) );
            
            process = biotracs.dataproc.model.DataStatsCalculator();
            process.setInputPortData('DataMatrix', dataMatrix);
            process.run();
            stats = process.getOutputPortData('Statistics');
            statMatrix = stats.get('StatsMatrix');
            testCase.verifyEqual( statMatrix.getDataByRowName('Mean'),  mean(dataMatrix.data));
            testCase.verifyEqual( statMatrix.getDataByRowName('Std'),  std(dataMatrix.data));
            testCase.verifyEqual( statMatrix.getDataByRowName('CV'),  std(dataMatrix.data) ./ mean(dataMatrix.data));
            
            
            process = biotracs.dataproc.model.DataStatsCalculator();
            process.setInputPortData('DataMatrix', dataMatrix);
            c = process.getConfig();
            c.updateParamValue('Direction', 'row');
            process.run();
            stats = process.getOutputPortData('Statistics');
            statMatrix = stats.get('StatsMatrix');
            testCase.verifyEqual( statMatrix.getDataByColumnName('Mean'),  mean(dataMatrix.data,2));
            testCase.verifyEqual( statMatrix.getDataByColumnName('Std'),  std(dataMatrix.data,0,2));
            testCase.verifyEqual( statMatrix.getDataByColumnName('CV'),  std(dataMatrix.data,0,2) ./ mean(dataMatrix.data,2));
        end
     
    end
    
    
    methods( Static )
        
    end
    
end
