function [gradX3d,gradY3d,gradZ3d] = getGrad3DInSphVecBySphVec(sphVec,N2D)
    

    NSph = numel(sphVec);
    NCut = NSph - 5;

    % generate spherical mesh
    grille = obtainMesh('sph',NSph,NSph,0,pi*2,0,pi/2);
    x2d = grille.x2d;
    y2d = grille.y2d;
    theta = grille.theta;
    phi = grille.phi;
    dTheta = theta(2) - theta(1);
    dPhi = phi(2) - phi(1);
    
    % generate the shadow 2d Mesh Vector for computing 2d derivatives
    x2dS = linspace(-1.02,1.02,N2D);
    y2dS = linspace(-1.02,1.02,N2D);
    
    % project the spherical vector to 2D shadow mesh and calculate
    % derivatives
    sphVec2DMesh = fieldSphVecTo2DScalarMesh(sphVec,N2D);
    grad3DSphVec2DMesh = get3DGradBy2DMesh(x2dS,y2dS,sphVec2DMesh);
    
    gradX3dFrom2DMesh = interp2(x2dS,y2dS,grad3DSphVec2DMesh.gradX3d,x2d,y2d,"cubic");
    gradY3dFrom2DMesh = interp2(x2dS,y2dS,grad3DSphVec2DMesh.gradY3d,x2d,y2d,"cubic");
    gradZ3dFrom2DMesh = interp2(x2dS,y2dS,grad3DSphVec2DMesh.gradZ3d,x2d,y2d,"cubic");

    % calculate 3D derivatives by Spherical coordiante
    N_theta = NSph;
    N_phi = NSph;
    sphMesh = repmat(sphVec,1,N_phi);
    gradTheta = zeros(N_theta,N_phi);
    gradTheta(2:end-1,:) = 1/(2*dTheta)*(sphMesh(3:end,:) - sphMesh(1:end-2,:));
    gradTheta(end,:) = 1/(2*dTheta)*(3*sphMesh(end,:) -4*sphMesh(end-1,:) + sphMesh(end-2,:) );

    gradPhi = zeros(N_theta,N_phi);
    gradPhi(:,2:end-1) = 1/(2*dPhi)*(sphMesh(:,3:end) - sphMesh(:,1:end-2));
    gradPhi(:,1) = 1/(2*dPhi)*(sphMesh(:,2) - sphMesh(:,end-1));
    gradPhi(:,end) = gradPhi(:,1);
    
    gradX3dFromSphMesh = zeros(N_theta,N_phi);
    gradY3dFromSphMesh = zeros(N_theta,N_phi);
    gradZ3dFromSphMesh = zeros(N_theta,N_phi);
    for iTheta = 1:N_theta
        for iPhi = 1:N_phi
            gradX3dFromSphMesh(iTheta,iPhi) = ...,
                gradTheta(iTheta,iPhi)*cos(theta(iTheta))*cos(phi(iPhi)) - gradPhi(iTheta,iPhi)*sin(phi(iPhi))/sin(theta(iTheta));
            gradY3dFromSphMesh(iTheta,iPhi) = ...,
                gradTheta(iTheta,iPhi)*cos(theta(iTheta))*sin(phi(iPhi)) + gradPhi(iTheta,iPhi)*cos(phi(iPhi))/sin(theta(iTheta));
            gradZ3dFromSphMesh(iTheta,iPhi) = -1*gradTheta(iTheta,iPhi)*sin(theta(iTheta));
        end
    end
         
    gradX3d = zeros(NSph,1);
    gradY3d = zeros(NSph,1);
    gradZ3d = zeros(NSph,1);
    gradX3d(1:NCut) = mean(gradX3dFrom2DMesh(1:NCut,:),2);
    gradY3d(1:NCut) = mean(gradY3dFrom2DMesh(1:NCut,:),2);
    gradZ3d(1:NCut) = mean(gradZ3dFrom2DMesh(1:NCut,:),2);
    gradX3d(NCut+1:end) = mean(gradX3dFromSphMesh(NCut+1:end,:),2);
    gradY3d(NCut+1:end) = mean(gradY3dFromSphMesh(NCut+1:end,:),2);
    gradZ3d(NCut+1:end) = mean(gradZ3dFromSphMesh(NCut+1:end,:),2);
end

