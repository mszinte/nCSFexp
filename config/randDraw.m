function result = randDraw(liste, numTirages)
    % Initialize the final result list
    result = []; 
    succes = false;
    maxAttempts = 1000; % Maximum number of attempts to find a solution
    attempt = 0;

    % Retry the entire process until successful or maximum attempts reached
    while ~succes && attempt < maxAttempts
        attempt = attempt + 1;
        try
            % Initialize tirages
            tirages = cell(1, numTirages);
            result = []; % Reset the final result list
            
            % Draw without replacement and respecting the conditions
            for t = 1:numTirages
                values = liste;
                previousTirage = [];
                if t > 1
                    previousTirage = tirages{t-1};
                end
                currentTirage = [];
                
                for i = 1:length(liste)
                    possibleValues = values;
                    if i > 1
                        possibleValues = setdiff(possibleValues, currentTirage(end));
                        possibleValues = possibleValues(abs(possibleValues - currentTirage(end)) > 1);
                    end
                    if t > 1
                        for pv = 1:length(previousTirage)
                            if mod(find(previousTirage == previousTirage(pv)), 2) == mod(i, 2)
                                possibleValues = setdiff(possibleValues, previousTirage(pv));
                            end
                        end
                        if i == 1
                            possibleValues = setdiff(possibleValues, previousTirage(end));
                        end
                    end
                    if isempty(possibleValues)
                        error('Impossible de satisfaire les conditions de tirage.');
                    end
                    currentTirage = [currentTirage, possibleValues(randperm(length(possibleValues), 1))];
                    values = setdiff(values, currentTirage(end));
                end
                tirages{t} = currentTirage;
                result = [result, currentTirage]; % Concatenate the results in the final list
            end
            
            % If successful, exit the loop
            succes = true;
        catch
            % Retry the entire process
        end
    end
    
    % If not successful after maximum attempts, return an error
    if ~succes
        error('Impossible to satisfy the draw conditions within the maximum number of attempts.');
    end
    % Convert result to a column vector
    result = result';
end