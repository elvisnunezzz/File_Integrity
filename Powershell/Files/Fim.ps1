

Write-host ""
Write-Host "What would you like to do?"
Write-Host "    A) collect new baseline"
Write-Host "    B) Begin monitoring files with saved baseline?"

#How to read input from the command line
Write-Host ""
$response = Read-Host -Prompt "please enter 'A' or 'B'" 



Function Calculate-File-Hash($filepath){
    Get-FileHash -Path $filepath -Algorithm SHA512
    return $filepath 

}

Function Erase-Baseline-If-Already-Exists(){
    $baselineExists = Test-Path -Path .\baseline.txt

    if($baselineExists){
    #Delete item
    Remove-Item -Path .\baseline.txt
    }
}

if ($response -eq "A".ToUpper()){
    #Delete baseline.txt if it already exists 
    Erase-Baseline-If-Already-Exists

    #Calculate hash from the target files and store in baseline.txt
    #Collect all files in the target folder
    $files = Get-ChildItem -Path .\Files
    
    #For each file, calculate the hash, and write to baseline.txt
    foreach ($f in $files){
        $hash = Calculate-File-Hash $f.FullName
        "$($hash.Path)|$($hash.Hash)" | Out-File -FilePath .\baseline.txt -Append
        }
}

elseif($response -eq "B".ToUpper()){

  $fileHashDictionary = @{}

    #Load file|hash from baseline and store then in a dictionary

    $filePathesAndHashes = Get-Content -Path .\baseline.txt
   }

    foreach($f in $filePathesAndHashes){

        $fileHashDictionary.add($f.Split("|")[0],$f.Split("|")[1])
   
    }
    

    #monitoring files with saved baseline using while loop
    while($true){
        Start-Sleep -Seconds 1
        
        $files = Get-ChildItem -Path .\Files

        #for wach file, calculate the has, and write to baseline.txt
        foreach ($f in $files){
        $hash = Calculate-File-Hash $f.FullName
       
       # "$($hash.Path)|$($hash.Hash)" | Out-File -FilePath .\baseline.txt -Append


       #notify if a new file has been created
       if($fileHashDictionary[$hash.Path] -eq $null){
            #new file has been created 
            Write-Host "$($hash.Path) has been created!" -ForegroundColor Green

       }
       else{

       #notifiy if a new file has been changed
       if($fileHashDictionary[$hash.Path] -eq $hash.Hash){
                #The file has not changed

       }

       else{
            # File file has been compromised, notify the user
            Write-Host "$($hash.Path) has changed!!!" -ForegroundColor Yellow

       }
      

    }

   


    }

        foreach ($key in $fileHashDictionary.Keys) {
        $baselineFilesStillExists = Test-Path -Path $key
        if(-Not $baselineFilesStillExists){
        #one of the baseline files must have been deleted, notify the user
        Write-Host "$($key) has been delete" -ForegroundColor DarkRed
        
        
        }

     }

    #variable has the path and hash 


# Begin monitoring files with saved Baseline
 
}


