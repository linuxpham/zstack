%% Z-Stack Image Analysis
%% Description : Split string to array
%% Author : gie.spaepen@ua.ac.be
%% Created date: 18/04/2014

function splittedstring = splitString( inpstr, strdelim )
    %deblank string
    deblank(inpstr);

    %Get number of substrings
    idx  = findstr(inpstr,strdelim);
    if size(idx) == 0
        splittedstring = inpstr;
    else
        %Define size of the indices
        sz = size(idx,2);
        
        %Define splittedstring
        tempsplit = {};
        
        %Loop through string and itinerate from delimiter to delimiter
        for i = 1:sz
            %Define standard start and stop positions for the start position,
            %choose 1 as startup position because otherwise you get an array
            %overflow, for the endposition you can detemine it from the
            %delimiter position
            strtpos = 1;
            endpos = idx(i)-1;
            %If i is not the beginning of the string get it from the delimiter
            %position
            if i ~= 1
                strtpos = idx(i-1)+1;
            end
            %If i is equal to the number of delimiters get the last element
            %first by determining the lengt of the string and then replace the
            %endpos back to a standard position
            if i == sz
                endpos = size(inpstr,2); 
                tempsplit(i+1) = {inpstr(idx(i)+1 : endpos)};
                endpos = idx(i)-1;
            end
            %Add substring to output: splittedstring a cell array
            tempsplit(i) = {inpstr(strtpos : endpos)};   
        end
        
        %Flag 
        isallnums = 1;
        
        %Check is there are NaN values if matrix elements are converted to
        %doubles
        for i = 1:size(tempsplit,2)
            tempdouble = str2double(tempsplit(i));
            if(isnan(tempdouble))
                isallnums = 0;
            end
        end
        
        %If isallnums = 1 then return a double array otherwise return a cell
        %array
        if(isallnums == 1)
            for i = 1:size(tempsplit,2)
                splittedstring(i) = str2double(tempsplit(i));
            end
        else
            splittedstring = tempsplit;
        end
    end

end

