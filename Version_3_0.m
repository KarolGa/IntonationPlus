%Docelowa zasadza dzia�ania: uzytkownik zaczyna gra�, dzwi�k jest rejestrowany,
%potem por�wnywany z utworem wzorcowym i wyswietlenie ktore partie sa ok a
%ktore trzeba poprawic
clc;
%%clear all;
close all;
licznik=0;
fs=44100;   %nasza cz�stotliwo�� pr�bkowania, kt�ra jest sta�a, bo nie
            %chcemy jej optymalizowa� (�eby zmniejszy� rozmiar utworu

while true
    licznik=licznik+1; %licznik ilo�ci nagra� w sesji
    t=5; %czas nagrywania w sekundach
	X=['Czas nagrywania to: ', num2str(t), ' sekund' ];
    disp(X);
    rozp=input('Wybierz 1 i zatwierd� enterem, aby rozpocz�� nagrywanie, 2 aby wykorzysta� poprzednie nagranie lub 3 aby wyj�� \n');
    while(rozp~=1&&rozp~=2&&rozp~=3)
    disp('Wprowadziles niepoprawn� warto��')
    rozp=input('Wybierz 1, 2 lub 3 i zatwierd� \n');
    end
    
    if(rozp==3) break; 
    end
    
    if(rozp==1)
        % Nagrywanie dzwieku:
        record = audiorecorder(fs, 16, 1); %sa dwa kanaly, dlatego wy�wietlamy 2 wykresy
    	disp('Zacznij grac/spiewac');
        recordblocking(record, t);
    	disp('Koniec nagrania');
        zatw=input('Wybierz 1 i zatwied� je�li chcesz odtworzy� Twoje nagarnie');
        %mo�na doda� odtworzenie nagrania wzorcowego
        if(zatw==1)   play(record); %odtworzenie nagrania
        end 
        % Store data in double-precision array:
        myRecording = getaudiodata(record);
        audiowrite('Piano_record.wav',myRecording,fs); %zapisanie dzwieku do pliku
            input('Wybierz dowoln� liczb�, aby kontynuowa�');
    end
    
  	zatw=input('Wci�nij 1 aby uzyska� informacje o nagraniach, lub inn� liczb� aby przej�� dalej');
  	if(zatw==1)
        audioinfo('Piano_target.wav') 
        audioinfo('Piano_record.wav')  
        input('Wybierz dowoln� liczb�, aby kontynuowa�');
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

    subplot(2,1,1), plot(t,y1),  title('Sygna� oryginalny przed fft');
    ylabel('Amplitude')
    xlabel('Time (s)')
    subplot(2,1,2), plot(t2,y2), title('Sygna� nagrany przed fft');
    ylabel('Amplitude')
    xlabel('Time (s)')
    
    Y = fft(y1);
    Z = fft(y2);
    figure;
    subplot(2,1,1), plot(f1,abs(Y)), title('Sygna� oryginalny w dziedzinie czestotliwoscui');
    subplot(2,1,2), plot(f2,abs(Z)), title('Sygna� nagrany w dziedzinie czestotliwosci');
    figure;
    %je�eli te sygna�y by�yby przesuniete bo np. kto� zacz��by gra�
    %po 1 s to trzeba sprawdzi� kiedy jest najwi�ksza koleracja
    %mi�dzy nimi to jest robione tutaj:
    [r,lags] = xcorr(abs(Y(:,1)),abs(fft(Z(:,1)))); %tutaj co� za du�e chyba te warto�ci wychodz�. Hindusom wychodzi�y mniejsze xD
    plot(lags/fs,r);
    title('Cross-correlation (xcorr) miedzy sygnalami')
    ylabel('Amplitude')
    xlabel('Time(s)')      
    grid on;

    [~,I] = max(abs(r));
    SampleDiff = lags(I)
    timeDiff = SampleDiff/fs  
end  

disp('Dzi�kuje za skorzystanie z programu, do zobaczenia!');
%Puszczanie muzyki i granie - problem z jednoczesnym puszczaniem muzyki i
%nagrywaniem
%Xcross - problem z zastosowaniem i dostosowaniem nagra� i r�nymi tempami

%co chcemy zrobi�:
%1 Wyr�wnujemy utw�r dzi�ki korelacji
%2 


%usefull 
%opis koleracji sygnalow itd.:
%https://www.mathworks.com/help/signal/examples/measuring-signal-similarities.html




