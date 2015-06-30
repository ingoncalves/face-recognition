clc;stacksize('max');

iClass = [1:10]; //Indice de classes
iTrain = [1:10]; //Indice de imagens para treinamento
iTest  = [11:14];//Indice de imagens para testes

Nc  = size(iClass,2);//Numero de classes
Ni  = size(iTrain,2);//Numero de imagens por classe
Np  = 200*150;//Numero de pixels
Cm = 3;//numero de camadas de cor (ex.: rgb=3, gray=1)
d  = Ni;//dimensão para compressão do SVA

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
    brain = list();
    for i=1:Nc
        brain(i) = list();
    end

    for i=1:size(samples)
        sampl = samples(i);
        if sampl.class <= Nc then
            class = brain(sampl.class);
            if size(class) < Ni then
                class($+1) = imread(sampl.path);
                brain(sampl.class) = class;
            end
        end
    end

    compiledBrain = list();
    for i=1:Nc
        class = brain(i);
        A = zeros(Np*Cm,Ni);
        k=1;
        for j=1:Ni
            img = class(j);
            A(:,k) = img(:);
            k = k+1;
        end
        compiledBrain($+1) = pcaCompress(A,d);
    end

    out = compiledBrain;
endfunction

function [class, sampl] = classificar(imagem, brain)
    nc = size(brain);
    for i=1:nc
        c = brain(i);
        y = c\imagem(:);
        diffs(i)  = diffImagem(imagem, c*y);
    end
    [j,k] = min(diffs);
    class = k;
endfunction

function out=diffImagem(A,B)
    out = norm(A(:) - B(:));
endfunction

function out=pcaCompress(A, d)
    [U S V] = sva(A, d);
    out = U*S;
endfunction

function out = testar(samples, brain)
    n = size(samples);
    acertos = 0;
    for i=1:n
        sampl = samples(i);
        c = classificar(imread(sampl.path), brain);
        if c == sampl.class then
            acertos = acertos + 1;
        end
    end
    out = acertos;
endfunction

[treinoImgs, testesImgs] = readImages('../database/fei-200x150');
brain = treinar(treinoImgs);
acertos = testar(testesImgs, brain);

n = size(testesImgs);
porcentagem = (acertos/n)*100;
printf('\nImagens testadas: %i\n', n);
printf('Acertos: %i\n',acertos);
printf('Porcentagem de acerto: %i%%\n',porcentagem);
