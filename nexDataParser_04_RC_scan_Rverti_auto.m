clc
clear all
close all
tic
%%%%these series of analysis files are modified for my data format
cd('/Users/majidlondon/Documents/MATLAB/09Spatial_pattern_illuminator/Rceptive_Field_Size_comprehensive')

addpath('/Users/majidlondon/Documents/MATLAB/ReadWriteNexNex5Files');%%%%%%nex5 read and write folder path

% %%%%%%%%%%%%%%%%%%%%%WT PI%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
addpath('/Volumes/Majid4TBSSD/Pattern Illuminator/Control data/24102023_WT_6months_20days\04');%%%Data folder path
filename='2023-10-24T14-09-41McsRecording-sorted-units.nex5';event=1;%%%%there



nexFile=readNex5File(filename);

neurons=nexFile.neurons;

%%%%to check events and neurons names
AAA_events_check=cell2mat(nexFile.events);
BBB_neurons_check=cell2mat(nexFile.neurons);


%%%%event selection
events=nexFile.events(event);
%%%%finding selected events
EV=events{1,1}.timestamps;
L1=length(EV);
I1=2:2:L1;

%%%this line extract timestamps of all bars
EV2=EV(I1);%%%%EV2 contains all time-stamps of bars, without the blank timestamps
L2=length(EV2);%%%%this only for 

%%%%%%%%inserting neurons list
run('neurons_pairs_cell')

neurons_list_length=length(neurons_pairs);
%%%this cell save 3 matrices values for verti bar values
qcell_Rverti=cell(neurons_list_length,4);


%%%%for loop for all neurons
for cell_id =1:neurons_list_length

%%%%%%%%%%%%%%%%%%%%


Stim_num=30;%%%%number of stimuli
RC_verti_map_vector=zeros(1,30);%%%%firing rate for example neuron
RC_verti_map_matrix = zeros(12,12,30);
RC_verti_Neuron_amp=cell(30,1);
%%%%assigning neurons class added 13/01/2025
neuronClassType_verti_bar = zeros(30,1);

All_MEA_map_max_amp_04=0;
%%%%%%for loop fro all bars for a single neuorn
for id=1:Stim_num
    Ibar=id:Stim_num:L2;
    

bar_number = Ibar;
%%%%just to see which bar is being processed
bar_number(1);

EV3=EV2(bar_number);
events{1,1}.timestamps=EV3;


%%%%%%removing non data Neurons
[neuronsSorted,neuronsNamesSorted,namesAllChar,namesAll]=nexSortNeurons(neurons);

%%%%%Input values assignment

prevTime=0.1;
postTime=.3;
binSize=.01;
sm_coef=10;%%%%%%this is a constant to calculate smoothing span based on this formula:(1/binSize)/sm_coef)  forr functions neuronsPSTH_Delay and neuronsClass

%%%%%%plotting events and calculating Firing rates and PSTH cells and
%%%%%%Matrices for single trial and single event correspondent to each neuron
[all_FR_trial,all_FR_event,all_PSTH_trial,all_PSTH_event,all_FR_trial_baseline,all_FR_event_baseline,all_PSTH_trial_baseline,all_PSTH_event_baseline,all_stimWidth_event,eventsNameCell,trialRepeat]=nexSortEvents(events,neuronsSorted,filename,prevTime,postTime);


[stdRatio,histFrValues,binSize,meanBaseline]=neuronsPSTH_Delay(namesAll,all_PSTH_event,all_PSTH_event_baseline,all_stimWidth_event,eventsNameCell,all_FR_event,all_FR_event_baseline,trialRepeat,filename,prevTime,postTime,binSize,sm_coef,20,0);

[resPercent,responsiveNeuron,respHistPeak,NonReHistPeak,lookupTable,DelayIRtON,DelayAverage,neuronClassType,neuronClasses]=neuronsClass(stdRatio,all_stimWidth_event,histFrValues,meanBaseline,neuronsNamesSorted,prevTime,postTime,binSize,sm_coef,3,-1,0);


%%%%assign the neuron index
Neuron_index_verti=neurons_pairs{cell_id}(1);

run('MEA_Electrode_RC_Map_Plot_Rverti.m')

RC_verti_map_vector(31-id) = RC_verti_map;%%%%example for C5
% % % this gets the heatmap value not the single neuron
RC_verti_map_matrix(:,:,31-id) = MEA_map_max_amp; 
RC_verti_Neuron_amp{31-id}=cell2mat(abc(:,4));

%%%%assigning neurons class added 13/01/2025
neuronClassType_verti_bar(31-id)= neuronClassType(Neuron_index_verti);

All_MEA_map_max_amp_04= All_MEA_map_max_amp_04 +MEA_map_max_amp;

end

%%%%qcell contains the 3 matrices for all 30 bars
qcell_Rverti{cell_id,1}= RC_verti_map_vector;
qcell_Rverti{cell_id,2}= RC_verti_Neuron_amp; 
qcell_Rverti{cell_id,3}= RC_verti_map_matrix;
qcell_Rverti{cell_id,4}= neuronClassType_verti_bar;
fprintf('This is 04 Rverti neuron number: %d\n',cell_id)
end

filename3=strcat(filename(1:end-5),'_04_qcell_RC_scan_real_vert_eventNo_',num2str(event),'_barNo_',num2str(bar_number(1)),'_',num2str(binSize),'s_neuronClasses.mat');
save (filename3,'qcell_Rverti')

toc
