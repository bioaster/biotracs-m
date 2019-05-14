classdef DataNormalizerTests < matlab.unittest.TestCase
    
    properties
        workingDir = fullfile(biotracs.core.env.Env.workingDir(), '/spectra/dataproc/DataNormalizerTests');
    end
    
    methods (Test)
        
        function testSimpleTests(testCase)
            %create random data
            ncols = 5000; nrows = 20;
            mu = 1; sigma = 2;
            data = normrnd(mu,sigma,nrows,ncols);
            data(10:20,:) = normrnd(mu+3,sigma*1.5,11,ncols);
            rownames = strcat('City:Paris_Rep:', arrayfun(@num2str, 1:nrows,'UniformOutput',false));
            colnames = strcat('F', arrayfun(@num2str, 1:ncols,'UniformOutput',false));
            dataSet = biotracs.data.model.DataSet(data, colnames, rownames);

            process = biotracs.dataproc.model.DataNormalizer();
            c = process.getConfig();
            c.updateParamValue('Method','snv');
            c.updateParamValue('Direction','row');
            c.updateParamValue('WorkingDirectory',testCase.workingDir);
            process.setInputPortData('DataMatrix', dataSet);
            process.run();
            normalizedDataSet = process.getOutputPortData('DataMatrix');
            testCase.verifyEqual( mean(normalizedDataSet.data,2), zeros(nrows,1), 'AbsTol', 1e-6 );
            testCase.verifyEqual( std(normalizedDataSet.data,0,2), ones(nrows,1), 'AbsTol', 1e-6 );
            
            
            process = biotracs.dataproc.model.DataNormalizer();
            c = process.getConfig();
            c.updateParamValue('Method','snv');
            c.updateParamValue('Direction','column');
            c.updateParamValue('WorkingDirectory',testCase.workingDir);
            process.setInputPortData('DataMatrix', dataSet);
            process.run();
            normalizedDataSet = process.getOutputPortData('DataMatrix');
            testCase.verifyEqual( mean(normalizedDataSet.data,1), zeros(1,ncols), 'AbsTol', 1e-6 );
            testCase.verifyEqual( std(normalizedDataSet.data,0,1), ones(1,ncols), 'AbsTol', 1e-6 );
            
            
            process = biotracs.dataproc.model.DataNormalizer();
            c = process.getConfig();
            c.updateParamValue('Method','quantile');
            c.updateParamValue('Direction','row');
            c.updateParamValue('WorkingDirectory',testCase.workingDir);
            process.setInputPortData('DataMatrix', dataSet);
            process.run();
            normalizedDataSet = process.getOutputPortData('DataMatrix');
            
            
            %check that quantiles are the same
            N = ncols;
            q = quantile(normalizedDataSet.data,N,2);
            testCase.verifyEqual( q(1,:), q(2,:), 'AbsTol', 1e-6 );
            testCase.verifyEqual( q(1,:), q(end,:), 'AbsTol', 1e-6 );
            
            %check that quantiles are the same
            figure();
            plot(q(1,:), q(2,:));
            title('Quantile comparison');
            xlabel('Sample 1 points');
            ylabel('Sample 2 points');
            grid on;
            
            %plot original data distribution
            dataSet.view(...
                'DistributionPlot', ...
                'Direction', 'row', ...
                'ShowDensity', true, ...
                'title', 'Before quantile normalization' ...
                );
            
            normalizedDataSet.view(...
                'DistributionPlot', ...
                'Direction', 'row', ...
                'ShowDensity', true, ...
                'title', 'After quantile normalization' ...
                );
        end    
    end
    
    methods(Access = protected)
 
    end
    
end
