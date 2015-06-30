clc;stacksize('max');

function [trainList, testList] = readImages(path)
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

function out = treinar(samples)
    brain = tlist(["brain", "class", "samples"], [], list());
    for i=1:Nc
        brain.class(i) = iClass(i);
        brain.samples(i) = list();
    end

    for i=1:size(samples)
        sampl = samples(i);
        if find(iClass==sampl.class) then
            index = find(brain.class==sampl.class);
            class = brain.samples(index);
            if size(class) < Ni then
                class($+1) = imread(sampl.path);
                brain.samples(index) = class;
            end
        end
    end
    out = brain;
endfunction

function [class, sampl] = classificar(imagem, brain)
    nc = size(brain.class, 1);
    for i=1:nc
        nSamples = brain.samples(i);
        ni = size(nSamples);
        for j=1:ni
           sampl = nSamples(j);
           diffs(i,j) = diffImagem(imagem, sampl);
        end
    end
    [j,k] = min(diffs);
    cIndex = k(1);//indice da classe
    sIndex = k(2);//indice da imagem

    class = brain.class(cIndex);
    samples = brain.samples(cIndex);
    sampl = samples(sIndex);
endfunction

function [acepted, rejected] = testar(samples, brain)
    n = size(samples);
    acepted = list();
    rejected = list();
    for i=1:n
        sampl = samples(i);
        c = classificar(imread(sampl.path), brain);
        if c == sampl.class then
            acepted($+1) = sampl;
        else
            rejected($+1) = sampl;
        end
    end
endfunction

function out=diffImagem(A,B)
    out = norm(A(:) - B(:));
endfunction

function [iClass, iTrain, iTest] = getRandomIndexes(nClass, nImgClass)
    iClass = unique(grand(1,10,"uin",1,nClass));
    iTest  = unique(grand(1,10,"uin",1,nImgClass));
    iTrain = setdiff([1:nImgClass], iTest);
endfunction


[iClass, iTrain, iTest] = getRandomIndexes(200, 14);
Nc  = size(iClass,2);//Numero de classes
Ni  = size(iTrain,2);//Numero de imagens por classe
Np  = 200*150;//Numero de pixels

[treinoImgs, testesImgs] = readImages('../database/fei-200x150');
brain = treinar(treinoImgs);
[a r] = testar(testesImgs, brain);
acertos = size(a);
n = size(testesImgs);
porcentagem = (acertos/n)*100;
printf('\nImagens testadas: %i\n', n);
printf('Acertos: %i\n',acertos);
printf('Porcentagem de acerto: %i%%\n',porcentagem);
