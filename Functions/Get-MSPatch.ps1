﻿<#	
	.NOTES
	===========================================================================
	 Created with: 	SAPIEN Technologies, Inc., PowerShell Studio 2015 v4.2.97
	 Created on:   	19-11-2015 09:42
	 Created by:   	 Daniel Lindegaard
	 Organization: 	 
	 Filename:     	Get-MSPatch
	===========================================================================
	.DESCRIPTION
		As of what I know and have researched, this will get all the Patches from
		Microsoft on your computer. But as MS don't allways follow there own standarts,
		I can be wrong on this part :-)
#>

function Get-MSPatch ($KB,$Quiet) {
	#See if the CPU is 64 bit.
	[boolean]$Is64Bit = [boolean]((Get-WmiObject -Class 'Win32_Processor' | Where-Object { $_.DeviceID -eq 'CPU0' } | Select-Object -ExpandProperty 'AddressWidth') -eq 64)
	
    #$KBs are for when I need to ask WMI(Win32_QuickFixEngineering/Get-hotfix) for the KB's.
    $Count = 0
    $QueryStringAssembly = ""

    #This part is to create there FilterScript String, we need to search for KB patches in the Registry.
    $FilterScript = @() 
    $KBObj = $kb -split ","
    $KBObjwStart = $KBObj | ForEach-Object -Process { '$_.displayname -like ' + ('"*' + $_ + '*"')}
    $WhereString = $KBObjwStart -join " -or "
    $FilterScript = [scriptblock]::Create( $WhereString )

    #Search the Reg.	
	if ($is64bit)
	{
		$Reg = @("HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*")
	}
	else
	{
		$Reg = @("HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\*")
	}
	$InstalledApps = Get-ItemProperty $Reg -EA 0
    $Run = 0

    $OfficeKBs = $InstalledApps |
    Where-Object -FilterScript {
        ($FilterScript.invoke())
    } |
	Add-Member -MemberType NoteProperty -Name 'Original Source' -Value 'Registry Database' -PassThru

    foreach ($Item in $KBObj) {
        $QueryStringAssembly += if ($Count -eq '0') {"where HotFixID='$Item'"} else { " OR HotFixID='$Item'"}
        $Count++
    }
    $WMIQuery =  "select * from Win32_QuickFixEngineering " + "$QueryStringAssembly"
	
	$WinKBs = Get-WmiObject -Query $WMIQuery |
	Select-Object -Property * |
	Add-Member -MemberType NoteProperty -Name 'Original Source' -Value 'Win32_QuickFixEngineering' -PassThru

#########################################################################################################################

    if ($Quiet)  {
        If ($OfficeKBs -eq $null -and $WinKBs -eq $null) {
            Write-Output $false
        }
        else {
            Write-Output $true
        }
    }
    Else {
		$ObjKB = @()
		$ObjKB += $WinKBs
		$ObjKB += $OfficeKBs
				
			foreach ($KBPatch in $ObjKB) {
			if ($KBPatch.'Original Source' -eq "Win32_QuickFixEngineering") {
				$object = [pscustomobject]@{
					DisplayName = 'N\A';
					KBNumber = $KBPatch.HotFixID;
					InstalledOn = $KBPatch.InstalledOn;
					UninstallString = 'N\A';
					Description = $KBPatch.Description;
					FullObject = $KBPatch #This all the will Object, if it's needed.
				}
			}
			elseif ($KBPatch.'Original Source' -eq "Registry Database") {
				$object = [pscustomobject]@{
					DisplayName = $KBPatch.DisplayName;
					KBNumber = (Select-String -Pattern "\((\w{2}\d+)\)" -InputObject ($KBPatch.DisplayName)).Matches.Groups[1];
					InstalledOn = $KBPatch.InstalledOn;
					UninstallString = $KBPatch.UninstallString;
					Description = $KBPatch.Comments;
					FullObject = $KBPatch #This all the will Object, if it's needed.
				}
			}
			Write-Output $object
			}
		
		}
}

Get-MSPatch -KB "KB3054886,KB3055034,KB3101521,KB3097877,KB3074230,KB3097996,KB3024995" -Quiet $false
