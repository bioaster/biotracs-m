classdef WorkflowTests < matlab.unittest.TestCase
    
    properties (TestParameter)
    end
    
    properties
        workingDir = fullfile( biotracs.core.env.Env.workingDir, '/biotracs/core/mvc/WorkflowTests' );
    end
    
    methods (Test)

        function testCreateSkeleton(testCase)
            w = testCase.doCreateWorkflow();
            w.setLabel('SimpleWorlflow');
            wd = [testCase.workingDir, '/SimpleWorkflowSkeleton/'];
            w.getConfig().updateParamValue( 'WorkingDirectory', wd );
            
            testCase.verifyEqual( w.readParamValue('Process1:Angle'), pi );
            testCase.verifyEqual( w.readParamValue('Process1:Velocity'), 2.5 );
            
            try
                testCase.verifyEqual( w.readParamValue('Process1'), pi );
            catch err
                testCase.verifyEqual( err.identifier, 'BIOTRACS:Parametrable:ParameterNotFound');
            end
            
            w.writeParamValue('Process1:Velocity', 3*pi/4);
            testCase.verifyEqual( w.readParamValue('Process1:Velocity'), 3*pi/4 );
            
            p = cell(1,10);
            for i=1:10
                p{i} = w.getNode(['Process',num2str(i)]);
            end

            testCase.verifyTrue( p{1}.isSource() );
            testCase.verifyFalse( p{1}.isSink() );
            testCase.verifyFalse( p{3}.isSource() );
            testCase.verifyFalse( p{3}.isSink() );
            testCase.verifyFalse( p{10}.isSource() );
            testCase.verifyTrue( p{10}.isSink() );
            
            testCase.verifyEqual( w.getNodeAt(1), p{1}  );
            testCase.verifyEqual( w.getNodeAt(2), p{2}  );
            testCase.verifyEmpty( p{1}.getPrevious() );
            testCase.verifyEqual( p{1}.getNext(), p(2)  );
            testCase.verifyNotEqual( p{1}.getNext(), p(3) );
            testCase.verifyTrue( isequal(p{2}.getNext(), p([3,5])) || isequal(p{2}.getNext(), p([5,3])) );
            testCase.verifyEmpty( p{4}.getNext() );
            testCase.verifyTrue( isequal(p{6}.getPrevious(), p([3,5])) || isequal(p{6}.getPrevious(), p([5,3])) );
 
            w.emulate();
            paths = w.getPaths();
            testCase.verifyEqual( size(paths), [1,11]  );
            expectedPaths = { w, p{1}, p{2}, p{5}, p{3}, p{4}, p{6}, p{7}, p{8}, p{9}, p{10} };
            testCase.verifyEqual( paths, expectedPaths );
        end
        
        function testCreatePortInterfaces(testCase)
            w = biotracs.core.mvc.model.Workflow();
            w.setLabel('TestedWorlflow');

            % Process 1
            p1 = testCase.doCreateProcess();
            p2 = testCase.doCreateProcess();
            p3 = testCase.doCreateProcess();
            w.addNode(p1, 'Process1');
            w.addNode(p2, 'Process2');
            w.addNode(p3, 'Process3');
            
            p1.getOutputPort('Output').connectTo( p2.getInputPort('Input') ); %p1 -> p2
            p2.getOutputPort('Output').connectTo( p3.getInputPort('Input') ); %p2 -> p3

            w.createInputPortInterface('Process1', 'Input');
            w.getInputPortData('Process1:Input');
            data1 = biotracs.data.model.DataMatrix([1,2,3]);
            w.setInputPortData( 'Process1:Input', data1 );
            data2 = p1.getInputPortData( 'Input' );
            testCase.verifyEqual( data1, data2  );
            testCase.verifyTrue(w.isInterfacedWithTheInputOfNode(p1));
            testCase.verifyFalse(w.isInterfacedWithTheOutputOfNode(p1));
            testCase.verifyFalse(w.isInterfacedWithTheOutputOfNode(p3));
            testCase.verifyFalse(w.isInterfacedWithTheInputOfNode(p2));        
            
            
            w.createOutputPortInterface('Process3', 'Output');
            data1 = biotracs.data.model.DataMatrix([pi, pi]);
            p3.setOutputPortData( 'Output', data1 );
            data2 = w.getOutputPortData( 'Process3:Output' );
            testCase.verifyEqual( data1, data2  );
            testCase.verifyTrue(w.isInterfacedWithTheInputOfNode(p1));
            testCase.verifyFalse(w.isInterfacedWithTheOutputOfNode(p1));
            testCase.verifyTrue(w.isInterfacedWithTheOutputOfNode(p3));
            testCase.verifyFalse(w.isInterfacedWithTheInputOfNode(p2));
            
            
            testCase.verifyTrue( p1.isSource() );
            testCase.verifyTrue( w.getNode('Process1').isSource() );
        end
        
        function testNestedWorkflows(testCase)
            %return;
            w = testCase.doCreateNestedWorkflow();
            
            p = w.getNode('ChildWorlflow1');
            testCase.verifyFalse( p.isSource() );
            testCase.verifyFalse( p.isSink() );
            
            p = w.getNode('ChildWorlflow2');
            testCase.verifyFalse( p.isSource() );
            testCase.verifyTrue( p.isSink() );
            
            p = w.getNode('Process1');
            testCase.verifyTrue( p.isSource() );
            testCase.verifyFalse( p.isSink() );
            
            p = w.getNode('ChildWorlflow1').getNode('Process1');
            testCase.verifyTrue( p.isSource() );
            testCase.verifyFalse( p.isSink() );
            
            w.emulate();

            p1 = w.getNode('Process1');
            p2 = w.getNode('Process2');
            testCase.verifyTrue( p1.isSource() );
            testCase.verifyFalse( p2.isSource() );
        end

    end
    
    methods
        
        function [ w ] = doCreateNestedWorkflow( testCase )
            w = testCase.doCreateWorkflow();
            w.setLabel('MasterWorlflow');
            wd = [testCase.workingDir, '/NestedWorkflowSkeleton/'];
            w.getConfig().updateParamValue( 'WorkingDirectory', wd );
            
            w1 = testCase.doCreateWorkflow();
            w1.createInputPortInterface('Process1', 'Input');
            w1.createOutputPortInterface('Process7', 'Output');
            
            w2 = testCase.doCreateWorkflow();
            w2.createInputPortInterface('Process1', 'Input');
            w2.createOutputPortInterface('Process7', 'Output');
            
            w.addNode( w1, 'ChildWorlflow1' );
            w.addNode( w2, 'ChildWorlflow2' );
            
            %               w1 --> w2
            %              /|\
            %               |
            % p1 --> p2 --> p3 --> p4
            %        |      |
            %       \|/    \|/
            %        p5 --> p6 --> p7
            % p8
            % p9 --> p10
            
            p3 = w.getNode('Process3');
            p3.getOutputPort('Output').connectTo( w1.getInputPort('Process1:Input') );
            w1.getOutputPort('Process7:Output').connectTo( w2.getInputPort('Process1:Input') );
        end
        
        function [ w ] = doCreateWorkflow( testCase )
            w = biotracs.core.mvc.model.Workflow();
            % Process 1
            p1 = testCase.doCreateProcess();
            p2 = testCase.doCreateProcess();
            p3 = testCase.doCreateProcess();
            p4 = testCase.doCreateProcess();
            p5 = testCase.doCreateProcess();
            p6 = testCase.doCreateProcess();
            p7 = testCase.doCreateProcess();
            p8 = testCase.doCreateProcess();
            p9 = testCase.doCreateProcess();
            p10 = testCase.doCreateProcess();
            
            p1.setInputPortData('Input', biotracs.core.mvc.model.Resource);
            p8.setInputPortData('Input', biotracs.core.mvc.model.Resource);
            p9.setInputPortData('Input', biotracs.core.mvc.model.Resource);
            
            w.addNode(p1, 'Process1');
            w.addNode(p2, 'Process2');
            w.addNode(p3, 'Process3');
            w.addNode(p4, 'Process4');
            w.addNode(p5, 'Process5');
            w.addNode(p6, 'Process6');
            w.addNode(p7, 'Process7');
            w.addNode(p8, 'Process8');
            w.addNode(p9, 'Process9');
            w.addNode(p10, 'Process10');
            
            % p1 --> p2 --> p3 --> p4
            %        |      |
            %       \|/    \|/
            %        p5 --> p6 --> p7
            % p8
            % p9 --> p10
            p1.getOutputPort('Output').connectTo( p2.getInputPort('Input') ); %p1 -> p2
            p2.getOutputPort('Output').connectTo( p5.getInputPort('Input') ); %p2 -> p5
            p2.getOutputPort('Output').connectTo( p3.getInputPort('Input') ); %p2 -> p3
            p3.getOutputPort('Output').connectTo( p4.getInputPort('Input') ); %p3 -> p4
            
            
            p6.setInputSpecs({...
                struct(...
                'name', 'Input#1',...
                'class', 'biotracs.core.mvc.model.Resource' ...
                ),...
                struct(...
                'name', 'Input#2',...
                'class', 'biotracs.core.mvc.model.Resource' ...
                )}...
            );

            p5.getOutputPort('Output').connectTo( p6.getInputPort('Input#1') ); %p5 -> p6
            p3.getOutputPort('Output').connectTo( p6.getInputPort('Input#2') ); %p3 -> p6
            p6.getOutputPort('Output').connectTo( p7.getInputPort('Input') );   %p6 -> p7
            p9.getOutputPort('Output').connectTo( p10.getInputPort('Input') );  %p9 -> p10
        end
        
        function [ process ] = doCreateProcess( ~ )
            process = biotracs.core.adapter.model.Passer();
            process.setInputSpecs({...
                struct(...
                'name', 'Input',...
                'class', 'biotracs.core.mvc.model.Resource' ...
                )}...
            );
            process.setOutputSpecs({...
                struct(...
                'name', 'Output',...
                'class', 'biotracs.core.mvc.model.Resource' ...
                )}...
            );
            process.setDescription('Test case: Generation of the report of Process_KO_GeneA');
            c = process.getConfig();
            c.createParam('Angle', pi, 'Constraint', biotracs.core.constraint.IsPositive());            
            c.createParam('Velocity', 2.5, 'Constraint', biotracs.core.constraint.IsPositive());            
        end
    end
end
