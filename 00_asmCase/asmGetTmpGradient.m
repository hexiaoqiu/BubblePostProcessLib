function [gradTmpX3d,gradTmpY3d,gradTmpZ3d] = asmGetTmpGradient(asmCase,subCaseIdx,tmpOrgMsh,itpMesh)
% attention!
% the imput tmpOrgMsh is the temperature field on the org mesh!
% the org mesh belongs to a sub case which is inidacted by subCaseIdx!
    
    
    [gradTmpX2d, gradTmpY2d] = ...
        getGradCoord2d( ...
            asmCase.h1(subCaseIdx),...
            asmCase.h2(subCaseIdx),...
            tmpOrgMsh ...
        );
    [x2dOrg,y2dOrg] = ...
        meshgrid( ...
            asmCase.x2dS{subCaseIdx},...
            asmCase.y2dS{subCaseIdx}...
        );
    [gradTmpX3dInnerOrg,gradTmpY3dInnerOrg,gradTmpZ3dInnerOrg] = ...
        grad2dToGrad3d(x2dOrg,y2dOrg,gradTmpX2d,gradTmpY2d);
    gradTmpX3dInner = ...
        interp2(    asmCase.x2dS{subCaseIdx}, ...
                    asmCase.y2dS{subCaseIdx},...
                    gradTmpX3dInnerOrg,...
                    itpMesh.x2d,...
                    itpMesh.y2d,...
                    'spline');
    gradTmpY3dInner = ...
        interp2(    asmCase.x2dS{subCaseIdx}, ...
                    asmCase.y2dS{subCaseIdx},...
                    gradTmpY3dInnerOrg,...
                    itpMesh.x2d,...
                    itpMesh.y2d,...
                    'spline');
    gradTmpZ3dInner = ...
        interp2(    asmCase.x2dS{subCaseIdx}, ...
                    asmCase.y2dS{subCaseIdx},...
                    gradTmpZ3dInnerOrg,...
                    itpMesh.x2d,...
                    itpMesh.y2d,...
                    'spline');
    
    tmp = interp2(  asmCase.x2dS{subCaseIdx}, ...
                    asmCase.y2dS{subCaseIdx},...
                    tmpOrgMsh,...
                    itpMesh.x2d,...
                    itpMesh.y2d,...
                    'spline');
                
    [gradPhiTmp,gradThetaTmp] = ...
        getGradCoordSph(itpMesh.dPhi, itpMesh.dTheta, tmp);
    [gradTmpX3dOuter, gradTmpY3dOuter, gradTmpZ3dOuter] = ...
        gradSphToGrad3d(itpMesh.phi, itpMesh.theta, gradPhiTmp, gradThetaTmp);
    
    overlapIdx = round(itpMesh.nTheta/10);
    gradTmpX3d = gradTmpX3dOuter;
    gradTmpX3d(1:overlapIdx,:) = gradTmpX3dInner(1:overlapIdx,:);
    gradTmpY3d = gradTmpY3dOuter;
    gradTmpY3d(1:overlapIdx,:) = gradTmpY3dInner(1:overlapIdx,:);
    gradTmpZ3d = gradTmpZ3dOuter;
    gradTmpZ3d(1:overlapIdx,:) = gradTmpZ3dInner(1:overlapIdx,:);
end

