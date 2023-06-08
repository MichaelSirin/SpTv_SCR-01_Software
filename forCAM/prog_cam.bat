rem трансляция и прошивание процессора

avrasm32.exe -fI -e CAM_KM5.eep -l cam_km5.lst CAM_KM5.AVR

@if exist CAM_KM5.HEX goto program
@echo					!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
@echo 				!! Ошибка ассемблирования  !!
@echo 				!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
pause
@goto finish
rem ухо означает не отображать команду 

:program
avreal32 +MEGA32 -p378 -as -e -fcksel=4,sut=3,boden=on,blev=off,brst=off,bsiz=3,eesv=off,ckopt=off,blb0=3,blb1=3,jtagen=off -w
@if errorlevel 10 goto prgerror
@if errorlevel 20 goto prgerror
@if errorlevel 30 goto prgerror
@if errorlevel 40 goto prgerror
@if errorlevel 50 goto prgerror
@if errorlevel 60 goto prgerror
@if errorlevel 70 goto prgerror

rem pause

avreal32 +MEGA32 -p378 -as -o8000 -fcksel=4,sut=0,boden=on,blev=off,brst=off,bsiz=3,eesv=off,ckopt=off,blb0=3,blb1=3,jtagen=off -c cam_km5.hex -d cam_km5.eep -w -v
rem -l2

@if errorlevel 10 goto prgerror
@if errorlevel 20 goto prgerror
@if errorlevel 30 goto prgerror
@if errorlevel 40 goto prgerror
@if errorlevel 50 goto prgerror
@if errorlevel 60 goto prgerror
@if errorlevel 70 goto prgerror

rem autonum
pause
@goto finish

:prgerror

@echo 				!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
@echo 				!! Ошибка программирования !!
@echo 				!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
@pause

goto finish

:finish
