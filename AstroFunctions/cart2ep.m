function EP = cart2ep(cart, mu)

% convert eci state vector to modified equinoctial elements

% input

%  mu   = gravitational constant (km**3/sec**2)
%  rr = eci position vector (kilometers)
%  vv = eci velocity vector (kilometers/second)

% output

%  mee(1) = semiparameter (kilometers)
%  mee(2) = f equinoctial element
%  mee(3) = g equinoctial element
%  mee(4) = h equinoctial element
%  mee(5) = k equinoctial element
%  mee(6) = true longitude (radians)

% Orbital Mechanics with MATLAB

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[m,n] = size(cart);

if m~=6
    error('Number of rows of Cartesian input must be 6');
end

EP = zeros(m,n);

for i = 1:n
    
    clearvars -except i m n EP mu cart
    
    rr = cart(1:3,i);
    vv = cart(4:6,i);
    
    
    radius = norm(rr);
    
    hv = cross(rr, vv);
    
    hmag = norm(hv);
    
    p = hmag^2 / mu;
    
    rdotv = dot(rr, vv);
    
    rzerod = rdotv / radius;
    
    eccen = cross(vv, hv);
    
    uhat = rr / radius;
    
    vhat = (radius * vv - rzerod * rr) / hmag;
    
    eccen = eccen / mu - uhat;
    
    % unit angular momentum vector
    
    hhat = hv / norm(hv);
    
    % compute kmee and hmee
    
    denom = 1.0 + hhat(3);
    
    k = hhat(1) / denom;
    
    h = -hhat(2) / denom;
    
    % construct unit vectors in the equinoctial frame
    
    fhat(1) = 1.0 - k^2 + h^2;
    fhat(2) = 2.0 * k * h;
    fhat(3) = -2.0 * k;
    
    ghat(1) = fhat(2);
    ghat(2) = 1.0 + k^2 - h^2;
    ghat(3) = 2.0 * h;
    
    ssqrd = 1.0 + k^2 + h^2;
    
    % normalize
    
    fhat = fhat / ssqrd;
    
    ghat = ghat / ssqrd;
    
    % compute fmee and gmee
    
    f = dot(eccen, fhat);
    
    g = dot(eccen, ghat);
    
    % compute true longitude
    
    cosl = uhat(1) + vhat(2);
    
    sinl = uhat(2) - vhat(1);
    
    l = atan2(sinl, cosl);
    
    % load modified equinoctial orbital elements array
    
    EP(1,i) = p;
    EP(2,i) = f;
    EP(3,i) = g;
    EP(4,i) = h;
    EP(5,i) = k;
    EP(6,i) = l;
    
end