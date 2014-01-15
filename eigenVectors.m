function [vectors values] = eigenVectors(matrix)
sigma1 = abs(matrix(1,1));
sigma2 = abs(matrix(2,2));
ro = abs(matrix(1,2));
firstPart = (sigma1+sigma2)/2;
secondPart = sqrt((((sigma1-sigma2)/2)^2)+ro^2);
values = [firstPart + secondPart, firstPart - secondPart];
matrix1 = matrix - values(1)*diag(ones(2,1));
det(matrix1)
matrix1 = matrix - values(2)*diag(ones(2,1));
det(matrix1)
lambda = eig(matrix);
matrix1 = matrix - lambda(1)*diag(ones(2,1));
det(matrix1)
matrix1 = matrix - lambda(2)*diag(ones(2,1));
det(matrix1)
end