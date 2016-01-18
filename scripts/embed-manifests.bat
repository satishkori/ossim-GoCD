@for %%i IN (%1\*.dll) do ( 
   @if exist %%i.manifest ( 
       @echo embedding manifest for file %%i 
       mt -manifest %%i.manifest -outputresource:%%i;2 
       del %%i.manifest 
   ) 
) 
@for %%i IN (%1\*.exe) do ( 
   @if exist %%i.manifest ( 
       @echo embedding manifest for file %%i 
       mt -manifest %%i.manifest -outputresource:%%i;1 
       del %%i.manifest 
   ) 
) 
