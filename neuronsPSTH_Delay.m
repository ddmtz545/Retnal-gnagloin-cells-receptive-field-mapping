function [stdRatio,histFrValues,binSize,meanBaseline]=neuronsPSTH_Delay(namesAll,all_PSTH_event,all_PSTH_event_baseline,all_stimWidth_event,eventsNameCell,all_FR_event,all_FR_event_baseline,trialRepeat,filename,prevTime,postTime,binSize,sm_coef,figN,showPlots)

try
    isempty(showPlots);
catch
    showPlots = 0;
end

% sm_coef=10;%%%%%%this is a constant to calculate smoothing span based on this formula:(1/binSize)/sm_coef)

%%%% figN :is the total number of subplots in each figure
%%%% binSize :is the size of the histogram bin 
%%%% showPlots :switches ON and OFF the histogram plots to lower the
%%%% processing speed


szPSTH_event=size(all_PSTH_event);%%%neurons number
LstimWidth_event=length(all_stimWidth_event);%%%%events number

% figN=50;
stdRatio=cell(szPSTH_event(1),LstimWidth_event);
histFrValues=cell(szPSTH_event(1),LstimWidth_event);

meanBaseline=zeros(szPSTH_event(1),LstimWidth_event);
% allBinEdges=cell(szPSTH_event(1),LstimWidth_event);
%%%%event loop
for i=1:LstimWidth_event
    
    numTrial=trialRepeat(i);
    
    T=all_stimWidth_event(i)+prevTime+postTime;
    
    A=0:figN:szPSTH_event(1);
    
        if A(end)~=szPSTH_event(1)
            neuronNum=[A szPSTH_event(1)];
        else
            neuronNum=A;
        end
    
    for jj=1:length(neuronNum)-1
    
        %%%%%neuron loop
        k=1;
        for j=(neuronNum(jj)+1):neuronNum(jj+1)
        
        
%             subplot(ceil(figN/4),4,k)%%%%%%commented on 15/11/2024 to not open figures
            %%%%counts per bin
            A=histogram(all_PSTH_event{j,i},0:binSize:T);
            
            %%%%spikes per second
            B=A.BinEdges(1:end-1);
            
%             allBinEdges{j,i}=A.Binedges;
            %%%I used the same x axix for baseline for superpositioning
            %%%plots
%             B_base=A.BinEdges;
            B_base=0:.01:T; %%%this line is only for plotting has nothing to do with the calculation
            
            C=A.Values/(binSize*numTrial);
            histFrValues{j,i}=C;%%%%%%%not smoothed
%             histFrValues{j,i}=smooth(C,((1/binSize)/sm_coef))';%%%%%smoothed%%%%comment to remove smoothing moving average
            
            
            %%%%%%baseline histogram
            %%%%this line is for 2 times of the stimulus pulse width
%             A_base=histogram(all_PSTH_event_baseline{j,i},0:binSize:(2*all_stimWidth_event(i)));

            A_base=histogram(all_PSTH_event_baseline{j,i},0:binSize:T);
            
           
            C_base=A_base.Values/(binSize*numTrial);%%%%%%%not smoothed
%             C_base=smooth(C_base,((1/binSize)/sm_coef))';%%%%%smoothed%%%%comment to remove smoothing moving average
            
            
            stdBase=std(C_base);
            meanBase=mean(C_base);
            
            %%%%%Amplitude
            %%%%%is the difference between peak response and baseline
            meanBaseline(j,i)=meanBase;
            
            
            %%%%%%%%%%%%%%%%%%neurons classification
            %%%%%stdRatio subtracts the baseline mean from histogram values and devide it by baseline std 
            
            %%%%%the if clause removes weak or no responses
%             if mean(C)>1

            stdRatio{j,i}=(C-meanBase)/stdBase;%%%%%%%not smoothed
%              stdRatio{j,i}=(smooth(C,((1/binSize)/sm_coef))'-meanBase)/stdBase;%%%%%smoothed%%%%comment to remove smoothing moving average
            
            %%%%%%%%%%%%%%%%%%%%%%plotting PSTH
            hold off
            
            if showPlots==1
            
            bar(B,C,'histc');
            
            hold on
            LB=length(B_base);
            MB=0;
            MB(1:LB)=meanBase;
            plot(B_base,MB,'g--')
            hold on
            
            MBSP=0;
            MBSP(1:LB)=2*stdBase+meanBase;
            plot(B_base,MBSP,'r--')
            hold on
            MBSP=0;
            MBSP(1:LB)=3*stdBase+meanBase;
            plot(B_base,MBSP,'r-.')
            MBSP=0;
            MBSP(1:LB)=4*stdBase+meanBase;
            plot(B_base,MBSP,'r:')
            
            hold on
            MBSN=0;
            MBSN(1:LB)=-2*stdBase+meanBase;
            plot(B_base,MBSN,'r--')
            hold on
            MBSN=0;
            MBSN(1:LB)=-3*stdBase+meanBase;
            plot(B_base,MBSN,'r-.')
            MBSN=0;
            MBSN(1:LB)=-4*stdBase+meanBase;
            plot(B_base,MBSN,'r:')
            
            %%%%poltting PSTH envelope(smoothing)%%%%%%do it in neuron
            %%%class for all of the matrix,only plots evelope
            hold on;plot(B,smooth(C,((1/binSize)/sm_coef)),'m.-')
            
            
            %%%%subplot title
            figTitle=sprintf('Ch#:%s Neuron#:%d',extractAfter(namesAll{j},"Data1"),j);
            title(figTitle);
            end
            
            k=k+1;
        
        end
        
    end
    
    
end

%%%%%%%%to close figures and decrease processing time
if  isempty(showPlots) || showPlots==0
    close all
end
       