function [configList] = getCaseDirListA4(rootPath)
    
    configList(1).caseDir{1} = ...
        '0_RaBubble_3E6/1_1_256/';
    configList(1).caseDir{2} = ...
        '0_RaBubble_3E6/1_2_256/';
    configList(1).caseDir{3} = ...
        '0_RaBubble_3E6/1_3_1024/';
    
    configList(2).caseDir{1} = ...
        '1_RaBubble_1E7/1_1_256/';
    configList(2).caseDir{2} = ...
        '1_RaBubble_1E7/1_2_512/';
    configList(2).caseDir{3} = ...
        '1_RaBubble_1E7/1_3_1024/';
    
    
    for idxConfig = 1:numel(configList)
        for idxSubCase = 1:numel(configList(idxConfig).caseDir)
            configList(idxConfig).caseDir{idxSubCase} = ...
                fullfile(rootPath,configList(idxConfig).caseDir{idxSubCase});
        end
    end

end

