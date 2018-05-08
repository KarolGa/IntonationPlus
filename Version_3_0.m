%Docelowa zasadza dzia³ania: uzytkownik zaczyna graæ, dzwiêk jest rejestrowany,
%potem porównywany z utworem wzorcowym i wyswietlenie ktore partie sa ok a
%ktore trzeba poprawic
clc;
%%clear all;
close all;
licznik=0;
fs=44100;   %nasza czêstotliwoœæ próbkowania, która jest sta³a, bo nie
            %chcemy jej optymalizowaæ (¿eby zmniejszyæ rozmiar utworu

while true
    licznik=licznik+1; %licznik iloœci nagrañ w sesji
    t=5; %czas nagrywania w sekundach
	X=['Czas nagrywania to: ', num2str(t), ' sekund' ];
    disp(X);
    rozp=input('Wybierz 1 i zatwierdŸ enterem, aby rozpocz¹æ nagrywanie, 2 aby wykorzystaæ poprzednie nagranie lub 3 aby wyjœæ \n');
    while(rozp~=1&&rozp~=2&&rozp~=3)
    disp('Wprowadziles niepoprawn¹ wartoœæ')
    rozp=input('Wybierz 1, 2 lub 3 i zatwierdŸ \n');
    end
    
    if(rozp==3) break; 
    end
    
    if(rozp==1)
        % Nagrywanie dzwieku:
        record = audiorecorder(fs, 16, 1); %sa dwa kanaly, dlatego wyœwietlamy 2 wykresy
    	disp('Zacznij grac/spiewac');
        recordblocking(record, t);
    	disp('Koniec nagrania');
        zatw=input('Wybierz 1 i zatwiedŸ jeœli chcesz odtworzyæ Twoje nagarnie');
        %mo¿na dodaæ odtworzenie nagrania wzorcowego
        if(zatw==1)   play(record); %odtworzenie nagrania
        end 
        % Store data in double-precision array:
        myRecording = getaudiodata(record);
        audiowrite('Piano_record.wav',myRecording,fs); %zapisanie dzwieku do pliku
            input('Wybierz dowoln¹ liczbê, aby kontynuowaæ');
    end
    
  	zatw=input('Wciœnij 1 aby uzyskaæ informacje o nagraniach, lub inn¹ liczbê aby przejœæ dalej');
  	if(zatw==1)
        audioinfo('Piano_target.wav') 
        audioinfo('Piano_record.wav')  
        input('Wybierz dowoln¹ liczbê, aby kontynuowaæ');
    end
    
    if(zatw~=2)
        [y1, Fs1] = audioread('Piano_record.wav'); %y - m-by-n matrix, where m is the number of audio samples read and n is the number of audio channels in the file.
        [y2, Fs2] = audioread('Piano_target.wav');

        y1 = y1(:, 1);                        % get the first channel
        N1 = length(y1);                      % audio signal length
        t1 = (0:N1-1)/Fs1;                    % time vector
        f1=(0:length(t1)-1)'*Fs1/length(t1);  

        y2 = y2(:, 1);                      
        N2 = length(y2);                     
        t2 = (0:N2-1)/Fs2;                     
        f2=(0:length(t2)-1)'*Fs2/length(t2);
    end

    subplot(2,1,1), plot(t,y1),  title('Sygna³ oryginalny przed fft');
    ylabel('Amplitude')
    xlabel('Time (s)')
    subplot(2,1,2), plot(t2,y2), title('Sygna³ nagrany przed fft');
    ylabel('Amplitude')
    xlabel('Time (s)')
    
    Y = fft(y1);
    Z = fft(y2);
    figure;
    subplot(2,1,1), plot(f1,abs(Y)), title('Sygna³ oryginalny w dziedzinie czestotliwoscui');
    subplot(2,1,2), plot(f2,abs(Z)), title('Sygna³ nagrany w dziedzinie czestotliwosci');
    figure;
    %je¿eli te sygna³y by³yby przesuniete bo np. ktoœ zacz¹³by graæ
    %po 1 s to trzeba sprawdziæ kiedy jest najwiêksza koleracja
    %miêdzy nimi to jest robione tutaj:
    [r,lags] = xcorr(abs(Y(:,1)),abs(fft(Z(:,1)))); %tutaj coœ za du¿e chyba te wartoœci wychodz¹. Hindusom wychodzi³y mniejsze xD
    plot(lags/fs,r);
    title('Cross-correlation (xcorr) miedzy sygnalami')
    ylabel('Amplitude')
    xlabel('Time(s)')      
    grid on;

    [~,I] = max(abs(r));
    SampleDiff = lags(I)
    timeDiff = SampleDiff/fs  
end  

disp('Dziêkuje za skorzystanie z programu, do zobaczenia!');
%Puszczanie muzyki i granie - problem z jednoczesnym puszczaniem muzyki i
%nagrywaniem
%Xcross - problem z zastosowaniem i dostosowaniem nagrañ i ró¿nymi tempami

%co chcemy zrobiæ:
%1 Wyrównujemy utwór dziêki korelacji
%2 


%usefull 
%opis koleracji sygnalow itd.:
%https://www.mathworks.com/help/signal/examples/measuring-signal-similarities.html




