%initScript.m
%This script is used to initliaze the 'Basic_DMT' model. It is run after
%opening the model and after clicking the 'OK' button of the 'Edit Model
%Parameters' block.

format shortEng

%Define the fixed-point arithmetic used by the simulink blocks
fiObject= fimath('RoundingMethod', 'Nearest', ...
                'OverflowAction', 'Saturate', ...
                'ProductMode', 'SpecifyPrecision', ...
                'ProductWordLength', bitCount, ...
                'ProductFractionLength', fracLen, ...
                'SumMode', 'SpecifyPrecision', ...
                'SumWordLength', bitCount, ...
                'SumFractionLength', fracLen, ...
                'CastBeforeSum', true);
assignin('base', 'fiObject', fiObject);

fiObjectAftIFFT= fimath('RoundingMethod', 'Nearest', ...
                'OverflowAction', 'Saturate', ...
                'ProductMode', 'SpecifyPrecision', ...
                'ProductWordLength', bitCount, ...
                'ProductFractionLength', fracLen, ...
                'SumMode', 'SpecifyPrecision', ...
                'SumWordLength', bitCount, ...
                'SumFractionLength', fracLen, ...
                'CastBeforeSum', true);
assignin('base', 'fiObjectAftIFFT', fiObjectAftIFFT);

%System Period for Simulink blocks
SystemPeriod = 4e-9;
%System Period for System Generator blocks
sysgenSystemPeriod=4e-9; 
assignin('base', 'sysgenSystemPeriod', sysgenSystemPeriod);
assignin('base', 'SystemPeriod', SystemPeriod);
fftLen = 16;%16
K=16; %Modulation alphabet depth
M=log2(K);
assignin('base', 'fftLen', fftLen);
assignin('base', 'M', M);
fftLenDMT = 2*fftLen;
assignin('base', 'fftLenDMT', fftLenDMT);
usedSubCar=14;
bitPerSymb=M;


%Set to zero for not used carriers
u1=0;
u2=1;
u3=1;
u4=1;
u5=1;
u6=1;
u7=1;
u8=1;
u9=0;
u10=1;
u11=1;
u12=1;
u13=1;
u14=1;
u15=1;
u16=1;
assignin('base', 'u1', u1);
assignin('base', 'u2', u2);
assignin('base', 'u3', u3);
assignin('base', 'u4', u4);
assignin('base', 'u5', u5);
assignin('base', 'u6', u6);
assignin('base', 'u7', u7);
assignin('base', 'u8', u8);
assignin('base', 'u9', u9);
assignin('base', 'u10', u10);
assignin('base', 'u11', u11);
assignin('base', 'u12', u12);
assignin('base', 'u13', u13);
assignin('base', 'u14', u14);
assignin('base', 'u15', u15);
assignin('base', 'u16', u16);

assignin('base', 'equalizer', equalizer);

%GI length
GI_Len = 4;
GI_LenDMT=GI_Len*2;    
assignin('base', 'GI_Len', GI_Len);
assignin('base', 'GI_LenDMT', GI_LenDMT);

if dmtOfdm == 1 %% To create blocks which are not dependent on variant subsystems.
    GI_Active = GI_Len;
    fftLenActive = fftLen;
    freqDivDMT = 1;
else
    GI_Active = GI_LenDMT;
    fftLenActive = fftLenDMT;
    freqDivDMT = 2;%To achieve the half processing frequency in DMT mode
end
assignin('base', 'GI_Active', GI_Active);
assignin('base', 'fftLenActive', fftLenActive);

%Used in Mcode blocks to as pre calculated values
OFDMFrameSmpCntAct = GI_Active + fftLenActive;
assignin('base', 'OFDMFrameSmpCntAct', OFDMFrameSmpCntAct);
assignin('base', 'freqDivDMT', freqDivDMT);

beta = fftLen/(fftLen+GI_Len); 
assignin('base', 'beta', beta);
assignin('base', 'usedSubCar', usedSubCar);
assignin('base', 'bitPerSymb', bitPerSymb);
assignin('base', 'bitCount',bitCount);
assignin('base', 'fracLen',fracLen);
SampleTime = 20e-9;
assignin('base', 'Ts', SampleTime);
assignin('base', 'Tb', BitTime);

%Divider for the Input FIFO. Determines how many samples are not sampled 
%until the next valid sample arrives. Calculated here, because it has to
%be calculated only once. 
freqDivSubcAlloc = BitTime/SystemPeriod;
assignin('base', 'freqDivSubcAlloc', freqDivSubcAlloc);

%How many bits are in one OFDM frame. Used in subc_alloc FSM
bitsPerFrame=usedSubCar*bitPerSymb;
assignin('base', 'bitsPerFrame', bitsPerFrame);
%Samplerate on Channel
Tchan=bitPerSymb*usedSubCar/fftLenActive*(BitTime*beta);
%Calc factor for downsampling before channel
chanDownFact=Tchan/SystemPeriod;
assignin('base', 'Tchan', Tchan);
assignin('base', 'chanDownFact', chanDownFact);
assignin('base', 'sysgenSystemPeriod', sysgenSystemPeriod);
modu_mode=0;%removed from GUI
assignin('base', 'modu_mode', modu_mode);
assignin('base', 'dmtOfdm', dmtOfdm);
assignin('base', 'AWGN', AWGN);
assignin('base', 'channel', channel);
grpDelayChannelFilt = 1;
assignin('base', 'grpDelayChannelFilt', grpDelayChannelFilt);

SNRdb = SNR_AWGN;
P_sym=10;%W Avg Power per Symbol
assignin('base', 'P_sym', P_sym);
assignin('base', 'SNRdb', SNRdb);
%Calculating signal power for AWGN channel model.
sigPowAWGN = P_sym*(fftLen-2)/fftLen*fftLenActive/(fftLenActive+GI_Active)*fftLenActive*2;

assignin('base', 'sigPowAWGN', sigPowAWGN);

%radio button for precision
assignin('base', 'radio_precision', str2double(radio_precision));
%To assign the number of bits to the blocks behind the IFFT, a different
%variable us used. this shall allow to change the number of bits
%independently if necessary
if radio_precision == 1
    precision_str = 'double';
    precStrAftIFFT = 'double';
else
    precision_str = strcat('fixdt(1,' , num2str(bitCount) , ',' , num2str(fracLen) , ')');
    precStrAftIFFT =strcat('fixdt(1,' , num2str(bitCount) , ',' , num2str(fracLen) , ')');
    precisionModu = strcat('sfix(',num2str(bitCount),')');
end
assignin('base', 'precision_str', precision_str);
assignin('base', 'precStrAftIFFT', precStrAftIFFT);
bitCountAftIFFT = bitCount;
assignin('base', 'bitCountAftIFFT', bitCountAftIFFT);
bitCountAftFFTRec = bitCount;
assignin('base', 'bitCountAftFFTRec', bitCountAftFFTRec);

%%%%SIMULINK-BLOCKS%%%%%

set_param('Basic_DMT/IFFTaPIS/Create_Frame_for_IFFT/OFDMorDMT/Frame_DMT/Constant','OutDataTypeStr',precision_str)
%set_param('Basic_DMT/AWGN/Yes_AWGN/Data_Type_Conversion','OutDataTypeStr',precStrAftIFFT)  
set_param('Basic_DMT/AWGN/Yes_AWGN/Data Type Conversion1','OutDataTypeStr',precStrAftIFFT)

set_param('Basic_DMT/AWGN1/Yes_AWGN/Data Type Conversion1','OutDataTypeStr',precStrAftIFFT)
set_param('Basic_DMT/SIPaFFT/Index Vector','OutDataTypeStr',precStrAftIFFT)
set_param('Basic_DMT/IFFTaPIS/Data Type Conversion','OutDataTypeStr',precision_str)

%%% CREATE FRAME OFDM

set_param('Basic_DMT/IFFTaPIS/Create_Frame_for_IFFT/OFDMorDMT/Frame_OFDM/MATLAB Function/o1','OutDataTypeStr',precision_str) 
set_param('Basic_DMT/IFFTaPIS/Create_Frame_for_IFFT/OFDMorDMT/Frame_OFDM/MATLAB Function/o2','OutDataTypeStr',precision_str) 
set_param('Basic_DMT/IFFTaPIS/Create_Frame_for_IFFT/OFDMorDMT/Frame_OFDM/MATLAB Function/o3','OutDataTypeStr',precision_str) 
set_param('Basic_DMT/IFFTaPIS/Create_Frame_for_IFFT/OFDMorDMT/Frame_OFDM/MATLAB Function/o4','OutDataTypeStr',precision_str) 
set_param('Basic_DMT/IFFTaPIS/Create_Frame_for_IFFT/OFDMorDMT/Frame_OFDM/MATLAB Function/o5','OutDataTypeStr',precision_str) 
set_param('Basic_DMT/IFFTaPIS/Create_Frame_for_IFFT/OFDMorDMT/Frame_OFDM/MATLAB Function/o6','OutDataTypeStr',precision_str) 
set_param('Basic_DMT/IFFTaPIS/Create_Frame_for_IFFT/OFDMorDMT/Frame_OFDM/MATLAB Function/o7','OutDataTypeStr',precision_str) 
set_param('Basic_DMT/IFFTaPIS/Create_Frame_for_IFFT/OFDMorDMT/Frame_OFDM/MATLAB Function/o8','OutDataTypeStr',precision_str) 
set_param('Basic_DMT/IFFTaPIS/Create_Frame_for_IFFT/OFDMorDMT/Frame_OFDM/MATLAB Function/o9','OutDataTypeStr',precision_str) 
set_param('Basic_DMT/IFFTaPIS/Create_Frame_for_IFFT/OFDMorDMT/Frame_OFDM/MATLAB Function/o10','OutDataTypeStr',precision_str) 
set_param('Basic_DMT/IFFTaPIS/Create_Frame_for_IFFT/OFDMorDMT/Frame_OFDM/MATLAB Function/o11','OutDataTypeStr',precision_str) 
set_param('Basic_DMT/IFFTaPIS/Create_Frame_for_IFFT/OFDMorDMT/Frame_OFDM/MATLAB Function/o12','OutDataTypeStr',precision_str) 
set_param('Basic_DMT/IFFTaPIS/Create_Frame_for_IFFT/OFDMorDMT/Frame_OFDM/MATLAB Function/o13','OutDataTypeStr',precision_str) 
set_param('Basic_DMT/IFFTaPIS/Create_Frame_for_IFFT/OFDMorDMT/Frame_OFDM/MATLAB Function/o14','OutDataTypeStr',precision_str) 
set_param('Basic_DMT/IFFTaPIS/Create_Frame_for_IFFT/OFDMorDMT/Frame_OFDM/MATLAB Function/o15','OutDataTypeStr',precision_str) 
set_param('Basic_DMT/IFFTaPIS/Create_Frame_for_IFFT/OFDMorDMT/Frame_OFDM/MATLAB Function/o16','OutDataTypeStr',precision_str) 

%%% SET GI OFDM
set_param('Basic_DMT/IFFTaPIS/Guard_Interval/Set_GI_OFDM/Data Store Memory1','OutDataTypeStr',precStrAftIFFT) 

set_param('Basic_DMT/IFFTaPIS/Guard_Interval/Set_GI_OFDM/MATLAB Function/out','OutDataTypeStr',precStrAftIFFT)
set_param('Basic_DMT/IFFTaPIS/Guard_Interval/Set_GI_OFDM/MATLAB Function/inp','OutDataTypeStr',precStrAftIFFT) 
set_param('Basic_DMT/IFFTaPIS/Guard_Interval/Set_GI_OFDM/MATLAB Function/i1','OutDataTypeStr',precStrAftIFFT)
set_param('Basic_DMT/IFFTaPIS/Guard_Interval/Set_GI_OFDM/MATLAB Function/i2','OutDataTypeStr',precStrAftIFFT) 
set_param('Basic_DMT/IFFTaPIS/Guard_Interval/Set_GI_OFDM/MATLAB Function/i3','OutDataTypeStr',precStrAftIFFT) 
set_param('Basic_DMT/IFFTaPIS/Guard_Interval/Set_GI_OFDM/MATLAB Function/i4','OutDataTypeStr',precStrAftIFFT) 
set_param('Basic_DMT/IFFTaPIS/Guard_Interval/Set_GI_OFDM/MATLAB Function/i5','OutDataTypeStr',precStrAftIFFT) 
set_param('Basic_DMT/IFFTaPIS/Guard_Interval/Set_GI_OFDM/MATLAB Function/i6','OutDataTypeStr',precStrAftIFFT) 
set_param('Basic_DMT/IFFTaPIS/Guard_Interval/Set_GI_OFDM/MATLAB Function/i7','OutDataTypeStr',precStrAftIFFT) 
set_param('Basic_DMT/IFFTaPIS/Guard_Interval/Set_GI_OFDM/MATLAB Function/i8','OutDataTypeStr',precStrAftIFFT) 
set_param('Basic_DMT/IFFTaPIS/Guard_Interval/Set_GI_OFDM/MATLAB Function/i9','OutDataTypeStr',precStrAftIFFT) 
set_param('Basic_DMT/IFFTaPIS/Guard_Interval/Set_GI_OFDM/MATLAB Function/i10','OutDataTypeStr',precStrAftIFFT) 
set_param('Basic_DMT/IFFTaPIS/Guard_Interval/Set_GI_OFDM/MATLAB Function/i11','OutDataTypeStr',precStrAftIFFT) 
set_param('Basic_DMT/IFFTaPIS/Guard_Interval/Set_GI_OFDM/MATLAB Function/i12','OutDataTypeStr',precStrAftIFFT) 
set_param('Basic_DMT/IFFTaPIS/Guard_Interval/Set_GI_OFDM/MATLAB Function/i13','OutDataTypeStr',precStrAftIFFT) 
set_param('Basic_DMT/IFFTaPIS/Guard_Interval/Set_GI_OFDM/MATLAB Function/i14','OutDataTypeStr',precStrAftIFFT) 
set_param('Basic_DMT/IFFTaPIS/Guard_Interval/Set_GI_OFDM/MATLAB Function/i15','OutDataTypeStr',precStrAftIFFT) 
set_param('Basic_DMT/IFFTaPIS/Guard_Interval/Set_GI_OFDM/MATLAB Function/i16','OutDataTypeStr',precStrAftIFFT)
set_param('Basic_DMT/IFFTaPIS/Guard_Interval/Set_GI_OFDM/MATLAB Function/o1','OutDataTypeStr',precStrAftIFFT)
set_param('Basic_DMT/IFFTaPIS/Guard_Interval/Set_GI_OFDM/MATLAB Function/o2','OutDataTypeStr',precStrAftIFFT) 
set_param('Basic_DMT/IFFTaPIS/Guard_Interval/Set_GI_OFDM/MATLAB Function/o3','OutDataTypeStr',precStrAftIFFT) 
set_param('Basic_DMT/IFFTaPIS/Guard_Interval/Set_GI_OFDM/MATLAB Function/o4','OutDataTypeStr',precStrAftIFFT) 
set_param('Basic_DMT/IFFTaPIS/Guard_Interval/Set_GI_OFDM/MATLAB Function/o5','OutDataTypeStr',precStrAftIFFT) 
set_param('Basic_DMT/IFFTaPIS/Guard_Interval/Set_GI_OFDM/MATLAB Function/o6','OutDataTypeStr',precStrAftIFFT) 
set_param('Basic_DMT/IFFTaPIS/Guard_Interval/Set_GI_OFDM/MATLAB Function/o7','OutDataTypeStr',precStrAftIFFT) 
set_param('Basic_DMT/IFFTaPIS/Guard_Interval/Set_GI_OFDM/MATLAB Function/o8','OutDataTypeStr',precStrAftIFFT) 
set_param('Basic_DMT/IFFTaPIS/Guard_Interval/Set_GI_OFDM/MATLAB Function/o9','OutDataTypeStr',precStrAftIFFT) 
set_param('Basic_DMT/IFFTaPIS/Guard_Interval/Set_GI_OFDM/MATLAB Function/o10','OutDataTypeStr',precStrAftIFFT) 
set_param('Basic_DMT/IFFTaPIS/Guard_Interval/Set_GI_OFDM/MATLAB Function/o11','OutDataTypeStr',precStrAftIFFT) 
set_param('Basic_DMT/IFFTaPIS/Guard_Interval/Set_GI_OFDM/MATLAB Function/o12','OutDataTypeStr',precStrAftIFFT) 
set_param('Basic_DMT/IFFTaPIS/Guard_Interval/Set_GI_OFDM/MATLAB Function/o13','OutDataTypeStr',precStrAftIFFT) 
set_param('Basic_DMT/IFFTaPIS/Guard_Interval/Set_GI_OFDM/MATLAB Function/o14','OutDataTypeStr',precStrAftIFFT) 
set_param('Basic_DMT/IFFTaPIS/Guard_Interval/Set_GI_OFDM/MATLAB Function/o15','OutDataTypeStr',precStrAftIFFT) 
set_param('Basic_DMT/IFFTaPIS/Guard_Interval/Set_GI_OFDM/MATLAB Function/o16','OutDataTypeStr',precStrAftIFFT)

%%% SET GI DMT
set_param('Basic_DMT/IFFTaPIS/Guard_Interval/Set_GI_DMT/Data Store Memory1','OutDataTypeStr',precStrAftIFFT) 
set_param('Basic_DMT/IFFTaPIS/Guard_Interval/Set_GI_DMT/MATLAB Function/out','OutDataTypeStr',precStrAftIFFT)
set_param('Basic_DMT/IFFTaPIS/Guard_Interval/Set_GI_DMT/MATLAB Function/inp','OutDataTypeStr',precStrAftIFFT) 
set_param('Basic_DMT/IFFTaPIS/Guard_Interval/Set_GI_DMT/MATLAB Function/i1','OutDataTypeStr',precStrAftIFFT)
set_param('Basic_DMT/IFFTaPIS/Guard_Interval/Set_GI_DMT/MATLAB Function/i2','OutDataTypeStr',precStrAftIFFT) 
set_param('Basic_DMT/IFFTaPIS/Guard_Interval/Set_GI_DMT/MATLAB Function/i3','OutDataTypeStr',precStrAftIFFT) 
set_param('Basic_DMT/IFFTaPIS/Guard_Interval/Set_GI_DMT/MATLAB Function/i4','OutDataTypeStr',precStrAftIFFT) 
set_param('Basic_DMT/IFFTaPIS/Guard_Interval/Set_GI_DMT/MATLAB Function/i5','OutDataTypeStr',precStrAftIFFT) 
set_param('Basic_DMT/IFFTaPIS/Guard_Interval/Set_GI_DMT/MATLAB Function/i6','OutDataTypeStr',precStrAftIFFT) 
set_param('Basic_DMT/IFFTaPIS/Guard_Interval/Set_GI_DMT/MATLAB Function/i7','OutDataTypeStr',precStrAftIFFT) 
set_param('Basic_DMT/IFFTaPIS/Guard_Interval/Set_GI_DMT/MATLAB Function/i8','OutDataTypeStr',precStrAftIFFT) 
set_param('Basic_DMT/IFFTaPIS/Guard_Interval/Set_GI_DMT/MATLAB Function/i9','OutDataTypeStr',precStrAftIFFT) 
set_param('Basic_DMT/IFFTaPIS/Guard_Interval/Set_GI_DMT/MATLAB Function/i10','OutDataTypeStr',precStrAftIFFT) 
set_param('Basic_DMT/IFFTaPIS/Guard_Interval/Set_GI_DMT/MATLAB Function/i11','OutDataTypeStr',precStrAftIFFT) 
set_param('Basic_DMT/IFFTaPIS/Guard_Interval/Set_GI_DMT/MATLAB Function/i12','OutDataTypeStr',precStrAftIFFT) 
set_param('Basic_DMT/IFFTaPIS/Guard_Interval/Set_GI_DMT/MATLAB Function/i13','OutDataTypeStr',precStrAftIFFT) 
set_param('Basic_DMT/IFFTaPIS/Guard_Interval/Set_GI_DMT/MATLAB Function/i14','OutDataTypeStr',precStrAftIFFT) 
set_param('Basic_DMT/IFFTaPIS/Guard_Interval/Set_GI_DMT/MATLAB Function/i15','OutDataTypeStr',precStrAftIFFT) 
set_param('Basic_DMT/IFFTaPIS/Guard_Interval/Set_GI_DMT/MATLAB Function/i16','OutDataTypeStr',precStrAftIFFT)
set_param('Basic_DMT/IFFTaPIS/Guard_Interval/Set_GI_DMT/MATLAB Function/i17','OutDataTypeStr',precStrAftIFFT)
set_param('Basic_DMT/IFFTaPIS/Guard_Interval/Set_GI_DMT/MATLAB Function/i18','OutDataTypeStr',precStrAftIFFT) 
set_param('Basic_DMT/IFFTaPIS/Guard_Interval/Set_GI_DMT/MATLAB Function/i19','OutDataTypeStr',precStrAftIFFT) 
set_param('Basic_DMT/IFFTaPIS/Guard_Interval/Set_GI_DMT/MATLAB Function/i20','OutDataTypeStr',precStrAftIFFT) 
set_param('Basic_DMT/IFFTaPIS/Guard_Interval/Set_GI_DMT/MATLAB Function/i21','OutDataTypeStr',precStrAftIFFT) 
set_param('Basic_DMT/IFFTaPIS/Guard_Interval/Set_GI_DMT/MATLAB Function/i22','OutDataTypeStr',precStrAftIFFT) 
set_param('Basic_DMT/IFFTaPIS/Guard_Interval/Set_GI_DMT/MATLAB Function/i23','OutDataTypeStr',precStrAftIFFT) 
set_param('Basic_DMT/IFFTaPIS/Guard_Interval/Set_GI_DMT/MATLAB Function/i24','OutDataTypeStr',precStrAftIFFT) 
set_param('Basic_DMT/IFFTaPIS/Guard_Interval/Set_GI_DMT/MATLAB Function/i25','OutDataTypeStr',precStrAftIFFT) 
set_param('Basic_DMT/IFFTaPIS/Guard_Interval/Set_GI_DMT/MATLAB Function/i26','OutDataTypeStr',precStrAftIFFT) 
set_param('Basic_DMT/IFFTaPIS/Guard_Interval/Set_GI_DMT/MATLAB Function/i27','OutDataTypeStr',precStrAftIFFT) 
set_param('Basic_DMT/IFFTaPIS/Guard_Interval/Set_GI_DMT/MATLAB Function/i28','OutDataTypeStr',precStrAftIFFT) 
set_param('Basic_DMT/IFFTaPIS/Guard_Interval/Set_GI_DMT/MATLAB Function/i29','OutDataTypeStr',precStrAftIFFT) 
set_param('Basic_DMT/IFFTaPIS/Guard_Interval/Set_GI_DMT/MATLAB Function/i30','OutDataTypeStr',precStrAftIFFT) 
set_param('Basic_DMT/IFFTaPIS/Guard_Interval/Set_GI_DMT/MATLAB Function/i31','OutDataTypeStr',precStrAftIFFT) 
set_param('Basic_DMT/IFFTaPIS/Guard_Interval/Set_GI_DMT/MATLAB Function/i32','OutDataTypeStr',precStrAftIFFT)
set_param('Basic_DMT/IFFTaPIS/Guard_Interval/Set_GI_DMT/MATLAB Function/o1','OutDataTypeStr',precStrAftIFFT)
set_param('Basic_DMT/IFFTaPIS/Guard_Interval/Set_GI_DMT/MATLAB Function/o2','OutDataTypeStr',precStrAftIFFT) 
set_param('Basic_DMT/IFFTaPIS/Guard_Interval/Set_GI_DMT/MATLAB Function/o3','OutDataTypeStr',precStrAftIFFT) 
set_param('Basic_DMT/IFFTaPIS/Guard_Interval/Set_GI_DMT/MATLAB Function/o4','OutDataTypeStr',precStrAftIFFT) 
set_param('Basic_DMT/IFFTaPIS/Guard_Interval/Set_GI_DMT/MATLAB Function/o5','OutDataTypeStr',precStrAftIFFT) 
set_param('Basic_DMT/IFFTaPIS/Guard_Interval/Set_GI_DMT/MATLAB Function/o6','OutDataTypeStr',precStrAftIFFT) 
set_param('Basic_DMT/IFFTaPIS/Guard_Interval/Set_GI_DMT/MATLAB Function/o7','OutDataTypeStr',precStrAftIFFT) 
set_param('Basic_DMT/IFFTaPIS/Guard_Interval/Set_GI_DMT/MATLAB Function/o8','OutDataTypeStr',precStrAftIFFT) 
set_param('Basic_DMT/IFFTaPIS/Guard_Interval/Set_GI_DMT/MATLAB Function/o9','OutDataTypeStr',precStrAftIFFT) 
set_param('Basic_DMT/IFFTaPIS/Guard_Interval/Set_GI_DMT/MATLAB Function/o10','OutDataTypeStr',precStrAftIFFT) 
set_param('Basic_DMT/IFFTaPIS/Guard_Interval/Set_GI_DMT/MATLAB Function/o11','OutDataTypeStr',precStrAftIFFT) 
set_param('Basic_DMT/IFFTaPIS/Guard_Interval/Set_GI_DMT/MATLAB Function/o12','OutDataTypeStr',precStrAftIFFT) 
set_param('Basic_DMT/IFFTaPIS/Guard_Interval/Set_GI_DMT/MATLAB Function/o13','OutDataTypeStr',precStrAftIFFT) 
set_param('Basic_DMT/IFFTaPIS/Guard_Interval/Set_GI_DMT/MATLAB Function/o14','OutDataTypeStr',precStrAftIFFT) 
set_param('Basic_DMT/IFFTaPIS/Guard_Interval/Set_GI_DMT/MATLAB Function/o15','OutDataTypeStr',precStrAftIFFT) 
set_param('Basic_DMT/IFFTaPIS/Guard_Interval/Set_GI_DMT/MATLAB Function/o16','OutDataTypeStr',precStrAftIFFT)
set_param('Basic_DMT/IFFTaPIS/Guard_Interval/Set_GI_DMT/MATLAB Function/o17','OutDataTypeStr',precStrAftIFFT)
set_param('Basic_DMT/IFFTaPIS/Guard_Interval/Set_GI_DMT/MATLAB Function/o18','OutDataTypeStr',precStrAftIFFT) 
set_param('Basic_DMT/IFFTaPIS/Guard_Interval/Set_GI_DMT/MATLAB Function/o19','OutDataTypeStr',precStrAftIFFT) 
set_param('Basic_DMT/IFFTaPIS/Guard_Interval/Set_GI_DMT/MATLAB Function/o20','OutDataTypeStr',precStrAftIFFT) 
set_param('Basic_DMT/IFFTaPIS/Guard_Interval/Set_GI_DMT/MATLAB Function/o21','OutDataTypeStr',precStrAftIFFT) 
set_param('Basic_DMT/IFFTaPIS/Guard_Interval/Set_GI_DMT/MATLAB Function/o22','OutDataTypeStr',precStrAftIFFT) 
set_param('Basic_DMT/IFFTaPIS/Guard_Interval/Set_GI_DMT/MATLAB Function/o23','OutDataTypeStr',precStrAftIFFT) 
set_param('Basic_DMT/IFFTaPIS/Guard_Interval/Set_GI_DMT/MATLAB Function/o24','OutDataTypeStr',precStrAftIFFT) 
set_param('Basic_DMT/IFFTaPIS/Guard_Interval/Set_GI_DMT/MATLAB Function/o25','OutDataTypeStr',precStrAftIFFT) 
set_param('Basic_DMT/IFFTaPIS/Guard_Interval/Set_GI_DMT/MATLAB Function/o26','OutDataTypeStr',precStrAftIFFT) 
set_param('Basic_DMT/IFFTaPIS/Guard_Interval/Set_GI_DMT/MATLAB Function/o27','OutDataTypeStr',precStrAftIFFT) 
set_param('Basic_DMT/IFFTaPIS/Guard_Interval/Set_GI_DMT/MATLAB Function/o28','OutDataTypeStr',precStrAftIFFT) 
set_param('Basic_DMT/IFFTaPIS/Guard_Interval/Set_GI_DMT/MATLAB Function/o29','OutDataTypeStr',precStrAftIFFT) 
set_param('Basic_DMT/IFFTaPIS/Guard_Interval/Set_GI_DMT/MATLAB Function/o30','OutDataTypeStr',precStrAftIFFT) 
set_param('Basic_DMT/IFFTaPIS/Guard_Interval/Set_GI_DMT/MATLAB Function/o31','OutDataTypeStr',precStrAftIFFT) 
set_param('Basic_DMT/IFFTaPIS/Guard_Interval/Set_GI_DMT/MATLAB Function/o32','OutDataTypeStr',precStrAftIFFT)


%%%%%%%%%%%%%%%%%%%RECEIVER
%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%SIP
set_param('Basic_DMT/SIPaFFT/Constant2','OutDataTypeStr',precStrAftIFFT)
%%% REM_GI OFDM
set_param('Basic_DMT/SIPaFFT/Rem_GI/Data Store Memory3','OutDataTypeStr',precStrAftIFFT) 

set_param('Basic_DMT/SIPaFFT/Rem_GI/MATLAB Function/out','OutDataTypeStr',precStrAftIFFT)
set_param('Basic_DMT/SIPaFFT/Rem_GI/MATLAB Function/inp','OutDataTypeStr',precStrAftIFFT) 

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
    set_param('Basic_DMT/Modulation/Bit_Mapping_P15/256_QAM/Rect_QAM_Mod','outDtype',precision_str)
    set_param('Basic_DMT/Modulation/Bit_Mapping_P15/16_QAM/Rect_QAM_Mod','outDtype',precision_str)
    set_param('Basic_DMT/Modulation/Bit_Mapping_P16/256_QAM/Rect_QAM_Mod','outDtype',precision_str)
    set_param('Basic_DMT/Modulation/Bit_Mapping_P16/16_QAM/Rect_QAM_Mod','outDtype',precision_str) 
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
    set_param('Basic_DMT/Modulation/Bit_Mapping_P15/256_QAM/Rect_QAM_Mod','outDtype','User-defined','outFracLenMode','User-defined','outFracLen',num2str(fracLen),'outUDDataType',precisionModu)
    set_param('Basic_DMT/Modulation/Bit_Mapping_P15/16_QAM/Rect_QAM_Mod','outDtype','User-defined','outFracLenMode','User-defined','outFracLen',num2str(fracLen),'outUDDataType',precisionModu)
    set_param('Basic_DMT/Modulation/Bit_Mapping_P16/256_QAM/Rect_QAM_Mod','outDtype','User-defined','outFracLenMode','User-defined','outFracLen',num2str(fracLen),'outUDDataType',precisionModu)
    set_param('Basic_DMT/Modulation/Bit_Mapping_P16/16_QAM/Rect_QAM_Mod','outDtype','User-defined','outFracLenMode','User-defined','outFracLen',num2str(fracLen),'outUDDataType',precisionModu)
    set_param('Basic_DMT/IFFTaPIS/IFFT','outputDataTypeStr',strcat('fixdt(1,' , num2str(bitCount) , ',' , num2str(fracLen) , ')'))
    set_param('Basic_DMT/SIPaFFT/FFT/FFT_OFDM/FFT','outputDataTypeStr',strcat('fixdt(1,' , num2str(bitCount) , ',' , num2str(fracLen) , ')'))
    set_param('Basic_DMT/SIPaFFT/FFT/FFT_DMT/FFT','outputDataTypeStr',strcat('fixdt(1,' , num2str(bitCount) , ',' , num2str(fracLen) , ')'))
end

%channel filter coefficients
%LP, second order,Windowmethod, rect-windows, fc=5MHz, Fs=14.286MHz
  a0=0.21194908595403703;
 a1=0.576101828091926;
 a2=a0;

assignin('base', 'a0', a0);
assignin('base', 'a1', a1);
assignin('base', 'a2', a2);

%equalizer coefficients
h=[a0; a1; a2;];

H=fft(h,fftLenActive);%ofdm16 dmt32
if dmtOfdm == 2 %DMT active
    H = H(1:16);
end

e=H;
e1=e(1);
e2=e(2);
e3=e(3);
e4=e(4);
e5=e(5);
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

assignin('base', 'H', H);

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
%Outputs all block paths
%BlockPaths = find_system('Basic_DMT','Type','Block')
