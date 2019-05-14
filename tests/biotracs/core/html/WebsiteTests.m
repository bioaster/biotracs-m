classdef WebsiteTests < matlab.unittest.TestCase

    properties
        workingDir = fullfile(biotracs.core.env.Env.workingDir, '/biotracs/core/html/WebsiteTests');
    end

    methods (Test)

        function TestWebsite(testCase)
            website = biotracs.core.html.Website();
            indexDoc = website.getIndexDoc();
            indexDoc.setBodyTitle('Website class: HTML Generator Testing');
            indexDoc.setDescription([...
                'This is the result of the unit test of biotracs.core.html.Website ', ...
                'that allows building and generating multipages websites.']);
            indexDoc.setKeywords('Biocode, HTML generation, biotracs.core.html.Website');
            
            for i=1:20
                % append the ith page;
                fileName = ['page',num2str(i)];
                website.appendDoc( testCase.createDoc(i), fileName );
                doc = website.getDoc(fileName);
                if i > 6
                    doc.setFolderName(['folder',num2str(i)]);
                end
                h = biotracs.core.html.Heading( 1, ['Page ', num2str(i)] );
                indexDoc.append( biotracs.core.html.Bookmark.fromHeading(h) );
                indexDoc.append(h);
                indexDoc.appendDiv('This the section for the 1st page of a multipage website');
                indexDoc.appendSpan('This is the link to ');
                indexDoc.appendLink( doc.getLocalUrl(), ['page ',num2str(i)]);
            end
            
            % show
            website.setBaseDirectory( testCase.workingDir );
            website.show('-browser');
        end
    end
    
    methods(Access = protected)
        
        function doc = createDoc(~, iPageNumber)
            doc = biotracs.core.html.Doc();
            doc.setBodyTitle(['Page ', num2str(iPageNumber),': HTML Generator Testing']);
            doc.setDescription([...
                'This is the result of the unit test of biotracs.core.html.Doc ', ...
                'that allows building and generating web pages.']);
            doc.setKeywords('Biocode, HTML generation, biotracs.core.html.Doc');

            card = biotracs.core.html.Card();
            card.setText('Test 2');
            card.setHeader('Header');
            card.setTitle('Title');
            card.setSubtitle('Subtitle');
            doc.append(card);
            
            link = biotracs.core.html.Link();
            link.setHref('http://google.fr');
            link.setText('Google website');
            card.appendLineBreak();
            card.append( link );
            card.appendLineBreak();
            card.appendSpan('Sample code testing:');
            card.appendCode( 'biotracs.core.html.Doc' );
            
            doc.appendParagraphBreak();
            
            h = biotracs.core.html.Heading(1);
            h.setText('Table of random numbers');
            doc.append(h);
            m = rand(100,5);
            t = biotracs.data.model.DataMatrix(m, 'C', 'R');
            table = biotracs.core.html.Table(t);
            doc.append(table);
            
            doc.appendParagraphBreak();
            
            h = biotracs.core.html.Heading(1);
            h.setText('Figure of MATLAB logo');
            doc.append(h);
            fig = doc.appendFigure([pwd,'/testdata/Matlab_Logo.png'], 'MATLAB Logo');
            fig.setAttributes(struct('style', 'width:30%; height:auto'));
            
            doc.appendParagraphBreak();
            
            h = biotracs.core.html.Heading(1);
            h.setText('Unordered List');
            doc.append(h);
            doc.appendList({'Paris'; 'Beijin'});

            doc.appendHeading(1, 'Ordered List');
            doc.appendList({'Paris'; 'Beijin'}, true);
            
            doc.appendHeading(1, 'Grid');
            g = biotracs.core.html.Grid(3,6);
            for i=1:3
                for j=1:6
                    div = g.getAt(i,j);
                    div.setText(['(',num2str(i),',',num2str(j),')']);
                end
            end
            doc.append(g);
            
            %doc.setBaseDirectory(testCase.workingDir);
            %doc.show( '-browser' );
        end
        
    end
    
end
