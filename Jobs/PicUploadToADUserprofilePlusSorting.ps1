﻿<#	
	.NOTES
	===========================================================================
	 Created with: 	SAPIEN Technologies, Inc., PowerShell Studio 2016 v4.2.99
	 Created on:   	10-03-2016 08:55
	 Created by:   	Daniel Lindegaard
	 Organization: 	MT Højgaard
	 Filename:     	PicUploadToADUserprofilePlusSorting.ps1
	===========================================================================
	.DESCRIPTION
		This job wil do the followig as it's ordered below.
	
	- If no Config File Create a default one, at "ProgramData - C:\ProgramData\PicUploadToADUserprofilePlusSorting\"
	- Import Config file to memory.
	- Check to see if the file name standart is currect.
		- Ex on image standart, [Username]_[ImageSizePixelxPixel].jpg, ex. scr_800x768.jpg
	- Sort(copy the files) all the images in to folders that is named, by image pixel size, Ex. 1024x768
	- Image_check_PreAD_Upload. Will need to check if the files meet the requirement for the image, before it's uploaded to AD.
		- Check ok:		Copy to "Ready for upload"
		- Check not ok:
			- Are all okey but file size, Compress the image to the currect file size. (Nice to have, need some .Net for this)
			- Are other then the file size not okey, move to "Need review" AND send a mail to Servicesdesk@mth.dk with a message
			  here about, and say it's att Jonas @ Rapro.
	- Match the image in "Ready for upload" to the urrect user in AD.
	- Uploac the image to the profile.
#>
#region ConfigInformation

$PathToPictures = "$env:ProgramData\Pictures"
$ConfigFile = "$env:ProgramData\PicUploadToADUserprofilePlusSorting\Config.xml"

#endregion

## Don't edit below, no need. Edit the variables in ConfigInformation
#region Default Config file

$ConfigHashTable = @{
	PathToPictures = $PathToPictures;
	Property2 = "Value2";
}
$ConfigHashTable

#endregion

#region Deploying Config file, of loading config file to memory.



#endregion

#region Functions

#Dot Sourcing, the function.
.\..\Adv-Functions_CmdLet\Get-FileMetaDataReturnObject.ps1

function SortingImagesByPixSize ($Path, $parameter2) {
	$FilesMetadata = Get-FileMetaData -folder (Get-childitem $path -Recurse -Directory).FullName
}

function FilenameStandartCheck ($parameter1, $parameter2)
{
	
}

#endregion

#region Controller

BEGIN
{
	# Try one or more commands
	try
	{
		$FilesMetadata = Get-FileMetaData -folder (Get-childitem $path -Recurse -Directory).FullName
	}
	# Catch specific types of exceptions thrown by one of those commands
	catch [System.IO.IOException] {
	}
	# Catch all other exceptions thrown by one of those commands
	catch
	{
	}
	# Execute these commands even if there is an exception thrown from the try block
	finally
	{
	}
}
PROCESS
{
     
}
END
{
	
}

#endregion