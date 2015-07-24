clc;stacksize('max');funcprot(0);getd('.');
porcentagemMedia = 0;
rejecteds = list();

Nc  = 9;//Numero de classes
Np  = 64*64;//Numero de pixels
Cm = 1;//numero de camadas de cor (ex.: rgb=3, gray=1)
d  = 1;//dimensão para compressão do SVA

iClass = 1:9
trainSamples = read_train('../database/fabbri/train');
testSamples = read_test('../database/fabbri/test');
pca_recognizer(trainSamples, testSamples);//bruteforce_recognizer || pca_recognizer ||pca_dct_recognizer
