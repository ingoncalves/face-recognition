function [iClass, iTrain, iTest] = random_indexes(nClassTrain, totalClass, nImgTrain, totalImgClass)
    iClass = [];
    iTest = [];
    iTrain = [];
    
    while length(iClass)<> nClassTrain do
        iClass = [iClass grand(1,1,"uin",1,totalClass)];
        iClass = unique(iClass);
    end
    
    while length(iTrain)<> nImgTrain do
        iTrain = [iTrain grand(1,1,"uin",1,totalImgClass)];
        iTrain = unique(iTrain);
    end
    
    iTest = setdiff([1:totalImgClass], iTest);
endfunction
