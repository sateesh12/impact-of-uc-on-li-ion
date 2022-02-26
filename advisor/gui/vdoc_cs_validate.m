% this function will scan the candidate value results for invalid conditions 
% (i.e. high SOC less than low SOC, ...) and remove those candidate values 
% and responses from the data set

global vinf

% condition one cs_hi_soc <= cs_lo_soc
if vinf.control_strategy.dv.active(1)&vinf.control_strategy.dv.active(2)
   bad_index=[];
   for i=1:length(vinf.control_strategy.cv)
      if vinf.control_strategy.cv{i}(1)>=vinf.control_strategy.cv{i}(2)
         bad_index=[bad_index i];
      end
   end
   if ~isempty(bad_index)
      temp.cv=vinf.control_strategy.cv;
      temp.cr=vinf.control_strategy.cr;
      vinf.control_strategy=rmfield(vinf.control_strategy,'cv');
      vinf.control_strategy=rmfield(vinf.control_strategy,'cr');
      good_counter=1;
      bad_counter=1;
      for i=1:length(temp.cv)
         if i==bad_index(bad_counter)
            bad_counter=min(bad_counter+1,length(bad_index));
         else
            vinf.control_strategy.cv{good_counter}=temp_cv{i}
            vinf.control_strategy.cr{good_counter}=temp_cr{i}
            good_counter=good_counter+1;
         end
      end
   end
end

      
% condition two ??
