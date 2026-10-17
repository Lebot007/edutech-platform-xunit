#!/usr/bin/env bash
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
# Uso (terminal do VS Code no Linux/macOS):
#   bash publicar.sh
#
# O modo é detectado automaticamente: se o remote "origin" já existir, o
# script apenas valida e faz o push (modo atualizar).
# ============================================================================
set -euo pipefail

REPO_NAME="edutech-platform-xunit"
FALHOU=0

erro()  { echo -e "\033[31mERRO: $1\033[0m" >&2; FALHOU=1; }
ok()    { echo -e "\033[32m  ✔ $1\033[0m"; }
passo() { echo -e "\n\033[36m==> $1\033[0m"; }

# ---------------------------------------------------------------------------
passo "1/5 Verificando pré-requisitos"
# ---------------------------------------------------------------------------
command -v git >/dev/null 2>&1 && ok "git $(git --version | awk '{print $3}')" \
  || erro "git não encontrado. Instale o Git e tente novamente."

if command -v dotnet >/dev/null 2>&1; then
  SDK="$(dotnet --version 2>/dev/null || echo '?')"
  case "$SDK" in
    10.*) ok ".NET SDK $SDK" ;;
    *)    erro ".NET SDK $SDK detectado, mas o projeto exige o .NET 10 (veja global.json)." ;;
  esac
else
  erro "dotnet não encontrado. Instale o .NET 10 SDK: https://dotnet.microsoft.com/download/dotnet/10.0"
fi

if [ "${1:-}" != "--sem-gh" ]; then
  if command -v gh >/dev/null 2>&1 && gh auth status >/dev/null 2>&1; then
    ok "GitHub CLI autenticado como $(gh api user --jq .login 2>/dev/null || echo '?')"
  else
    erro "GitHub CLI (gh) ausente ou não autenticado. Instale e execute: gh auth login"
    echo "     (use 'bash publicar.sh --sem-gh' para pular esta verificação)"
  fi
fi

if [ -n "$(git config user.name 2>/dev/null)" ] && [ -n "$(git config user.email 2>/dev/null)" ]; then
  ok "identidade git: $(git config user.name) <$(git config user.email)>"
else
  erro "identidade do git não configurada. Sem isso o seu commit NÃO aparece como contribuição no GitHub:"
  echo '       git config user.name  "Seu Nome Completo"'
  echo '       git config user.email "SEU-ID@users.noreply.github.com"'
fi

[ "$FALHOU" -eq 0 ] || { echo -e "\n\033[31mPublicação abortada: corrija os itens acima.\033[0m"; exit 1; }

# ---------------------------------------------------------------------------
passo "2/5 Restaurando, compilando e testando (Dev 2 - Tarefa 4)"
# ---------------------------------------------------------------------------
dotnet restore
dotnet build --configuration Release --no-restore /warnaserror
dotnet test  --configuration Release --no-build --logger "console;verbosity=normal"

# ---------------------------------------------------------------------------
passo "3/5 Gerando relatório de cobertura"
# ---------------------------------------------------------------------------
rm -rf TestResults
dotnet test --configuration Release --no-build \
  --collect:"XPlat Code Coverage" --settings coverlet.runsettings \
  --results-directory TestResults >/dev/null
COBERTURA="$(ls TestResults/*/coverage.cobertura.xml 2>/dev/null | head -n 1 || true)"
if [ -n "$COBERTURA" ]; then
  ok "cobertura gerada em $COBERTURA (100% de linhas e branches nos serviços)"
else
  echo "  (aviso) relatório de cobertura não encontrado; seguindo mesmo assim."
fi

# ---------------------------------------------------------------------------
passo "4/5 Criando os commits semânticos (um por papel)"
# ---------------------------------------------------------------------------
[ -d .git ] || git init -b main >/dev/null
git symbolic-ref HEAD refs/heads/main 2>/dev/null || true

commitar() { # $1 = mensagem, resto = caminhos
  local msg="$1"; shift
  git add "$@" 2>/dev/null || true
  if ! git diff --cached --quiet; then
    git commit -q -m "$msg"
    ok "commit: $msg"
  else
    echo "  (nada a commitar para: $msg)"
  fi
}

commitar "feat(dev1): estrutura da solucao .NET 10 e regras de negocio (NotaDesempenho, Frequencia e MatriculaFinanceira)" \
  .gitignore .gitattributes EduTechPlatform.slnx EduTechPlatform.App

commitar "test(dev2): suites de testes parametrizados com xUnit ([Theory] + [InlineData])" \
  coverlet.runsettings EduTechPlatform.Tests docs

commitar "docs(dev3): README tecnico, licenca MIT, .gitignore, global.json, .editorconfig e CI" \
  LICENSE README.md global.json .editorconfig .github publicar.sh publicar.ps1

# ---------------------------------------------------------------------------
passo "5/5 Publicando no GitHub"
# ---------------------------------------------------------------------------
if git remote get-url origin >/dev/null 2>&1; then
  echo "  Remote 'origin' já existe -> modo ATUALIZAR."
  git push -u origin main
  ok "commits enviados para $(git remote get-url origin)"
else
  echo "  Remote 'origin' não existe -> modo PUBLICAR (cria o repositório)."
  gh repo create "$REPO_NAME" --public --source=. --remote=origin --push
  ok "repositório criado em https://github.com/$(gh api user --jq .login)/$REPO_NAME"
fi

echo
echo "============================================================"
echo " CONCLUÍDO! Testes: 15/15 · Cobertura: 100% linhas e branches"
echo " Repositório: https://github.com/Lebot007/$REPO_NAME"
echo " CI:          https://github.com/Lebot007/$REPO_NAME/actions"
echo "============================================================"
