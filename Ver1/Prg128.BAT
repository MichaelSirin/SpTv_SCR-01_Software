@echo Erasing ...
@avreal32 +Mega128 -p378 -as -o8000 -e > output
@if errorlevel 1 goto ERROR

@echo Writing flash ...
@avreal32 +Mega128 -p378 -as -o8000 -c fulldemo.hex  -W > output
@if errorlevel 1 goto ERROR

@echo Verifying flash ...
@avreal32 +Mega128 -p378 -as -o8000 -c fulldemo.hex  -v > output

@if errorlevel 1 goto ERROR
rem @echo Programming Fuse ...
rem @avreal32 +Mega128 -p378 -as -o8000 -w -fblev=4,cksel=3 -v > output
rem @if errorlevel 1 goto ERROR

@echo Programming Lock ...
rem @avreal32 +Mega128 -p378 -as -o8000  -l+2  > output
rem @if errorlevel 1 goto ERROR


@echo OK!
@GOTO END

:ERROR
@type output

:END
@del output
