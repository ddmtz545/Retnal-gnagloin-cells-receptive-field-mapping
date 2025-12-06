function [stimWidth]=stimuli_pulse_width(eventName)
        %%%this function finds the stimulation pulse width from the name of
        %%%the event string
        %%%%%%%%%%%%%%%%%%%%%%%%%%%Attentoin!!!!the stimulation pulse width
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%is being extracted from the
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%event name
        
        k=strfind(eventName,'Flashes ');
        k1=strfind(eventName,'ND');%%%supposed that all names that have "ND" their pulse width is 1 second
        
        if ~isempty(k1)
           stimWidth=1;
        elseif ~isempty(k) && isempty(k1)
            IndexK=14;%%%supposed that name begins with "Test Flashes " string
            count=0;
            while ~isempty(str2num(eventName(IndexK+count)))
                count=count+1;
                
            end
         
            if (eventName(IndexK+count))=='m'
                
                stimWidth=str2num(eventName(IndexK:(IndexK+count-1)))/1000;
                
            elseif (eventName(IndexK+count))=='s'
            
                stimWidth=str2num(eventName(IndexK:(IndexK+count-1)));
                
            end
            
        else
            stimWidth=0.1;%%%%%if there is no number in the event name to specify the duration of stimuli pulse the value here would be the default value
            %%%%change it for other values
        end
        
    
end
       