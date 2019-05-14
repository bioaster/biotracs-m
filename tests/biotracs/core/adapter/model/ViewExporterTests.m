classdef ViewExporterTests < matlab.unittest.TestCase

    properties
        workingDir = fullfile(biotracs.core.env.Env.workingDir, '/biotracs/core/adpater/ViewExporterTest');
    end
    
    methods (Test)
        
        function testViewExporter(testCase)
            m = 50;
            N = 0.3;
            x = (1:m)';
            s = std(x);
            X = x + normrnd(0,s*N, m, 1);
            Y = x + normrnd(0,s*N, m, 1);
            dataMatrix = biotracs.data.model.DataMatrix( [X, Y], 'X', 'Y' );
            dataMatrix.setLabel('ToyData');
            
            viewExporter = biotracs.core.adapter.model.ViewExporter();
            viewExporter.setInputPortData('Resource', dataMatrix);
            viewExporter.getConfig()...
                .updateParamValue('ViewNames', {'Html','DistributionPlot'})...
                .updateParamValue('ViewParameters', {{},{'ShowPoints', true}})...
                .updateParamValue('WorkingDirectory', fullfile(testCase.workingDir,'DataSetPlot'));
            viewExporter.run();
        end
        
%         function testViewExporter(testCase)
%             m = 200;
%             N = 0.3;
%             x = (1:m)';
%             s = std(x);
%             X = x + normrnd(0,s*N, m, 1);
%             Y = x + normrnd(0,s*N, m, 1);
%             trSet = biotracs.data.model.DataSet( [X, Y], 'X', 'Y' );
%             trSet.setLabel('ToyData');
%             trSet.setOutputIndexes( getSize(trSet,2) );
%             
%             learningProcess = biotracs.stats.pls.model.Learner();
%             c = learningProcess.getConfig();
%             c.updateParamValue('NbComponents', 1);
%             c.updateParamValue('kFoldCrossValidation', m );
%             c.updateParamValue('MonteCarloPermutation', 1000 );
%             learningProcess.setInputPortData( 'TrainingSet', trSet );
%             learningProcess.run();
%             learningResults = learningProcess.getOutputPortData('Result');
%             
%             predictionProcess = biotracs.stats.pls.model.Predictor();
%             predictionProcess.setInputPortData('TestSet', trSet );
%             predictionProcess.setInputPortData('PredictiveModel', learningResults);
%             predictionProcess.run();
%             predictionResults = predictionProcess.getOutputPortData('Result');
%             
%             viewExporter = biotracs.core.adapter.model.ViewExporter();
%             viewExporter.setInputPortData('Resource', learningResults);
%             viewExporter.getConfig()...
%                 .updateParamValue('ViewNames', {'PermutationPlot','VipPlot'})...
%                 .updateParamValue('ViewParameters', {{'Criterion', 'R2Y'},{}})...
%                 .updateParamValue('WorkingDirectory', fullfile(testCase.workingDir,'Pls'));
%             viewExporter.run();
%             
%             %%
%             viewExporter = biotracs.core.adapter.model.ViewExporter();
%             viewExporter.setInputPortData('Resource', predictionResults);
%             viewExporter.getConfig()...
%                 .updateParamValue('ViewNames', {'YPredictionPlot'})...
%                 .updateParamValue('WorkingDirectory', fullfile(testCase.workingDir,'Pls'));
%             viewExporter.run();
%             
%             %%
%             viewExporter = biotracs.core.adapter.model.ViewExporter();
%             viewExporter.setInputPortData('Resource', trSet);
%             viewExporter.getConfig()...
%                 .updateParamValue('ViewNames', {'Html'})...
%                 .updateParamValue('WorkingDirectory', fullfile(testCase.workingDir,'Data'));
%             viewExporter.run();
%         end
        
    end
    
end
