rem �࠭���� � ������� mask.chb

rem RbfPack CAM_MODULE.rbf a
rem pause

avrasm32.exe -fI -e CAM_KM5.eep -l cam_km5.lst CAM_KM5.AVR
@if exist CAM_KM5.HEX goto okasm


@echo !!!!!!!!!!!!!!!!!!!!!!!!!!!!!
@echo !! �訡�� �࠭��樨 !!
@echo !!!!!!!!!!!!!!!!!!!!!!!!!!!!!

@pause

:okasm
hex2bin cam_km5.hex progflas.bin
if errorlevel 0 goto okhex
@echo !!!!!!!!!!!!!!!!!!!!!!!!!!!!!
@echo !! �訡�� hex !!
@echo !!!!!!!!!!!!!!!!!!!!!!!!!!!!!

@pause

:okhex

crcflas1

rem copy progeepr.bin c:\Users\Yuri\YC\ScramblingControl\
pause
