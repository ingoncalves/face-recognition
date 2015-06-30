function [iClass, iTrain, iTest] = random_indexes(nClass, nImgClass)
    iClass = unique(grand(1,10,"uin",1,nClass));
    iTest  = unique(grand(1,10,"uin",1,nImgClass));
    iTrain = setdiff([1:nImgClass], iTest);
endfunction
