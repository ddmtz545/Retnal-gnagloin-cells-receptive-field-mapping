function [resPercent,responsiveNeuron,respHistPeak,NonReHistPeak,lookupTable,DelayIRtON,DelayAverage,neuronClassType,neuronClasses]=neuronsClass(stdRatio,all_stimWidth_event,histFrValues,meanBaseline,neuronsNamesSorted,prevTime,postTime,binSize,sm_coef,stdFold,negStdFold,showComulativePlots)

%%%%this function classify neurons based on the difference of the response
%%%%FR and  baseline FR
%%%%stdFold: is the value determines the threshold level for neurons,
%%%%stdfold multiplies by the standard deviation of the baseline
%%%%%showComulativePlots switch on and off figure that shows comulative
%%%%%response of each class of neurons

try
    isempty(showComulativePlots);
catch
    showComulativePlots = 0;
end

%%%%response

neuronsNum=size(stdRatio,1);  %%%%neurons number
LstimWidth_event=length(all_stimWidth_event);%%%%events number

responsiveNeuron=zeros(neuronsNum,LstimWidth_event);

RtON=zeros(neuronsNum,LstimWidth_event);
RtOFF=zeros(neuronsNum,LstimWidth_event);
RtOFF3=zeros(neuronsNum,LstimWidth_event);

negativetON=zeros(neuronsNum,LstimWidth_event);
negativetOFF=zeros(neuronsNum,LstimWidth_event);

DelayIRtON=zeros(neuronsNum,LstimWidth_event);
DelayIRtOFF=zeros(neuronsNum,LstimWidth_event);
DelayIRtOFF3=zeros(neuronsNum,LstimWidth_event);

AmplitudeON=zeros(neuronsNum,LstimWidth_event);
AmplitudeOFF=zeros(neuronsNum,LstimWidth_event);
AmplitudeOFF3=zeros(neuronsNum,LstimWidth_event);

DelayIRtONnegative=zeros(neuronsNum,LstimWidth_event);
DelayIRtOFFnegative=zeros(neuronsNum,LstimWidth_event);

AmplitudeONnegative=zeros(neuronsNum,LstimWidth_event);
AmplitudeOFFnegative=zeros(neuronsNum,LstimWidth_event);

%%%%%event loop
for i=1:LstimWidth_event

           stimWidth=all_stimWidth_event(i);
           
           D=0;%%%response delay
           T=stimWidth/binSize;
           tON=(prevTime/binSize)+D;%%%light onset
           tOFF=tON+T;%%%%dark onset
           tOFF2=tON+2*T;
           %%%%end of sustained response
           
           %%%%%%I changed this for 10s stimuli,tON+8*T to tON+5*T
%            tOFF3=tON+6*T;
           %%%%%31/07/2023, I redefine tOFF3 for Pattern response as
           %%%%%follows:
           tOFF3=tON+4*T;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%for light sensitive ganglion cells%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %            D=0;%%%response delay
% %            T=stimWidth/binSize;
% %            tON=(prevTime/binSize)+D;%%%light onset
% %            tOFF=tON+8*T;%%%%dark onset
% %            tOFF2=tON+8*T;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%      


           
%%%%neuron loop
    for j=1:neuronsNum
            
      
%%%%%%%%%%%%%%%%%%%%%%%%%%2. Latency calculation based on the Max response and
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Amplitude calculation%%%%%%%%%%%%%%%%
%%%%%Amplitude is the difference between peak response and baseline

%%%%%%smoothing PSTH to calculate latency
%          smhistFrValues=smooth(histFrValues{j,i},((1/binSize)/sm_coef));%%%%%smoothed%%%%comment to remove smoothing moving average
         smhistFrValues=histFrValues{j,i};
%%%%%%%%%%%

         [dtOnMax,IdtOnMax]=max(smhistFrValues(tON+1:tOFF));
         if ~isempty(IdtOnMax)       
            DelayIRtON(j,i)=IdtOnMax*binSize*1000;
            AmplitudeON(j,i)=dtOnMax-meanBaseline(j,i);
         end
         
         [dtOffMax,IdtOffMax]=max(smhistFrValues(tOFF+1:tOFF2));
         if ~isempty(IdtOffMax)       
            DelayIRtOFF(j,i)=IdtOffMax*binSize*1000;
            AmplitudeOFF(j,i)=dtOffMax-meanBaseline(j,i);
         end
        %%%%%%sustained class%%%%%%%%%%% 
%          [dtOff3Max,IdtOff3Max]=max(smhistFrValues(tOFF2+1:tOFF3));
         [dtOff3Max,IdtOff3Max]=max(smhistFrValues(tON+1:tOFF3));

         if ~isempty(IdtOff3Max)       
            DelayIRtOFF3(j,i)=IdtOff3Max*binSize*1000;
            AmplitudeOFF3(j,i)=dtOff3Max-meanBaseline(j,i);
         end
         %%%%%%%%%%%%%%%%%%%%%%%%%%
         [dtOnMin,IdtOnMin]=min(smhistFrValues(tON+1:tOFF));
         if ~isempty(IdtOnMin)       
            DelayIRtONnegative(j,i)=IdtOnMin*binSize*1000;
            AmplitudeONnegative(j,i)=dtOnMin-meanBaseline(j,i);
         end
         
         [dtOffMin,IdtOffMin]=min(smhistFrValues(tOFF+1:tOFF2));
         if ~isempty(IdtOffMin)       
            DelayIRtOFFnegative(j,i)=IdtOffMin*binSize*1000;
            AmplitudeOFFnegative(j,i)=dtOffMin-meanBaseline(j,i);
         end
         
         
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
       
       
       
       
        %%%%%%%%%%%%%%%%%Responsive Neuron
%        if ~isempty(find(stdRatio{j,i}>=stdFold))
         
if ~isempty(find(stdRatio{j,i}(tON+1:tOFF2)>=stdFold))
           
           responsiveNeuron(j,i)=1;
         end
       
         
         
       
       %%%%Responsive tON
       IRtON=find(stdRatio{j,i}(tON+1:tOFF)>=stdFold);
       
       if ~isempty(IRtON) && length(IRtON)>=1 %&& isConsecutiveNatural(IRtON,1)
            RtON(j,i)=1;
       end
       %%%%Responsive tOFF
       IRtOFF=find(stdRatio{j,i}(tOFF+1:tOFF2)>=stdFold);
       if ~isempty(IRtOFF) && length(IRtOFF)>=1 %&& isConsecutiveNatural(IRtOFF,1) 
            RtOFF(j,i)=1;
            %%%%%this line is to categorizing ON cells with strong burst
            %%%%%correctly to avoid replacing ON with ON-OFF cells
            if length(IRtOFF)==1 && length(IRtON)==10
               RtOFF(j,i)=0;
            end
            
       end
       
       %%%%sustained response, above threshold after tOFF2
       IRtOFF3=find(stdRatio{j,i}(tOFF2+1:tOFF3)>=stdFold);
       if ~isempty(IRtOFF3) && length(IRtOFF3)>=1 && isConsecutiveNatural(IRtOFF3,2) 
            RtOFF3(j,i)=1;
       end
           
       
       
       %%%%Responsive Negative tON
       InegativetON=find(stdRatio{j,i}(tON+1:tOFF)<=negStdFold);
       if ~isempty(InegativetON) && length(InegativetON)>=2 && isConsecutiveNatural(InegativetON,2)
            negativetON(j,i)=1;
       end
       %%%%Responsive Negative tOFF
       InegativetOFF=find(stdRatio{j,i}(tOFF+1:tOFF2)<=negStdFold);
        if ~isempty(InegativetOFF) && length(InegativetOFF)>=2 && isConsecutiveNatural(InegativetOFF,2) 
            negativetOFF(j,i)=1;
        end
        
        
    end
   
    
end



%%%%%%%%%%%%%%%%%%%%%look up table%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

resPercent=[];
respHistPeak=cell(LstimWidth_event,1);
NonReHistPeak=cell(LstimWidth_event,1);

lookupTable=cell(LstimWidth_event,1);
DelayAverage=zeros(LstimWidth_event,1);

for k=1:LstimWidth_event
    
    NR=find(responsiveNeuron(:,k));
    LNR=length(NR);
    resPercent(k)=(LNR/neuronsNum)*100;
    
    %%%%responsive neurons histogram peak values
    respHistPeak{k}=histFrValues(NR,k);
    
    respHistPeak{k}=cell2mat(respHistPeak{k});
%     respNeuronsName=neuronsNamesSorted(NR);
    %%%%Non responsive neurons histogram peak values
    NonR=find(responsiveNeuron(:,k)==0);
    NonReHistPeak{k}=histFrValues(NonR,k);
    NonReHistPeak{k}=cell2mat(NonReHistPeak{k});
%     NonrespNeuronsName=neuronsNamesSorted(NonR);

%%%%%%%lookup  table to cluster neurons
    lookupTable{k}=[RtON(:,k) RtOFF(:,k) negativetON(:,k) negativetOFF(:,k) RtOFF3(:,k)];
    
    
    %%%%%%Average Latency
     ResIndices=find(responsiveNeuron(:,k));
    %%%%it calculates the average delay for only responsive Neurons 
    X0=DelayIRtON(ResIndices,k);
    X1=find(X0);
    DelayAverage(k)=mean(X0(X1));
    
    

end

%%%%%lookup table search and information extract
%%%%%neurons classification(categorization)
neuronClassType=zeros(neuronsNum,LstimWidth_event);

for g=1:1:LstimWidth_event
    for h=1:neuronsNum
        
    trow=lookupTable{g}(h,:);
    %%%%class 1 : ON cell
    if trow(1)==1   &&  trow(2)==0  && trow(4)==0  && trow(5)==0   %&& trow(3)==0    
    neuronClassType(h,g)=1;
    end
    
    %%%%class 2 : ON cell suppressed by dark
    if trow(1)==1   &&  trow(2)==0  && trow(4)==1   && trow(5)==0  %&& trow(3)==0 
    neuronClassType(h,g)=2;
    end
    
    %%%%class 3 : OFF cell
    if trow(1)==0   &&  trow(2)==1   && trow(3)==0  && trow(5)==0  %&& trow(4)==0
    neuronClassType(h,g)=3;
    end
    
    %%%%class 4 : ON-OFF cell
    if trow(1)==1   &&  trow(2)==1   && trow(5)==0 %&& trow(3)==0    && trow(4)==0
    neuronClassType(h,g)=4;
    end
    
    %%%%class 5 : OFF cell suppressed by light
    if trow(1)==0   &&  trow(2)==1   && trow(3)==1    && trow(5)==0 %&& trow(4)==0
    neuronClassType(h,g)=5;
    end
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%class 5.5: sustained response
    if (trow(1)==1   ||  trow(2)==1) && trow(5)==1
        neuronClassType(h,g)=8.5;
    end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    %%%%class 6 : Suppressed by light ON
    if trow(1)==0   &&  trow(2)==0   && trow(3)==1    && trow(4)==0
    neuronClassType(h,g)=6;
    end
    
    %%%%class 7 : Suppressed by light OFF
    if trow(1)==0   &&  trow(2)==0   && trow(3)==0    && trow(4)==1
    neuronClassType(h,g)=7;
    end
    
    %%%%class 8 : suppressed by light ON-OFF
    if trow(1)==0   &&  trow(2)==0   && trow(3)==1    && trow(4)==1
    neuronClassType(h,g)=8;
    end
    
    %%%%class 9 : no response or spontaneous activity 
    if trow(1)==0   &&  trow(2)==0   && trow(3)==0    && trow(4)==0
    neuronClassType(h,g)=9;
    end
    

        
        
        
    end
end






%%%%%extracting neurons type percentage from neuronClassType
%%%%%also extracting PSTH graph values for each event

for gg=1:LstimWidth_event
%     for hh=1:neuronsNum
       PSTHvalues=cell2mat(histFrValues(:,gg));

       typeVector=neuronClassType(:,gg); 
       
     Iclass1=find(typeVector==1); 
     class1(gg)=length(Iclass1);class1Index{gg}=Iclass1;class1PSTHvalues{gg}=PSTHvalues(Iclass1,:);%%CC=cell2mat(neuronClasses.Class1_PSTHvalues(1));
     class1LatencyON{gg}=DelayIRtON(Iclass1,gg);
     class1AmplitudeON{gg}=AmplitudeON(Iclass1,gg);
     
     Iclass2=find(typeVector==2);
     class2(gg)=length(Iclass2);class2Index{gg}=Iclass2;class2PSTHvalues{gg}=PSTHvalues(Iclass2,:);
     class2LatencyON{gg}=DelayIRtON(Iclass2,gg);
     class2AmplitudeON{gg}=AmplitudeON(Iclass2,gg);
     Class2LatencyOFFsuppressed{gg}=DelayIRtOFFnegative(Iclass2,gg);
     Class2AmplitudeOFFsuppressed{gg}=AmplitudeOFFnegative(Iclass2,gg);
     
     Iclass3=find(typeVector==3);
     class3(gg)=length(Iclass3);class3Index{gg}=Iclass3;class3PSTHvalues{gg}=PSTHvalues(Iclass3,:);
     class3LatencyOFF{gg}=DelayIRtOFF(Iclass3,gg);
     class3AmplitudeOFF{gg}=AmplitudeOFF(Iclass3,gg);
     
     Iclass4=find(typeVector==4);
     class4(gg)=length(Iclass4);class4Index{gg}=Iclass4;class4PSTHvalues{gg}=PSTHvalues(Iclass4,:);
     class4LatencyON{gg}=DelayIRtON(Iclass4,gg);
     class4AmplitudeON{gg}=AmplitudeON(Iclass4,gg);
     class4LatencyOFF{gg}=DelayIRtOFF(Iclass4,gg);
     class4AmplitudeOFF{gg}=AmplitudeOFF(Iclass4,gg);
     
     
     Iclass5=find(typeVector==5);
     class5(gg)=length(Iclass5);class5Index{gg}=Iclass5;class5PSTHvalues{gg}=PSTHvalues(Iclass5,:);
     class5LatencyOFF{gg}=DelayIRtOFF(Iclass5,gg);
     class5AmplitudeOFF{gg}=AmplitudeOFF(Iclass5,gg);
     Class5LatencyONsuppressed{gg}=DelayIRtONnegative(Iclass5,gg);
     Class5AmplitudeONsuppressed{gg}=AmplitudeONnegative(Iclass5,gg);
     
     Iclass55=find(typeVector==8.5);
     class55(gg)=length(Iclass55);class55Index{gg}=Iclass55;class55PSTHvalues{gg}=PSTHvalues(Iclass55,:);
     class55LatencyOFF{gg}=DelayIRtOFF3(Iclass55,gg);
     class55AmplitudeOFF{gg}=AmplitudeOFF3(Iclass55,gg);
%      Class55LatencyONsuppressed{gg}=DelayIRtOFF3negative(Iclass55,gg);
%      Class55AmplitudeONsuppressed{gg}=AmplitudeOFF3negative(Iclass55,gg);
     
     Iclass6=find(typeVector==6);
     class6(gg)=length(Iclass6);class6Index{gg}=Iclass6;class6PSTHvalues{gg}=PSTHvalues(Iclass6,:);
     Class6LatencyONsuppressed{gg}=DelayIRtONnegative(Iclass6,gg);
     Class6AmplitudeONsuppressed{gg}=AmplitudeONnegative(Iclass6,gg);
     
     Iclass7=find(typeVector==7);
     class7(gg)=length(Iclass7);class7Index{gg}=Iclass7;class7PSTHvalues{gg}=PSTHvalues(Iclass7,:);
     Class7LatencyOFFsuppressed{gg}=DelayIRtOFFnegative(Iclass7,gg);
     Class7AmplitudeOFFsuppressed{gg}=AmplitudeOFFnegative(Iclass7,gg);
     
     Iclass8=find(typeVector==8);
     class8(gg)=length(Iclass8);class8Index{gg}=Iclass8;class8PSTHvalues{gg}=PSTHvalues(Iclass8,:);
     Class8LatencyOFFsuppressed{gg}=DelayIRtOFFnegative(Iclass8,gg);
     Class8AmplitudeOFFsuppressed{gg}=AmplitudeOFFnegative(Iclass8,gg);
     Class8LatencyONsuppressed{gg}=DelayIRtONnegative(Iclass8,gg);
     Class8AmplitudeONsuppressed{gg}=AmplitudeONnegative(Iclass8,gg);
     
     
     Iclass9=find(typeVector==9);
     class9(gg)=length(Iclass9);class9Index{gg}=Iclass9;class9PSTHvalues{gg}=PSTHvalues(Iclass9,:);
     
     IRCO=find(typeVector<8.5);
     ResponsiveClassOnlyOnOffCells(gg)=length(IRCO);ResponsiveClassOnlyOnOffCellsIndex{gg}=IRCO;ResponsiveClassOnlyOnOffCellsPSTHvalues{gg}=PSTHvalues(IRCO,:);
     
     IRCE=find(typeVector<9);
     ResponsiveClassExcludeClass9(gg)=length(IRCE);ResponsiveClassExcludeClass9Index{gg}=IRCE;ResponsiveClassExcludeClass9PSTHvalues{gg}=PSTHvalues(IRCE,:);
     
%      NonResponsiveClass(gg)=length(find(typeVector>4));
     
     PercentageResponsiveClassOnlyOnOffCells(gg)=ResponsiveClassOnlyOnOffCells(gg)/neuronsNum*100;
     PercentageResponsiveClassExcludeClass9(gg)=ResponsiveClassExcludeClass9(gg)/neuronsNum*100;

        
%     end
end



%%%%%%neuronClasses structure%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%it contains the final analysis results


neuronClasses.class1Number=class1;neuronClasses.Class1NeuronIndex=class1Index;neuronClasses.Class1_PSTHvalues=class1PSTHvalues;
neuronClasses.class1LatencyON=class1LatencyON;
neuronClasses.class1AmplitudeON=class1AmplitudeON;

neuronClasses.class2Number=class2;neuronClasses.Class2NeuronIndex=class2Index;neuronClasses.Class2_PSTHvalues=class2PSTHvalues;
neuronClasses.class2LatencyON=class2LatencyON;
neuronClasses.class2AmplitudeON=class2AmplitudeON;
neuronClasses.Class2LatencyOFFsuppressed=Class2LatencyOFFsuppressed;
neuronClasses.Class2AmplitudeOFFsuppressed=Class2AmplitudeOFFsuppressed;

neuronClasses.class3Number=class3;neuronClasses.Class3NeuronIndex=class3Index;neuronClasses.Class3_PSTHvalues=class3PSTHvalues;
neuronClasses.class3LatencyOFF=class3LatencyOFF;
neuronClasses.class3AmplitudeOFF=class3AmplitudeOFF;

neuronClasses.class4Number=class4;neuronClasses.Class4NeuronIndex=class4Index;neuronClasses.Class4_PSTHvalues=class4PSTHvalues;
neuronClasses.class4LatencyON=class4LatencyON;
neuronClasses.class4AmplitudeON=class4AmplitudeON;
neuronClasses.class4LatencyOFF=class4LatencyOFF;
neuronClasses.class4AmplitudeOFF=class4AmplitudeOFF;

neuronClasses.class5Number=class5;neuronClasses.Class5NeuronIndex=class5Index;neuronClasses.Class5_PSTHvalues=class5PSTHvalues;
neuronClasses.class5LatencyOFF=class5LatencyOFF;
neuronClasses.class5AmplitudeOFF=class5AmplitudeOFF;
neuronClasses.Class5LatencyONsuppressed=Class5LatencyONsuppressed;
neuronClasses.Class5AmplitudeONsuppressed=Class5AmplitudeONsuppressed;


neuronClasses.class55Number=class55;neuronClasses.Class55NeuronIndex=class55Index;neuronClasses.Class55_PSTHvalues=class55PSTHvalues;
neuronClasses.class55LatencyOFF=class55LatencyOFF;
neuronClasses.class55AmplitudeOFF=class55AmplitudeOFF;


neuronClasses.class6Number=class6;neuronClasses.Class6NeuronIndex=class6Index;neuronClasses.Class6_PSTHvalues=class6PSTHvalues;
neuronClasses.Class6LatencyONsuppressed=Class6LatencyONsuppressed;
neuronClasses.Class6AmplitudeONsuppressed=Class6AmplitudeONsuppressed;

neuronClasses.class7Number=class7;neuronClasses.Class7NeuronIndex=class7Index;neuronClasses.Class7_PSTHvalues=class7PSTHvalues;
neuronClasses.Class7LatencyOFFsuppressed=Class7LatencyOFFsuppressed;
neuronClasses.Class7AmplitudeOFFsuppressed=Class7AmplitudeOFFsuppressed;

neuronClasses.class8Number=class8;neuronClasses.Class8NeuronIndex=class8Index;neuronClasses.Class8_PSTHvalues=class8PSTHvalues;
neuronClasses.Class8LatencyOFFsuppressed=Class8LatencyOFFsuppressed;
neuronClasses.Class8AmplitudeOFFsuppressed=Class8AmplitudeOFFsuppressed;
neuronClasses.Class8LatencyONsuppressed=Class8LatencyONsuppressed;
neuronClasses.Class8AmplitudeONsuppressed=Class8AmplitudeONsuppressed;

neuronClasses.class9Number=class9;neuronClasses.Class9NeuronIndex=class9Index;neuronClasses.Class9_PSTHvalues=class9PSTHvalues;



neuronClasses.PercentResponsiveOnlyOnOffCells=PercentageResponsiveClassOnlyOnOffCells;
neuronClasses.PResponsiveOnlyOnOffCellsIndex=ResponsiveClassOnlyOnOffCellsIndex;
neuronClasses.PResponsiveOnlyOnOffCells_PSTHvalues=ResponsiveClassOnlyOnOffCellsPSTHvalues;

neuronClasses.PrecentResponsiveClassExcludeClass9=PercentageResponsiveClassExcludeClass9;
neuronClasses.PResponsiveClassExcludeClass9Index=ResponsiveClassExcludeClass9Index;
neuronClasses.PResponsiveClassExcludeClass9_PSTHvalues=ResponsiveClassExcludeClass9PSTHvalues;



%%%%%%%%Latency and amplitude Matrices to compute for other bin sizes
neuronClasses.DelayIRtON=DelayIRtON;
neuronClasses.DelayIRtOFF=DelayIRtOFF;

neuronClasses.AmplitudeON=AmplitudeON;
neuronClasses.AmplitudeOFF=AmplitudeOFF;

neuronClasses.DelayIRtONnegative=DelayIRtONnegative;
neuronClasses.DelayIRtOFFnegative=DelayIRtOFFnegative;

neuronClasses.AmplitudeONnegative=AmplitudeONnegative;
neuronClasses.AmplitudeOFFnegative=AmplitudeOFFnegative;

neuronClasses.DelayIRtOFF3=DelayIRtOFF3;
neuronClasses.AmplitudeOFF3=AmplitudeOFF3;

%%%%%%%I save this key values for the second layer of calculations
%%%%%%%%%%%%stdRatio,histFrValues,binSize,meanBaseline
%%%%%%%%stdRatio,all_stimWidth_event,histFrValues,meanBaseline,neuronsNamesSorted,prevTime,postTime,binSize,stdFold,negStdFold,showComulativePlots)
neuronClasses.secondLayer_Parameters={stdRatio,all_stimWidth_event,histFrValues,meanBaseline,neuronsNamesSorted,prevTime,postTime,binSize,stdFold,negStdFold,showComulativePlots};





%%%%%%%%%to plot categorized neurons comulative response

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%it is only for one event
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if showComulativePlots==1



A1=[];A2=[];A3=[];A4=[];A5=[];A6=[];A7=[];A8=[];A9=[];A55=[];
L1=[];L2=[];L3=[];L4=[];L5=[];L6=[];L7=[];L8=[];L55=[];
L22=[];L42=[];L52=[];L82=[];
L1amp=[];L2amp=[];L3amp=[];L4amp=[];L5amp=[];L6amp=[];L7amp=[];L8amp=[];L55amp=[];
L22amp=[];L42amp=[];L52amp=[];L82amp=[];

    A1=[A1;cell2mat(neuronClasses.Class1_PSTHvalues)];L1=[L1;cell2mat(neuronClasses.class1LatencyON)];
    L1amp=[L1amp;cell2mat(neuronClasses.class1AmplitudeON)];
    
    A2=[A2;cell2mat(neuronClasses.Class2_PSTHvalues)];L2=[L2;cell2mat(neuronClasses.class2LatencyON)];L22=[L22;cell2mat(neuronClasses.Class2LatencyOFFsuppressed)];
    L2amp=[L2amp;cell2mat(neuronClasses.class2AmplitudeON)];L22amp=[L22amp;cell2mat(neuronClasses.Class2AmplitudeOFFsuppressed)];
    
    A3=[A3;cell2mat(neuronClasses.Class3_PSTHvalues)];L3=[L3;cell2mat(neuronClasses.class3LatencyOFF)];
    L3amp=[L3amp;cell2mat(neuronClasses.class3AmplitudeOFF)];
    
    A4=[A4;cell2mat(neuronClasses.Class4_PSTHvalues)];L4=[L4;cell2mat(neuronClasses.class4LatencyON)];L42=[L42;cell2mat(neuronClasses.class4LatencyOFF)];
    L4amp=[L4amp;cell2mat(neuronClasses.class4AmplitudeON)];L42amp=[L42amp;cell2mat(neuronClasses.class4AmplitudeOFF)];
    
    A5=[A5;cell2mat(neuronClasses.Class5_PSTHvalues)];L5=[L5;cell2mat(neuronClasses.class5LatencyOFF)];L52=[L52;cell2mat(neuronClasses.Class5LatencyONsuppressed)];
    L5amp=[L5amp;cell2mat(neuronClasses.class5AmplitudeOFF)];L52amp=[L52amp;cell2mat(neuronClasses.Class5AmplitudeONsuppressed)];
    
    A6=[A6;cell2mat(neuronClasses.Class6_PSTHvalues)];L6=[L6;cell2mat(neuronClasses.Class6LatencyONsuppressed)];
    L6amp=[L6amp;cell2mat(neuronClasses.Class6AmplitudeONsuppressed)];
    
    A7=[A7;cell2mat(neuronClasses.Class7_PSTHvalues)];L7=[L7;cell2mat(neuronClasses.Class7LatencyOFFsuppressed)];
    L7amp=[L7amp;cell2mat(neuronClasses.Class7AmplitudeOFFsuppressed)];
    
    A8=[A8;cell2mat(neuronClasses.Class8_PSTHvalues)];L8=[L8;cell2mat(neuronClasses.Class8LatencyONsuppressed)];L82=[L82;cell2mat(neuronClasses.Class8LatencyOFFsuppressed)];
    L8amp=[L8amp;cell2mat(neuronClasses.Class8AmplitudeONsuppressed)];L82amp=[L82amp;cell2mat(neuronClasses.Class8AmplitudeOFFsuppressed)];
    
    A9=[A9;cell2mat(neuronClasses.Class9_PSTHvalues)];

    A55=[A55;cell2mat(neuronClasses.Class55_PSTHvalues)];L55=[L55;cell2mat(neuronClasses.class55LatencyOFF)];
    L55amp=[L55amp;cell2mat(neuronClasses.class55AmplitudeOFF)];

    
    MarkerSize=11;
lineWidth=1;%%default value=0.5
fontSize=12;%%default value=11
colSpec='r';

figure
subplot 241
plot(sum(A1,1)/size(A1,1),colSpec,'LineWidth',lineWidth)
hold on
plot(prevTime/binSize+((mean(L1)/1000)/binSize),mean(L1amp),'g*','MarkerSize',MarkerSize)
figTitle=sprintf('class 1: ON Neuron#:%d',size(A1,1));
title(figTitle,'FontSize',fontSize);

subplot 242
plot(sum(A2,1)/(size(A2,1)),colSpec,'LineWidth',lineWidth)
hold on
plot(prevTime/binSize+((mean(L2)/1000)/binSize),mean(L2amp),'g*','MarkerSize',MarkerSize)
hold on
plot(prevTime/binSize+all_stimWidth_event(1)/binSize+((mean(L22)/1000)/binSize),mean(L22amp),'ro','MarkerSize',MarkerSize)
figTitle=sprintf('class 2: ON Dark Suppressed Neuron#:%d',size(A2,1));
title(figTitle,'FontSize',fontSize);

subplot 243
plot(sum(A3,1)/size(A3,1),colSpec,'LineWidth',lineWidth)
hold on
plot(prevTime/binSize+all_stimWidth_event(1)/binSize+((mean(L3)/1000)/binSize),mean(L3amp),'rd','MarkerSize',MarkerSize)
figTitle=sprintf('class 3: OFF Neuron#:%d',size(A3,1));
title(figTitle,'FontSize',fontSize);

subplot 244
plot(sum(A4,1)/size(A4,1),colSpec,'LineWidth',lineWidth)
hold on
plot(prevTime/binSize+((mean(L4)/1000)/binSize),mean(L4amp),'g*','MarkerSize',MarkerSize)
hold on
plot(prevTime/binSize+all_stimWidth_event(1)/binSize+((mean(L42)/1000)/binSize),mean(L42amp),'rd','MarkerSize',MarkerSize)
figTitle=sprintf('class 4: ON-OFF Neuron#:%d',size(A4,1));
title(figTitle,'FontSize',fontSize);

subplot 245
plot(sum(A5,1)/size(A5,1),colSpec,'LineWidth',lineWidth)
hold on
plot(prevTime/binSize+((mean(L52)/1000)/binSize),mean(L52amp),'g+','MarkerSize',MarkerSize)
hold on
plot(prevTime/binSize+all_stimWidth_event(1)/binSize+((mean(L5)/1000)/binSize),mean(L5amp),'rd','MarkerSize',MarkerSize)
figTitle=sprintf('class 5: OFF Light Suppressed Neuron#:%d',size(A5,1));
title(figTitle,'FontSize',fontSize);

subplot 246
plot(sum(A6,1)/size(A6,1),colSpec,'LineWidth',lineWidth)
hold on
plot(prevTime/binSize+((mean(L6)/1000)/binSize),mean(L6amp),'g+','MarkerSize',MarkerSize)
figTitle=sprintf('class 6: Suppressed Light ON Neuron#:%d',size(A6,1));
title(figTitle,'FontSize',fontSize);

subplot 247
plot(sum(A7,1)/size(A7,1),colSpec,'LineWidth',lineWidth)
hold on
plot(prevTime/binSize+all_stimWidth_event(1)/binSize+((mean(L7)/1000)/binSize),mean(L7amp),'ro','MarkerSize',MarkerSize)
figTitle=sprintf('class 7: Suppressed Light OFF Neuron#:%d',size(A7,1));
title(figTitle,'FontSize',fontSize);

subplot 248
plot(sum(A8,1)/size(A8,1),colSpec,'LineWidth',lineWidth)
hold on
plot(prevTime/binSize+((mean(L8)/1000)/binSize),mean(L8amp),'g+','MarkerSize',MarkerSize)
hold on
plot(prevTime/binSize+all_stimWidth_event(1)/binSize+((mean(L82)/1000)/binSize),mean(L82amp),'ro','MarkerSize',MarkerSize)
figTitle=sprintf('class 8: Suppressed Light ON-OFF Neuron#:%d',size(A8,1));
title(figTitle,'FontSize',fontSize);



figure;
subplot 241
plot(sum(A9,1)/size(A9,1),colSpec,'LineWidth',lineWidth)
figTitle=sprintf('class 9: NO RESPONSE Neuron#:%d',size(A9,1));
title(figTitle,'FontSize',fontSize);

subplot 242
plot(sum(A55,1)/size(A55,1),colSpec,'LineWidth',lineWidth)
hold on
plot(prevTime/binSize+((mean(L55)/1000)/binSize),mean(L55amp),'g*','MarkerSize',MarkerSize)
figTitle=sprintf('class 10: Sustained RESPONSE Neuron#:%d',size(A55,1));
title(figTitle,'FontSize',fontSize);


end


