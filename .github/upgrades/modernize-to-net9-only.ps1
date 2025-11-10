# Modernize ALL projects to target ONLY .NET 9
Write-Host "?? Modernizing MessagePack-CSharp to .NET 9 ONLY..." -ForegroundColor Cyan

$projects = @(
    "src\MessagePack.Annotations\MessagePack.Annotations.csproj",
    "src\MessagePack.UnityShims\MessagePack.UnityShims.csproj",
    "src\MessagePack.ReactiveProperty\MessagePack.ReactiveProperty.csproj",
    "src\MessagePack.ImmutableCollection\MessagePack.ImmutableCollection.csproj",
    "src\MessagePack.GeneratorCore\MessagePack.GeneratorCore.csproj",
    "src\MessagePackAnalyzer\MessagePackAnalyzer.csproj",
    "src\MessagePack.MSBuild.Tasks\MessagePack.MSBuild.Tasks.csproj",
    "src\MessagePack.Experimental\MessagePack.Experimental.csproj",
    "src\MessagePack.AspNetCoreMvcFormatter\MessagePack.AspNetCoreMvcFormatter.csproj",
    "src\MessagePack.Generator\MessagePack.Generator.csproj",
    "tests\MessagePack.Tests\MessagePack.Tests.csproj",
    "tests\MessagePack.GeneratedCode.Tests\MessagePack.GeneratedCode.Tests.csproj",
    "tests\MessagePack.Experimental.Tests\MessagePack.Experimental.Tests.csproj",
    "tests\MessagePack.Generator.Tests\MessagePack.Generator.Tests.csproj",
    "tests\MessagePackAnalyzer.Tests\MessagePackAnalyzer.Tests.csproj",
    "tests\MessagePack.Internal.Tests\MessagePack.Internal.Tests.csproj",
    "tests\MessagePack.AspNetCoreMvcFormatter.Tests\MessagePack.AspNetCoreMvcFormatter.Tests.csproj",
    "benchmark\ExperimentalBenchmark\ExperimentalBenchmark.csproj",
    "benchmark\SerializerBenchmark\SerializerBenchmark.csproj",
    "sandbox\Sandbox\Sandbox.csproj",
    "sandbox\DynamicCodeDumper\DynamicCodeDumper.csproj",
    "sandbox\SharedData\SharedData.csproj",
    "sandbox\MessagePack.Internal\MessagePack.Internal.csproj",
    "sandbox\TestData2\TestData2.csproj",
    "sandbox\PerfBenchmarkDotNet\PerfBenchmarkDotNet.csproj",
    "sandbox\PerfNetFramework\PerfNetFramework.csproj"
)

$count = 0
foreach ($proj in $projects) {
    $fullPath = Join-Path $PSScriptRoot "..\..\" $proj
    if (Test-Path $fullPath) {
        $content = Get-Content $fullPath -Raw
        
        # Replace TargetFrameworks (plural) with TargetFramework (singular) = net9.0
        $content = $content -replace '<TargetFrameworks>.*?</TargetFrameworks>', '<TargetFramework>net9.0</TargetFramework>'
        
        # Replace any existing TargetFramework with net9.0
        $content = $content -replace '<TargetFramework>(?!net9\.0).*?</TargetFramework>', '<TargetFramework>net9.0</TargetFramework>'
        
        # Update LangVersion to latest
        if ($content -match '<LangVersion>') {
            $content = $content -replace '<LangVersion>.*?</LangVersion>', '<LangVersion>latest</LangVersion>'
        }
        
        Set-Content -Path $fullPath -Value $content -NoNewline
        $count++
        Write-Host "?? Updated: $proj" -ForegroundColor Green
    } else {
        Write-Host "?? Not found: $proj" -ForegroundColor Yellow
    }
}

Write-Host ""
Write-Host "?? Modernization complete! $count projects updated to target .NET 9 ONLY." -ForegroundColor Cyan
Write-Host ""
Write-Host "Next steps:" -ForegroundColor Yellow
Write-Host "1. dotnet clean MessagePack.sln" -ForegroundColor White
Write-Host "2. dotnet build MessagePack.sln" -ForegroundColor White
Write-Host "3. dotnet test MessagePack.sln" -ForegroundColor White
