function [trainList, testList] = read_samples(path)
    files = listfiles(path);
    trainList = list();
    testList = list();
    for i=1:size(files, 1)
        fileName = files(i);
        [a,b,c,d] = regexp(fileName,'/(?P<class>\d+)-(?P<index>\d+)\.(?P<type>\w+)/');
        class = strtod(d(1));
        index = strtod(d(2));
        if find(iClass==class) then
            sampl = struct('class', class, 'index', index,'path', path+'/'+fileName);
            if find(iTrain==index) then
                trainList($+1) = sampl;
            elseif find(iTest==index) then
                testList($+1) = sampl;
            end
        end
    end
endfunction
