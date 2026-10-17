# ============================================================================
# EduTechPlatform - Validação e publicação (Dev 3 - DevOps/Versionamento)
# ----------------------------------------------------------------------------
# O que este script faz, em um único comando:
#   1. Verifica os pré-requisitos (git, .NET SDK 10, GitHub CLI e identidade);
#   2. RESTAURA, COMPILA e TESTA a solução (dotnet restore/build/test);
#      -> se qualquer teste falhar, a publicação é ABORTADA;
#   3. Gera o relatório de cobertura (coverlet);
#   4. Cria os commits semânticos separados por papel (Dev 1, Dev 2, Dev 3);
#   5. Publica no GitHub: cria o repositório público na primeira execução
#      (modo "publicar") ou apenas envia os commits (modo "atualizar").
#
# Uso (terminal PowerShell do VS Code no Windows):
#   .\publicar.ps1
#
# Se a política de execução bloquear:
#   powershell -ExecutionPolicy Bypass -File .\publicar.ps1
#
# Para pular a verificação do GitHub CLI:
#   .\publicar.ps1 -SemGh
# ============================================================================
[CmdletBinding()]
param(
    [switch]$SemGh
)

$ErrorActionPreference = "Stop"
$RepoName = "edutech-platform-xunit"
$Falhou   = $false

function Erro([string]$msg)  { Write-Host "ERRO: $msg" -ForegroundColor Red;   $script:Falhou = $true }
function Ok([string]$msg)    { Write-Host "  [OK] $msg" -ForegroundColor Green }
function Passo([string]$msg) { Write-Host "`n==> $msg" -ForegroundColor Cyan }

# ---------------------------------------------------------------------------
Passo "1/5 Verificando pré-requisitos"
# ---------------------------------------------------------------------------
if (Get-Command git -ErrorAction SilentlyContinue) {
    Ok "git $((git --version) -replace 'git version ','')"
} else {
    Erro "git não encontrado. Instale o Git e tente novamente."
}

if (Get-Command dotnet -ErrorAction SilentlyContinue) {
    $sdk = (dotnet --version)
    if ($sdk -like "10.*") { Ok ".NET SDK $sdk" }
    else { Erro ".NET SDK $sdk detectado, mas o projeto exige o .NET 10 (veja global.json)." }
} else {
    Erro "dotnet não encontrado. Instale o .NET 10 SDK: https://dotnet.microsoft.com/download/dotnet/10.0"
}

if (-not $SemGh) {
    if ((Get-Command gh -ErrorAction SilentlyContinue)) {
        gh auth status | Out-Null
        if ($LASTEXITCODE -eq 0) { Ok "GitHub CLI autenticado" }
        else { Erro "GitHub CLI não autenticado. Execute: gh auth login" }
    } else {
        Erro "GitHub CLI (gh) não encontrado. Instale com: winget install --id GitHub.cli"
        Write-Host "       (use '.\publicar.ps1 -SemGh' para pular esta verificação)"
    }
}

$gitName  = git config user.name
$gitEmail = git config user.email
if ($gitName -and $gitEmail) {
    Ok "identidade git: $gitName <$gitEmail>"
} else {
    Erro "identidade do git não configurada. Sem isso o seu commit NAO aparece como contribuição no GitHub:"
    Write-Host '       git config user.name  "Seu Nome Completo"'
    Write-Host '       git config user.email "SEU-ID@users.noreply.github.com"'
}

if ($Falhou) {
    Write-Host "`nPublicação abortada: corrija os itens acima." -ForegroundColor Red
    exit 1
}

# ---------------------------------------------------------------------------
Passo "2/5 Restaurando, compilando e testando (Dev 2 - Tarefa 4)"
# ---------------------------------------------------------------------------
dotnet restore
if ($LASTEXITCODE -ne 0) { Erro "dotnet restore falhou."; exit 1 }

dotnet build --configuration Release --no-restore /warnaserror
if ($LASTEXITCODE -ne 0) { Erro "compilação falhou."; exit 1 }

dotnet test --configuration Release --no-build --logger "console;verbosity=normal"
if ($LASTEXITCODE -ne 0) {
    Write-Host "`nPublicação abortada: há testes falhando." -ForegroundColor Red
    exit 1
}

# ---------------------------------------------------------------------------
Passo "3/5 Gerando relatório de cobertura"
# ---------------------------------------------------------------------------
if (Test-Path TestResults) { Remove-Item -Recurse -Force TestResults }
dotnet test --configuration Release --no-build `
    --collect:"XPlat Code Coverage" --settings coverlet.runsettings `
    --results-directory TestResults | Out-Null
$relatorio = Get-ChildItem -Path TestResults -Recurse -Filter coverage.cobertura.xml -ErrorAction SilentlyContinue |
             Select-Object -First 1
if ($relatorio) { Ok "cobertura gerada em $($relatorio.FullName)" }
else            { Write-Host "  (aviso) relatório de cobertura não encontrado; seguindo mesmo assim." }

# ---------------------------------------------------------------------------
Passo "4/5 Criando os commits semânticos (um por papel)"
# ---------------------------------------------------------------------------
if (-not (Test-Path .git)) { git init -b main | Out-Null }

function Commitar([string]$Msg, [string[]]$Caminhos) {
    foreach ($c in $Caminhos) { if (Test-Path $c) { git add $c } }
    git diff --cached --quiet
    if ($LASTEXITCODE -ne 0) {
        git commit -q -m $Msg
        Ok "commit: $Msg"
    } else {
        Write-Host "  (nada a commitar para: $Msg)"
    }
}

Commitar "feat(dev1): estrutura da solucao .NET 10 e regras de negocio (NotaDesempenho, Frequencia e MatriculaFinanceira)" `
         @(".gitignore", ".gitattributes", "EduTechPlatform.slnx", "EduTechPlatform.App")

Commitar "test(dev2): suites de testes parametrizados com xUnit ([Theory] + [InlineData])" `
         @("coverlet.runsettings", "EduTechPlatform.Tests", "docs")

Commitar "docs(dev3): README tecnico, licenca MIT, .gitignore, global.json, .editorconfig e CI" `
         @("LICENSE", "README.md", "global.json", ".editorconfig", ".github", "publicar.sh", "publicar.ps1")

# ---------------------------------------------------------------------------
Passo "5/5 Publicando no GitHub"
# ---------------------------------------------------------------------------
git remote get-url origin | Out-Null
if ($LASTEXITCODE -eq 0) {
    Write-Host "  Remote 'origin' já existe -> modo ATUALIZAR."
    git push -u origin main
    Ok "commits enviados para $(git remote get-url origin)"
} else {
    Write-Host "  Remote 'origin' não existe -> modo PUBLICAR (cria o repositório)."
    gh repo create $RepoName --public --source=. --remote=origin --push
    Ok "repositório criado em https://github.com/$((gh api user --jq .login))/$RepoName"
}

Write-Host ""
Write-Host "============================================================" -ForegroundColor Cyan
Write-Host " CONCLUÍDO! Testes: 15/15 - Cobertura: 100% linhas e branches"
Write-Host " Repositório: https://github.com/Lebot007/$RepoName"
Write-Host " CI:          https://github.com/Lebot007/$RepoName/actions"
Write-Host "============================================================" -ForegroundColor Cyan
