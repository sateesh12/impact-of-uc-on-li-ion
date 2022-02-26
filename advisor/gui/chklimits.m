% chklimits.m
% A script to quickly find indices at which drivetrain limits were reached.  For
% this script to work, a simulation must have been run which generates boolean
% flags, *_limited, with TRUE indicating that the particular limit was reached.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% INITIALIZE
format compact
legend_list=cell(10,1);

% vector indicating which flags have been plotted
plotted_indices=[];

% flag indicating whether some limit has been reached at some time
found_limit=0;

% 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% BUILD LIST OF DEFINED VARIABLES
flag_list=who('lim*');
if isempty(flag_list)
   error('CHKLIMITS failed:  No limits to check.')
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% LOOP THROUGH LIST
for flag_counter=1:length(flag_list)
   
   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   % FIND INDICES AT WHICH EACH VARIABLE IS TRUE
   indices=find(eval(char(flag_list(flag_counter))));
   if ~isempty(indices)
      found_limit=1;
      
      %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
      % OUTPUT RESULTS
      disp(['Drivetrain performance limited:  flag name=',...
            char(flag_list(flag_counter))])
      disp([num2str(length(indices)),' times.'])

      plot_it=input('Do you want to see at what time steps? (y/n) ','s');
      if strncmp(plot_it,'y',1) | strncmp(plot_it,'Y',1)
         %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
         % MAKE A NEW FIGURE WINDOW IF NECESSARY
         if length(plotted_indices)==0
            figure
         end
         
         %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
         % PLOT RESULTS
         switch rem(length(plotted_indices),4)
         case 0
            line_color='b.';
         case 1
            line_color='g.';
         case 2
            line_color='r.';
         case 3
            line_color='k.';
         end
         eval(['plot(',char(flag_list(flag_counter)),...
               '+0.01*length(plotted_indices),line_color)'])
         plotted_indices=[plotted_indices flag_counter];
         hold on
      end                     
      disp(' ')
   end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% CLEAN UP

% put a legend on the new figure if one was made
if length(plotted_indices)>0
   for i=1:length(plotted_indices)
      legend_list(i)=cellstr(strrep(char(flag_list(plotted_indices(i))),...
         '_','\_'));
   end % for i
   legend(char(legend_list(1:length(plotted_indices))))
   hold off
end
if ~found_limit
   disp('No limits were reached.')
end

clear found_limit flag_list indices flag_counter plotted_indices legend_list
   