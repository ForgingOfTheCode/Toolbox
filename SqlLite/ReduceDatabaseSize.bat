@echo off
REM Script to reduce the size of a SQLite database on Windows.

REM Check if sqlite3 is in the PATH.
where sqlite3 >nul 2>&1
if %errorlevel% neq 0 (
    echo sqlite3 is not found in your PATH. Please install it and add it to your PATH.
    goto :eof
)

REM Check if a database file is provided as an argument
if "%1"=="" (
    echo Usage: vacuum_sqlite.bat ^<database_file^>
    goto :eof
)

set DATABASE=%1

REM Check if the database file exists
if not exist "%DATABASE%" (
    echo Error: Database file "%DATABASE%" not found.
    goto :eof
)

REM Create a temporary file. Windows uses a different method.
set TEMP_DB=%TEMP%\vacuumed_db_%RANDOM%.db

echo Vacuuming database "%DATABASE%"...

REM Vacuum the database into the temporary file.
sqlite3 "%DATABASE%" ".backup '%TEMP_DB%'"
if %errorlevel% neq 0 (
    echo Error vacuuming database. Check for errors from sqlite3.
    del "%TEMP_DB%"
    goto :eof
)

echo Replacing original database with vacuumed version...

REM Replace the original database with the vacuumed version.
move /y "%TEMP_DB%" "%DATABASE%" >nul
if %errorlevel% neq 0 (
    echo Error replacing original database. Keeping original database.
    goto :eof
)

echo Database "%DATABASE%" vacuumed successfully.

REM Optional: Display size reduction (more complex on Windows)
for %%a in ("%DATABASE%") do set ORIGINAL_SIZE=%%~za
for %%a in ("%DATABASE%") do set VACUUMED_SIZE=%%~za
set /a SIZE_REDUCTION=%ORIGINAL_SIZE% - %VACUUMED_SIZE%

echo Original size: %ORIGINAL_SIZE% bytes
echo Vacuumed size: %VACUUMED_SIZE% bytes
echo Size reduction: %SIZE_REDUCTION% bytes

goto :eof
