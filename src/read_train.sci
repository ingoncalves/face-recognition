function [trainList] = read_train(path)
    files = listfiles(path);
    trainList = list();
    for i=1:size(files, 1)
        fileName = files(i);
        [a,b,c,d] = regexp(fileName,'/(?P<class>\d+)-(?P<index>\d+)\.(?P<type>\w+)/');
        class = strtod(d(1));
        index = strtod(d(2));
        sampl = struct('class', class, 'index', index,'path', path+'/'+fileName);
        trainList($+1) = sampl;
    end
endfunction
