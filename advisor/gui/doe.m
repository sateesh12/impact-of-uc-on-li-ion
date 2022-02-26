function [cv, cr]=doe(lb,ub,active)
%
% Matlab-based Design of Experiments
% 
% This routine will generate the candidate values and the candidate responses
% for a full qradratic Koshal design with postive interactions
%

% doe type flag
doe_type_flag=0; % 0=> Koshal design, 1=> alternative design

% set flag for vdoc_cs_opt
running_doe=1;

% create matrix of possible design variable values
test_points=[lb; (lb+ub)/2; ub];

% create a matrix defining the range of the design variables
range=[((lb+ub)/2)-lb; ub-((lb+ub)/2)];

% initialize index
counter=1;

% zero terms
cv{counter}=test_points(2,:);
counter=counter+1;

% initialize random number generator
rand('state',sum(100*clock));

% upper bound terms
if ~doe_type_flag
   for i=1:length(test_points)
      if active(i)
         cv{counter}=test_points(2,:);
         cv{counter}(i)=test_points(2,i)+range(2,i);
         counter=counter+1;
      end
   end
   % lower bound terms
   for i=1:length(test_points)
      if active(i)
         cv{counter}=test_points(2,:);
         cv{counter}(i)=test_points(2,i)-range(1,i);
         counter=counter+1;
      end
   end
end

% postive interaction terms
for x=1:length(test_points)-1
   for i=1:length(test_points)-x
      if active(i)&active(i+x)
         cv{counter}=test_points(2,:);
         if doe_type_flag
            r_num=0;
            while r_num<0.5
               r_num=rand;
            end
         else
            r_num=1;
         end
         cv{counter}(i)=test_points(2,i)+range(2,i)*r_num;
         if doe_type_flag
            r_num=0;
            while r_num<0.5
               r_num=rand;
            end
         else
            r_num=1;
         end
         cv{counter}(i+x)=test_points(2,i+x)+range(2,i+x)*r_num;
         counter=counter+1;
      end
   end
end

if doe_type_flag
   % negative interaction terms
   for x=1:length(test_points)-1
      for i=1:length(test_points)-x
         if active(i)&active(i+x)
            cv{counter}=test_points(2,:);
            r_num=0;
            while r_num<0.5
               r_num=rand;
            end
            cv{counter}(i)=test_points(2,i)-range(1,i)*r_num;
            r_num=0;
            while r_num<0.5
               r_num=rand;
            end
            cv{counter}(i+x)=test_points(2,i+x)-range(1,i+x)*r_num;
            counter=counter+1;
         end
      end
   end
end

% generate candidate responses
for i=1:length(cv)
   index=0;
   for x=1:length(cv{i})
      if ~active(x)
         cv{i}(x)=-1;
      else
         index=index+1;
         cv2{i}(index)=cv{i}(x);
      end
   end
   cr{i}=vdoc_cs_opt('visdoc',cv2{i});
end

return

% revision history
% 8/23/99:tm file created
% 10/25/99:tm modified cv definitions so that an alternative doe method to 
%             the Koshal design could by used by setting the doe_type_flag
%
