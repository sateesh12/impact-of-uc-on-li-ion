function summary=CompareWorkspace(Workspace1,Workspace2)

wks1=load(Workspace1);
wks2=load(Workspace2);

wks1_names=fieldnames(wks1);
wks2_names=fieldnames(wks2);

wks1_only_names=[];
wks2_only_names=[];

wks1_only=[];
wks2_only=[];

a=1; b=1;
for i=length(wks1_names):-1:1
    if isfield(wks2,wks1_names{i})
        common_names{a}=wks1_names{i};
        a=a+1;
    else
        wks1_only_names{b}=wks1_names{i};
        b=b+1;
    end
end

c=1;
for i=length(wks2_names):-1:1
    found=0;
    for ii=length(common_names):-1:1
        if strcmp(wks2_names{i},common_names{ii})
            found=1;
        end
    end
    if found==0
        wks2_only_names{c}=wks2_names{i};
        c=c+1;
    end
end

d=1; e=1; 
for i=length(common_names):-1:1
    
    if eval(['isnumeric(wks1.',common_names{i},')'])
        if eval(['size(wks1.',common_names{i},')==size(wks2.',common_names{i},')'])
            if eval(['wks1.',common_names{i},'==wks2.',common_names{i},';'])
                eval(['common.same.name{',num2str(d),'}=''',common_names{i},''';'])
                eval(['common.same.value{',num2str(d),'}=wks1.',common_names{i},';'])
                d=d+1;    
            else
                eval(['common.diff.name{',num2str(e),'}=''',common_names{i},''';'])
                eval(['common.diff.wks1.value{',num2str(e),'}=wks1.',common_names{i},';'])
                eval(['common.diff.wks2.value{',num2str(e),'}=wks2.',common_names{i},';'])
                e=e+1;
            end
        else
            eval(['common.diff.name{',num2str(e),'}=''',common_names{i},''';'])
            eval(['common.diff.wks1.value{',num2str(e),'}=wks1.',common_names{i},';'])
            eval(['common.diff.wks2.value{',num2str(e),'}=wks2.',common_names{i},';'])
            e=e+1;
        end
        
    elseif eval(['isstr(wks1.',common_names{i},')'])
        if eval(['strcmp(wks1.',common_names{i},',wks2.',common_names{i},');'])
            eval(['common.same.name{',num2str(d),'}=''',common_names{i},''';'])
            eval(['common.same.value{',num2str(d),'}=wks1.',common_names{i},';'])
            d=d+1;    
        else
            eval(['common.diff.name{',num2str(e),'}=''',common_names{i},''';'])
            eval(['common.diff.wks1.value{',num2str(e),'}=wks1.',common_names{i},';'])
            eval(['common.diff.wks2.value{',num2str(e),'}=wks2.',common_names{i},';'])
            e=e+1;
        end        
        
    elseif eval(['iscell(wks1.',common_names{i},')'])
        
        disp(['Cell Datatype:',common_names{i}])    
        
        [x1,y1]=eval(['size(wks1.',common_names{i},')']);
        [x2,y2]=eval(['size(wks1.',common_names{i},')']);
        
        if x1==x2&y1==y2
            for xx=1:x1
                for yy=1:y1
                    ['wks1.',common_names{i},'{',num2str(xx),',',num2str(yy),'}==wks2.',common_names{i},'{',num2str(xx),',',num2str(yy),'}']
                    if eval(['isnumeric(wks1.',common_names{i},'{',num2str(xx),',',num2str(yy),'})'])
                        if eval(['wks1.',common_names{i},'{',num2str(xx),',',num2str(yy),'}==wks2.',common_names{i},'{',num2str(xx),',',num2str(yy),'}'])
                            eval(['common.same.name{',num2str(d),'}=''',common_names{i},''';'])
                            eval(['common.same.value{',num2str(d),'}=wks1.',common_names{i},';'])
                            d=d+1;    
                        else
                            eval(['common.diff.name{',num2str(e),'}=''',common_names{i},''';'])
                            eval(['common.diff.wks1.value{',num2str(e),'}=wks1.',common_names{i},';'])
                            eval(['common.diff.wks2.value{',num2str(e),'}=wks2.',common_names{i},';'])
                            e=e+1;
                        end
                    elseif eval(['isstr(wks1.',common_names{i},'{',num2str(xx),',',num2str(yy),'})'])
                        if eval(['strcmp(wks1.',common_names{i},'{',num2str(xx),',',num2str(yy),'},wks2.',common_names{i},'{',num2str(xx),',',num2str(yy),'})'])
                            eval(['common.same.name{',num2str(d),'}=''',common_names{i},''';'])
                            eval(['common.same.value{',num2str(d),'}=wks1.',common_names{i},';'])
                            d=d+1;    
                        else
                            eval(['common.diff.name{',num2str(e),'}=''',common_names{i},''';'])
                            eval(['common.diff.wks1.value{',num2str(e),'}=wks1.',common_names{i},';'])
                            eval(['common.diff.wks2.value{',num2str(e),'}=wks2.',common_names{i},';'])
                            e=e+1;
                        end
                        
                    else
                        disp(['Unhandled Cell Datatype:',common_names{i}])    
                    end
                end
            end
            
        else
            eval(['common.diff.name{',num2str(e),'}=''',common_names{i},''';'])
            eval(['common.diff.wks1.value{',num2str(e),'}=wks1.',common_names{i},';'])
            eval(['common.diff.wks2.value{',num2str(e),'}=wks2.',common_names{i},';'])
            e=e+1;
        end
        
    elseif eval(['isstruct(wks1.',common_names{i},')'])
        disp(['Structure Datatype:',common_names{i}])    
        
    else
        disp(['Unknown Datatype:',common_names{i}])    
    end
    
end

for i=length(wks1_only_names):-1:1
    wks1_only.name{i}=wks1_only_names{i};
    wks1_only.value{i}=eval(['wks1.',wks1_only_names{i}]);
end

for i=length(wks2_only_names):-1:1
    wks2_only.name{i}=wks2_only_names{i};
    wks2_only.value{i}=eval(['wks2.',wks2_only_names{i}]);
end

summary.wks1_only=wks1_only;
summary.wks2_only=wks2_only;
summary.common=common;

return









