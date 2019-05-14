classdef IteratorTests < matlab.unittest.TestCase
    
    properties (TestParameter)
    end
    
    properties
        workingDir = fullfile(biotracs.core.env.Env.workingDir, '/biotracs/core/mvc/IteratorTests');
    end
    
    methods (Test)

        function testIterator(testCase)
            iw = testCase.doCreateNestedWorkflow();
            iw.setLabel('IteratedWorkflow');
            iw.createInputPortInterface('Process1', 'Input');
            iw.createOutputPortInterface('Process4', 'Output');
            
            w = biotracs.core.mvc.model.Iterator( iw );
            w.getConfig().updateParamValue( 'WorkingDirectory', testCase.workingDir );
            
            %iterator
            fasta{1} = biotracs.data.model.DataFile( '../testdata/toy_fasta.fa' );
            fasta{2} = biotracs.data.model.DataFile( '../testdata/toy_fasta.fa' );
            fasta{3} = biotracs.data.model.DataFile( '../testdata/toy_fasta.fa' );
            resourceSet = biotracs.core.mvc.model.ResourceSet();
            resourceSet.add(fasta{1})...
                .add(fasta{2})...
                .add(fasta{3});
            
            w.setInputPortData('ResourceSet', resourceSet);
            w.addlistener('afterEach', @afterEach);
            
            function afterEach(src, ~)
                e = src.getIteratedProcess();
                iter = src.getIterationCount();
                result = e.getOutput().getPortAt(1).getData();
                testCase.verifyEqual( result, resourceSet.getAt( iter ) );
            end
            
            w.run();
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
            c.createParam('Angle', pi, 'Cosntraint', biotracs.core.constraint.IsPositive());            
            c.createParam('Velocity', 2.5, 'Cosntraint', biotracs.core.constraint.IsPositive());            
        end
    end
end
