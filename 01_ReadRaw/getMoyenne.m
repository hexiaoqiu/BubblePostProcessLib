% **************************************************************************************************
% Aurthor: Xiaoqiu HE
% Date: 2019/12/23
% **************************************************************************************************
% Purpose : 
%   This function reads the field of velocity, pressure and temperature stored in the form of strings
%   and in a integral file. Then to store them in the form of binary and in the separate files.
% **************************************************************************************************
% Attention :
%   the field is written in the sequency of lines, so the fileds is read by lines too.
% **************************************************************************************************
% Updates :
%   2020/08/19 : the function is modified in order to merge the multiple original string cases into 
%   one binary case. The variable <shiftTimeStep> is added in order to yield a correct time step index
%   in the merged binary case

function [tmpMoyenne, u2dMoyenne, v2dMoyenne, prsMoyenne] = getMoyenne(caseRawDir)
    
    % read the basic infor
    [x2dGauche, x2dDroit, y2dBas, y2dHaut, n1, n2, ~, ~, ~, ~, ~] = readBasicInformation(caseRawDir);

    % build the coordinate vector
    h1 = (x2dDroit - x2dGauche) / n1;
    h2 = (y2dHaut - y2dBas) / n2;
    x2dS = x2dGauche+h1/2:h1:x2dDroit-h1/2;
    y2dS = y2dBas+h2/2:h2:y2dHaut-h2/2;
    x2dU = x2dGauche:h1:x2dDroit;
    y2dU = y2dS;
    x2dV = x2dS;
    y2dV = y2dBas:h2:y2dHaut;

    % locate original data file
    nssaveDir = fullfile(caseRawDir,'nssave.dat');

    % allocate field of one time step  
    tmpMoyenne = zeros(n2, n1);
    u2dMoyenne = zeros(n2, n1 + 1);
    v2dMoyenne = zeros(n2 + 1, n1);
    prsMoyenne = zeros(n2, n1);

    % start the read loop
    % calculate the quntity of numbers in one timeStep
    % tmpOrg        u2dOrg(staggered)       v2dOrg(staggered)       prsOrg
    % n1*n2         n2*(n1+1)               (n2+1)*n1               n1*n2;
    numFloatInOneTimeStep = n1 * n2 + (n1 + 1) * n2 + n1 * (n2 + 1) + n1 * n2;
    numLineOneStep = ceil(numFloatInOneTimeStep / 5) + 1;
    halt = 0; % stop sign
    timeStep = 0; % time step indicator
    % open file
    fid = fopen(nssaveDir, 'r');
    % startReading = false;

    while halt == 0
        % indicate the index to operate
        timeStep = timeStep + 1;
        disp(['Time step = ',num2str(timeStep,'%d')])

        if timeStep == 1
            % This is first time to read
            % Skip all the timeSteps before
            numLineSkip = 3;
            % startReading = true;
        else
            % this is not the first time to read
            % only to skile the head line and the last read line
            % The 1 means the invalide data which occupy one line
            numLineSkip = numLineOneStep + 1 + 4;
        end

        % At the begining of the each time step
        % There are some head lines
        % Analyse this head line in order to check if the last time step is reached
        cache = textscan(fid, '%s %s', 1, 'headerlines', numLineSkip);
        if (numel(cache{1}) == 0)||(numel(cache{2}) == 0)
            disp('One or More time step data is corrupted');
            disp(['The last good time step is stored is ',num2str(timeStep,'%d')])
            disp('No MOYENNE result exists !')
            break;
        end
        str = cache{1}{1};
        if strcmp(str, 'MOYENNE')

            % if it is the last time step, halt the process
            % disp('Reach the FINAL step! exit!')
            disp(['Found the Moyenne result at the time step = ',num2str(timeStep,'%d')]); % the final step's data is always bad
            
        else
            % the write of data is disrrupted
            % No complete date of one time step is stored
            disp(['Skipping the time step = ',num2str(timeStep,'%d')]);
            continue;
        end

        % read fields
        cache = textscan(fid, '%f', numFloatInOneTimeStep, 'headerlines', 2);
        headIndex = 1;
        % compare the number of float number in the buffer
        numFloat = numel(cache{1});
        if numFloat < numFloatInOneTimeStep
            % if the number of float is less than normal
            % means that this step is broken
            disp('One or More time step data is corrupted');
            disp(['The last good time step is stored is ',num2str(timeStep,'%d')])
            break
        end

        % load tmpOrg Temperature
        for j = 1:n2
            y = y2dS(j);
            for i = 1:n1
                x = x2dS(i);
                r = sqrt(x^2+y^2);
                if r < 1
                    tmpMoyenne(j, i) = cache{1}(headIndex);    
                else
                    tmpMoyenne(j, i) = 1;
                end
                headIndex = headIndex + 1;
            end
        end
        

        % load u2dOrg
        for j = 1:n2
            y = y2dU(j);
            for i = 1:(n1 + 1)
                x = x2dU(i);
                r = sqrt(x^2+y^2);
                if r < 1
                    u2dMoyenne(j, i) = cache{1}(headIndex);
                else
                    u2dMoyenne(j, i) = 0;
                end
                headIndex = headIndex + 1;
            end
        end

        % load v2dOrg
        for j = 1:(n2 + 1)
            y = y2dV(j);
            for i = 1:n1
                x = x2dV(i);
                r = sqrt(x^2+y^2);
                if r < 1
                    v2dMoyenne(j, i) = cache{1}(headIndex);
                else
                    v2dMoyenne(j,i) = 0;
                end
                headIndex = headIndex + 1;
            end
        end

        % load prsOrg
        for j = 1:n1
            for i = 1:n2
                prsMoyenne(j, i) = cache{1}(headIndex);
                headIndex = headIndex + 1;
            end
        end

        halt = 1;

    end
    fclose(fid);
    
end