classdef XmlTests < matlab.unittest.TestCase
    
    properties
        workingDir = [biotracs.core.env.Env.workingDir(), '/XmlTests'];
    end
    
    methods(TestMethodTeardown)
    end
    
    methods (Test)
        
        function testXml(testCase)
            filePath = './testdata/test.xml';
            data = biomex.xml.xml2struct(filePath);
            testCase.verifyClass( data, 'struct' );
            testCase.verifyEqual( fieldnames(data), {'SCS','TS','VV','coords','elems','energy','free','hirshfeld','omega','overlap_c','overlap_x','rsSCS'}' );
            testCase.verifyEqual( data.SCS.val__.C6.val__, '64.708953282642057 64.708953282642966' );
            testCase.verifyEqual( data.SCS.val__.C6_total.val__, '258.83581313057016' );
        end
        
        function testMzXML(testCase)
            filePath = './testdata/msfile.mzXML';
            data = biomex.xml.xml2struct(filePath);
            testCase.verifyClass( data, 'struct' );
            testCase.verifyEqual( fieldnames(data), {'indexOffset','msRun'}' );
        end
        
        function testFileNotFoundOrUnknownError(testCase)
            data = biomex.xml.xml2struct();
            testCase.verifyEqual( data, 1 );
            
            data = biomex.xml.xml2struct('');
            testCase.verifyEqual( data, 1 );
            
            data = biomex.xml.xml2struct('dfsfssf');
            testCase.verifyEqual( data, 1 );
        end
        
        function testInvalidFile(testCase)
            data = biomex.xml.xml2struct('./testdata/corrupted1.xml');
            testCase.verifyEqual( data, 1 );
            
            data = biomex.xml.xml2struct('./testdata/corrupted2.xml');
            testCase.verifyEqual( data, 1 );
            
            data = biomex.xml.xml2struct('./testdata/corrupted3.xml');
            testCase.verifyEqual( data, 1 );
            
            data = biomex.xml.xml2struct('./testdata/empty.xml');
            testCase.verifyEqual( data, 1 );
            
            data = biomex.xml.xml2struct('./testdata/blank.xml');
            testCase.verifyEqual( data, 1 );
        end
        
    end
    
end
