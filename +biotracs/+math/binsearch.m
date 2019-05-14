%"""
%biotracs.math.binsearch
%Fast binary search in a sorted vector
%* `iSortedVector` Sorted vector in which to search
%* `iValuesSearched` List of values to search in `iSortedVector`
%* `iAbsTol` Absolute tolerance (default = 1e-12)
%* return The index of the closest value of `iValueSearched` found in `iSortedVector`
%* return The closest value of `iValueSearched`
%* License: BIOASTER License
%* Created by: Bioinformatics team, Omics Hub, BIOASTER Technology Research Institute (http://www.bioaster.org), 2015
%"""

function [ oIndexes, oValues ] = binsearch( iSortedVector, iValuesSearched, iAbsTol )
	 if nargin < 3, iAbsTol = 1e-12; end
	 oIndexes = []; oValues = [];
		  
     if length(iAbsTol) == 1
         for i=1:length(iValuesSearched)
              [idx, value] = doBinsearch( iSortedVector, iValuesSearched(i), iAbsTol );
              oIndexes = [oIndexes, idx];
              oValues = [oValues, value];
         end
     else
         for i=1:length(iValuesSearched)
              [idx, value] = doBinsearch( iSortedVector, iValuesSearched(i), iAbsTol(i) );
              oIndexes = [oIndexes, idx];
              oValues = [oValues, value];
         end
     end
end


function [ idx, value ] = doBinsearch( iSortedVector, iValueSearched, iAbsTol )
    if iValueSearched <= iSortedVector(1)
        if abs(iValueSearched-iSortedVector(1)) > iAbsTol
            idx = []; value = [];
        else
            idx = 1;
            value = iSortedVector(1);
        end
        return
    elseif iValueSearched >= iSortedVector(end)
        if abs(iValueSearched-iSortedVector(end)) > iAbsTol
            idx = []; value = [];
        else
            idx = length(iSortedVector);
            value = iSortedVector(end);
        end
        return
    end
	 
	 div = 1;
	 N = length(iSortedVector);
	 idx = floor(N/div);
	 while(1)
		  div = div * 2;
		  % Check if less than val check if the next is greater
		  if iSortedVector(idx) == iValueSearched
				value = iSortedVector(idx);
				break
		  elseif iSortedVector(idx) < iValueSearched
				if iSortedVector(idx + 1) > iValueSearched
					 currentValue = iSortedVector(idx);
					 nextValue = iSortedVector(idx + 1);
					 %Get to closest index
					 if abs(currentValue-iValueSearched) < abs(nextValue-iValueSearched)
						  value = currentValue;
					 else
						  value = nextValue;
						  idx = idx + 1; 
					 end
					 %Check that the closest index lies in the tolerance interval	 
					 if abs(value-iValueSearched) > iAbsTol
						  idx = []; value = [];
					 end
					 break
				else
					 % Get half-bigger index
					 idx = idx + max([floor(N / div), 1]);
				end
		  end
		  
		  % Get half-smaller index
		  if iSortedVector(idx) > iValueSearched
				idx = idx - max([floor(N / div), 1]);
		  end
	 end
	 
end