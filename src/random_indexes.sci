function [iClass, iTrain, iTest] = random_indexes(nClass, totalClass, nImgClass, totalImgClass)
    iClass = [];
    iTrain = [];
    iTest = [];
    
    while length(iClass)<>nClass 
        iClass = [iClass grand(1, 1,"uin",1,totalClass)]
        iClass = unique(iClass)
    end
    
    while length(iTest)<>nImgClass do
        iTest = [iTest grand(1, 1,"uin",1,nImgClass)]
        iTest = unique(iTest);
    end
    
    iTrain = setdiff([1:totalImgClass], iTest);
endfunction
