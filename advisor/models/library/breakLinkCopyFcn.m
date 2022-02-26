% breakLinkCopyFcn
% This script file kills (renders inactive or destroys depending on setting) the library link to a block when you copy it.
%
if 0
    SET='inactive';
    
    DEBUG=0;
    % none
    %  Block is not a reference block.
    %  
    % resolved
    %  Link is resolved.
    %  
    % unresolved
    %  Link is unresolved.
    %  
    % implicit
    %  Block is within a linked block.
    %  
    % inactive
    %  Link is disabled.
    if DEBUG
        disp(['[',mfilename,'] starting file'])
    end
    execute=0;
    try
        %disp('COPY:')
        %disp(['For block ',gcb])
        %disp(['LinkStatus is ',get_param(gcb,'LinkStatus')])
        %if strcmp(get_param(gcb,'LinkStatus'),'resolved')|strcmp(get_param(gcb,'LinkStatus'),'implicit')
        if strcmp(get_param(gcb,'LinkStatus'),'implicit')
            set_param(gcb,'LinkStatus',SET)   
        end
        execute=1;
    end
    if DEBUG
        disp(['Tried to set to ',SET])
        if execute
            disp('set_param run without errors')
        else
            disp('set_param caused errors')
            disp(lasterr)
        end
        disp(['After set, Link Status is ', get_param(gcb,'LinkStatus')])
    end
end