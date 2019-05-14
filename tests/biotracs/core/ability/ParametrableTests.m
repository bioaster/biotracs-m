classdef ParametrableTests < matlab.unittest.TestCase

    properties
        workingDir = [biotracs.core.env.Env.workingDir(), '/biotracs/core/ability/ParametrableTests'];
    end
    
    methods (Test)
        
        function testCreateGetSetParam(testCase)
            parametrable = MyFakeParametrable();
            parametrable.createParam('param1', 'oui');
            parametrable.createParam('param2', '3');
            parametrable.createParam('param4', 'bioaster');
            testCase.verifyEqual( parametrable.getParamValue('param1'), 'oui' );
            testCase.verifyEqual( parametrable.getParamValue('param4'), 'bioaster' );
            try
                parametrable.getParamValue('param1123');
            catch err
                testCase.verifyEqual( err.message(), 'Parameter ''param1123'' is not found' );
            end
            parametrable.updateParamValue('param1', 4.5);
            testCase.verifyEqual( parametrable.getParamValue('param1'), 4.5 );
            parametrable.createParam('param1123',8.4);
            testCase.verifyEqual( parametrable.getParamValue('param1123'), 8.4 );
        end
        
        function testAddRemoveParam(testCase)
            parametrable = MyFakeParametrable();
            parametrable.createParam('param8','5');
            parametrable.createParam('param10',4);
            try
                parametrable.createParam('param10',1.345);
            catch err
                testCase.verifyEqual( err.message(), 'This parameter already exists' );
            end
            parametrable.createParam('param101',1.345);
            parametrable.removeParam('param10');
            try
                parametrable.removeParam('param1123');
            catch err
                testCase.verifyEqual( err.message(), 'Parameter ''param1123'' is not found' );
            end
        end

        
        function testSimpleHydration(testCase)
            c1 = MyFakeParametrable();
            c1.createParam('v1', 3);
            c1.createParam('v2', [1,2,3]);
            c1.createParam('v3');
            c1.createParam('v4', 'oui');
            c1.createParam('v6', 'idem');
            c2 = MyFakeParametrable();
            c2.createParam('v1', [2, 3]);
            c2.createParam('v2', 8);
            c2.createParam('v3');
            c2.createParam('v5', 'rien');
            c2.createParam('v6', 'idem');
            testCase.verifyNotEqual( c1.getParamValue('v1'), c2.getParamValue('v1') );
            testCase.verifyNotEqual( c1.getParamValue('v2'), c2.getParamValue('v2') );
            testCase.verifyEqual( c1.getParamValue('v3'), c2.getParamValue('v3') );
            testCase.verifyEqual( c1.getParamValue('v4'), 'oui' );
            testCase.verifyEqual( c2.getParamValue('v5'), 'rien' );
            testCase.verifyEqual( c1.getParamValue('v6'), c2.getParamValue('v6') );
            c2.hydrateWith(c1);
            testCase.verifyEqual( c2.getParamValue('v1'), c1.getParamValue('v1') );
            testCase.verifyEqual( c2.getParamValue('v2'), c1.getParamValue('v2') );
            testCase.verifyEqual( c2.getParamValue('v3'), c1.getParamValue('v3') );
            testCase.verifyEqual( c2.getParamValue('v5'), 'rien' );
            testCase.verifyEqual( c1.getParamValue('v4'), 'oui' );
            testCase.verifyEqual( c2.getParamValue('v6'), c1.getParamValue('v6') );
            try
                c2.getParamValue('v4');
                error('An error was expected');
            catch err
                testCase.verifyEqual( err.message(), 'Parameter ''v4'' is not found' );
            end
            try
                c1.getParamValue('v5');
                error('An error was expected');
            catch err
                testCase.verifyEqual( err.message(), 'Parameter ''v5'' is not found' );
            end
        end
        
        function testHydrationWithCreationOfParameter(testCase)
            c1 = MyFakeParametrable();
            c1.createParam('v1', 3);
            c1.createParam('v2', [1,2,3]);
            c1.createParam('v3');
            c1.createParam('v4', 'oui');
            c1.createParam('v6', 'idem');
            c2 = MyFakeParametrable();
            c2.createParam('v1', [2, 3]);
            c2.createParam('v2', 8);
            c2.createParam('v3');
            c2.createParam('v5', 'rien');
            c2.createParam('v6', 'idem');
            c2.hydrateWith(c1, 'CreateParamIfNotExists', true);
            testCase.verifyEqual( c2.getParamValue('v1'), c1.getParamValue('v1') );
            testCase.verifyEqual( c2.getParamValue('v2'), c1.getParamValue('v2') );
            testCase.verifyEqual( c2.getParamValue('v3'), c1.getParamValue('v3') );
            testCase.verifyEqual( c2.getParamValue('v5'), 'rien' );
            testCase.verifyEqual( c2.getParamValue('v4'), c1.getParamValue('v4') );
            testCase.verifyEqual( c2.getParamValue('v6'), c1.getParamValue('v6') );
        end
        
        function testConstraints(testCase)
            parametrable = MyFakeParametrable();
            b0 = biotracs.core.constraint.IsBetween( [0, 10] );
            b1 = biotracs.core.constraint.IsBetween( [0, 2] ); 
            parametrable.createParam('pi', 3.14).setConstraint( b0 );
            testCase.verifyEqual( parametrable.areConstraintsValidated(), true );
            try
                parametrable.checkParameterConstraints();
            catch err
                error('An exception was not expected. Message: %s', err.message)
            end
            parametrable.getParam('pi').setConstraint( b1 );
            testCase.verifyEqual( parametrable.areConstraintsValidated(), false );
            try
                parametrable.checkParameterConstraints();
            catch err
                testCase.verifyEqual( err.message, 'Parameter ''pi'' does not fullfill constraints. Actual value is: 3.14')
            end
        end

        function testExportImportParam(testCase)
            p = MyFakeParametrable();
            p.createParam('param1', 3);
            p.createParam('param2', [1,2,3], 'Constraint', biotracs.core.constraint.IsNumeric('IsScalar', false));
            p.createParam('param3');
            p.createParam('param4', 'NY', 'Constraint', biotracs.core.constraint.IsText(), 'Description', 'My city');
            p.createParam('param5', 'true');
            p.createParam('param6', {1,2,3}, 'Constraint', biotracs.core.constraint.IsInSet({1,2,3}));
            p.createParam('param7', 'Beijin', 'Constraint', biotracs.core.constraint.IsInSet({'NY','Beijin','Paris'}));
            p.createParam('param8', [1:10;11:20], 'Constraint', biotracs.core.constraint.IsNumeric('Scalar', false));
            p.exportParams( [testCase.workingDir,'/parameters1.xml'] );
            p.exportParams( [testCase.workingDir,'/parameters1.json'] );
            keyVals = biotracs.core.ability.Parametrable.readKeyValParamFromXmlFile( [testCase.workingDir,'/parameters1.xml'] );

            testCase.verifyClass( keyVals, 'cell' );
            testCase.verifyEqual( keyVals(1:2), {'param1', 3});
            testCase.verifyEqual( keyVals(3:4), {'param2', [1,2,3]});
            testCase.verifyEqual( keyVals(7:8), {'param4', 'NY'});
        end
        
        function testExportImportParam2(testCase)
            file = [testCase.workingDir,'/parameters2.xml'];
            p1 = MyFakeParametrable();
            p1.createParam('param1', 3);
            p1.createParam('param2', [1,2,3], 'Constraint', biotracs.core.constraint.IsNumeric('IsScalar', false));
            p1.createParam('param3');
            p1.createParam('param4', 'NY', 'Constraint', biotracs.core.constraint.IsText(), 'Description', 'My city');
            p1.createParam('param5', true);
            p1.createParam('param6', 3, 'Constraint', biotracs.core.constraint.IsInSet({1,2,3}));
            p1.createParam('param7', 'Beijin', 'Constraint', biotracs.core.constraint.IsInSet({'NY','Beijin','Paris'}));
            p1.createParam('param8', [1:10;11:20], 'Constraint', biotracs.core.constraint.IsNumeric('IsScalar', false));
            p1.createParam('param9', {'my first text','my second text'}, 'Constraint', biotracs.core.constraint.IsText('IsScalar', false));
            p1.exportParams(file);
            testCase.verifyTrue(isfile(file));
            
            p2 = MyFakeParametrable();
            p2.createParam('param1', []);
            p2.createParam('param2', [], 'Constraint', biotracs.core.constraint.IsNumeric('IsScalar', false));
            p2.createParam('param3', []);
            p2.createParam('param4', [], 'Constraint', biotracs.core.constraint.IsText(), 'Description', 'My city');
            p2.createParam('param5', []);
            p2.createParam('param6', [], 'Constraint', biotracs.core.constraint.IsInSet({1,2,3}));
            p2.createParam('param7', [], 'Constraint', biotracs.core.constraint.IsInSet({'NY','Beijin','Paris'}));
            p2.createParam('param8', [], 'Constraint', biotracs.core.constraint.IsNumeric('IsScalar', false));
            p2.createParam('param9', {}, 'Constraint', biotracs.core.constraint.IsText('IsScalar', false));
            p2.importParams(file);
            testCase.verifyTrue( isEqualTo(p1, p2) );
        end
        
    end
    
end
