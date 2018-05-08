clc;
clear all;
close all;
%zasadza dzia�ania - docelowa - ktos zaczyna gra�, ca�osci sie nagrywa,
%potem porownanie z utworem wzorcowym i wyswietlenie ktore partie sa ok a
%ktore trzeba poprawic - jakos tak to widze

while true
 t=5; %czas nagrywania
   X=['Czas nagrywania to: ', num2str(t), ' sekund' ];
   disp(X)
    xx=input('Wybierz 1 i zatwierd�, aby rozpocz�� nagrywanie \n');
    while(xx~=1) 
    disp('Wprowadziles niepoprawn� warto��')
    xx=input('Wybierz 1 i zatwierd�, aby rozpocz�� nagrywanie \n');
    end
    if(xx==1)
    % Nagrywanie dzwieku:
    
    fs=44100;
    recObj = audiorecorder(fs, 16, 2); %dwa kana�y dlatego s� dwa wykresy na jednym
    disp('Zacznij grac')
    recordblocking(recObj, t);
    disp('Koniec nagrania');
    % Store data in double-precision array:
    myRecording = getaudiodata(recObj);

       %Praca na nagraniach
        
       % u nas czestotliwosc probkowania bedzie taka sama - nie idziemy  w
       % optymalizacje zajetego miejsca przez utwor

        audiowrite('Piano_record.wav',myRecording,fs); %zapisanie dzwieku do pliku
           % info = audioinfo('Piano.wav')  
           % info = audioinfo('Piano_record.wav')  
       
        [y1, Fs1] = audioread('Piano.wav'); %y - m-by-n matrix, where m is the number of audio samples read and n is the number of audio channels in the file.
             [y2, Fs2] = audioread('Piano_record.wav');
             
                y1 = y1(:, 2);                        % get the first channel
                N1 = length(y1);                      % audio signal length
                t1 = (0:N1-1)/Fs1;                     % time vector
                f1=(0:length(t1)-1)'*Fs1/length(t1)  
               
                
                 y2 = y2(:, 2);                      
                N2 = length(y2);                     
                t2 = (0:N2-1)/Fs2;                     
                f2=(0:length(t2)-1)'*Fs2/length(t2) 
               
             Y = fft(y1);
             Z = fft(y2);
             
             subplot(2,1,1), plot(t,y),  title('Sygna� oryginalny przed fft');
             ylabel('Amplitude')
             xlabel('Time (s)')
             subplot(2,1,2), plot(t2,y2), title('Sygna� nagrany przed fft');
             ylabel('Amplitude')
             xlabel('Time (s)')
             
             figure;
           subplot(2,1,1), plot(f1,abs(Y)), title('Sygna� oryginalny w dziedzinie czestotliwoscui');
           subplot(2,1,2), plot(f2,abs(Z)), title('Sygna� nagrany w dziedzinie czestotliwosci');
           figure;
           %je�eli te sygna�y by�yby przesuniete bo np. kto� zacz��by gra�
           %po 1 s to trzeba sprawdzi� kiedy jest najwi�ksza koleracja
           %mi�dzy nimi to jest robione tutaj:
             [r,lags] = xcorr(abs(Y(:,1)),abs(fft(Z(:,1)))); %tutaj co� za du�e chyba te warto�ci wychodz�. Hindusom wychodzi�y mniejsze xD
             plot(lags/Fs,r);
             title('Cross-correlation (xcorr) miedzy sygnalami')
            ylabel('Amplitude')
            xlabel('Time(s)')      
             grid on;
             
             [~,I] = max(abs(r));
                SampleDiff = lags(I)
                    timeDiff = SampleDiff/Fs
  
      end
xx=0;    

end






%usefull 
%opis koleracji sygnalow itd.:
%https://www.mathworks.com/help/signal/examples/measuring-signal-similarities.html




