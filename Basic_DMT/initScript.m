%initScript.m
format shortEng

%bitCount = '8';
%fracLen = '0';
fftLen = 8;
assignin('base', 'fftLen', fftLen);
assignin('base', 'bitCount',bitCount);
assignin('base', 'fracLen',fracLen);
assignin('base', 'Ts', SampleTime);
assignin('base', 'Tb', BitTime);
assignin('base', 'modu_mode', modu_mode);
assignin('base', 'radio_precision', str2double(radio_precision));
assignin('base', 'dmtOfdm', dmtOfdm);
assignin('base', 'guardInterval', guardInterval);
if radio_precision == 1
    precision_str = 'double';
else
    precision_str = strcat('fixdt(1,' , num2str(bitCount) , ',' , num2str(fracLen) , ')');
    precisionModu = strcat('sfix(',num2str(bitCount),')');
end
assignin('base', 'precision_str', precision_str);

%set_param('Basic_DMT/Constant','OutDataTypeStr',precision)

%Rectangular QAM Modulator Data Type
%'outDtype' = 'double' or 'User-defined'
%'outFracLenMode'='User-defined'
%'outFracLen'=fracLen
%'outUDDataType'=precisionModu

%%%%SIMULINK-BLOCKS%%%%%

%Not possible to replace these with variables in the simulink-constant
%blocks.
set_param('Basic_DMT/IFFTaPIS/Create_Frame_for_IFFT/OFDMorDMT/OFDM/Constant','OutDataTypeStr',precision_str)
set_param('Basic_DMT/IFFTaPIS/Create_Frame_for_IFFT/OFDMorDMT/DMT/Constant','OutDataTypeStr',precision_str)


if radio_precision == 1
    
    set_param('Basic_DMT/Modulation/Bit_Mapping_P1/256_QAM/Rect_QAM_Mod','outDtype',precision_str)
    set_param('Basic_DMT/Modulation/Bit_Mapping_P1/16_QAM/Rect_QAM','outDtype',precision_str)
    set_param('Basic_DMT/Modulation/Bit_Mapping_P2/256_QAM/Rectangular_QAM_Modu','outDtype',precision_str)
    set_param('Basic_DMT/Modulation/Bit_Mapping_P2/16_QAM/Rectangular_QAM_Modu','outDtype',precision_str)    
    
    set_param('Basic_DMT/IFFTaPIS/IFFT','outputDataTypeStr','Inherit: Inherit via internal rule')
    
    set_param('Basic_DMT/SIPaFFT/FFT','outputDataTypeStr','Inherit: Inherit via internal rule')
else
    set_param('Basic_DMT/Modulation/Bit_Mapping_P1/256_QAM/Rect_QAM_Mod','outDtype','User-defined','outFracLenMode','User-defined','outFracLen',num2str(fracLen),'outUDDataType',precisionModu)
    set_param('Basic_DMT/Modulation/Bit_Mapping_P1/16_QAM/Rect_QAM','outDtype','User-defined','outFracLenMode','User-defined','outFracLen',num2str(fracLen),'outUDDataType',precisionModu)
    set_param('Basic_DMT/Modulation/Bit_Mapping_P2/256_QAM/Rectangular_QAM_Modu','outDtype','User-defined','outFracLenMode','User-defined','outFracLen',num2str(fracLen),'outUDDataType',precisionModu)
    set_param('Basic_DMT/Modulation/Bit_Mapping_P2/16_QAM/Rectangular_QAM_Modu','outDtype','User-defined','outFracLenMode','User-defined','outFracLen',num2str(fracLen),'outUDDataType',precisionModu)

    set_param('Basic_DMT/IFFTaPIS/IFFT','outputDataTypeStr',strcat('fixdt(1,' , num2str(bitCount+log2(fftLen)+1) , ',' , num2str(fracLen) , ')'))
    set_param('Basic_DMT/SIPaFFT/FFT','outputDataTypeStr',strcat('fixdt(1,' , num2str(bitCount+(log2(fftLen)+1)*2) , ',' , num2str(fracLen) , ')'))
end



%%%%SYSGEN-BLOCKS%%%%%

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