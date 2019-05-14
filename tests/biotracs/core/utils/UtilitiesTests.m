classdef UtilitiesTests < matlab.unittest.TestCase

    properties
        workingDir = fullfile(biotracs.core.env.Env.workingDir, '/biotracs/core/utils/utilsTests/');
    end
    
    methods (Test)
        
        function testGetField(testCase)
            s.a = 1;
            s.b = 3;
            
            testCase.verifyEqual(biotracs.core.utils.getfield(s,'a'), 1);
            testCase.verifyEqual(biotracs.core.utils.getfield(s,'b'), 3);
            testCase.verifyEqual(biotracs.core.utils.getfield(s,'c', []), []);
            
            try
               testCase.verifyEqual(biotracs.core.utils.getfield(s,'c'), []); 
            catch err
                testCase.verifyEqual(err.message(), 'The field does not exist in the struture');
            end
            
            s = 1;
            try
               testCase.verifyEqual(biotracs.core.utils.getfield(s,'c', []), []); 
            catch err
                testCase.verifyEqual(err.message(), 'Wrong argument, only structures can be parsed');
            end
        end
        
        
         function testCellFind(testCase)
             c = {'a','b',1,'3',5,'b',1,1, [1,2,3]};
             testCase.verifyEqual(biotracs.core.utils.cellfind(c,'a'), 1); 
             testCase.verifyEqual(biotracs.core.utils.cellfind(c,1), [3,7,8]); 
             testCase.verifyEqual(biotracs.core.utils.cellfind(c,'b'), [2,6]);
             testCase.verifyEqual(biotracs.core.utils.cellfind(c,[1,2,3]), 9);
         end
             
         
         function testUntar(testCase)
             import biotracs.core.utils.*
             expectedFileText = fileread('./testdata/tar-gz-zip/testfile.txt');             
             wd = fullfile(testCase.workingDir, '/tar-gz-zip/outputs');
             compressedFile = './testdata/tar-gz-zip/testfile.tar';
             uncompressedFile = biotracs.core.utils.uncompress(compressedFile, wd);
             
             testCase.verifyTrue(isfile(uncompressedFile{1}));
             uncompressedFileText = fileread(uncompressedFile{1});
             testCase.verifyEqual(expectedFileText, uncompressedFileText);
             rmdir(wd,'s');
             testCase.verifyTrue(~isfile(uncompressedFile{1}));
             
             biotracs.core.utils.uncompress(compressedFile, wd, 'tar');
             testCase.verifyTrue(isfile(uncompressedFile{1}));
             uncompressedFileText = fileread(fullfile(wd, '/testfile.txt'));
             testCase.verifyEqual(expectedFileText, uncompressedFileText);
             rmdir(wd,'s');
         end
         
         function testUnGz(testCase)
             expectedFileText = fileread('./testdata/tar-gz-zip/testfile.txt');
             wd = fullfile(testCase.workingDir, '/tar-gz-zip/outputs');
             compressedFile = './testdata/tar-gz-zip/testfile.txt.gz';
             
             uncompressedFile = biotracs.core.utils.uncompress(compressedFile, wd);
                          
             testCase.verifyTrue(isfile(uncompressedFile{1}));
             uncompressedFileText = fileread(uncompressedFile{1});
             testCase.verifyEqual(uncompressedFileText, expectedFileText);
             rmdir(wd,'s')
             testCase.verifyTrue(~isfile(uncompressedFile{1}));
             
             uncompressedFile = biotracs.core.utils.uncompress(compressedFile, wd, 'gz');
             testCase.verifyTrue(isfile(uncompressedFile{1}));
             uncompressedFileText = fileread(uncompressedFile{1});
             testCase.verifyEqual(uncompressedFileText, expectedFileText);
             rmdir(wd,'s')
         end
         
         function testUnTarGz(testCase)
             expectedFileText = fileread('./testdata/tar-gz-zip/testfile.txt');
             wd = fullfile(testCase.workingDir, '/tar-gz-zip/outputs_1');
             compressedFile = './testdata/tar-gz-zip/testfile.tar.gz';
             
             uncompressedFile = biotracs.core.utils.uncompress(compressedFile, wd);
                          
             testCase.verifyTrue(isfile(uncompressedFile{1}));
             uncompressedFileText = fileread(uncompressedFile{1});
             testCase.verifyEqual(uncompressedFileText, expectedFileText);
             rmdir(wd,'s')
             testCase.verifyTrue(~isfile(uncompressedFile{1}));
             
             uncompressedFile = biotracs.core.utils.uncompress(compressedFile, wd, 'tar.gz');
             testCase.verifyTrue(isfile(uncompressedFile{1}));
             uncompressedFileText = fileread(uncompressedFile{1});
             testCase.verifyEqual(uncompressedFileText, expectedFileText);
             rmdir(wd,'s')
         end
         
         function testUnzip(testCase)
             expectedFileText = fileread('./testdata/tar-gz-zip/testfile.txt');
             wd = fullfile(testCase.workingDir, '/tar-gz-zip/outputs_2');
             compressedFile = './testdata/tar-gz-zip/testfile.zip';
             
             uncompressedFile = biotracs.core.utils.uncompress(compressedFile, wd);
             
             testCase.verifyTrue(isfile(uncompressedFile{1}));
             uncompressedFileText = fileread(uncompressedFile{1});
             testCase.verifyEqual(uncompressedFileText, expectedFileText);
             rmdir(wd,'s')
             testCase.verifyTrue(~isfile(uncompressedFile{1}));
             
             uncompressedFile = biotracs.core.utils.uncompress(compressedFile, wd, 'zip');
             testCase.verifyTrue(isfile(uncompressedFile{1}));
             uncompressedFileText = fileread(uncompressedFile{1});
             testCase.verifyEqual(uncompressedFileText, expectedFileText);
             rmdir(wd,'s')
         end
         
    end
    
end
