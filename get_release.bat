del bin\ /S /Q
rd bin\client\GUI /S /Q
mkdir bin
mkdir bin\server
mkdir bin\client
mkdir bin\client\GUI
erlc -o bin\server src_erl\erl_server\pe_server.erl
erlc -o bin\client src_erl\erl_client\pe_client.erl src_erl\erl_client\pe_msg.erl
xcopy src_erl\python_GUI\* bin\client\GUI /S
xcopy src_erl\client_start.bat bin\client
xcopy src_erl\server_start.bat bin\server