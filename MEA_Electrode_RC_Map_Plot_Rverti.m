
% % clc
% % clear all
close all

% %%%%assign the neuron index   %%%04/09/2024transferred to 04 datparser 
% Neuron_index_verti=19;

% Set the font size to 24 (you can adjust this value as needed)
fontSize = 26;
%%%%%set scale bar limits 
heatleftlim=0; 
heatrightlim=150;

% % Set specific color limits for the scale bar
% colorLimits = [heatleftlim, heatrightlim];
% h.ColorLimits = colorLimits;

heat_num_leftlim =0;
heat_num_rightlim =4;

% % Set specific color limits for the scale bar
% colorLimits = [heat_num_leftlim, heat_num_rightlim];
% h.ColorLimits = colorLimits;

bar_num_ylim = 20;
%%ylim([0 bar_num_ylim])
bar_avg_resp_ylim = 100;
%%ylim([0 bar_avg_resp_ylim])

%%
%%%%this produce a cell with chanel names and corespondent 
data=struct();
data.D1=0;data.E1=0;data.F1=0;data.G1=0;data.H1=0;data.J1=0;
data.C2=0;data.D2=0;data.E2=0;data.F2=0;data.G2=0;data.H2=0;data.J2=0;data.K2=0;
data.B3=0;data.C3=0;data.D3=0;data.E3=0;data.F3=0;data.G3=0;data.H3=0;data.J3=0;data.K3=0;data.L3=0;
data.A4=0;data.B4=0;data.C4=0;data.D4=0;data.E4=0;data.F4=0;data.G4=0;data.H4=0;data.J4=0;data.K4=0;data.L4=0;data.M4=0;
data.A5=0;data.B5=0;data.C5=0;data.D5=0;data.E5=0;data.F5=0;data.G5=0;data.H5=0;data.J5=0;data.K5=0;data.L5=0;data.M5=0;
data.A6=0;data.B6=0;data.C6=0;data.D6=0;data.E6=0;data.F6=0;data.G6=0;data.H6=0;data.J6=0;data.K6=0;data.L6=0;data.M6=0;
data.A7=0;data.B7=0;data.C7=0;data.D7=0;data.E7=0;data.F7=0;data.G7=0;data.H7=0;data.J7=0;data.K7=0;data.L7=0;data.M7=0;
data.A8=0;data.B8=0;data.C8=0;data.D8=0;data.E8=0;data.F8=0;data.G8=0;data.H8=0;data.J8=0;data.K8=0;data.L8=0;data.M8=0;
data.A9=0;data.B9=0;data.C9=0;data.D9=0;data.E9=0;data.F9=0;data.G9=0;data.H9=0;data.J9=0;data.K9=0;data.L9=0;data.M9=0;
data.B10=0;data.C10=0;data.D10=0;data.E10=0;data.F10=0;data.G10=0;data.H10=0;data.J10=0;data.K10=0;data.L10=0;
data.C11=0;data.D11=0;data.E11=0;data.F11=0;data.G11=0;data.H11=0;data.J11=0;data.K11=0;
data.D12=0;data.E12=0;data.F12=0;data.G12=0;data.H12=0;data.J12=0;

nn=numel(namesAll);
abc=cell(nn,11);
for i=1:nn
    
    abc{i,1}=namesAll(i);
    abc{i,2}=neuronClasses.AmplitudeON(i);
    abc{i,3}=neuronClasses.AmplitudeOFF(i);
    abc{i,4}=max(neuronClasses.AmplitudeON(i),neuronClasses.AmplitudeOFF(i));
    abc{i,5}=extractAfter(namesAll{i},"Data1");
    abc{i,6}=extractBetween(namesAll{i},"(",")");
    abc{i,7}=extractAfter(namesAll{i},")");
    abc{i,8}=0;
    abc{i,9}=0;
    abc{i,10}=0;
    abc{i,11}=0;

%     data.(cell2mat(abc{i,6}))=abc{i,4}; 
end

%%%%%%%%%%%now find neurons in each channel and claculate the average
abcmat_channel_name_avg=string();
abcmat_channel_max_value=[];
for ii=1:nn
    abcmat_channel_name_avg(ii,1)=cell2mat(abc{ii,6});
    abcmat_channel_max_value(ii,1)=abc{ii,4};
    
end
% Find unique elements and their counts
[uniqueElements_ch_avg, ida_ch_avg, idx_ch_avg] = unique(abcmat_channel_name_avg);
% Display unique elements and their counts
Ch_amp_avg=[];
for iii = 1:numel(ida_ch_avg)
    [m_ch_avg,n_ch_avg]=find(abcmat_channel_name_avg==abcmat_channel_name_avg(ida_ch_avg(iii)));
    Ch_amp_avg(iii)=mean(abcmat_channel_max_value(m_ch_avg));
    data.(uniqueElements_ch_avg(iii))=Ch_amp_avg(iii);
%     fprintf('Element: %s, Count: %d\n', uniqueElements{iii}, counts(iii));
%     data2.(uniqueElements{i})=counts(i);
end
% [m,n]=find(test==test(ia(1)))

MEA_map=[0,0,0,data.D1,data.E1,data.F1,data.G1,data.H1,data.J1,0,0,0
0,0,data.C2,data.D2,data.E2,data.F2,data.G2,data.H2,data.J2,data.K2,0,0
0,data.B3,data.C3,data.D3,data.E3,data.F3,data.G3,data.H3,data.J3,data.K3,data.L3,0
data.A4,data.B4,data.C4,data.D4,data.E4,data.F4,data.G4,data.H4,data.J4,data.K4,data.L4,data.M4
data.A5,data.B5,data.C5,data.D5,data.E5,data.F5,data.G5,data.H5,data.J5,data.K5,data.L5,data.M5
data.A6,data.B6,data.C6,data.D6,data.E6,data.F6,data.G6,data.H6,data.J6,data.K6,data.L6,data.M6
data.A7,data.B7,data.C7,data.D7,data.E7,data.F7,data.G7,data.H7,data.J7,data.K7,data.L7,data.M7
data.A8,data.B8,data.C8,data.D8,data.E8,data.F8,data.G8,data.H8,data.J8,data.K8,data.L8,data.M8
data.A9,data.B9,data.C9,data.D9,data.E9,data.F9,data.G9,data.H9,data.J9,data.K9,data.L9,data.M9
0,data.B10,data.C10,data.D10,data.E10,data.F10,data.G10,data.H10,data.J10,data.K10,data.L10,0
0,0,data.C11,data.D11,data.E11,data.F11,data.G11,data.H11,data.J11,data.K11,0,0
0,0,0,data.D12,data.E12,data.F12,data.G12,data.H12,data.J12,0,0,0];


%%
%%%%this piece of code converts channel names into a string array, we need
%%%%this array to use find function

data2=struct(); %%%%this a the structure for number of responsive neurons in each recording channel
data2.D1=0;data2.E1=0;data2.F1=0;data2.G1=0;data2.H1=0;data2.J1=0;
data2.C2=0;data2.D2=0;data2.E2=0;data2.F2=0;data2.G2=0;data2.H2=0;data2.J2=0;data2.K2=0;
data2.B3=0;data2.C3=0;data2.D3=0;data2.E3=0;data2.F3=0;data2.G3=0;data2.H3=0;data2.J3=0;data2.K3=0;data2.L3=0;
data2.A4=0;data2.B4=0;data2.C4=0;data2.D4=0;data2.E4=0;data2.F4=0;data2.G4=0;data2.H4=0;data2.J4=0;data2.K4=0;data2.L4=0;data2.M4=0;
data2.A5=0;data2.B5=0;data2.C5=0;data2.D5=0;data2.E5=0;data2.F5=0;data2.G5=0;data2.H5=0;data2.J5=0;data2.K5=0;data2.L5=0;data2.M5=0;
data2.A6=0;data2.B6=0;data2.C6=0;data2.D6=0;data2.E6=0;data2.F6=0;data2.G6=0;data2.H6=0;data2.J6=0;data2.K6=0;data2.L6=0;data2.M6=0;
data2.A7=0;data2.B7=0;data2.C7=0;data2.D7=0;data2.E7=0;data2.F7=0;data2.G7=0;data2.H7=0;data2.J7=0;data2.K7=0;data2.L7=0;data2.M7=0;
data2.A8=0;data2.B8=0;data2.C8=0;data2.D8=0;data2.E8=0;data2.F8=0;data2.G8=0;data2.H8=0;data2.J8=0;data2.K8=0;data2.L8=0;data2.M8=0;
data2.A9=0;data2.B9=0;data2.C9=0;data2.D9=0;data2.E9=0;data2.F9=0;data2.G9=0;data2.H9=0;data2.J9=0;data2.K9=0;data2.L9=0;data2.M9=0;
data2.B10=0;data2.C10=0;data2.D10=0;data2.E10=0;data2.F10=0;data2.G10=0;data2.H10=0;data2.J10=0;data2.K10=0;data2.L10=0;
data2.C11=0;data2.D11=0;data2.E11=0;data2.F11=0;data2.G11=0;data2.H11=0;data2.J11=0;data2.K11=0;
data2.D12=0;data2.E12=0;data2.F12=0;data2.G12=0;data2.H12=0;data2.J12=0;


%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%this new code acts as above but in a dynamic way specificcaly for
%%%%%%each stimulus bar
% Display unique elements and their counts
abcmat_channel_name=string();
%%%%we can choose between all of the responsive cells or just ON and OFF
%%%%%only ON and OFF cells
% LRN_bar=neuronClasses.PResponsiveOnlyOnOffCellsIndex{1};
%%%I did not find this usefull as only off or only on or only on-off

%%%all except class9
% LRN_bar=neuronClasses.PResponsiveClassExcludeClass9Index{1};

%%%this is only  ON cells
LRN_bar=neuronClasses.Class1NeuronIndex{1};

%%%this is only off cells
% LRN_bar=neuronClasses.Class3NeuronIndex{1};

%%%only ON-OFF cells
% LRN_bar=neuronClasses.Class4NeuronIndex{1};

%%%only sustained cells
% LRN_bar=neuronClasses.Class55NeuronIndex{1};

uniqueElements=[];

if ~isempty(LRN_bar)%%%%%%this line added to secure from error message when we have only one channel or neuron 17/05/2022

for ii=1:length(LRN_bar)
    abcmat_channel_name(ii,1)=cell2mat(abc{LRN_bar(ii),6});
    abcmat_channel_max_value_responsive(ii,1)=abc{LRN_bar(ii),4};
end

% Find unique elements and their counts
[uniqueElements, ida, idx] = unique(abcmat_channel_name);
counts = histcounts(idx, 1:numel(uniqueElements)+1);

%%
% Display unique elements and their counts
for i = 1:numel(uniqueElements)
%     fprintf('Element: %s, Count: %d\n', uniqueElements{i}, counts(i));
    data2.(uniqueElements{i})=counts(i);
end

end
MEA_num_map=[0,0,0,data2.D1,data2.E1,data2.F1,data2.G1,data2.H1,data2.J1,0,0,0
0,0,data2.C2,data2.D2,data2.E2,data2.F2,data2.G2,data2.H2,data2.J2,data2.K2,0,0
0,data2.B3,data2.C3,data2.D3,data2.E3,data2.F3,data2.G3,data2.H3,data2.J3,data2.K3,data2.L3,0
data2.A4,data2.B4,data2.C4,data2.D4,data2.E4,data2.F4,data2.G4,data2.H4,data2.J4,data2.K4,data2.L4,data2.M4
data2.A5,data2.B5,data2.C5,data2.D5,data2.E5,data2.F5,data2.G5,data2.H5,data2.J5,data2.K5,data2.L5,data2.M5
data2.A6,data2.B6,data2.C6,data2.D6,data2.E6,data2.F6,data2.G6,data2.H6,data2.J6,data2.K6,data2.L6,data2.M6
data2.A7,data2.B7,data2.C7,data2.D7,data2.E7,data2.F7,data2.G7,data2.H7,data2.J7,data2.K7,data2.L7,data2.M7
data2.A8,data2.B8,data2.C8,data2.D8,data2.E8,data2.F8,data2.G8,data2.H8,data2.J8,data2.K8,data2.L8,data2.M8
data2.A9,data2.B9,data2.C9,data2.D9,data2.E9,data2.F9,data2.G9,data2.H9,data2.J9,data2.K9,data2.L9,data2.M9
0,data2.B10,data2.C10,data2.D10,data2.E10,data2.F10,data2.G10,data2.H10,data2.J10,data2.K10,data2.L10,0
0,0,data2.C11,data2.D11,data2.E11,data2.F11,data2.G11,data2.H11,data2.J11,data2.K11,0,0
0,0,0,data2.D12,data2.E12,data2.F12,data2.G12,data2.H12,data2.J12,0,0,0];


MEA_bar_gh_num_map = sum(MEA_num_map);

%%
%%this section plots the heatmap for stimulus responsive neurons

data3=struct(); %%%%this a the structure for number of responsive neurons in each recording channel
data3.D1=0;data3.E1=0;data3.F1=0;data3.G1=0;data3.H1=0;data3.J1=0;
data3.C2=0;data3.D2=0;data3.E2=0;data3.F2=0;data3.G2=0;data3.H2=0;data3.J2=0;data3.K2=0;
data3.B3=0;data3.C3=0;data3.D3=0;data3.E3=0;data3.F3=0;data3.G3=0;data3.H3=0;data3.J3=0;data3.K3=0;data3.L3=0;
data3.A4=0;data3.B4=0;data3.C4=0;data3.D4=0;data3.E4=0;data3.F4=0;data3.G4=0;data3.H4=0;data3.J4=0;data3.K4=0;data3.L4=0;data3.M4=0;
data3.A5=0;data3.B5=0;data3.C5=0;data3.D5=0;data3.E5=0;data3.F5=0;data3.G5=0;data3.H5=0;data3.J5=0;data3.K5=0;data3.L5=0;data3.M5=0;
data3.A6=0;data3.B6=0;data3.C6=0;data3.D6=0;data3.E6=0;data3.F6=0;data3.G6=0;data3.H6=0;data3.J6=0;data3.K6=0;data3.L6=0;data3.M6=0;
data3.A7=0;data3.B7=0;data3.C7=0;data3.D7=0;data3.E7=0;data3.F7=0;data3.G7=0;data3.H7=0;data3.J7=0;data3.K7=0;data3.L7=0;data3.M7=0;
data3.A8=0;data3.B8=0;data3.C8=0;data3.D8=0;data3.E8=0;data3.F8=0;data3.G8=0;data3.H8=0;data3.J8=0;data3.K8=0;data3.L8=0;data3.M8=0;
data3.A9=0;data3.B9=0;data3.C9=0;data3.D9=0;data3.E9=0;data3.F9=0;data3.G9=0;data3.H9=0;data3.J9=0;data3.K9=0;data3.L9=0;data3.M9=0;
data3.B10=0;data3.C10=0;data3.D10=0;data3.E10=0;data3.F10=0;data3.G10=0;data3.H10=0;data3.J10=0;data3.K10=0;data3.L10=0;
data3.C11=0;data3.D11=0;data3.E11=0;data3.F11=0;data3.G11=0;data3.H11=0;data3.J11=0;data3.K11=0;
data3.D12=0;data3.E12=0;data3.F12=0;data3.G12=0;data3.H12=0;data3.J12=0;

%%%%%assign values to data3
if ~isempty(uniqueElements) %%%%%%this line added to secure from error message when we have only one channel or neuron 17/05/2022
Ch_amp_avg_responsive=[];
for iii = 1:numel(ida)
    [m_ch_avg_responsive,n_ch_avg_responsive]=find(abcmat_channel_name==abcmat_channel_name(ida(iii)));
    Ch_amp_avg_responsive(iii)=mean(abcmat_channel_max_value_responsive(m_ch_avg_responsive));
    data3.(uniqueElements(iii))=Ch_amp_avg_responsive(iii);
end
end

MEA_responsive_map=[0,0,0,data3.D1,data3.E1,data3.F1,data3.G1,data3.H1,data3.J1,0,0,0
0,0,data3.C2,data3.D2,data3.E2,data3.F2,data3.G2,data3.H2,data3.J2,data3.K2,0,0
0,data3.B3,data3.C3,data3.D3,data3.E3,data3.F3,data3.G3,data3.H3,data3.J3,data3.K3,data3.L3,0
data3.A4,data3.B4,data3.C4,data3.D4,data3.E4,data3.F4,data3.G4,data3.H4,data3.J4,data3.K4,data3.L4,data3.M4
data3.A5,data3.B5,data3.C5,data3.D5,data3.E5,data3.F5,data3.G5,data3.H5,data3.J5,data3.K5,data3.L5,data3.M5
data3.A6,data3.B6,data3.C6,data3.D6,data3.E6,data3.F6,data3.G6,data3.H6,data3.J6,data3.K6,data3.L6,data3.M6
data3.A7,data3.B7,data3.C7,data3.D7,data3.E7,data3.F7,data3.G7,data3.H7,data3.J7,data3.K7,data3.L7,data3.M7
data3.A8,data3.B8,data3.C8,data3.D8,data3.E8,data3.F8,data3.G8,data3.H8,data3.J8,data3.K8,data3.L8,data3.M8
data3.A9,data3.B9,data3.C9,data3.D9,data3.E9,data3.F9,data3.G9,data3.H9,data3.J9,data3.K9,data3.L9,data3.M9
0,data3.B10,data3.C10,data3.D10,data3.E10,data3.F10,data3.G10,data3.H10,data3.J10,data3.K10,data3.L10,0
0,0,data3.C11,data3.D11,data3.E11,data3.F11,data3.G11,data3.H11,data3.J11,data3.K11,0,0
0,0,0,data3.D12,data3.E12,data3.F12,data3.G12,data3.H12,data3.J12,0,0,0];

%%%this is for saving the variable for excel file
MEA_responsive_map_zero = MEA_responsive_map;


MEA_Bar_gh_amp_rn = mean(MEA_responsive_map);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%average of only responsive neurons
% figure;heatmap(MEA_map,'Colormap',jet)
% title('only responsive non zero neurons')
% Replace zero elements with NaN
MEA_responsive_map(MEA_responsive_map == 0) = NaN;
MEA_Bar_gh_amp_rn_Nan = nanmean(MEA_responsive_map);



%%
%%%the difference between this block and first code block is that in this
%%%one the maximum response among all of neurons in one channel is assigned
%%%as the final value for the heatmap

data=struct();
data.D1=0;data.E1=0;data.F1=0;data.G1=0;data.H1=0;data.J1=0;
data.C2=0;data.D2=0;data.E2=0;data.F2=0;data.G2=0;data.H2=0;data.J2=0;data.K2=0;
data.B3=0;data.C3=0;data.D3=0;data.E3=0;data.F3=0;data.G3=0;data.H3=0;data.J3=0;data.K3=0;data.L3=0;
data.A4=0;data.B4=0;data.C4=0;data.D4=0;data.E4=0;data.F4=0;data.G4=0;data.H4=0;data.J4=0;data.K4=0;data.L4=0;data.M4=0;
data.A5=0;data.B5=0;data.C5=0;data.D5=0;data.E5=0;data.F5=0;data.G5=0;data.H5=0;data.J5=0;data.K5=0;data.L5=0;data.M5=0;
data.A6=0;data.B6=0;data.C6=0;data.D6=0;data.E6=0;data.F6=0;data.G6=0;data.H6=0;data.J6=0;data.K6=0;data.L6=0;data.M6=0;
data.A7=0;data.B7=0;data.C7=0;data.D7=0;data.E7=0;data.F7=0;data.G7=0;data.H7=0;data.J7=0;data.K7=0;data.L7=0;data.M7=0;
data.A8=0;data.B8=0;data.C8=0;data.D8=0;data.E8=0;data.F8=0;data.G8=0;data.H8=0;data.J8=0;data.K8=0;data.L8=0;data.M8=0;
data.A9=0;data.B9=0;data.C9=0;data.D9=0;data.E9=0;data.F9=0;data.G9=0;data.H9=0;data.J9=0;data.K9=0;data.L9=0;data.M9=0;
data.B10=0;data.C10=0;data.D10=0;data.E10=0;data.F10=0;data.G10=0;data.H10=0;data.J10=0;data.K10=0;data.L10=0;
data.C11=0;data.D11=0;data.E11=0;data.F11=0;data.G11=0;data.H11=0;data.J11=0;data.K11=0;
data.D12=0;data.E12=0;data.F12=0;data.G12=0;data.H12=0;data.J12=0;
%%%%this for loop checks the channels that have more than one neuron


for j=1:nn
%     A=abc{j,6};
%     B=abc{j+1,6};
%     D=abc{j,4};
%     E=abc{j+1,4};

       abc{j,10}=find(abcmat_channel_name==abc{j,6});
       abc{j,8}=length(find(abcmat_channel_name==abc{j,6}));


       abc{j,11}=max(cell2mat(abc(abc{j,10},4)));
       if ~isempty(abc{j,11})
       data.(cell2mat(abc{j,6}))=abc{j,11};
       end
        
end


MEA_map_max_amp=[0,0,0,data.D1,data.E1,data.F1,data.G1,data.H1,data.J1,0,0,0
0,0,data.C2,data.D2,data.E2,data.F2,data.G2,data.H2,data.J2,data.K2,0,0
0,data.B3,data.C3,data.D3,data.E3,data.F3,data.G3,data.H3,data.J3,data.K3,data.L3,0
data.A4,data.B4,data.C4,data.D4,data.E4,data.F4,data.G4,data.H4,data.J4,data.K4,data.L4,data.M4
data.A5,data.B5,data.C5,data.D5,data.E5,data.F5,data.G5,data.H5,data.J5,data.K5,data.L5,data.M5
data.A6,data.B6,data.C6,data.D6,data.E6,data.F6,data.G6,data.H6,data.J6,data.K6,data.L6,data.M6
data.A7,data.B7,data.C7,data.D7,data.E7,data.F7,data.G7,data.H7,data.J7,data.K7,data.L7,data.M7
data.A8,data.B8,data.C8,data.D8,data.E8,data.F8,data.G8,data.H8,data.J8,data.K8,data.L8,data.M8
data.A9,data.B9,data.C9,data.D9,data.E9,data.F9,data.G9,data.H9,data.J9,data.K9,data.L9,data.M9
0,data.B10,data.C10,data.D10,data.E10,data.F10,data.G10,data.H10,data.J10,data.K10,data.L10,0
0,0,data.C11,data.D11,data.E11,data.F11,data.G11,data.H11,data.J11,data.K11,0,0
0,0,0,data.D12,data.E12,data.F12,data.G12,data.H12,data.J12,0,0,0];

%%%%this for receptivefield size selected neuron%%%%
RC_verti_map = abc{Neuron_index_verti,4};
