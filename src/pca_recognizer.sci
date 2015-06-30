function [acepted, rejected] = pca_recognizer(trainSamples, testSamples)
    brain = pca_train(trainSamples);
    acepted = list();
    rejected = list();
    for i=1: size(testSamples)
        sampl = testSamples(i);
        c = pca_test(imread(sampl.path), brain);
        if c == sampl.class then
            acepted($+1) = sampl;
        else
            rejected($+1) = sampl;
        end
    end
endfunction

function out = pca_train(samples)
    brain = tlist(["brain", "class", "samples"], [], list());
    for i=1:Nc
        brain.class(i) = iClass(i);
        brain.samples(i) = list();
    end
    for i=1:size(samples)
        sampl = samples(i);
        index = find(brain.class==sampl.class);
        class = brain.samples(index);
        class($+1) = imread(sampl.path);
        brain.samples(index) = class;
    end

    compiledBrain = tlist(["brain", "class", "sampl"], [], list());
    for i=1:Nc
        nClass = brain.class(i);
        nSamples = brain.samples(i);
        A = zeros(Np*Cm,Ni);
        k=1;
        for j=1:Ni
            img = nSamples(j);
            A(:,k) = img(:);
            k = k+1;
        end
        compiledBrain.class(i) = nClass;
        compiledBrain.sampl(i) = pca_compress(A,d);
    end

    out = compiledBrain;
endfunction

function [class] = pca_test(imagem, brain)
    nc = size(brain.class, 1);
    for i=1:nc
        c = brain.sampl(i);
        y = c\imagem(:);
        diffs(i)  = pca_diffImagem(imagem, c*y);
    end
    [j,k] = min(diffs);
    class = brain.class(k);
endfunction

function out=pca_compress(A, d)
    [U S V] = sva(A, d);
    out = U*S;
endfunction

function out = pca_diffImagem(A,B)
    out = norm(A(:) - B(:));
endfunction
