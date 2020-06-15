if "%PROCESSOR_ARCHITECTURE%"=="ARM64" set HBCLI=..\binaries\aarch64\HandBrakeCLI.exe
if "%PROCESSOR_ARCHITECTURE%"=="AMD64" set HBCLI=..\binaries\x86_64\HandBrakeCLI.exe
if "%PROCESSOR_ARCHITECTURE%"=="x86" exit

mkdir output

%HBCLI% -i source.mp4 -o output\hb_h264_quality10.mp4 -e mf_h264 -q 10 
%HBCLI% -i source.mp4 -o output\hb_h264_quality50.mp4 -e mf_h264 -q 50 
%HBCLI% -i source.mp4 -o output\hb_h264_quality100.mp4 -e mf_h264 -q 100 

%HBCLI% -i source.mp4 -o output\hb_h264_cbr.mp4 -e mf_h264 -b 5000 --cfr
%HBCLI% -i source.mp4 -o output\hb_h264_pvbr.mp4 -e mf_h264 -b 5000 --pfr
%HBCLI% -i source.mp4 -o output\hb_h264_vbr.mp4 -e mf_h264 -b 5000 --vfr

%HBCLI% -i source.mp4 -o output\hb_hevc_quality10.mp4 -e mf_h265 -q 10 
%HBCLI% -i source.mp4 -o output\hb_hevc_quality50.mp4 -e mf_h265 -q 50 
%HBCLI% -i source.mp4 -o output\hb_hevc_quality100.mp4 -e mf_h265 -q 100

%HBCLI% -i source.mp4 -o output\hb_hevc_cbr.mp4 -e mf_h265 -b 5000 --cfr
%HBCLI% -i source.mp4 -o output\hb_hevc_pvbr.mp4 -e mf_h265 -b 5000 --pfr
%HBCLI% -i source.mp4 -o output\hb_hevc_vbr.mp4 -e mf_h265 -b 5000 --vfr
