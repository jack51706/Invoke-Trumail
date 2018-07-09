<#

Author: RastaMouse
Version: 0.1

Purpose: Trumail is an email address verification API.
         This script takes an email list input and checks
         them against the Trumail service.

#>

function Invoke-Trumail {

  [CmdletBinding()]
  Param(
    [Parameter(Mandatory=$True)]
    [string]$EmailFile
  )

  BEGIN {
  
    $EmailList = Get-Content -LiteralPath $EmailFile -Encoding Ascii
    $EmailCount = ($EmailList | Measure-Object -Line).Lines
    Write-Verbose "$($EmailCount) email(s) found in $($EmailFile)"

    $Results = @()
  
  }

  PROCESS {

    $i = 0
  
    ForEach ($Email in $EmailList) {

      $API = "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
    
      $Req = Invoke-RestMethod -Method Get -Uri "https://api.trumail.io/v2/lookups/json?email=$($Email)&token=$($API)"
      $Results += $Req

      $i++
      $Progress = [math]::Round($i/$EmailCount*100)
      Write-Progress -Activity "Validating..." -PercentComplete $Progress -CurrentOperation "$($Progress)% Complete"
    
    }
  
  }

  END {
  
    $Results | Out-GridView -Title "Trumail" -PassThru
  
  }

}