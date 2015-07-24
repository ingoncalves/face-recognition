function pca_dct_recognizer(trainSamples, testSamples)
    brain = pca_dct_train(trainSamples);
    for i=1: size(testSamples)
        sampl = testSamples(i);
        c = pca_dct_test(gray_imread(sampl.path), brain);
        disp("path = "+sampl.path + " | class = " + string(c));
    end
endfunction

function out = pca_dct_train(samples)
    brain = tlist(["brain", "class", "samples"], [], list());
    for i=1:Nc
        brain.class(i) = iClass(i);
        brain.samples(i) = list();
    end
    for i=1:size(samples)
        sampl = samples(i);
        index = find(brain.class==sampl.class);
        class = brain.samples(index);
        class($+1) = gray_imread(sampl.path);
        brain.samples(index) = class;
    end

    compiledBrain = tlist(["brain", "class", "sampl"], [], list());
    for i=1:Nc
        nClass = brain.class(i);
        nSamples = brain.samples(i);
        Ni = size(nSamples);
        A = zeros(Np*Cm,Ni);
        k=1;
        for j=1:Ni
            img = nSamples(j);
            imgd = dct(img);
            imgd(abs(imgd)<1)=0;
            imgd = dct(imgd, 1);
            alpha = 10.0;
            imgr = (img + alpha*imgd)/(1+alpha);
            A(:,k) = imgr(:);
            k = k+1;
        end
        compiledBrain.class(i) = nClass;
        compiledBrain.sampl(i) = pca_dct_compress(A,d);
    end

    out = compiledBrain;
endfunction

function [class] = pca_dct_test(imagem, brain)
    nc = size(brain.class, 1);
    for i=1:nc
        c = brain.sampl(i);
        y = c\imagem(:);
        diffs(i)  = pca_dct_diffImagem(imagem, c*y);
    end
    [j,k] = min(diffs);
    class = brain.class(k);
endfunction

function out=pca_dct_compress(A, d)
    [U S V] = sva(A, d);
    out = U*S;
endfunction

function out = pca_dct_diffImagem(A,B)
    out = norm(A(:) - B(:));
endfunction
