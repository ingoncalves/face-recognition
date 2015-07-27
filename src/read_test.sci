function [testList] = read_test(path)
    dirs = listfiles(path);
    testList = list();
    for i=1:size(dirs, 1)
        dirName = dirs(i);
        files = listfiles(path+'/'+dirName);
        for j=1:size(files, 1)
            fileName = files(j);
            [a,b,c,d] = regexp(fileName,'/(?P<index>\d+)\.(?P<type>\w+)/');
            class = strtod(dirName);
            index = strtod(d(1));
            sampl = struct('class', class, 'index', index,'path', path+'/'+dirName+'/'+fileName);
            testList($+1) = sampl;
        end
    end
endfunction
