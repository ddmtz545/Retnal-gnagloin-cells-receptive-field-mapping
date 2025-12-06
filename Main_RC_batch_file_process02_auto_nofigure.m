clc
clear all
close all
%%%%this code multiply and sum the matrices

tic



run('nexDataParser_04_RC_scan_Rverti_auto.m')
save RC_verti_map_vector.mat qcell_Rverti filename3
% % save RC_verti_map_vector.mat RC_verti_map_vector RC_verti_Neuron_amp RC_verti_map_matrix
% RC_verti_map_vector=zeros(1,30);%%%%firing rate for example neuron

%%%%qcell contains the 3 matrices for all 30 bars

% % % qcell_Rverti{cell_id,1}= RC_verti_map_vector;
% % % qcell_Rverti{cell_id,2}= RC_verti_Neuron_amp; 
% % % qcell_Rverti{cell_id,3}= RC_verti_map_matrix;

%%%RC_verti_map_vector(1x30)  contains the single neuron amplitude values
%%%RC_verti_Neuron_amp(30x1)cell  contains the amplitude values for all neurons
%%%RC_verti_map_matrix(12x12x30)  contains 12x12 heatmap matrix values for each bar

run('nexDataParser_05_RC_scan_Rhori_auto.m') 
save RC_hori_map_vector.mat qcell_Rhori filename3
% % save RC_hori_map_vector.mat RC_hori_map_vector RC_hori_Neuron_amp RC_hori_map_matrix
% RC_hori_map_vector=zeros(60,1);%%%%firing rate for example neuron
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%qcell contains the 3 matrices for all 60 bars
% % % qcell_Rhori{cell_id,1}= RC_hori_map_vector;
% % % qcell_Rhori{cell_id,2}= RC_hori_Neuron_amp; 
% % % qcell_Rhori{cell_id,3}= RC_hori_map_matrix;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%RC_hori_map_vector(60x1)  contains the single neuron amplitude values
%%%RC_hori_Neuron_amp(60x1)cell  contains the amplitude values for all neurons
%%%RC_hori_map_matrix(12x12x60)  contains 12x12 heatmap matrix values for each bar

%%

try
    isempty(showPlots);
catch
    showPlots = 0;
end
%%%% showPlots :switches ON and OFF plots to qucken the
%%%% processing speed
showPlots = 0;

%%%reevaluate from here%%%%
%%%%%set scale bar limits 
heatleftlim=0; 
heatrightlim=100;


load('RC_verti_map_vector.mat')
load('RC_hori_map_vector.mat')

[mcells n]=size(qcell_Rhori);
%%%%the value for m should be the same for both hori and verti qcells
%%%%assigning values to variables from cell that has comprehensive
%%%%calculations

%%%this cell save 3 matrices values for mapped receptive fields
qcell_RFM=cell(mcells,5);

%%%%%%I added this line for computer crashes%%%%%
% mcells = 3;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

for cell_id = 1:mcells


%%%%qcell contains the 3 matrices for all 30 bars
RC_verti_map_vector = qcell_Rverti{cell_id,1} ;
RC_verti_Neuron_amp = qcell_Rverti{cell_id,2} ; 
RC_verti_map_matrix = qcell_Rverti{cell_id,3} ;
RC_verti_neuron_class_matrix = qcell_Rverti{cell_id,4} ;

%%%%qcell contains the 3 matrices for all 60 bars
RC_hori_map_vector = qcell_Rhori{cell_id,1} ;
RC_hori_Neuron_amp = qcell_Rhori{cell_id,2} ; 
RC_hori_map_matrix = qcell_Rhori{cell_id,3} ;
RC_hori_neuron_class_matrix = qcell_Rhori{cell_id,4} ;




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

row_ind=60;col_ind=30;
%%%this line give a matrix with repititive columns or rows

RC_heatmap_matrix_verti=zeros(60,30);%%%%firing rate for example neuron
RC_heatmap_matrix2_hori=zeros(60,30);%%%%firing rate for example neuron


for i=1:row_ind
RC_heatmap_matrix_verti(i,:)= normalize(RC_verti_map_vector,'range');
% RC_heatmap_matrix_verti(i,:)= RC_verti_map_vector;
end
for j=1:col_ind
RC_heatmap_matrix2_hori(:,j)= normalize(RC_hori_map_vector,'range');
% RC_heatmap_matrix2_hori(:,j)= RC_hori_map_vector;
end


RC_heatmap_mltply=RC_heatmap_matrix_verti.*RC_heatmap_matrix2_hori;
RC_heatmap_plus=(RC_heatmap_matrix_verti+RC_heatmap_matrix2_hori)./2;



close all

if showPlots==1

figure;
h=heatmap(RC_verti_map_vector,'Colormap',jet);
% Set specific color limits for the scale bar
colorLimits = [heatleftlim, heatrightlim];
h.ColorLimits = colorLimits;
title('RC verti map Max Amplitude ')

figure;
h=heatmap(RC_hori_map_vector,'Colormap',jet);
% Set specific color limits for the scale bar
colorLimits = [heatleftlim, heatrightlim];
h.ColorLimits = colorLimits;
title('RC hori map Max Amplitude ')




%%%%%set scale bar limits 
heatleftlim=0; 
heatrightlim=1;


figure;
h=heatmap(RC_heatmap_mltply,'Colormap',jet);

title(' Multiplification of Max Amplitude ')
end
%%%%to save the value in mat file
qcell_RFM{cell_id,3}= RC_heatmap_mltply;%%%Multiplification of Max Amplitude



if showPlots==1
figure;
h=heatmap(RC_heatmap_plus,'Colormap',jet);
% Set specific color limits for the scale bar
% colorLimits = [heatleftlim, heatrightlim];
% h.ColorLimits = colorLimits;
title(' sum of Max Amplitude ')
end

%%%heatmap for heatmap matirces
verti_sum_matrices = sum(RC_verti_map_matrix,3)./30;
hori_sum_vertices = sum(RC_hori_map_matrix,3)./60;
total_matrices=(verti_sum_matrices+hori_sum_vertices)./2;

heatleftlim=0; heatrightlim=10;

if showPlots==1
figure;
h=heatmap(total_matrices,'Colormap',jet);
% Set specific color limits for the scale bar
colorLimits = [heatleftlim, heatrightlim];
h.ColorLimits = colorLimits;
title(' total heatmap matrices average for Max Amplitude ')
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%gaussian fitting for multiplied matrices
% Define the threshold
threshold = 0.4;
% Replace all values below the threshold with zero
RC_heatmap_mltply(RC_heatmap_mltply < threshold) = 0;

% Define the 2D Gaussian function
gaussian2D = @(b, x) b(1) * exp(-((x(:,1)-b(2)).^2 / (2*b(4)^2) + (x(:,2)-b(3)).^2 / (2*b(5)^2))) + b(6);

% Step 1: Smooth the data using a Gaussian filter
sigma = 2; % Standard deviation for Gaussian filter (adjust as necessary)
smoothedDataMatrix2 = imgaussfilt(RC_heatmap_mltply, sigma);
smoothedDataMatrix = RC_heatmap_mltply;


% Create a grid for the data
[xData, yData] = meshgrid(1:size(smoothedDataMatrix, 2), 1:size(smoothedDataMatrix, 1));
xData = xData(:);
yData = yData(:);
zData = smoothedDataMatrix(:);

% Initial guesses for the parameters [amplitude, x0, y0, sigma_x, sigma_y, offset]
initialGuess = [max(zData), mean(xData), mean(yData), std(xData), std(yData), min(zData)];

options = optimoptions('lsqcurvefit', 'FunctionTolerance', 1e-8, 'OptimalityTolerance', 1e-8, 'Display', 'iter');

% Step 6: Perform the optimization using lsqcurvefit with refined tolerances
fitParams = lsqcurvefit(gaussian2D, initialGuess, [xData, yData], zData, [], [], options);


% Create a grid for visualization
[X, Y] = meshgrid(1:size(smoothedDataMatrix, 2), 1:size(smoothedDataMatrix, 1));

% Calculate the fitted Gaussian
Z_fit = gaussian2D(fitParams, [X(:), Y(:)]);
Z_fit = reshape(Z_fit, size(smoothedDataMatrix, 1), size(smoothedDataMatrix, 2));


if showPlots==1
% Plot the original data
figure;
% subplot(1, 2, 1);
imagesc(smoothedDataMatrix2);
title('Fitted Gaussian for Multiplication Matrix');
colorbar;
axis image;

figure
% RC_heatmap_mltply
% subplot(1, 2, 2);
imagesc(RC_heatmap_mltply);
title('Original Data for Multiplication Matrix');
colorbar;
axis image;
end

qcell_RFM{cell_id,1}= smoothedDataMatrix2;%%Fitted Gaussian for Multiplication Matrix
qcell_RFM{cell_id,2}= RC_heatmap_mltply; %%Original Data for Multiplication Matrix
qcell_RFM{cell_id,4}= RC_verti_neuron_class_matrix;%%%30x1 array
qcell_RFM{cell_id,5}= RC_hori_neuron_class_matrix;%%%60x1 array



fprintf('This is map neuron number: %d\n',cell_id)
end

filename3=strcat(filename3,'_RFM.mat');
save (filename3,'qcell_RFM')

toc