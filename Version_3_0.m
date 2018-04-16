clc;
clear all;
close all;
xx=1;
while xx==1
 t=5; %czas nagrywania
   X=['Czas nagrywania to: ', num2str(t), ' sekund' ];
   disp(X)
    xx=input('Wci�nji 1 aby rozpocz�� program i nagrywanie \n');
      
    if(xx==1)
    % Nagrywanie dzwieku:
    
    fs=44100;
    recObj = audiorecorder(fs, 16, 2); %dwa kana�y dlatego s� dwa wykresy na jednym
    disp('Zacznij grac')
    recordblocking(recObj, t);
    disp('Koniec nagrania');
    % Store data in double-precision array.
    myRecording = getaudiodata(recObj);

       %Praca na nagraniach
       % info = audioinfo('Piano.wav')
        audiowrite('Piano_record.wav',myRecording,fs); %zapisanie dzwieku do pliku
            [y, Fs] = audioread('Piano.wav');
             [y2, Fs1] = audioread('Piano_record.wav');
             Y = fft(y);
             Z = fft(y2);
             subplot(2,1,1), plot(y),  title('Sygna� oryginalny przed fft');
             subplot(2,1,2), plot(y2), title('Sygna� nagrany przed fft');
             figure;
           subplot(2,1,1), plot(abs(Y)), title('Sygna� oryginalny po fft');
           subplot(2,1,2), plot(abs(Z)), title('Sygna� nagrany po fft');
           figure;
           %je�eli te sygna�y by�yby przesuniete bo np. kto� zacz��by gra�
           %po 1 s to trzeba sprawdzi� kiedy jest najwi�ksza koleracja
           %mi�dzy nimi to jest robione tutaj:
             [r,lags] = xcorr(abs(Y(:,1)),abs(fft(Z(:,1)))); %tutaj co� za du�e chyba te warto�ci wychodz�. Hindusom wychodzi�y mniejsze xD
             plot(lags,r);
             title('Cross-correlation (xcorr) miedzy zygnalami')
             ylabel('correlation');
             xlabel('lag');      
             grid on;
      end
xx=0;    
end