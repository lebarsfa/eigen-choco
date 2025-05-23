﻿$ErrorActionPreference = 'Stop'; # Stop on all errors.

# Source variables which are shared between install and uninstall.
. $PSScriptRoot\sharedVars.ps1

$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$pp = Get-PackageParameters
$packageDir = Join-Path "$toolsDir" ".." -Resolve
$installDir = Join-Path "$packageDir" ".." -Resolve
if ($pp.InstallDir -or $pp.InstallationPath) { 
	$installDir = $pp.InstallDir + $pp.InstallationPath 
}
Write-Host "Eigen is going to be uninstalled from '$installDir'"

$root = Join-Path $installDir "eigen"

try {
    Get-ItemProperty -Path $CMakeSystemRepositoryPath\$CMakePackageName | Select-Object -ExpandProperty "Eigen$CMakePackageVer" -ErrorAction Stop | Out-Null
    Remove-ItemProperty -Path $CMakeSystemRepositoryPath\$CMakePackageName -Name "Eigen$CMakePackageVer"
}
catch {

}

if (Test-Path $root) {
    if ((Resolve-Path $root).Path -notcontains (Resolve-Path $packageDir).Path) {
        Remove-Item -Recurse -Force $root
    }
}
