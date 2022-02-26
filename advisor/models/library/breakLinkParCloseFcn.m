% BreakLinkParCloseFcn

if 0
    try
        blockLinkStatus=get_param(gcb,'LinkStatus');
        if strcmp(blockLinkStatus,'resolved')
            set_param(gcb,'LinkStatus','inactive')
            %set_param(gcb,'LinkStatus','none')
        end
    end
end