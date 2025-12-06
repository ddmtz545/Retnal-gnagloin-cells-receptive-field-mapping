function[all_FR_trial,all_FR_event,all_PSTH_trial,all_PSTH_event,all_FR_trial_baseline,all_FR_event_baseline,all_PSTH_trial_baseline,all_PSTH_event_baseline,all_stimWidth_event,eventsNameCell,trialRepeat]=nexSortEvents(events,neuronsSorted,filename,prevTime,postTime)

%%%%%%%%this function extract events from nex5
%%%%events variables: name , varNex5Version , timestamps
%%%%neuronsSorted:the structure that contains sorted neurons
%%%%filename: is the name of the data file to plot on the figure title
%%%%prevTime: pre stimulation time value
%%%%postTime: post stimulation time value

%%%%omitting the first event which is all of the events
% events=events(2:end);

eventsNum=size(events,1);
neuronsSortedNum=length(neuronsSorted);


%%%%%%Plotting events
eventsNameCell=cell(eventsNum,1);
for i=1:eventsNum
    
    eventsNameCell{i,1}=events{i,1}.name;
    
end




%%%%%%%%firing rate calculation for each neuron and event
% prevTime=0.1;
% postTime=0.1;

%%%%stimulation pulse width calculation for each event and assigning all
%%%%values to all_stimWidth matrix
all_stimWidth_event=[];
 for h=1:eventsNum
        
        eventNameh=events{h,1}.name;
        
        %%%stimulus pulse width notice: this is calculated from the the
        %%%string that contains event name
        stimWidth=stimuli_pulse_width(eventNameh);
        all_stimWidth_event(h)=stimWidth;
 end



all_FR_trial={};all_FR_trial_baseline={};
all_FR_event=[];all_FR_event_baseline=[];
all_PSTH_trial={};all_PSTH_trial_baseline={};
all_PSTH_event={};all_PSTH_event_baseline={};

%%%%%neuron loop
for k=1:neuronsSortedNum
    neuronsSortedk=neuronsSorted{k,1}.timestamps;
    
    %%%%j is 2 because j=1 contains all of the events altogether
    %%%%%event loop
    trialRepeat=zeros(eventsNum,1);
    for j=1:eventsNum
        
%         eventName=events{j,1}.name;
        
        %%%stimulus pulse width notice: this is calculated from the the
        %%%string that contains event name
        stimWidth=all_stimWidth_event(j);
        
        %%%%%%L is the number of events 05/07/2023 Majid for example =20 for
        %%%%%%old experiments
        L=length(events{j,1}.timestamps);
        trialRepeat(j)=L;
        eventsj=events{j,1}.timestamps;
        
        %%%%%this is the interval of two stimuli in event j
%         interval=eventsj(2)-eventsj(1);
        
        %%%%%this loop extract neuron response for each trial
        %%%%%trial loop
        FiringRate_trial=[];FiringRate_trial_baseline=[];
        PSTH_trial={};PSTH_trial_baseline={};
        PSTH_event=[];PSTH_event_baseline=[];
%         AverageFR=[];
        for jj=1:L
            
            %%%%%this line finds spikes in the specified time window
            indiceA=find((neuronsSortedk>=(eventsj(jj)-prevTime)) & neuronsSortedk<(eventsj(jj)+postTime+stimWidth));
            
            indiceB=find((neuronsSortedk>=(0.0)) & neuronsSortedk<(eventsj(jj)-prevTime));
            
            %%%calculation for single trial
            PSTH_trial{jj,1}=neuronsSortedk(indiceA)-(eventsj(jj)-prevTime);
            
            PSTH_trial_baseline{jj,1}=neuronsSortedk(indiceB)-(eventsj(jj)-prevTime-(postTime+stimWidth+prevTime));
            

            %%%%calculation for the whole event;  concatenating trials
            PSTH_event=[PSTH_event,PSTH_trial{jj,1}'];
            %%%%Baseline calculation for the whole event; concatenating trials
            PSTH_event_baseline=[PSTH_event_baseline,PSTH_trial_baseline{jj,1}'];
            
            %%%%normal Spike/Sec calculation for each trial
            FiringRate_trial(jj)=length(indiceA)/(prevTime+postTime+stimWidth);
            
            
            %%%%Baseline normal Spike/Sec calculation for each trial
             FiringRate_trial_baseline(jj)=length(indiceB)/(postTime+stimWidth+prevTime);
            
            
             
        end
         all_FR_trial{k,j}=FiringRate_trial; all_FR_trial_baseline{k,j}=FiringRate_trial_baseline;
         %%%%normal Spike/Sec calculation for each event
         all_FR_event(k,j)=sum(FiringRate_trial)/L;all_FR_event_baseline(k,j)=sum(FiringRate_trial_baseline)/L;
         all_PSTH_trial{k,j}=PSTH_trial;all_PSTH_trial_baseline{k,j}=PSTH_trial_baseline;
         %%%%PSTH_event is sorted to easily find the onset and offet of the
         %%%%event
         all_PSTH_event{k,j}=sort(PSTH_event);all_PSTH_event_baseline{k,j}=sort(PSTH_event_baseline);
        
    end
    
end


end
        
 
 





