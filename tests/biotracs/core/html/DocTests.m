classdef DocTests < matlab.unittest.TestCase

    properties
        workingDir = fullfile(biotracs.core.env.Env.workingDir, '/biotracs/core/html/DocTests');
    end

    methods (Test)

        function TestDoc(testCase)
            doc = biotracs.core.html.Doc();
            doc.setBodyTitle('Doc class: HTML Generator Testing');
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
            doc.append( biotracs.core.html.Bookmark.fromHeading(h) );
            doc.append(h);
            m = rand(100,5);
            t = biotracs.data.model.DataMatrix(m, 'C', 'R');
            table = biotracs.core.html.Table(t);
            doc.append(table);
            
            doc.appendParagraphBreak();
            
            h = biotracs.core.html.Heading(1);
            h.setText('Figure of MATLAB logo');
            doc.append( biotracs.core.html.Bookmark.fromHeading(h) );
            doc.append(h);
            fig = doc.appendFigure([pwd,'/testdata/Matlab_Logo.png'], 'MATLAB Logo');
            fig.setAttributes(struct('style', 'width:30%; height:auto'));
            
            doc.appendParagraphBreak();
            
            h = biotracs.core.html.Heading(1);
            h.setText('Unordered List');
            doc.append( biotracs.core.html.Bookmark.fromHeading(h) );
            doc.append(h);
            doc.appendList({'Paris'; 'Beijin'});

            h = doc.appendHeading(1, 'Ordered List');
            doc.append( biotracs.core.html.Bookmark.fromHeading(h) );
            doc.appendList({'Paris'; 'Beijin'}, true);
            
            h = doc.appendHeading(1, 'Grid');
            doc.append( biotracs.core.html.Bookmark.fromHeading(h) );
            g = biotracs.core.html.Grid(3,6);
            for i=1:3
                for j=1:6
                    div = g.getAt(i,j);
                    div.setText(['(',num2str(i),',',num2str(j),')']);
                end
            end
            doc.append(g);
            
            
            accordion = biotracs.core.html.Accordion();
            item = biotracs.core.html.AccordionItem( 'Item1' );
            item.appendDiv('Paris');
            item.appendDiv('NY');
            accordion.append(item);
            
            item = biotracs.core.html.AccordionItem( 'Item2' );
            item.appendDiv('Paris');
            item.appendDiv('NY');
            accordion.append(item);
            
            item = biotracs.core.html.AccordionItem( 'Item3' );
            item.appendDiv('Paris');
            item.appendDiv('NY');
            accordion.append(item);
            doc.append(accordion);
            
            doc.setBaseDirectory(testCase.workingDir);
            doc.show( '-browser' );
        end

        
    end
    
end
