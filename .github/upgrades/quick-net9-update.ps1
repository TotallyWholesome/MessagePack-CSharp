# Quick .NET 9 Only Modernization Script
Write-Host "?? Converting ALL projects to .NET 9 ONLY..." -ForegroundColor Cyan

$rootPath = "C:\Users\tgraf\Source\Repos\MessagePack-CSharp"
$projectFiles = Get-ChildItem -Path $rootPath -Filter "*.csproj" -Recurse

$updated = 0
foreach ($proj in $projectFiles) {
    $content = Get-Content $proj.FullName -Raw
    $original = $content
    
    # Replace TargetFrameworks (plural) with TargetFramework (singular) = net9.0
    $content = $content -replace '<TargetFrameworks>[^<]*</TargetFrameworks>', '<TargetFramework>net9.0</TargetFramework>'
    
    # Replace TargetFramework that isn't already net9.0
    $content = $content -replace '<TargetFramework>(?!net9\.0)[^<]*</TargetFramework>', '<TargetFramework>net9.0</TargetFramework>'
    
    # Add or update LangVersion to latest if PropertyGroup exists
    if ($content -match '<PropertyGroup>') {
        if ($content -match '<LangVersion>[^<]*</LangVersion>') {
            $content = $content -replace '<LangVersion>[^<]*</LangVersion>', '<LangVersion>latest</LangVersion>'
        } elseif ($content -match '(<PropertyGroup>.*?<TargetFramework>)') {
            $content = $content -replace '(<TargetFramework>[^<]*</TargetFramework>)', "`$1`r`n    <LangVersion>latest</LangVersion>"
        }
    }
    
    # Update descriptions to mention .NET 9
    $content = $content -replace '\(\.NET, \.NET Core, Unity, Xamarin\)', 'targeting modern .NET 9'
    $content = $content -replace 'for C#', 'for C# (.NET 9)'
    
    # Update PackageTags to include NET9
    if ($content -match '<PackageTags>(?!.*NET9)([^<]*)</PackageTags>') {
        $content = $content -replace '<PackageTags>([^<]*)</PackageTags>', '<PackageTags>$1;NET9</PackageTags>'
    }
    
    if ($content -ne $original) {
        Set-Content -Path $proj.FullName -Value $content -NoNewline
        $updated++
        Write-Host "?? $($proj.Name)" -ForegroundColor Green
    }
}

Write-Host "`n?? Updated $updated project files to .NET 9!" -ForegroundColor Cyan
