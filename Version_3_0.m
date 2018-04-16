clc;
clear all;
close all;
xx=1;
while xx==1
 t=5; %czas nagrywania
   X=['Czas nagrywania to: ', num2str(t), ' sekund' ];
   disp(X)
    xx=input('Wciœnji 1 aby rozpocz¹æ program i nagrywanie \n');
      
    if(xx==1)
    % Nagrywanie dzwieku:
    
    fs=44100;
    recObj = audiorecorder(fs, 16, 2); %dwa kana³y dlatego s¹ dwa wykresy na jednym
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
             subplot(2,1,1), plot(y),  title('Sygna³ oryginalny przed fft');
             subplot(2,1,2), plot(y2), title('Sygna³ nagrany przed fft');
             figure;
           subplot(2,1,1), plot(abs(Y)), title('Sygna³ oryginalny po fft');
           subplot(2,1,2), plot(abs(Z)), title('Sygna³ nagrany po fft');
           figure;
           %je¿eli te sygna³y by³yby przesuniete bo np. ktoœ zacz¹³by graæ
           %po 1 s to trzeba sprawdziæ kiedy jest najwiêksza koleracja
           %miêdzy nimi to jest robione tutaj:
             [r,lags] = xcorr(abs(Y(:,1)),abs(fft(Z(:,1)))); %tutaj coœ za du¿e chyba te wartoœci wychodz¹. Hindusom wychodzi³y mniejsze xD
             plot(lags,r);
             title('Cross-correlation (xcorr) miedzy zygnalami')
             ylabel('correlation');
             xlabel('lag');      
             grid on;
      end
xx=0;    
end