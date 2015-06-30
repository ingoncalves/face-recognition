clc;stacksize('max');funcprot(0);getd('.');

[iClass, iTrain, iTest] = getRandomIndexes(200, 14);
Nc  = size(iClass,2);//Numero de classes
Ni  = size(iTrain,2);//Numero de imagens por classe
Np  = 200*150;//Numero de pixels
Cm = 3;//numero de camadas de cor (ex.: rgb=3, gray=1)
d  = Ni;//dimensão para compressão do SVA

[trainSamples, testSamples] = read_samples('../database/fei-200x150');//imagens do banco
[acepted rejected] = pca_recognizer(trainSamples, testSamples);
acertos = size(acepted);

n = size(testSamples);
porcentagem = (acertos/n)*100;
printf('\nImagens testadas: %i\n', n);
printf('Acertos: %i\n',acertos);
printf('Porcentagem de acerto: %i%%\n',porcentagem)
