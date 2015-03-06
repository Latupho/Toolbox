﻿<#	
	.NOTES
	===========================================================================
	 Created with: 	SAPIEN Technologies, Inc., PowerShell Studio 2015 v4.2.80
	 Created on:   	04-03-2015 17:17
	 Created by:   	Daniel Lindegaard
	 Source:	https://github.com/Latupho/Small_and_Practical/blob/master/Functions/Function_DriveLetterCheck.ps1
	 Licence:	GNU licence - http://www.gnu.org/licenses/licenses.html
	 Filename:     	Function_DriveLetterCheck.ps1
	===========================================================================
	.DESCRIPTION
		Check if a driver letter is there or not and will return a $true or $false.
		You can put as meney drives letters you like in -Driveletter as like, as long its comma(,) separated.
#>

function DriveLetterCheck ($DriveLetter)
{
	$count1 = 1
	foreach ($Letter in $DriveLetter)
	{
		$DriveLetterCheck = Get-PSDrive -PSProvider Filesystem | Where-Object -FilterScript { $_.Name -eq "$Letter" }
        [PSCustomObject]@{
            "Exists"       = ($DriveLetterCheck -eq $null);
            "DriveLetter"  = $Letter;
            "Count Number" = $count1
            }
        $count1++
	}
}

DriveLetterCheck -DriveLetter r,c