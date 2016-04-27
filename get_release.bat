del bin\ /S /Q
rd bin\client\GUI /S /Q
mkdir bin
mkdir bin\server
mkdir bin\client
mkdir bin\client\GUI
xcopy src_erl\erl_client\ebin\* bin\client
xcopy src_erl\erl_server\ebin\* bin\server
xcopy src_erl\python_GUI\* bin\client\GUI /S
