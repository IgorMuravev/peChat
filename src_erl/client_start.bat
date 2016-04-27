set "enodename=%COMPUTERNAME%%RANDOM%%RANDOM%"
set /P var="Enter name servers node: "
erl -sname %enodename% -cookie 9716ae4038ee99eb3cb9cc3f37c1e322 -s pe_client init %var%