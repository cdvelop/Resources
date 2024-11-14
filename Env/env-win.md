


Process to refresh environment variables without reboot Windows:

Set Environment Variable in Windows via Command Prompt

setx [variable_name] "[variable_value]"

setx Test_variable "Variable value"




1. Open CMD command prompt window

2. Input command:
   set PATH=C

3. Close and restart CMD window

4. Test by running:
   echo %PATH%

   more info:
   https://phoenixnap.com/kb/windows-set-environment-variable
   