%% Z-Stack Image Analysis
%% Description : List all stack in a directory
%% Author : Pham Thai Hoa - thaihoabo@gmail.com
%% Created date: 23/02/2014

function [arrStackList, arrStackListName] = getStackList(directoryPath)
    % Create empty map data
    arrStackList = containers.Map('KeyType','char','ValueType','int32');    
    arrStackListName = containers.Map('KeyType','char','ValueType','any');

    % Get all files in this directory
    arrList = dir(directoryPath);
    iLength = length(arrList);
    
    % Create vector images data
    arrVectorTheDepth = containers.Map('KeyType','int32','ValueType','char');    
    preKeyName = '';
    jLoop = 1;
        
    % Loop to check files
    for iLoop = 1:iLength
        % Check only file
        if arrList(iLoop).isdir == 0
            if ((length(arrList(iLoop).name) > 0) && (~isempty(strfind(arrList(iLoop).name, 'tif')) || ~isempty(strfind(arrList(iLoop).name, 'TIF'))))
                % Split string to array
                arrDetail = regexp(arrList(iLoop).name, '_', 'split');
                
                % Check length data
                if length(arrDetail) == 5
                    % Get key name
                    keyName = char(arrDetail(4));
                    
                    % Add stack list data                    
                    if isKey(arrStackList, keyName)
                        % Push stack name to map
                        arrStackList(keyName) = arrStackList(keyName) + 1;
                        
                        % Add the depth image name                        
                        arrVectorTheDepth(jLoop) = arrList(iLoop).name;
                        jLoop = jLoop + 1;
                    else
                        % Check previous key name and difference with
                        % current key nam data
                        if (length(preKeyName) > 0) && (strcmp(preKeyName, keyName) == 0)
                            % Add the depth image
                            arrStackListName(preKeyName) = arrVectorTheDepth;
                            
                            % Reset data for list
                            arrVectorTheDepth = containers.Map('KeyType','int32','ValueType','char');
                            jLoop = 1;
                            
                            % Reset previous key name
                            preKeyName = '';
                        end
                        
                        % Set previous key name and stack data
                        arrStackList(keyName) = 1;
                        preKeyName = keyName;
                        
                        % Add the depth image name                        
                        arrVectorTheDepth(jLoop) = arrList(iLoop).name;
                        jLoop = jLoop + 1;
                    end
                end
            end
        end
    end
    
    % Check vector the depth
    if (length(arrVectorTheDepth) > 0) && (length(preKeyName) > 0)
        arrStackListName(preKeyName) = arrVectorTheDepth;
        arrVectorTheDepth = containers.Map('KeyType','int32','ValueType','char');
        jLoop = 1;
    end
    
    % Set response data
    %arrStackList  = [];
end