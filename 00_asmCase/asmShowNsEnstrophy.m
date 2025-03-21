function [ok] = asmShowNsEnstrophy( varargin )
    minArgs = 1;
    maxArgs = 4;
    narginchk(minArgs,maxArgs);
    if nargin == 3
        thisAsm = varargin{1};
        savePic = varargin{2};
        onlySavedIdx = varargin{3};
    elseif nargin == 2
        thisAsm = varargin{1};
        savePic = varargin{2};
        onlySavedIdx = true;
    elseif nargin == 1
        thisAsm = varargin{1};
        savePic = false;
        onlySavedIdx = true;
    elseif nargin == 4
        thisAsm = varargin{1};
        savePic = varargin{2};
        onlySavedIdx = varargin{3};
        picPath = varargin{4};
    end
    
    [asmTime,nsTest{1},nsTest{2},nsTest{3},nsTest{4}] = asmFusionNsTest(thisAsm,onlySavedIdx);


    LineWidth = 4;
    FontSize = 30;
    legendFontSize = 20;
    labelFontSize = 35;
    titleFontSize = 18;
    pOsItiON = [0,20,1024,768];


    fig_1 = figure();
    set(fig_1,'position',pOsItiON);
    for i = 2
        x = asmTime;
        y = nsTest{i};
        plot(x, y, ...,
            '-r','LineWidth',LineWidth)
        hold on
    end
    legendText{1} = '$I_{\Omega}$';
    hold off
    
    % set global coef
    set(gca,'FontSize',FontSize);
    
    % legend 
    legend(legendText,'interpreter','latex','FontSize',legendFontSize, ...
        'location','best','NumColumns',1,'Orientation','horizontal');
    legend('boxoff')
    
    % axis
    ylabel('Total Quantities','interpreter','latex','FontSize',labelFontSize)
    ylim([0,1.1*max(y,[],'all')])
    % ylim([min(cell2mat(nsTest),[],'all')*1.05,max(cell2mat(nsTest),[],'all')*1.2])
    xlabel('$t$','interpreter','latex','FontSize',labelFontSize)
    
    % title
    figTitle = asmGetPlotTitle(thisAsm);
    title(figTitle,'interpreter','latex','FontSize',titleFontSize);
    
    
    % other config
    grid on;
    drawnow
    
    % save config
    if savePic == true
        caseName = asmGetSaveName(thisAsm);
        suffix = char(datetime("now","Format","uuuu-MM-dd"));
        fileName = ['NsEnstrophy_',caseName,'_',suffix];
        fileNameFull = [fileName,'.png'];
        saveas(gcf,fullfile(picPath,fileNameFull));
        % fileNameFull_1 = [fileName,'.eps'];
        % saveas(gcf,fullfile(folderName,fileNameFull_1),'epsc');
    end

    ok = true;
end