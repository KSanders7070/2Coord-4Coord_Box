@echo off

title 2Coord-4Coord box

rem when not debugging, make this value =false
SET debug=false

:HELLO

	ECHO.
	ECHO.
	ECHO This batch file will convert your 2 set of coordinates into a complete square
	ECHO and then output it to geojson.
	ECHO.
	ECHO First type the facility ID, then type the coordinates in the following format
	ECHO without spaces after the commas:
	ECHO 	Northeast Lon, Northeast Lat, Southwest Lon, Southwest Lat.
	ECHO 		Example: -90.0,40.0,-100.0,30.0
	ECHO.
	ECHO.
	ECHO It is suggest that you make a list of the coordinates with the facilities you
	ECHO wish to export and then just copy/paste it into this command prompt.
	ECHO 		Example:
	ECHO 					ZZA
	ECHO 					-90.0,40.0,-100.0,30.0
	ECHO 					ZZB
	ECHO 					-80.0,30.0,-90.0,20.0
	ECHO 					ZZC
	ECHO 					-70.0,20.0,-80.0,10.0
	ECHO 					ZZD
	ECHO 					-60.0,10.0,-70.0,00.0
	ECHO.
	ECHO 			Note - leave blank line at the end of the paste.
	ECHO.
	ECHO.
	ECHO.
	ECHO.

:USER_INPUT

	echo.
	
	if "%debug%"=="false" (
		set /p FAC_ID=Type/paste Facility ID and press enter: 
		set /p COORDS=Type/paste the coordinate and press enter: 
	) else (
		set FAC_ID=test
		set COORDS=-90.0,40.0,-100.0,30.0
	)

:GETCOORDS

	for /f "tokens=1,2,3,4 delims=," %%a in ("%COORDS%") do (
		
			set "E_LON=%%a"
			set "N_LAT=%%b"
			set "W_LON=%%c"
			set "S_LAT=%%d"
	)

:FORMATCOORDS
	
	SET NE_COORDS=%E_LON%,%N_LAT%
	SET SE_COORDS=%E_LON%,%S_LAT%
	SET SW_COORDS=%W_LON%,%S_LAT%
	SET NW_COORDS=%W_LON%,%N_LAT%

:PRINTGEOJSON
	
	echo.
	echo 		%FAC_ID%
	echo 		   "%NW_COORDS%"	"%NE_COORDS%"
	echo 		   "%SW_COORDS%"	"%SE_COORDS%"
	echo.
	
	(
		echo ^{"type":"Feature","properties":^{"name":"%FAC_ID%_AOI"^},"geometry":^{"type":"Polygon","coordinates":^[^[^[%NE_COORDS%^],^[%SE_COORDS%^],^[%SW_COORDS%^],^[%NW_COORDS%^]^]^]^}^}
	)>"%FAC_ID%_AOI.geojson"

	echo 		...Exported to: %FAC_ID%_AOI.geojson
	echo.
	echo.
	echo.

	if "%debug%"=="false" (
		goto USER_INPUT
	) else (
		pause
		exit
	)






