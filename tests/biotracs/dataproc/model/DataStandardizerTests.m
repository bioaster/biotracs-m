classdef DataStandardizerTests < matlab.unittest.TestCase
    
    properties
        workingDir = fullfile(biotracs.core.env.Env.workingDir(), '/spectra/dataproc/DataStandardizerTests');
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
            data = biotracs.data.model.DataSet(data, colnames, rownames);
            
            %check that data are not standardized
            testCase.verifyNotEqual( mean(data.data,1), zeros(1, data.getNbColumns()) );
            testCase.verifyNotEqual( std(data.data,0,1), ones(1, data.getNbColumns()) );

            %center & scale
            process = biotracs.dataproc.model.DataStandardizer();
            process.setInputPortData('DataMatrix', data);
            process.run();
            oData = process.getOutputPortData('DataMatrix');
            testCase.verifyEqual(mean(oData.data), zeros(1, data.getNbColumns()), 'AbsTol', 1e-9);
            testCase.verifyEqual(std(oData.data), ones(1, data.getNbColumns()), 'AbsTol', 1e-9);

            %only center
            process = biotracs.dataproc.model.DataStandardizer();
            c = process.getConfig();
            process.setInputPortData('DataMatrix', data);
            c.updateParamValue('Center',true);
            c.updateParamValue('Scale','none');
            process.run();
            oData = process.getOutputPortData('DataMatrix');
            testCase.verifyEqual(mean(oData.data), zeros(1, data.getNbColumns()), 'AbsTol', 1e-9);
            
            %only scale
            process = biotracs.dataproc.model.DataStandardizer();
            c = process.getConfig();
            process.setInputPortData('DataMatrix', data);
            c.updateParamValue('Center',false);
            c.updateParamValue('Scale','uv');
            process.run();
            oData = process.getOutputPortData('DataMatrix');
            testCase.verifyEqual(std(oData.data), ones(1, data.getNbColumns()), 'AbsTol', 1e-9);
        end
        
        function testCenterScaleRows(testCase)
            %create random data
            ncols = 5000; nrows = 20;
            mu = 1; sigma = 2;
            data = normrnd(mu,sigma,nrows,ncols);
            data(10:20,:) = normrnd(mu+3,sigma*1.5,11,ncols);
            rownames = strcat('City:Paris_Rep:', arrayfun(@num2str, 1:nrows,'UniformOutput',false));
            colnames = strcat('F', arrayfun(@num2str, 1:ncols,'UniformOutput',false));
            data = biotracs.data.model.DataSet(data, colnames, rownames);
            
            %check that data are not standardized
            testCase.verifyNotEqual( mean(data.data,2), zeros(data.getNbRows(), 1) );
            testCase.verifyNotEqual( std(data.data,0,2), ones(data.getNbRows(), 1) );
            
            %center & scale
            process = biotracs.dataproc.model.DataStandardizer();
            c = process.getConfig();
            process.setInputPortData('DataMatrix', data);
            c.updateParamValue('Direction','row');
            process.run();
            oData = process.getOutputPortData('DataMatrix');
            testCase.verifyEqual(mean(oData.data,2), zeros(oData.getNbRows(), 1), 'AbsTol', 1e-9);
            testCase.verifyEqual(std(oData.data,0,2), ones(oData.getNbRows(), 1), 'AbsTol', 1e-9);
            
            
            %only center
            process = biotracs.dataproc.model.DataStandardizer();
            c = process.getConfig();
            process.setInputPortData('DataMatrix', data);
            c.updateParamValue('Scale','none');
            c.updateParamValue('Direction','row');
            process.run();
            oData = process.getOutputPortData('DataMatrix');
            testCase.verifyEqual(mean(oData.data,2), zeros(oData.getNbRows(), 1), 'AbsTol', 1e-9);
            testCase.verifyNotEqual(std(oData.data,0,2), std(data.data,0,2));
            
            %only scale
            process = biotracs.dataproc.model.DataStandardizer();
            c = process.getConfig();
            process.setInputPortData('DataMatrix', data);
            c.updateParamValue('Center',false);
            c.updateParamValue('Scale','uv');
            c.updateParamValue('Direction','row');
            process.run();
            oData = process.getOutputPortData('DataMatrix');
            testCase.verifyNotEqual(mean(oData.data,2), mean(data.data,2));
            testCase.verifyEqual(std(oData.data,0,2), ones(oData.getNbRows(), 1), 'AbsTol', 1e-9);
        end
        
    end
    
    
    methods( Static )
        
    end
    
end
