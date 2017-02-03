clear;
close all;


% fréquence d'echantillonnage et base de temps
    Fe = 5e6;   
    T=1/Fe;
    Npts = 2^15; % longueur d'enregistrement
    n= 0:Npts-1; 
    t= n*T;
    dureeSignal=Npts*T;
    
   temp=29.70;
   tempK=273.15 + temp ;
   m=4.8157e-026;
   C = sqrt((1.4*1.38*10^(-23)*tempK)/m)
   
   
    
 % génération du signal créneau 
    d =[0 : 25 :437.5]' * 1e-6;
    w = 12.5e-6;
    X1 = pulstran(t,d,'rectpuls',w);

% génération du signal créneau PWM
    
    Pts=19000;
  
    temps = importdata('s.mat');
    V = importdata('V.mat');
    V1= importdata('V1.mat');
    %définition de X3 dans T
    
    X3=V;
    X4=V1;
    figure (2)
    plot(t,X3,t,X4);
    
% 
%     Delay =2.4e-3;
%     IndiceDepartSignal2= 1+ Delay/T;
%     X2=zeros(1,Npts);
%     X2(IndiceDepartSignal2:Npts)=X1(1:(Npts-IndiceDepartSignal2)+1);

% %génération d'une pulsation a t=0 :  
%     s1=sin(2*pi*40000*t); % signal de base 
%     c=rectpuls(t,2*1.4e-4); % Signal porte
% 
% %porteuse
%     t_e=(1:length(s1))/Fe;
%     e=cos(2*pi*3333*t_e-pi/2);
% 
% %Produit de convolution des 3 signaux
%     p1=s1.*e;
%     X11=p1.*c; 


% génération d'une pulsation retardée 2.4 ms
%     Delay =2.4e-3;
%     IndiceDepartSignal2= 1+ Delay/T;
%     s2=zeros(1,Npts);
%     s2(IndiceDepartSignal2:Npts)=X11(1:(Npts-IndiceDepartSignal2)+1);
%     X2=s2;
%     figure(3)
%     plot(t,X2);
% 
%     
    


    Wn =40000/((Fe)/2);
    r=0.999;
    wpt=(2*pi*40000)/(Fe);
    B=1;
    A(1)=1;
    A(2)=-2*r*cos(wpt);
    A(3)=r^2;
   % [B,A] = butter(1,Wn);
    Y1 = filter(B,A,X3);
    Y2=filter(B,A,X4);
    
    
    figure (4)
    
    plot(t,Y1,t,Y2);
    title ('Emission/Récéption')
 grid
    
    
    % Code corrélation
    
    % Transformée de fourier du premier signal
    x1=fft(Y1);
    
%      figure(6)
%     plot(abs(x1));
    
    % Transformée de fourier du second signal
    x2=fft(X4);
    
    %Fonction complexe conjugue de x2
    x1conjugue=conj(x1);
    
    %Produit x1 et x2conjugue
    interspectre=x2.*x1conjugue;
    
    % Transformée de fourier inverse de interspectre
    correlation=ifft(interspectre);
    
%      
%     figure(5)
%      plot(t,correlation);
%      title('correlation');
%      grid;
%  
    
    moyennecorrelation=mean(correlation);
    correlation=correlation-moyennecorrelation;
    
    figure(5)
     plot(t,correlation);
     title('correlation');
     grid;
 
    
     [ord,absc]=max(abs(correlation))
      [ordmin,abscmin]=min(correlation)
     Uabsolue=absc*T*1000
     Umin=abscmin*T*1000
     
    %calcul de la vitesse du vent
    Usansvent=( 0.8/C )*10^3
    corr=Uabsolue-Usansvent
    Retardcorrige=Uabsolue - 0.3327
    Vitessevent=(0.8/(Retardcorrige*10^-3)) - 348.1708 
   
    
%     Delay2 =0.3246 ;
