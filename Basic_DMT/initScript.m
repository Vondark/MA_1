%initScript.m
format shortEng

%bitCount = '8';
%fracLen = '0';

sysgenSystemPeriod=.5e-9;
assignin('base', 'sysgenSystemPeriod', sysgenSystemPeriod);
fftLen = 16;
M=log2(fftLen);
assignin('base', 'fftLen', fftLen);
assignin('base', 'M', M);
fftLenDMT = 2*fftLen;
assignin('base', 'fftLenDMT', fftLenDMT);
usedSubCar=14;
bitPerSymb=4;

upsampleFactor = 8; 

assignin('base', 'impulseResponse', impulseResponse);


if guardInterval == 2
    GI_Len = 4;
    GI_LenDMT=GI_Len*2;
    
else
    GI_Len = 0;
     GI_LenDMT=0;
     GI_Active=0;
end
assignin('base', 'GI_Len', GI_Len);
assignin('base', 'GI_LenDMT', GI_LenDMT);
if dmtOfdm == 1 %% To create blocks which are not dependent on variant subsystems.
    GI_Active = GI_Len;
    fftLenActive = fftLen;
else
    GI_Active = GI_LenDMT;
    fftLenActive = fftLenDMT;
end
assignin('base', 'GI_Active', GI_Active);
assignin('base', 'fftLenActive', fftLenActive);
beta = fftLen/(fftLen+GI_Len); 
assignin('base', 'beta', beta);

assignin('base', 'usedSubCar', usedSubCar);
assignin('base', 'bitPerSymb', bitPerSymb);
assignin('base', 'bitCount',bitCount);
assignin('base', 'fracLen',fracLen);
assignin('base', 'Ts', SampleTime);
if upsample == 2
    upsampleFactor = 8; 
else
    upsampleFactor = 1; %used in AWGN Simulink Channel sample time calculation
end
assignin('base', 'upsample', upsample);
assignin('base', 'upsampleFactor', upsampleFactor);


%sysgenSystemPeriod = SampleTime*usedSubCar/fftLen;
assignin('base', 'sysgenSystemPeriod', sysgenSystemPeriod);
assignin('base', 'Tb', BitTime);
assignin('base', 'modu_mode', modu_mode);
assignin('base', 'radio_precision', str2double(radio_precision));
assignin('base', 'dmtOfdm', dmtOfdm);
assignin('base', 'guardInterval', guardInterval);
assignin('base', 'AWGN', AWGN);
assignin('base', 'channel', channel);
grpDelayChannelFilt = 1;
assignin('base', 'grpDelayChannelFilt', grpDelayChannelFilt);

if radio_precision == 1
    precision_str = 'double';
    precStrAftIFFT = 'double';
else
    precision_str = strcat('fixdt(1,' , num2str(bitCount) , ',' , num2str(fracLen) , ')');
    precStrAftIFFT =strcat('fixdt(1,' , num2str(bitCount+(log2(fftLen)+1)) , ',' , num2str(fracLen) , ')');
    precisionModu = strcat('sfix(',num2str(bitCount),')');
end
assignin('base', 'precision_str', precision_str);
assignin('base', 'precStrAftIFFT', precStrAftIFFT);

if dmtOfdm == 2
%fftLen = 32;
end
%set_param('Basic_DMT/Constant','OutDataTypeStr',precision)

%Rectangular QAM Modulator Data Type
%'outDtype' = 'double' or 'User-defined'
%'outFracLenMode'='User-defined'
%'outFracLen'=fracLen
%'outUDDataType'=precisionModu

%%%%SIMULINK-BLOCKS%%%%%

%Not possible to replace these with variables in the simulink-constant
%blocks.
set_param('Basic_DMT/IFFTaPIS/Create_Frame_for_IFFT/OFDMorDMT/Frame_OFDM/Constant','OutDataTypeStr',precision_str)
set_param('Basic_DMT/IFFTaPIS/Create_Frame_for_IFFT/OFDMorDMT/Frame_DMT/Constant','OutDataTypeStr',precision_str)
set_param('Basic_DMT/AWGN/Yes_AWGN/Data_Type_Conversion','OutDataTypeStr',precStrAftIFFT)  

if radio_precision == 1 
    
    set_param('Basic_DMT/Modulation/Bit_Mapping_P1/256_QAM/Rect_QAM_Mod','outDtype',precision_str)
    set_param('Basic_DMT/Modulation/Bit_Mapping_P1/16_QAM/Rect_QAM_Mod','outDtype',precision_str)
    set_param('Basic_DMT/Modulation/Bit_Mapping_P2/256_QAM/Rect_QAM_Mod','outDtype',precision_str)
    set_param('Basic_DMT/Modulation/Bit_Mapping_P2/16_QAM/Rect_QAM_Mod','outDtype',precision_str)    
    set_param('Basic_DMT/Modulation/Bit_Mapping_P3/256_QAM/Rect_QAM_Mod','outDtype',precision_str)
    set_param('Basic_DMT/Modulation/Bit_Mapping_P3/16_QAM/Rect_QAM_Mod','outDtype',precision_str)
    set_param('Basic_DMT/Modulation/Bit_Mapping_P4/256_QAM/Rect_QAM_Mod','outDtype',precision_str)
    set_param('Basic_DMT/Modulation/Bit_Mapping_P4/16_QAM/Rect_QAM_Mod','outDtype',precision_str) 
    set_param('Basic_DMT/Modulation/Bit_Mapping_P5/256_QAM/Rect_QAM_Mod','outDtype',precision_str)
    set_param('Basic_DMT/Modulation/Bit_Mapping_P5/16_QAM/Rect_QAM_Mod','outDtype',precision_str)
    set_param('Basic_DMT/Modulation/Bit_Mapping_P6/256_QAM/Rect_QAM_Mod','outDtype',precision_str)
    set_param('Basic_DMT/Modulation/Bit_Mapping_P6/16_QAM/Rect_QAM_Mod','outDtype',precision_str)    
    set_param('Basic_DMT/Modulation/Bit_Mapping_P7/256_QAM/Rect_QAM_Mod','outDtype',precision_str)
    set_param('Basic_DMT/Modulation/Bit_Mapping_P7/16_QAM/Rect_QAM_Mod','outDtype',precision_str)
    set_param('Basic_DMT/Modulation/Bit_Mapping_P8/256_QAM/Rect_QAM_Mod','outDtype',precision_str)
    set_param('Basic_DMT/Modulation/Bit_Mapping_P8/16_QAM/Rect_QAM_Mod','outDtype',precision_str)    
    set_param('Basic_DMT/Modulation/Bit_Mapping_P9/256_QAM/Rect_QAM_Mod','outDtype',precision_str)
    set_param('Basic_DMT/Modulation/Bit_Mapping_P9/16_QAM/Rect_QAM_Mod','outDtype',precision_str)
    set_param('Basic_DMT/Modulation/Bit_Mapping_P10/256_QAM/Rect_QAM_Mod','outDtype',precision_str)
    set_param('Basic_DMT/Modulation/Bit_Mapping_P10/16_QAM/Rect_QAM_Mod','outDtype',precision_str)    
    set_param('Basic_DMT/Modulation/Bit_Mapping_P11/256_QAM/Rect_QAM_Mod','outDtype',precision_str)
    set_param('Basic_DMT/Modulation/Bit_Mapping_P11/16_QAM/Rect_QAM_Mod','outDtype',precision_str)
    set_param('Basic_DMT/Modulation/Bit_Mapping_P12/256_QAM/Rect_QAM_Mod','outDtype',precision_str)
    set_param('Basic_DMT/Modulation/Bit_Mapping_P12/16_QAM/Rect_QAM_Mod','outDtype',precision_str)    
    set_param('Basic_DMT/Modulation/Bit_Mapping_P13/256_QAM/Rect_QAM_Mod','outDtype',precision_str)
    set_param('Basic_DMT/Modulation/Bit_Mapping_P13/16_QAM/Rect_QAM_Mod','outDtype',precision_str)
    set_param('Basic_DMT/Modulation/Bit_Mapping_P14/256_QAM/Rect_QAM_Mod','outDtype',precision_str)
    set_param('Basic_DMT/Modulation/Bit_Mapping_P14/16_QAM/Rect_QAM_Mod','outDtype',precision_str)
    
    set_param('Basic_DMT/IFFTaPIS/IFFT','outputDataTypeStr','Inherit: Inherit via internal rule')
    
    set_param('Basic_DMT/SIPaFFT/FFT/FFT_OFDM/FFT','outputDataTypeStr','Inherit: Inherit via internal rule')
    set_param('Basic_DMT/SIPaFFT/FFT/FFT_DMT/FFT','outputDataTypeStr','Inherit: Inherit via internal rule')
else
    set_param('Basic_DMT/Modulation/Bit_Mapping_P1/256_QAM/Rect_QAM_Mod','outDtype','User-defined','outFracLenMode','User-defined','outFracLen',num2str(fracLen),'outUDDataType',precisionModu)
    set_param('Basic_DMT/Modulation/Bit_Mapping_P1/16_QAM/Rect_QAM_Mod','outDtype','User-defined','outFracLenMode','User-defined','outFracLen',num2str(fracLen),'outUDDataType',precisionModu)
    set_param('Basic_DMT/Modulation/Bit_Mapping_P2/256_QAM/Rect_QAM_Mod','outDtype','User-defined','outFracLenMode','User-defined','outFracLen',num2str(fracLen),'outUDDataType',precisionModu)
    set_param('Basic_DMT/Modulation/Bit_Mapping_P2/16_QAM/Rect_QAM_Mod','outDtype','User-defined','outFracLenMode','User-defined','outFracLen',num2str(fracLen),'outUDDataType',precisionModu)
    set_param('Basic_DMT/Modulation/Bit_Mapping_P3/256_QAM/Rect_QAM_Mod','outDtype','User-defined','outFracLenMode','User-defined','outFracLen',num2str(fracLen),'outUDDataType',precisionModu)
    set_param('Basic_DMT/Modulation/Bit_Mapping_P3/16_QAM/Rect_QAM_Mod','outDtype','User-defined','outFracLenMode','User-defined','outFracLen',num2str(fracLen),'outUDDataType',precisionModu)
    set_param('Basic_DMT/Modulation/Bit_Mapping_P4/256_QAM/Rect_QAM_Mod','outDtype','User-defined','outFracLenMode','User-defined','outFracLen',num2str(fracLen),'outUDDataType',precisionModu)
    set_param('Basic_DMT/Modulation/Bit_Mapping_P4/16_QAM/Rect_QAM_Mod','outDtype','User-defined','outFracLenMode','User-defined','outFracLen',num2str(fracLen),'outUDDataType',precisionModu)
    set_param('Basic_DMT/Modulation/Bit_Mapping_P5/256_QAM/Rect_QAM_Mod','outDtype','User-defined','outFracLenMode','User-defined','outFracLen',num2str(fracLen),'outUDDataType',precisionModu)
    set_param('Basic_DMT/Modulation/Bit_Mapping_P5/16_QAM/Rect_QAM_Mod','outDtype','User-defined','outFracLenMode','User-defined','outFracLen',num2str(fracLen),'outUDDataType',precisionModu)
    set_param('Basic_DMT/Modulation/Bit_Mapping_P6/256_QAM/Rect_QAM_Mod','outDtype','User-defined','outFracLenMode','User-defined','outFracLen',num2str(fracLen),'outUDDataType',precisionModu)
    set_param('Basic_DMT/Modulation/Bit_Mapping_P6/16_QAM/Rect_QAM_Mod','outDtype','User-defined','outFracLenMode','User-defined','outFracLen',num2str(fracLen),'outUDDataType',precisionModu)
    set_param('Basic_DMT/Modulation/Bit_Mapping_P7/256_QAM/Rect_QAM_Mod','outDtype','User-defined','outFracLenMode','User-defined','outFracLen',num2str(fracLen),'outUDDataType',precisionModu)
    set_param('Basic_DMT/Modulation/Bit_Mapping_P7/16_QAM/Rect_QAM_Mod','outDtype','User-defined','outFracLenMode','User-defined','outFracLen',num2str(fracLen),'outUDDataType',precisionModu)
    set_param('Basic_DMT/Modulation/Bit_Mapping_P8/256_QAM/Rect_QAM_Mod','outDtype','User-defined','outFracLenMode','User-defined','outFracLen',num2str(fracLen),'outUDDataType',precisionModu)
    set_param('Basic_DMT/Modulation/Bit_Mapping_P8/16_QAM/Rect_QAM_Mod','outDtype','User-defined','outFracLenMode','User-defined','outFracLen',num2str(fracLen),'outUDDataType',precisionModu)
    set_param('Basic_DMT/Modulation/Bit_Mapping_P9/256_QAM/Rect_QAM_Mod','outDtype','User-defined','outFracLenMode','User-defined','outFracLen',num2str(fracLen),'outUDDataType',precisionModu)
    set_param('Basic_DMT/Modulation/Bit_Mapping_P9/16_QAM/Rect_QAM_Mod','outDtype','User-defined','outFracLenMode','User-defined','outFracLen',num2str(fracLen),'outUDDataType',precisionModu)
    set_param('Basic_DMT/Modulation/Bit_Mapping_P10/256_QAM/Rect_QAM_Mod','outDtype','User-defined','outFracLenMode','User-defined','outFracLen',num2str(fracLen),'outUDDataType',precisionModu)
    set_param('Basic_DMT/Modulation/Bit_Mapping_P10/16_QAM/Rect_QAM_Mod','outDtype','User-defined','outFracLenMode','User-defined','outFracLen',num2str(fracLen),'outUDDataType',precisionModu)
    set_param('Basic_DMT/Modulation/Bit_Mapping_P11/256_QAM/Rect_QAM_Mod','outDtype','User-defined','outFracLenMode','User-defined','outFracLen',num2str(fracLen),'outUDDataType',precisionModu)
    set_param('Basic_DMT/Modulation/Bit_Mapping_P11/16_QAM/Rect_QAM_Mod','outDtype','User-defined','outFracLenMode','User-defined','outFracLen',num2str(fracLen),'outUDDataType',precisionModu)
    set_param('Basic_DMT/Modulation/Bit_Mapping_P12/256_QAM/Rect_QAM_Mod','outDtype','User-defined','outFracLenMode','User-defined','outFracLen',num2str(fracLen),'outUDDataType',precisionModu)
    set_param('Basic_DMT/Modulation/Bit_Mapping_P12/16_QAM/Rect_QAM_Mod','outDtype','User-defined','outFracLenMode','User-defined','outFracLen',num2str(fracLen),'outUDDataType',precisionModu)
    set_param('Basic_DMT/Modulation/Bit_Mapping_P13/256_QAM/Rect_QAM_Mod','outDtype','User-defined','outFracLenMode','User-defined','outFracLen',num2str(fracLen),'outUDDataType',precisionModu)
    set_param('Basic_DMT/Modulation/Bit_Mapping_P13/16_QAM/Rect_QAM_Mod','outDtype','User-defined','outFracLenMode','User-defined','outFracLen',num2str(fracLen),'outUDDataType',precisionModu)
    set_param('Basic_DMT/Modulation/Bit_Mapping_P14/256_QAM/Rect_QAM_Mod','outDtype','User-defined','outFracLenMode','User-defined','outFracLen',num2str(fracLen),'outUDDataType',precisionModu)
    set_param('Basic_DMT/Modulation/Bit_Mapping_P14/16_QAM/Rect_QAM_Mod','outDtype','User-defined','outFracLenMode','User-defined','outFracLen',num2str(fracLen),'outUDDataType',precisionModu)
  
    set_param('Basic_DMT/IFFTaPIS/IFFT','outputDataTypeStr',strcat('fixdt(1,' , num2str(bitCount+log2(fftLen)+1) , ',' , num2str(fracLen) , ')'))
    set_param('Basic_DMT/SIPaFFT/FFT/FFT_OFDM/FFT','outputDataTypeStr',strcat('fixdt(1,' , num2str(bitCount+(log2(fftLen)+1)*2) , ',' , num2str(fracLen) , ')'))
    set_param('Basic_DMT/SIPaFFT/FFT/FFT_DMT/FFT','outputDataTypeStr',strcat('fixdt(1,' , num2str(bitCount+(log2(fftLen)+1)*2) , ',' , num2str(fracLen) , ')'))
end

%channel filter coefficients
%TP zweiter ordnung, Fenstermethode, rect-windows, fc=5MHz, Fs=14.286MHz
 %a0=0.21194908595403703;
% a1=0.576101828091926;
% a2=a0;

%channel filter coefficients
%TP zweiter ordnung, Fenstermethode, rect-windows, fc=5MHz, Fs=17.8MHz
%  a0=0.26324574007976659;
%  a1=0.47350851984046677;
%  a2=a0;


%channel filter coefficients
%TP (triangular) mit nur 7dB D�mpfung, geht auch ohne equalizer
a0=0.14442723509625877;
a1=0.71114552980748247;
a2=a0;

%channel filter coefficients
%lahmer TP mit nur 3dB D�mpfung, geht auch ohne equalizer
%  a0=0.04100388;
%   a1=0.9179922382;
%  a2=a0;
assignin('base', 'a0', a0);
assignin('base', 'a1', a1);
assignin('base', 'a2', a2);

%equalizer coefficients

%h=[a0; a1; a2; zeros(13,1) ];
h=[a0; a1; a2; zeros(17857,1) ];
%h=[a0; a1; a2; zeros(32-3,1) ];
p=fft(h);
%p=real(g)+1+1i*imag(g);
e(1:8)=p(1:893:8*893);
e(9:16)=p(13*893:893:20*893);

eCalc=e;
assignin('base', 'p', p);
assignin('base', 'eCalc', eCalc);
%e=e1(1:893:17857*2);
%e=e1(1:16);
%e=ones(16,1);
% 


e1=e(1);
e2=e(2);
e3=e(3);
e4=e(4);
e5=e(5);
%e5=483.3333e-003 - 16.6667e-003i;
e6=e(6);
e7=e(7);
e8=e(8);
e9=e(9);
e10=e(10);
e11=e(11);
e12=e(12);
e13=e(13);
e14=e(14);
e15=e(15);
e16=e(16);


%lahmer TP mit nur 3dB D�mpfung, geht auch ohne equalizer
% e9=0.8719;
% e10=0.8801+i*0.01569;
% e11=0.889+i*0.02899;
% e12=0.9023+i*0.03788;
% e13=0.918+i*0.041;
% e14=0.9337+i*0.03788;
% e15=0.947+i*0.02899;
% e16=0.9559+i*0.01569;
% e1=0.9641;
% e2=0.9559-i*0.01569;
% e3=0.947-i*0.02899;
% e4=0.9337-i*0.03788;
% e5=0.918-i*0.041;
% e6=0.9023-i*0.03788;
% e7=0.889-i*0.02899;
% e8=0.8801-i*0.01569;


%TP zweiter Ordnung
% e9=0.1774;
% e10=0.2303+i*0.1007;
% e11=0.2874+i*0.1861;
% e12=0.3728+i*0.2432;
% e13=0.4735+i*0.2632;
% e14=0.5742+i*0.2432;
% e15=0.6597+i*0.1861;
% e16=0.7167+i*0.1007;
% e1=0.7697;
% e2=0.7167-i*0.1007;
% e3=0.6597-i*0.1861;
% e4=0.5742-i*0.2432;
% e5=0.4735-i*0.2632;
% e6=0.3728-i*0.2432;
% e7=0.2874-i*0.1861;
% e8=0.2303-i*0.1007;

%TP triangular 7dB
e9=0.1444;
e10=0.5777+i*0.05527;
e11=0.609+i*0.1021;
e12=0.6559+i*0.1334;
e13=0.7111+i*0.1444;
e14=0.7664+i*0.1334;
e15=0.8133+i*0.1021;
e16=0.8446+i*0.05527;
e1=-0.1444;
e2=0.8446-i*0.05527;
e3=0.8133-i*0.1021;
e4=0.7664-i*0.1334;
e5=0.7111-i*0.1444;
e6=0.6559-i*0.1334;
e7=0.609-i*0.1021;
e8=0.5777-i*0.05527;

elook=[e1 e2 e3 e4 e5 e6 e7 e8 e9 e10 e11 e12 e13 e14 e15 e16];
assignin('base', 'elook', elook);
assignin('base', 'e', e);
assignin('base', 'e1', e1);
assignin('base', 'e2', e2);
assignin('base', 'e3', e3);
assignin('base', 'e4', e4);
assignin('base', 'e5', e5);
assignin('base', 'e6', e6);
assignin('base', 'e7', e7);
assignin('base', 'e8', e8);
assignin('base', 'e9', e9);
assignin('base', 'e10', e10);
assignin('base', 'e11', e11);
assignin('base', 'e12', e12);
assignin('base', 'e13', e13);
assignin('base', 'e14', e14);
assignin('base', 'e15', e15);
assignin('base', 'e16', e16);
%%%%SYSGEN-BLOCKS%%%%%

%Prepare coefficients for sysgen
e1s=1/e1;
e2s=1/e2;
e3s=1/e3;
e4s=1/e4;
e5s=1/e5;
e6s=1/e6;
e7s=1/e7;
e8s=1/e8;
e9s=1/e9;
e10s=1/e10;
e11s=1/e11;
e12s=1/e12;
e13s=1/e13;
e14s=1/e14;
e15s=1/e15;
e16s=1/e16;

assignin('base', 'e1_re', real(e1s));
assignin('base', 'e1_im', imag(e1s));
assignin('base', 'e2_re', real(e2s));
assignin('base', 'e2_im', imag(e2s));
assignin('base', 'e3_re', real(e3s));
assignin('base', 'e3_im', imag(e3s));
assignin('base', 'e4_re', real(e4s));
assignin('base', 'e4_im', imag(e4s));
assignin('base', 'e5_re', real(e5s));
assignin('base', 'e5_im', imag(e5s));
assignin('base', 'e6_re', real(e6s));
assignin('base', 'e6_im', imag(e6s));
assignin('base', 'e7_re', real(e7s));
assignin('base', 'e7_im', imag(e7s));
assignin('base', 'e8_re', real(e8s));
assignin('base', 'e8_im', imag(e8s));
assignin('base', 'e9_re', real(e9s));
assignin('base', 'e9_im', imag(e9s));
assignin('base', 'e10_re', real(e10s));
assignin('base', 'e10_im', imag(e10s));
assignin('base', 'e11_re', real(e11s));
assignin('base', 'e11_im', imag(e11s));
assignin('base', 'e12_re', real(e12s));
assignin('base', 'e12_im', imag(e12s));
assignin('base', 'e13_re', real(e13s));
assignin('base', 'e13_im', imag(e13s));
assignin('base', 'e14_re', real(e14s));
assignin('base', 'e14_im', imag(e14s));
assignin('base', 'e15_re', real(e15s));
assignin('base', 'e15_im', imag(e15s));
assignin('base', 'e16_re', real(e16s));
assignin('base', 'e16_im', imag(e16s));
%set_param('Basic_DMT/Sysgen_Modulation/16-QAM/Constant1','arith_type','Signed (2''s comp)','bin_pt',fracLen,'n_bits',bitCount)
%set_param('Basic_DMT/Sysgen_Modulation/16-QAM/Constant2','arith_type','Signed (2''s comp)','bin_pt',fracLen,'n_bits',bitCount)
%set_param('Basic_DMT/Sysgen_Modulation/16-QAM/Constant3','arith_type','Signed (2''s comp)','bin_pt',fracLen,'n_bits',bitCount)
%set_param('Basic_DMT/Sysgen_Modulation/16-QAM/Constant4','arith_type','Signed (2''s comp)','bin_pt',fracLen,'n_bits',bitCount)
%set_param('Basic_DMT/Sysgen_Modulation/16-QAM/Constant5','arith_type','Signed (2''s comp)','bin_pt',fracLen,'n_bits',bitCount)
%set_param('Basic_DMT/Sysgen_Modulation/16-QAM/Constant6','arith_type','Signed (2''s comp)','bin_pt',fracLen,'n_bits',bitCount)
%set_param('Basic_DMT/Sysgen_Modulation/16-QAM/Constant7','arith_type','Signed (2''s comp)','bin_pt',fracLen,'n_bits',bitCount)
%set_param('Basic_DMT/Sysgen_Modulation/16-QAM/Constant8','arith_type','Signed (2''s comp)','bin_pt',fracLen,'n_bits',bitCount)

%set_param('Basic_DMT/Sysgen_Modulation/16-QAM1/Constant1','arith_type','Signed (2''s comp)','bin_pt',fracLen,'n_bits',bitCount)
%set_param('Basic_DMT/Sysgen_Modulation/16-QAM1/Constant2','arith_type','Signed (2''s comp)','bin_pt',fracLen,'n_bits',bitCount)
%set_param('Basic_DMT/Sysgen_Modulation/16-QAM1/Constant3','arith_type','Signed (2''s comp)','bin_pt',fracLen,'n_bits',bitCount)
%set_param('Basic_DMT/Sysgen_Modulation/16-QAM1/Constant4','arith_type','Signed (2''s comp)','bin_pt',fracLen,'n_bits',bitCount)
%set_param('Basic_DMT/Sysgen_Modulation/16-QAM1/Constant5','arith_type','Signed (2''s comp)','bin_pt',fracLen,'n_bits',bitCount)
%set_param('Basic_DMT/Sysgen_Modulation/16-QAM1/Constant6','arith_type','Signed (2''s comp)','bin_pt',fracLen,'n_bits',bitCount)
%set_param('Basic_DMT/Sysgen_Modulation/16-QAM1/Constant7','arith_type','Signed (2''s comp)','bin_pt',fracLen,'n_bits',bitCount)
%set_param('Basic_DMT/Sysgen_Modulation/16-QAM1/Constant8','arith_type','Signed (2''s comp)','bin_pt',fracLen,'n_bits',bitCount)

%set_param('Basic_DMT/Sysgen_IFFTaPIS/Constant','arith_type','Signed (2''s comp)','bin_pt',fracLen,'n_bits',bitCount)
%set_param('Basic_DMT/Sysgen_IFFTaPIS/Reinterpret','bin_pt',num2str(str2double(bitCount)-1))
%set_param('Basic_DMT/Sysgen_IFFTaPIS/Reinterpret1','bin_pt',num2str(str2double(bitCount)-1))
%set_param('Basic_DMT/Sysgen_IFFTaPIS/Reinterpret2','bin_pt',fracLen)
%set_param('Basic_DMT/Sysgen_IFFTaPIS/Reinterpret3','bin_pt',fracLen)

%set_param('Basic_DMT/Sysgen_SIPaFFT/Reinterpret','bin_pt',num2str(str2double(bitCount)-1+log2(fftLen)+1))
%set_param('Basic_DMT/Sysgen_SIPaFFT/Reinterpret1','bin_pt',num2str(str2double(bitCount)-1+log2(fftLen)+1))
%set_param('Basic_DMT/Sysgen_SIPaFFT/Reinterpret2','bin_pt',fracLen)
%set_param('Basic_DMT/Sysgen_SIPaFFT/Reinterpret3','bin_pt',fracLen)
%set_param('Basic_DMT/Sysgen_SIPaFFT/Reinterpret4','bin_pt',fracLen)
%set_param('Basic_DMT/Sysgen_SIPaFFT/Reinterpret5','bin_pt',fracLen)
%set_param('Basic_DMT/Sysgen_SIPaFFT/Reinterpret6','bin_pt',fracLen)
%set_param('Basic_DMT/Sysgen_SIPaFFT/Reinterpret7','bin_pt',fracLen)
%set_param('Basic_DMT/Sysgen_SIPaFFT/Reinterpret8','bin_pt',fracLen)
%set_param('Basic_DMT/Sysgen_SIPaFFT/Reinterpret9','bin_pt',fracLen)


%get_param(gcb,'arith_type')
%get_param(gcb,'bin_pt')
%get_param(gcb,'n_bits')
%Outputs all block paths
%BlockPaths = find_system('Basic_DMT','Type','Block')

%set_param('Basic_DMT/Modulation/Bit-Mapping-P1/256-QAM/Rectangular-QAM-Modulator-Baseband1','OutDataTypeStr',precision)
%set_param(Basic_DMT,'SimulationCommand','Update')