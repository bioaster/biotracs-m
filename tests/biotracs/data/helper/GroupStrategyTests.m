classdef GroupStrategyTests < matlab.unittest.TestCase
    
    properties
        workingDir = fullfile(biotracs.core.env.Env.workingDir() , '/biotracs/data/GroupStrategyTests');
    end
    
    methods(TestMethodTeardown)
    end
    
    methods (Test)
       
        function testParseGroup(testCase)
            labels = {'Sample:KO_Time:1H_BR:1_AR:1_Seq:123',
                    'Sample:WT_Time:1H_BR:1_AR:1_Seq:125',
                    'Sample:KO_Time:2p5H_BR:1_AR:1_Seq:128',
                    'Sample:WT_Time:2p5H_BR:1_AR:1_Seq:135',
                    'Sample:KOG_Time:1H_BR:1_AR:1_Seq:138',
                    'Sample:KOG_Time:2p5H_BR:1_AR:1_Seq:140'};
            groupList = {'Sample', 'Time', 'BR', 'AR', 'Seq'};
            sep = '_';
            
            grpStrat = biotracs.data.helper.GroupStrategy( labels, groupList, sep );
            strat = grpStrat.getStrategy();

            testCase.verifyEqual( strat{1}.Sample,  struct('name','Sample:KO', 'index', 1) );
            testCase.verifyEqual( strat{1}.Time,    struct('name','Time:1H', 'index', 1) );
            testCase.verifyEqual( strat{1}.BR,      struct('name','BR:1', 'index', 1) );
            testCase.verifyEqual( strat{1}.AR,      struct('name','AR:1', 'index', 1) );
            testCase.verifyEqual( strat{1}.Seq,     struct('name','Seq:123', 'index', 1) );
            
            testCase.verifyEqual( strat{2}.Sample,  struct('name','Sample:WT', 'index', 2) );
            testCase.verifyEqual( strat{2}.Time,    struct('name','Time:1H', 'index', 1) );
            testCase.verifyEqual( strat{2}.BR,      struct('name','BR:1', 'index', 1) );
            testCase.verifyEqual( strat{2}.AR,      struct('name','AR:1', 'index', 1) );
            testCase.verifyEqual( strat{2}.Seq,     struct('name','Seq:125', 'index', 2) );
            
            testCase.verifyEqual( strat{3}.Sample,	struct('name','Sample:KO', 'index', 1) );
            testCase.verifyEqual( strat{3}.Time,	struct('name','Time:2p5H', 'index', 2) );
            testCase.verifyEqual( strat{3}.BR,      struct('name','BR:1', 'index', 1) );
            testCase.verifyEqual( strat{3}.AR,      struct('name','AR:1', 'index', 1) );
            testCase.verifyEqual( strat{3}.Seq,     struct('name','Seq:128', 'index', 3) );
        end
        
        function testGroupStrategyTwoGroups( testCase )
            %create random data
            data = rand(40,100);
            data11RowNames = strcat('City:Paris_Rep:', arrayfun(@num2str, 1:20,'UniformOutput',false));
            data21RowNames = strcat('City:Beijin_Rep:', arrayfun(@num2str, 1:20,'UniformOutput',false));
            data11ColNames = strcat('M', arrayfun(@num2str, 1:50,'UniformOutput',false));
            data12ColNames = strcat('F', arrayfun(@num2str, 1:50,'UniformOutput',false));
            rownames = [data11RowNames, data21RowNames];
            colnames = [data11ColNames, data12ColNames];
            dataSet = biotracs.data.model.DataSet(data, colnames, rownames);
            dataSet.setRowNamePatterns({'City'});
            
            strat = dataSet.createRowGroupStrategy();
            [idx, sliceNames] = strat.getSlicesIndexesOfGroup( 'City' );

            expectedIdx = false(40,2);
            expectedIdx(1:20,2) = true;
            expectedIdx(21:40,1) = true;
            
            testCase.verifyEqual(idx,expectedIdx);
            testCase.verifyEqual(sliceNames, {'City:Beijin', 'City:Paris'})
        end
        
        
        function testGroupStrategyThreeGroup( testCase )
            %create random data
            data = rand(40,100);
            data11RowNames = strcat('City:Paris_Color:Blue_Rep:', arrayfun(@num2str, 1:10,'UniformOutput',false));
            data21RowNames = strcat('City:Beijin_Color:Green_Rep:', arrayfun(@num2str, 1:10,'UniformOutput',false));
            data31RowNames = strcat('City:NY_Color:Green_Rep:', arrayfun(@num2str, 1:20,'UniformOutput',false));
            data11ColNames = strcat('M', arrayfun(@num2str, 1:50,'UniformOutput',false));
            data12ColNames = strcat('F', arrayfun(@num2str, 1:50,'UniformOutput',false));
            rownames = [data11RowNames, data21RowNames, data31RowNames];
            colnames = [data11ColNames, data12ColNames];
            dataSet = biotracs.data.model.DataSet(data, colnames, rownames);

            % test 1
            dataSet.setRowNamePatterns({'City'});
            ySet = dataSet.createYDataSet();
            ySet.summary();
            
            strat = dataSet.createRowGroupStrategy();
            [idx, sliceNames] = strat.getSlicesIndexesOfGroup( 'City' );

            expectedIdx = false(40,3);
            expectedIdx(11:20,1) = true;
            expectedIdx(21:40,2) = true;
            expectedIdx(1:10,3) = true;
            testCase.verifyEqual(idx,expectedIdx);
            testCase.verifyEqual(sliceNames, {'City:Beijin','City:NY','City:Paris'})
            
            % test 2
            dataSet.setRowNamePatterns({'City','Color'});
            ySet = dataSet.createYDataSet();
            ySet.summary();
            
            strat = dataSet.createRowGroupStrategy();

            [idx, sliceNames] = strat.getSlicesIndexesOfGroup( 'City' );
            expectedIdx = false(40,3);
            expectedIdx(11:20,1) = true;
            expectedIdx(21:40,2) = true;
            expectedIdx(1:10,3) = true;
            testCase.verifyEqual(idx,expectedIdx);
            testCase.verifyEqual(sliceNames, {'City:Beijin','City:NY','City:Paris'});
            
            [idx, sliceNames] = strat.getSlicesIndexesOfGroup( 'Color' );
            expectedIdx = false(40,2);
            expectedIdx(1:10,1) = true;
            expectedIdx(11:40,2) = true;
            testCase.verifyEqual(idx,expectedIdx);
            testCase.verifyEqual(sliceNames, {'Color:Blue'    'Color:Green'});
        end
        
    end
    
end
