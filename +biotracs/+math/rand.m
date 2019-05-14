function randValues = rand( m, n, expectedMean, expectedStd )
    cv = expectedStd/expectedMean;
    b = expectedMean;
    q = sqrt(12)*cv/2;
    a = max(1e-3, -b * (q-1)/(q+1));
    randValues = (b-a) * rand(m,n) + a;
    
    %center to distribution on the expectedMean
    randValues = randValues + (b-mean(randValues));
end