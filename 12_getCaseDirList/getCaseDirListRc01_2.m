function [configList] = getCaseDirListRc01_2(rootPath)

    n = 1;

    configList(n).caseDir{1} = ...
        'Ra9e2/1_1_256/';
    configList(n).caseDir{2} = ...
        'Ra9e2/1_2_512/';

    n = n + 1;
    configList(n).caseDir{1} = ...
        'Ra3e3_r_c_0.1/00_1_iniTmp0_256/';
    configList(n).caseDir{2} = ...
        'Ra3e3_r_c_0.1/00_2_512/';
    % configList(n).caseDir{3} = ...
    %     'Ra3e3_r_c_0.1/00_3_512/';

    n = n + 1;
    configList(n).caseDir{1} = ...
        'Ra9e3/1_1_256/';
    configList(n).caseDir{2} = ...
        'Ra9e3/1_2_512/';
    
    n = n + 1;
    configList(n).caseDir{1} = ...
        'Ra3e4_r_c_0.1/00_1_iniTmp0_256/';
    configList(n).caseDir{2} = ...
        'Ra3e4_r_c_0.1/00_2_512/';

    n = n + 1;
    configList(n).caseDir{1} = ...
        'Ra9e4/1_1_256/';
    configList(n).caseDir{2} = ...
        'Ra9e4/1_2_512/';
    
    n = n + 1;
    configList(n).caseDir{1} = ...
        'Ra3e5_r_c_0.1/00_1_iniTmp0_256/';
    configList(n).caseDir{2} = ...
        'Ra3e5_r_c_0.1/00_2_iniTmp0_512/';
    configList(n).caseDir{3} = ...
        'Ra3e5_r_c_0.1/00_3_1024/';

    n = n + 1;
    configList(n).caseDir{1} = ...
        'Ra9e5/1_1_256/';
    configList(n).caseDir{2} = ...
        'Ra9e5/1_2_512/';
    configList(n).caseDir{3} = ...
        'Ra9e5/1_3_1024/';
    configList(n).caseDir{4} = ...
        'Ra9e5/1_4_1024/';
    
    % configList(4).caseDir{1} = ...
    % 'Ra3e6_r_c_0.1/02_1_initTmp0_1024/';
    % configList(4).caseDir{2} = ...
    % 'Ra3e6_r_c_0.1/02_2_initTmp0_1024/';
    % 
    % configList(5).caseDir{1} = ...
    % 'Ra3e7_r_c_0.1/04_1_iniTmp0_1024/';
    % 
    % configList(6).caseDir{1} = ...
    % 'Ra3e8_r_c_0.1/05_1_iniTmp0_1024/';
    % 
    % configList(7).caseDir{1} = ...
    % 'Ra3e9_r_c_0.1/46_1_iniTmp0_1536/';
    
    
    for idxConfig = 1:numel(configList)
        for idxSubCase = 1:numel(configList(idxConfig).caseDir)
            configList(idxConfig).caseDir{idxSubCase} = ...
                fullfile(rootPath,configList(idxConfig).caseDir{idxSubCase});
        end
    end
end

