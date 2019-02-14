[CmdletBinding()]
Param()
$File = ""
$RootKey = ""
$PropertyKey = ""
$OutputVariableName = ""

function Get-NodeByKey([string]$nodeKey, $fileContent)
{
    Write-Host "Getting the node by Key name: $nodeKey"
    $lineStart = 0
    $result = ""

    for($i=0; $i -lt $fileContent.Length; $i++)
    {
        $line = $fileContent[$i];
        if($lineStart -lt 1 -and $line.StartsWith($nodeKey))
        {
            $lineStart = $i
        }

        elseif($lineStart -gt 0 -and $line.EndsWith("}"))
        {
            $lineEnd = $i
            break
        }
    }

    Write-Host "Got the full node, starting on line: $lineStart, and ending on line: $lineEnd"

    $result = ""
    for($i=$lineStart+1; $i -lt $lineEnd; $i++)
    {
        $result = $result + "," + $fileContent[$i].Trim()
    }
    $result = $result.Trim(',')
    Write-Host "Node Text: $result"
    return $result
}

function Get-ValueByKey($Node, [string]$KeyName)
{
    Write-Host "Fetching Value by keyname: $KeyName"
    $lines = ""
    if([string]::IsNullOrEmpty($RootKey))
    {
        $lines = $Node
    }
    else {
        $lines = $Node.Split(',')
    }

    foreach($line in $lines)
    {
        if($line.StartsWith($KeyName))
        {
            $value = $line.Split('=')[1].Trim(@('"', ' '))
            Write-Host
            return $value
        }
    }
}


# For more information on the VSTS Task SDK:
# https://github.com/Microsoft/vsts-task-lib
Trace-VstsEnteringInvocation $MyInvocation
try {
    # Set the working directory.
    $cwd = Get-VstsInput -Name cwd -Require
    Assert-VstsPath -LiteralPath $cwd -PathType Container
    Write-Verbose "Setting working directory to '$cwd'."
    Set-Location $cwd

    # Task code below
    $File = Get-VstsInput -Name File -Require
    $RootKey = Get-VstsInput -Name RootKey
    $PropertyKey = Get-VstsInput -Name PropertyKey -Require
    $OutputVariableName = Get-VstsInput -Name OutputVariableName -Require

    $fileContent = Get-Content -Path $File
    $node = ""
    if([string]::IsNullOrEmpty($RootKey))
    {
        $node = $fileContent
    }
    else {
        $node = Get-NodeByKey $RootKey $fileContent
    }

    $value = Get-ValueByKey $node $PropertyKey 
    Write-Host "##vso[task.setvariable variable=$OutputVariableName;]$value"
    Write-Host "Result:  $value" -ForegroundColor Green
} 

finally {
    Trace-VstsLeavingInvocation $MyInvocation
}
