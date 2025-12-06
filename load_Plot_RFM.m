clc
clear 
close all

%%%this program loads previously calculated receptive fields maps and plot
%%%them, finds the diameter and area

fontSize = 14;

%%%%var = qcell_RFM


%%%%%%%%%%%%%%%%%%%%%%%%WT transplant%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
addpath('/Users/majidlondon/Documents/01RFM_matfiles_data/19092023_WT_RFM')
filename='split_merged_05_2023-09-19T13-46-26McsRecording-WT-sorted-units_05_qcell_RC_scan_real_hori_eventNo_1_barNo_60_0.01s_neuronClasses.mat_RFM_1_183_th$4.mat';


%%
load(filename)

[m n]=size(qcell_RFM);

%%%%to select a section of data enter m value manually
%%%below line replaces above line of code
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
RF_dimensions=cell(m,6);

for i=1:m
    
% Plot the original data
figure;
% subplot(1, 2, 1);
imagesc(qcell_RFM{i,1});

figTitle=sprintf('Fitted Gaussian for Multiplication Matrix Neuron#:%d',i);
title(figTitle,'FontSize',fontSize);

colorbar;
% colorbar('off')

% Example: Adjust colorbar range to match Gaussian peak and spread
caxis([0, 0.25]); % Adjust range for Gaussian values between x and y

axis image;

RF_dimensions{i,4}= qcell_RFM{i,1};

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
matrix = qcell_RFM{i,1};
%%%%%plotting the mask and then area calculation
% Step 1: Find the peak value
peakValue = max(matrix(:));

% Step 2: Threshold the gausiian fitted matrix at 25% of the peak
threshold = 0.25 * peakValue;
matrix(matrix < threshold) = 0;

% Step 3: Find the peak location after thresholding
[maxValue, linearIdx] = max(matrix(:));
[rowPeak, colPeak] = ind2sub(size(matrix), linearIdx);

% Step 4: Create a circular mask with a radius of 10 around the peak
[x, y] = meshgrid(1:size(matrix, 2), 1:size(matrix, 1));
mask = sqrt((x - colPeak).^2 + (y - rowPeak).^2) <= 10;

% Step 5: Apply the mask to keep only the peak area within the 10-element radius
matrix(~mask) = 0;

% Display the final matrix
% figure
% imagesc(matrix)
% 
%%%%%%do not comment below line when you want to save RF-dimensions
RF_dimensions{i,5} = matrix;
% %%%%%%%%%%%%%%%area and dimeter calculation
%set the pixel size
Px_size= 25;
[row, col] = find(matrix); % Returns row and column indices of non-zero elements
area=length(row)*(Px_size^2);
diameter= max((max(row)-min(row)+1),(max(col)-min(col))+1)*Px_size;
figTitle=sprintf('The total RF area:%d u2m \n The RF diameter:%d um Neuron#:%d',area,diameter,i);
% title(figTitle);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Step 6: Extract a 15x15 area centered around the peak for plotting
margin=7;
rowStart = max(1, rowPeak - margin);
rowEnd = min(size(matrix, 1), rowPeak + margin);
colStart = max(1, colPeak - margin);
colEnd = min(size(matrix, 2), colPeak + margin);
matrix_peak_area = matrix(rowStart:rowEnd, colStart:colEnd);



% Step 7: Create a 15x15 matrix and place the extracted peak area at the center
centered_matrix = zeros(21, 21); % Initialize a 20x20 zero matrix
startRow = floor((21 - (rowEnd - rowStart + 1)) / 2) + 1;
startCol = floor((21 - (colEnd - colStart + 1)) / 2) + 1;
centered_matrix(startRow:startRow + (rowEnd - rowStart), startCol:startCol + (colEnd - colStart)) = matrix_peak_area;

% Plotting
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%centered_Matrix%%%%%%%%%%%%%%%%%%%%%%%
%{
figure;
imagesc(centered_matrix);

% colormap hot;
colorbar;
figTitle=sprintf('15x15 Peak Area Centered Around Peak Neuron#:%d',i);
title(figTitle);
axis off
%}

RF_dimensions{i,6} = centered_matrix;



figure
% RC_heatmap_mltply
% subplot(1, 2, 2);
imagesc(qcell_RFM{i,2});
% imagesc(RC_heatmap_mltply);
figTitle=sprintf('Original Data for Multiplication Matrix Neuron#:%d',i);
title(figTitle,'FontSize',fontSize);
% title('Original Data for Multiplication Matrix');
colorbar;
axis image;

figure
% RC_heatmap_mltply
% subplot(1, 2, 2);
heatmap(qcell_RFM{i,3});
% imagesc(RC_heatmap_mltply);
figTitle=sprintf('Original Data for Multiplication Matrix Neuron#:%d',i);
title(figTitle);


RF_dimensions{i,1}=diameter;
RF_dimensions{i,2}=area;
RF_dimensions{i,3}=i;

% close all
% colorbar;
% axis image;
fprintf('This is neuron :%d\n',i)
end 
%%%%uncomment for saving diameter and area
filename3=strcat(filename(7:57),filename(end-18:end-4),'_RF_dimensions.mat');
save (filename3,'RF_dimensions')