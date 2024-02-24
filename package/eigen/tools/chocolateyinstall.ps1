$ErrorActionPreference = 'Stop'; # Stop on all errors.

# Source variables which are shared between install and uninstall.
. $PSScriptRoot\sharedVars.ps1

$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$pp = Get-PackageParameters
$packageDir = Join-Path "$toolsDir" ".." -Resolve
$installDir = Join-Path "$packageDir" ".." -Resolve
if ($pp.InstallDir -or $pp.InstallationPath) { 
	$installDir = $pp.InstallDir + $pp.InstallationPath 
}
Write-Host "Eigen is going to be installed in '$installDir'"

$root = Join-Path $installDir "eigen"
New-Item -ItemType Directory -Force -Path $root | Out-Null

if (!$pp['NoRegistry']) {
	New-Item "$CMakeSystemRepositoryPath\$CMakePackageName" -ItemType directory -Force
	New-ItemProperty -Name "Eigen$CMakePackageVer" -PropertyType String -Value "$root\share\eigen3\cmake" -Path "$CMakeSystemRepositoryPath\$CMakePackageName" -Force
}
