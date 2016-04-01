function [ F ] = Ah_T3( IMAGE )
X = DCTPlane(IMAGE); absX = abs(X);
F  = extract_submodels_abs(absX,1:20,3,'hor');
F = F';

function f = extract_submodels_abs(X,IDs,T,type)
f = [];
for ID=IDs
    % interpret cooccurence ID as a list of DCT modes of interest
    [a,b] = ind2sub([6 6],find([0 1 2 3 4 5;6 7 8 9 10 21;11 12 13 14 22 26;15 16 17 23 27 30;18 19 24 28 31 33;20 25 29 32 34 35]==ID));
    if strcmp(type,'sym_8x8'), target = [a,b;b,a]; end
    if strcmp(type,'inter_semidiag'), target = [a+8,b;a,b+8]; end
    if strcmp(type,'inter_symm'), target = [a,b;b,a+8]; end
    if strcmp(type,'inter_hor'), target = [a,b;a,b+8]; end
    if strcmp(type,'inter_diag'), target = [a,b;a+8,b+8]; end
    if strcmp(type,'hor'), target = [a,b;a,b+1]; end
    if strcmp(type,'diag'), target = [a,b;a+1,b+1]; end
    if strcmp(type,'semidiag'), target = [a,b;a-1,b+1]; end
    if strcmp(type,'hor_skip'), target = [a,b;a,b+2]; end
    if strcmp(type,'diag_skip'), target = [a,b;a+2,b+2]; end
    if strcmp(type,'semidiag_skip'), target = [a,b;a-2,b+2]; end
    if strcmp(type,'horse'), target = [a,b;a-1,b+2]; end
    
    % extract the cooccurence features and 8x8 diag. symmetric features
    f1 = extractCooccurencesFromColumns_abs(ExtractCoocColumns(X,target),T);
    f2 = extractCooccurencesFromColumns_abs(ExtractCoocColumns(X,target(:,[2,1])),T);
    [f1,f2] = deal(normalize(f1),normalize(f2));
    f = [f;(f1(:)+f2(:))/2]; %#ok<*AGROW>
end
function F = extractCooccurencesFromColumns_abs(blocks,t)
% blocks = columns of values from which we want to extract the
% cooccurences. marginalize to [0..t]. no normalization involved
blocks(blocks>t) = t;   % marginalization
% 2nd order cooccurence
F = zeros(t+1,t+1);
for i=0:t
    fB = blocks(blocks(:,1)==i,2);
    if ~isempty(fB)
        for j=0:t
            F(i+1,j+1) = sum(fB==j);
        end
    end
end
function mask = getMask(target)
% transform list of DCT modes of interest into a mask with all zeros and
% ones at the positions of those DCT modes of interest
x=8;y=8;
if sum(target(:,1)>8)>0 && sum(target(:,1)>16)==0, x=16; end
if sum(target(:,1)>16)>0 && sum(target(:,1)>24)==0, x=24; end
if sum(target(:,1)>24)>0 && sum(target(:,1)>32)==0, x=32; end
if sum(target(:,2)>8)>0 && sum(target(:,2)>16)==0, y=16; end
if sum(target(:,2)>16)>0 && sum(target(:,2)>24)==0, y=24; end
if sum(target(:,2)>24)>0 && sum(target(:,2)>32)==0, y=32; end

mask = zeros(x,y);
for i=1:size(target,1)
    mask(target(i,1),target(i,2)) = 1;
end
function columns = ExtractCoocColumns(A,target)
% Take the target DCT modes and extracts their corresponding n-tuples from
% the DCT plane A. Store them as individual columns.
mask = getMask(target);
v = floor(size(A,1)/8)+1-(size(mask,1)/8); % number of vertical block shifts
h = floor(size(A,2)/8)+1-(size(mask,2)/8); % number of horizontal block shifts

for i=1:size(target,1)
    C = A(target(i,1)+(1:8:8*v)-1,target(i,2)+(1:8:8*h)-1);
    if ~exist('columns','var'),columns = zeros(numel(C),size(target,1)); end
    columns(:,i) = C(:);
end

function f = normalize(f)
S = sum(f(:));
if S~=0, f=f/S; end
function Plane=DCTPlane(path)
% loads DCT Plane of the given JPEG image + Quantization table
jobj=jpeg_read(path);
Plane=jobj.coef_arrays{1};