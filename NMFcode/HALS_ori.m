function [W,H,it,normR,normRes,T]...
    = HALS_ori(V,W,H,tol,maxit, stop)
% % Nonnegative Matrix Factorization
% % Hierarchical Alternating Least Squares (HALS)
if nargin <= 5
    stop = 0;
end
r = size(W,2);
% [W,H] = mat_scale(W,H);
R = V - W*H;
normR = zeros(maxit,1);
normR(1) = norm(R,'fro');

gradH = -W'*R;
gradW = -R*H';
resH = min(H,  gradH);
resW = min(W,  gradW);

normResH = zeros(maxit,1);
normResW = zeros(maxit,1);
normRes  = zeros(maxit,1);
normResH(1) = norm(resH,'fro');
normResW(1) = norm(resW,'fro');
normRes(1) = sqrt(normResH(1)^2 + normResW(1)^2);

T = zeros(maxit,1);
it = 0;
total = 0;
%subR = 1;
if stop == 0
    while normRes(it+1)/normRes(1) > tol  &&  it < maxit
        tic;
        it = it + 1;

        k = mod(it-1, r) + 1;
        %     H-subproblem
        Vbar = R + W(:,k)*H(k,:);
        H(k,:) = max(W(:,k)'*Vbar/(W(:,k)'*W(:,k)),  0);
        R = Vbar - W(:,k)*H(k,:);
        %     W-subproblem
        Vbar = R + W(:,k)*H(k,:);
        W(:,k) = max(Vbar*H(k,:)'/(H(k,:)*H(k,:)'),  0);
        R = Vbar - W(:,k)*H(k,:);

        gradH = -W'*R;
        resH = min(H,  gradH);
        gradW = -R*H';
        resW = min(W,  gradW);

        total = total + toc;
        T(it+1) = total;

        normResH(it+1) = norm(resH,'fro');
        normResW(it+1) = norm(resW,'fro');
        normRes(it+1) = sqrt(normResH(it+1)^2 + normResW(it+1)^2);
        normR(it+1) = norm(R,"fro");
        %subR = abs((normR(it+1) - normR(it)) / normR(1));
    end
elseif stop == 1
    while normR(it+1)/normR(1) > tol  &&  it < maxit
        tic;
        it = it + 1;

        k = mod(it-1, r) + 1;
        %     H-subproblem
        Vbar = R + W(:,k)*H(k,:);
        H(k,:) = max(W(:,k)'*Vbar/(W(:,k)'*W(:,k)),  0);
        R = Vbar - W(:,k)*H(k,:);
        %     W-subproblem
        Vbar = R + W(:,k)*H(k,:);
        W(:,k) = max(Vbar*H(k,:)'/(H(k,:)*H(k,:)'),  0);
        R = Vbar - W(:,k)*H(k,:);

        gradH = -W'*R;
        resH = min(H,  gradH);
        gradW = -R*H';
        resW = min(W,  gradW);

        total = total + toc;
        T(it+1) = total;

        normResH(it+1) = norm(resH,'fro');
        normResW(it+1) = norm(resW,'fro');
        normRes(it+1) = sqrt(normResH(it+1)^2 + normResW(it+1)^2);
        normR(it+1) = norm(R,"fro");
        %subR = abs((normR(it+1) - normR(it)) / normR(1));
    end
end
normR(it+2:end) = [];
normRes(it+2:end) = [];
T(it+2:end) = [];