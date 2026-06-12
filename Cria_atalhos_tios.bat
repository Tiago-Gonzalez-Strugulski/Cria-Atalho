:: Scrip criado para automatizar o processo de copia do atalho Tios na area de trabalho de usuarios da maquina local
:: Esse script deve ser rodado apos a instalação do Tios.
:: Criado em 12/06/2026 - Tiago Gonzalez Strugulski.

@echo off
:: Altera a codificação do prompt para UTF-8 (corrige problemas com o acento de "Área de Trabalho")
chcp 65001 > nul
echo.
echo ====================================================================
echo                         Cria Atalhos Tios
echo ====================================================================
echo.
:: ==============================================================================
:: VALIDAÇÃO DE ADMINISTRADOR
:: ==============================================================================
net session >nul 2>&1
if %errorLevel% NEQ 0 (
    echo ====================================================================
    echo [ERRO] ESTE SCRIPT PRECISA SER EXECUTADO COMO ADMINISTRADOR!
    echo ====================================================================
    echo.
    echo Por favor, clique com o botão direito no arquivo .bat e selecione:
    echo.
    echo "Executar como Administrador"
    echo ====================================================================
    echo.
    pause
    exit
)

:: ==============================================================================
:: CONFIGURAÇÕES DO SISTEMA E ATALHO
:: ==============================================================================
set "NomeAtalho=Tios.lnk"
set "ExecutavelSistema=C:\TMCTIOS\D2\D2A001W\20200304101\TIOS\bin\TIOS.exe"
set "PastaTrabalho=C:\TMCTIOS\D2\D2A001W\20200304101\TIOS\bin"

:: Valida se o sistema principal está instalado no caminho correto
if not exist "%ExecutavelSistema%" (
    echo [ERRO] O executavel do sistema nao foi encontrado em:
    echo %ExecutavelSistema%
    echo Verifique a instalação antes de Executar esse Script
    echo.
    pause
    exit
)

:: ==============================================================================
:: EMISSÃO DO ATALHO PARA OS USUÁRIOS
:: ==============================================================================
for /f "tokens=*" %%G in ('dir /b /ad "C:\Users"') do (
    if /i "%%G" NEQ "Public" if /i "%%G" NEQ "Default" if /i "%%G" NEQ "All Users" if /i "%%G" NEQ "Default User" (
        
        :: Caminho em Inglês
        if exist "C:\Users\%%G\Desktop" (
            set "DestinoFinal=C:\Users\%%G\Desktop\%NomeAtalho%"
            call :CriarAtalho
            echo   Atalho criado no Desktop de: %%G
            echo.            
        )
        
        :: Caminho em Português
        if exist "C:\Users\%%G\Área de Trabalho" (
            set "DestinoFinal=C:\Users\%%G\Área de Trabalho\%NomeAtalho%"
            call :CriarAtalho
            echo   Atalho criado na Area de Trabalho de: %%G
            echo.
        )
    )
)

echo.
echo ====================================================================
echo                 Processo concluido com sucesso!
echo ====================================================================
echo.
pause
exit

:: ==============================================================================
:: FUNÇÃO QUE GERA O ATALHO VIA POWERSHELL (EM SEGUNDO PLANO)
:: ==============================================================================
:CriarAtalho
powershell -NoProfile -Command "$ws = New-Object -ComObject WScript.Shell; $s = $ws.CreateShortcut('%DestinoFinal%'); $s.TargetPath = '%ExecutavelSistema%'; $s.WorkingDirectory = '%PastaTrabalho%'; $s.Save()"
goto :eof