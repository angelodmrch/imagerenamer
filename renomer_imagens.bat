@echo off
setlocal enabledelayedexpansion

if not exist "renomeadas" mkdir "renomeadas"

for %%f in (*.jpg *.jpeg) do (
    REM Obtém nome (sem extensão) e extensão
    set "filename=%%~nf"
    set "extension=%%~xf"

    REM Extrai as partes do nome usando "_" como delimitador
    set "parts=0"
    for %%a in ("!filename:_=" "!") do (
        set /a parts+=1
        set "part!parts!=%%~a"
    )

    REM Caso 1: Formato com 4 partes (ex: XXXXXX_ParteA_ParteB_ParteC)
    if !parts! equ 4 (
        
        set "extra="
        set "first5=!part2!"
        set "next6=!part3!"
        set "part3=!part4!"
        
        set "newname=!first5!_!next6!_!part3!!extra!!extension!"

        
        REM Chama sub-rotina para verificar duplicidade
        call :CheckDup
    ) else (
        REM Caso 2: Formato com 3 partes (ex: XXXXXX_CODIGO_ParteFinal)
        REM O CODIGO tem 11 caracteres: os 5 primeiros serão a primeira parte e os 6 seguintes a segunda parte.
        set "combined=!part2!"
        set "first5=!combined:~0,5!"
        set "next6=!combined:~5,6!"

        set "extra="

        set "newname=!first5!_!next6!_!part3!!extra!!extension!"
        REM Chama sub-rotina para verificar duplicidade
        call :CheckDup
    )

    REM Copia o arquivo para a pasta "renomeadas" com o novo nome
    copy "%%f" "renomeadas\!newname!" >nul
)

echo Concluído! Arquivos renomeados em: renomeadas\
pause
goto :eof

:CheckDup
REM Esta sub-rotina verifica se o nome gerado já existe; se existir, acrescenta um "1" extra e repete.
:CheckDupLoop
if exist "renomeadas\!newname!" (
    set "extra=!extra!1"
    set "newname=!first5!_!next6!_!part3!!extra!!extension!"
    goto :CheckDupLoop
)
goto :eof
