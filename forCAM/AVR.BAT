rem ed /s cam_km5.avr
avrasm32.exe -fG -e %1.eep -l %1.lst cam_km5.avr
avrasm32.exe -fG -o %1.rom -l %1.lst cam_km5.avr
pause
