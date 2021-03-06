Given 'a DSC Configuration script compiling a MOF locally' {
    $RelativePathToDemo = "$PSScriptRoot/../../DscBuildHelpers/Examples/demo2/"
    
    #Loading DSC Configuration Script
    . "$RelativePathToDemo\examples\dsc_configuration.ps1"

    Default -OutputPath "$RelativePathToDemo\OutputPath\Configurations" -instanceName localhost -Verbose
}

When 'we copy the configuration MOF' {
    $RelativePathToDemo = "$PSScriptRoot/../../DscBuildHelpers/Examples/demo2/"
    Copy-Item -ToSession $Script:RemoteSession -Path "$RelativePathToDemo\OutputPath\Configurations" -Destination 'C:\TMP\DSC\' -Force -Recurse
}

Then 'the DSC Configuration is applied successfully' {
    Invoke-Command -Session $Script:RemoteSession -scriptblock {
        Start-DscConfiguration -Wait -Force -Path 'C:\TMP\DSC\configurations\' -Verbose
    }
}

Then 'we call Push-DscConfiguration to apply mof with dependencies' {
    $RelativePathToDemo = "$PSScriptRoot/../../DscBuildHelpers/Examples/demo2/"
    Push-DscConfiguration -ConfigurationDocument 'C:\TMP\DSC\Configurations\localhost.mof' -Session $Script:RemoteSession -WithModule (Get-ModuleFromFolder (gi "$RelativePathToDemo/modules/")) -Confirm:$false
}