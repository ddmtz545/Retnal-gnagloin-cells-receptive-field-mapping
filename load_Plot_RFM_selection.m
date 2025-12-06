clc
clear
close all

%%%%the inoutput mat file from 'load_Plot_RFM' is the the input for this
%%%%file. This code refines the ambigoues and doggy receptive field
addpath('/Users/majidlondon/Documents/MATLAB/09Spatial_pattern_illuminator/violinPlot')


%%%%%%%%%%%%%%%%%%%%%%%%  WT  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

addpath('/Users/majidlondon/Documents/01RFM_matfiles_data/25092024_WT_RFM')

filename='itmerged_2024-09-25T14-20-27McsRecording-sorted-uniM_neurons_1_216_RF_dimensions.mat';
selected_neurons = [187,183,170,167,166,164,161,156,153,152,150,145,138,137,134,132,131,130,129,125,124,123,118,117,116,108,...
    105,97,94,93,91,90,87,85,84,81,79,77,75,71,70,69,68,66,65,64,63,62,60,59,58,57,56,55,51,46,45,43,41,34,30,28,26,22,21,20,18,13,4,3];
selected_neurons = sort(selected_neurons);




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
load(filename)
%%%it loads RF_dimensions cell
%%%indices name: 1:diameter 2:area 3: i 4:Fitted Gaussian for
%%%Multiplication Matrix 5:thresholded matrix 6: centered_matrix


% Select and separate the rows from the cell array
selectedRows = RF_dimensions(selected_neurons,:);
[ms ns]=size(selectedRows);
ms= 1;
% %{
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%Extract the  4:Fitted Gaussian for Multiplication Matrix of each row
for i = 1:ms
    FGMM_matrixElements{i} = selectedRows{i, 4}; % Extract the favorite element of each row
end

% Plot each favorite element in a new figure
for i = 1:length(FGMM_matrixElements)
    figure;
    imagesc(FGMM_matrixElements{i});
    xlabel('Index');
    ylabel('Value');
    title(['Plot of First Element of Row ', num2str(selected_neurons(i))]);
    axis off
    colorbar;
end
%}





% %{
% %%%%%%%%%%%%%%%%%%%%%%%%%%Extract the centered_matrix element of each row
for i = 1:ms
    centered_matrixElements{i} = selectedRows{i, 6}; % Extract the favorite element of each row
    area_centered_matrixElements{i} = selectedRows{i, 2}; % Extract the (area) favorite element of each row

end

% Plot each favorite element in a new figure
for i = 1:length(centered_matrixElements)
    figure;
    imagesc(centered_matrixElements{i});
    xlabel('Index');
    ylabel('Value');
    title(['Plot of First Element of Row ', num2str(selected_neurons(i)),'   Area   ',num2str(area_centered_matrixElements{i})]);
    axis off
    
end
% %}


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Extract the thresholded matrix element of each row
for i = 1:ms
    thresholded_matrixElements{i} = selectedRows{i, 5}; % Extract the favorite element of each row
end

% Plot each thresholded matrix element in a new figure
figure
for i = 1:length(thresholded_matrixElements)
    %{
    figure;
    imagesc(thresholded_matrixElements{i});
    xlabel('Index');
    ylabel('Value');
    title(['Plot of First Element of Row ', num2str(selected_neurons(i))]);
    axis off
    %}

%%%%plotting circle or oval around the RF
matrix = thresholded_matrixElements{i};  %%%%%assine the matrix value

%{
Find the indices of positive values
[rowIdx, colIdx] = find(matrix > 0);
% Determine the bounding box for positive values
rowStart = min(rowIdx);
rowEnd = max(rowIdx);
colStart = min(colIdx);
colEnd = max(colIdx);

% Calculate the center and dimensions of the bounding box
centerRow = (rowStart + rowEnd) / 2; % Center row
centerCol = (colStart + colEnd) / 2; % Center column
height = rowEnd - rowStart + 1; % Height of the box
width = colEnd - colStart + 1; % Width of the box

% Scale the dimensions slightly for the oval/circle
scaleFactor = .2; % Adjust to make the oval larger
ovalHeight = height * scaleFactor;
ovalWidth = width * scaleFactor;

% Plot the matrix grid (optional, for visual reference)
% figure;
% imagesc(matrix);
% colormap hot;

% hold on;

% Plot the oval/circle around the region
rectangle('Position', [centerCol - ovalWidth/2, centerRow - ovalHeight/2, ovalWidth, ovalHeight], ...
          'Curvature', [1, 1], ... % Make it an oval/circle
          'EdgeColor', 'k', ... % Color of the outline
          'LineWidth', 2); % Thickness of the outline
%}

% Find the indices and values of positive elements
[rowIdx, colIdx, values] = find(matrix > 0.01);
%{
% Calculate the weighted center
totalValue = sum(values);
weightedRow = sum(rowIdx .* values) / totalValue; % Weighted mean of row indices
weightedCol = sum(colIdx .* values) / totalValue; % Weighted mean of column indices

% Determine the bounding box for positive values
rowStart = min(rowIdx);
rowEnd = max(rowIdx);
colStart = min(colIdx);
colEnd = max(colIdx);

% Calculate the dimensions of the bounding box
height = rowEnd - rowStart + 1; % Height of the box
width = colEnd - colStart + 1; % Width of the box

% Scale the dimensions slightly for the oval/circle
scaleFactor = .3; % Adjust to make the oval larger
ovalHeight = height * scaleFactor;
ovalWidth = width * scaleFactor;

% Plot the matrix grid using imagesc
% figure;
imagesc(matrix);
% colormap('hot'); % Adjust the colormap
% hold on;

% Plot the oval/circle around the region using the weighted center
rectangle('Position', [weightedCol - ovalWidth/2, weightedRow - ovalHeight/2, ovalWidth, ovalHeight], ...
          'Curvature', [1, 1], ... % Make it an oval/circle
          'EdgeColor', 'b', ... % Color of the outline
          'LineWidth', 2); % Thickness of the outline
%}

% Calculate the weighted center (enhanced accuracy)
totalValue = sum(values);
weightedRow = sum(rowIdx .* values) / totalValue; % Weighted mean of row indices
weightedCol = sum(colIdx .* values) / totalValue; % Weighted mean of column indices

% Refine the bounding box dimensions based on weighted values
weightedRowStd = sqrt(sum(values .* ((rowIdx - weightedRow) .^ 2)) / totalValue);
weightedColStd = sqrt(sum(values .* ((colIdx - weightedCol) .^ 2)) / totalValue);

% Scale the dimensions slightly for the oval/circle
scaleFactor = 0.6; % Adjust to make the oval larger
ovalHeight = 2 * weightedRowStd * scaleFactor; % Based on weighted standard deviation
ovalWidth = 2 * weightedColStd * scaleFactor;

% Plot the matrix grid using imagesc
% figure;
% imagesc(matrix);
% colormap('hot'); % Adjust the colormap
% colorbar;
% hold on;
% Plot the oval/circle around the region using the refined center
rectangle('Position', [weightedCol - ovalWidth/2, weightedRow - ovalHeight/2, ovalWidth, ovalHeight], ...
          'Curvature', [1, 1], ... % Make it an oval/circle
          'EdgeColor', 'b', ... % Color of the outline
          'LineWidth', 2); % Thickness of the outline



% Configure plot
% [mp np]=size(matrix);
% axis ([0 np 0 np]);
axis equal
xlim([1 30])
ylim([1 60])
set(gca, 'YDir', 'reverse'); % Flip Y-axis to align with matrix indexing


% title('Circular/Oval Boundary Around Positive Values');
% xlabel('Columns');
% ylabel('Rows');

% Set the background color to yellow
set(gca, 'Color', [1, 1, 1]); % RGB color for yellow =[1, 1, 0] background

% % Remove tick marks and labels
set(gca, 'XTick', [], 'YTick', []); % Remove ticks
% set(gca, 'XColor', 'y', 'YColor', 'y'); % Keep frame in black
set(gca, 'YTickLabel',[],'XTickLabel',[] );
box on; % Ensure the axes box remains visible

  
end

%%%%%%adding a scale to the RFM plot%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
hold on;

% Define scale bar properties
scale_length_units = 3.5; % 4 units in your figure corresponds to 100 µm
x_start = 26; % Starting position on the x-axis
y_start = 58; % Position slightly above the x-axis for visibility

% Draw the scale bar
line([x_start, x_start + scale_length_units], [y_start, y_start], ...
    'Color', 'k', 'LineWidth', 3); % White scale bar, 3px thick

% Add text label for scale
text(x_start + scale_length_units / 2, y_start + 1, '100 µm', ...
    'Color', 'k', 'FontSize', 10,'FontWeight', 'bold', 'HorizontalAlignment', 'center');

hold off;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%







