param(
    
    [Parameter(Mandatory=$true)]
    [string]
    $TemplateFile,

    [Parameter(Mandatory=$false)]
    [string]
    $OutputFileName,
    
    [Parameter(Mandatory=$false)]
    [string]
    $JsonSchema = "https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#"

)

if (!$OutputFileName) {
    
    $OutputFileName = "{0}.parameters.json" -f $TemplateFile.Split("\")[-1].Split(".")[0]
}

$file = Get-Content -LiteralPath $TemplateFile
$parameterlines = $file.Where({$_ -like "param *"})
$parameters = @{}

foreach ($i in $parameterlines) {

    $parameterName = $i.Split(" ")[1]
    $parameterDataType = $i.Split(" ")[2]
    $parameterDefaultValue = $i.Split(" = ")[1]

    if ($parameterDataType -eq 'string') {
        $parameterDefaultValue = ""
    } elseif ($parameterDataType -eq 'int') {
        $parameterDefaultValue = 0
    }

    $parameters.$parameterName = @{
        "value" = $parameterDefaultValue
    }

}

$json = @{
    '$schema' = $JsonSchema
    'contentVersion' = "1.0.0.0"
    'parameters' = $parameters
}

$json | ConvertTo-Json -Depth 4 | out-file $OutputFileName