# EduTechPlatform

> Plataforma acadêmica de **gestão de notas, frequência e financeiro de alunos**.

[![CI - Build & Tests](https://github.com/Lebot007/edutech-platform-xunit/actions/workflows/ci.yml/badge.svg)](https://github.com/Lebot007/edutech-platform-xunit/actions/workflows/ci.yml)
[![.NET](https://img.shields.io/badge/.NET-10.0-512BD4?logo=dotnet&logoColor=white)](https://dotnet.microsoft.com/download/dotnet/10.0)
[![xUnit](https://img.shields.io/badge/tests-15%20passed-brightgreen)](docs/RELATORIO-QUALIDADE.md)
[![Cobertura](https://img.shields.io/badge/coverage-100%25%20lines%20%26%20branches-brightgreen)](docs/RELATORIO-QUALIDADE.md#6-cobertura-de-código)
[![License](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)

Projeto desenvolvido como atividade da disciplina **Garantia da Qualidade de Software** (Gestão e Qualidade de Software — Prof. Daniel Henrique Matos de Paiva).

O projeto demonstra boas práticas de qualidade de software:

- **Separação de responsabilidades**: cada domínio de negócio possui sua própria classe de serviço;
- **Testes unitários automatizados**: cobertura das regras de negócio com **xUnit** e testes parametrizados (`[Theory]` + `[InlineData]`);
- **Cobertura medida**: **100% de linhas e de branches** nas três classes de serviço (coverlet + Cobertura XML);
- **Integração contínua**: pipeline no **GitHub Actions** que restaura, compila (`/warnaserror`), testa e mede a cobertura a cada push ou Pull Request;
- **Versionamento e documentação**: repositório público com `.gitignore` oficial do .NET, `global.json`, `.editorconfig`, licença MIT, README técnico, [relatório de qualidade](docs/RELATORIO-QUALIDADE.md) e commits semânticos.

---

## Sumário

- [Visão Geral](#visão-geral)
- [Equipe](#equipe)
- [Estrutura da Solução](#estrutura-da-solução)
- [Requisitos do Ambiente](#requisitos-do-ambiente)
- [Classes de Serviço](#classes-de-serviço--responsabilidades-dev-1)
- [Guia de Execução](#guia-de-execução-cli)
- [Testes Parametrizados](#testes-parametrizados-com-theory-e-inlinedata-dev-2)
- [Gestão do Repositório](#gestão-do-repositório-dev-3)
- [Integração Contínua](#integração-contínua-dev-3)
- [Divisão do Trabalho](#divisão-do-trabalho)
- [Licença](#licença)

## Visão Geral

A **EduTechPlatform** apoia a gestão acadêmica e financeira de uma instituição de ensino. Nesta etapa, o núcleo da aplicação (`EduTechPlatform.App`) implementa as regras de negócio de três domínios:

| Domínio | Classe de Serviço | Regras implementadas |
|---|---|---|
| Desempenho acadêmico | `NotaDesempenhoService` | Média ponderada (pesos 3, 3 e 4) e situação do aluno |
| Frequência | `FrequenciaService` | Percentual de presença e aprovação por frequência (mín. 75%) |
| Matrícula/Financeiro | `MatriculaFinanceiraService` | Valor da mensalidade (bolsa/pontualidade) e elegibilidade de rematrícula |

A camada de qualidade (`EduTechPlatform.Tests`) valida **todas** as regras acima por meio de testes unitários parametrizados, executados com `dotnet test`.

## Equipe

Integrantes responsáveis pelo desenvolvimento da **EduTechPlatform**:

| # | Integrante | Papel no projeto | GitHub |
|---|---|---|---|
| 1 | **Rafael Luiz Ferreira de Souza** | Dev 1 — Regras de Serviço (Backend/Core) | [@rafaellfsouza](https://github.com/rafaellfsouza) |
| 2 | **João Vitor Alves Rodrigues** | Dev 2 — Qualidade e Testes (xUnit) | [@Lebot007](https://github.com/Lebot007) |
| 3 | **Pietro Cardoso de Oliveira** | Dev 3 — Documentação e DevOps/Versionamento | [@Pietro2820](https://github.com/Pietro2820) |
| 4 | **Pedro Henrique Martins** | Dev 3 — Documentação e DevOps/Versionamento | [@PedroHenriqueM2005](https://github.com/PedroHenriqueM2005) |

> A descrição detalhada das entregas de cada papel (arquivos e responsabilidades) está em [Divisão do Trabalho](#divisão-do-trabalho).

## Estrutura da Solução

```
edutech-platform-xunit/
├── .github/workflows/ci.yml              # CI: restore + build + testes + cobertura (Dev 3)
├── EduTechPlatform.slnx                  # Solução (.NET 10 — formato slnx gerado por `dotnet new sln`)
├── global.json                           # Fixa o SDK .NET usado pelo time e pelo CI (Dev 3)
├── .editorconfig                         # Padroniza indentação e estilo C# (Dev 3)
├── coverlet.runsettings                  # Configuração da medição de cobertura (Dev 2)
├── EduTechPlatform.App/                  # Projeto console — regras de negócio (Dev 1)
│   ├── NotaDesempenhoService.cs
│   ├── FrequenciaService.cs
│   ├── MatriculaFinanceiraService.cs
│   └── Program.cs                        # Demonstração de uso dos serviços
├── EduTechPlatform.Tests/                # Projeto de testes xUnit (Dev 2)
│   ├── NotaDesempenhoServiceTests.cs
│   ├── FrequenciaServiceTests.cs
│   └── MatriculaFinanceiraServiceTests.cs
├── docs/
│   └── RELATORIO-QUALIDADE.md            # Evidência de validação, rastreabilidade e cobertura
├── .gitignore                            # Ignora bin/, obj/, TestResults/, .vs/ etc. (Dev 3)
├── .gitattributes                        # Normaliza quebras de linha (Dev 3)
├── LICENSE                               # Licença MIT (Dev 3)
├── publicar.ps1 / publicar.sh            # Automação: testes + commits + criação do repositório + push (Dev 3)
└── README.md                             # Este arquivo (Dev 3)
```

A solução foi criada com os comandos oficiais da .NET CLI:

```bash
dotnet new sln -n EduTechPlatform
dotnet new console -n EduTechPlatform.App -f net10.0
dotnet new xunit -n EduTechPlatform.Tests -f net10.0
dotnet sln add EduTechPlatform.App/EduTechPlatform.App.csproj
dotnet sln add EduTechPlatform.Tests/EduTechPlatform.Tests.csproj
dotnet add EduTechPlatform.Tests/EduTechPlatform.Tests.csproj reference EduTechPlatform.App/EduTechPlatform.App.csproj
```

## Requisitos do Ambiente

| Requisito | Versão mínima | Verificação |
|---|---|---|
| [.NET SDK](https://dotnet.microsoft.com/download/dotnet/10.0) | **10.0** | `dotnet --version` |
| Git | 2.28+ | `git --version` |
| GitHub CLI (apenas para o script de publicação) | 2.x | `gh --version` |

> 🔒 **Reprodutibilidade do ambiente.** O arquivo **`global.json`** fixa o SDK em **10.0.402** (`rollForward: latestFeature`). Assim, todos os integrantes da equipe **e** o pipeline de CI compilam exatamente com a mesma versão do .NET, eliminando o clássico defeito *"na minha máquina funciona"*.
>
> 📏 **Padronização de código.** O **`.editorconfig`** na raiz garante a mesma indentação (4 espaços), codificação (UTF-8), quebra de linha (LF) e convenções de nomenclatura em qualquer editor — atendendo ao requisito de *"algoritmos devidamente indentados"*.
>
> 💡 Recomendado: **Visual Studio Code** com a extensão **C# Dev Kit** (ou **Visual Studio 2026**) para abrir a solução `EduTechPlatform.slnx`.

## Classes de Serviço — Responsabilidades (Dev 1)

### 1. `NotaDesempenhoService`

Responsável pelo domínio de **notas e desempenho acadêmico**:

- `CalcularMediaPonderada(decimal nota1, decimal nota2, decimal notaProjeto) → decimal`
  Calcula a média ponderada com **pesos 3 (Nota 1), 3 (Nota 2) e 4 (Nota Projeto)**:
  `((nota1 * 3) + (nota2 * 3) + (notaProjeto * 4)) / 10`
- `ObterSituacaoAcademica(decimal mediaFinal) → string`
  Classifica o aluno:
  - `mediaFinal >= 7.0` → **`"APROVADO"`**
  - `5.0 <= mediaFinal < 7.0` → **`"RECUPERACAO"`**
  - `mediaFinal < 5.0` → **`"REPROVADO"`**

### 2. `FrequenciaService`

Responsável pelo domínio de **frequência**:

- `CalcularPorcentagemPresenca(int aulasTotais, int faltas) → double`
  Retorna o percentual de presença: `((aulasTotais - faltas) / (double)aulasTotais) * 100`
- `AprovadoPorFrequencia(int aulasTotais, int faltas) → bool`
  Retorna `true` somente se a presença for **≥ 75%** (mínimo institucional); caso contrário, `false`.

### 3. `MatriculaFinanceiraService`

Responsável pelo domínio **financeiro/matrícula**:

- `CalcularValorMensalidade(decimal valorBase, int diaPagamento, bool eBolsista) → decimal`
  Aplica as regras de desconto:
  - **Bolsista** (`eBolsista == true`): desconto fixo de **50%** (`valorBase * 0.50m`), independentemente do dia de pagamento;
  - **Não bolsista que paga até o dia 5**: desconto de **10%** por pontualidade (`valorBase * 0.90m`);
  - **Não bolsista que paga após o dia 5**: **valor integral** (`valorBase`).
- `PodeRealizarRematricula(bool possuiPendenciaFinanceira, string situacaoAcademica) → bool`
  Retorna `true` apenas se **não houver pendência financeira** E a situação acadêmica **não for `"REPROVADO"`**.

## Guia de Execução (CLI)

```bash
# 1. RESTAURAÇÃO — baixa as dependências NuGet (xUnit, Test SDK, coverlet)
dotnet restore

# 2. COMPILAÇÃO — gera os binários da solução
dotnet build -c Release

# 3. Executar o aplicativo console (demonstração das regras de negócio)
dotnet run --project EduTechPlatform.App

# 4. Executar os testes unitários (validação oficial — Dev 2, Tarefa 4)
dotnet test
```

Variações úteis do passo 4:

```bash
# 4.1 Mostra o nome e os parâmetros de cada cenário executado
dotnet test --logger "console;verbosity=normal"

# 4.2 Testes + relatório de cobertura (gera Cobertura XML em TestResults/)
dotnet test --collect:"XPlat Code Coverage" --settings coverlet.runsettings

# 4.3 Mesmo fluxo do CI: build com warnings tratados como erro + testes + cobertura
dotnet build -c Release /warnaserror
dotnet test -c Release --no-build --collect:"XPlat Code Coverage" --settings coverlet.runsettings
```

> ⚠️ **`error MSB1003: Especifique um arquivo de solução ou de projeto`.** A solução está no formato **`.slnx`**, que só é resolvido automaticamente a partir do **.NET SDK 10**. Se aparecer esse erro, verifique `dotnet --version` e, enquanto não atualizar o SDK, aponte o arquivo explicitamente: `dotnet test EduTechPlatform.slnx` (ou `dotnet test EduTechPlatform.Tests`).

### ✅ Evidência de execução

Saída esperada do `dotnet test`: **15 testes aprovados, 0 falhas**

```
Build succeeded.
    0 Warning(s)
    0 Error(s)

Test Run Successful.
Total tests: 15
     Passed: 15
 Total time: 1.3605 Seconds
```

Validado em **17/10/2026** com o **.NET SDK 10.0.402**. A saída completa, cenário por cenário, e a matriz de rastreabilidade *requisito × caso de teste × técnica* estão no **[Relatório de Qualidade](docs/RELATORIO-QUALIDADE.md)**.

### 📈 Cobertura de código (coverlet)

| Classe de serviço | Linhas | Branches |
|---|---|---|
| `NotaDesempenhoService` | **100%** (12/12) | **100%** |
| `FrequenciaService` | **100%** (4/4) | **100%** |
| `MatriculaFinanceiraService` | **100%** (12/12) | **100%** |
| **Total das regras de negócio** | **100%** (14/14) | **100%** (10/10) |

`Program.cs` é apenas o ponto de entrada de demonstração (sem regra de negócio) e por isso é excluído da medição em `coverlet.runsettings` — sem essa exclusão o índice total apareceria como ~36%, mascarando o resultado real.

## Testes Parametrizados com `[Theory]` e `[InlineData]` (Dev 2)

Os testes utilizam o atributo **`[Theory]`** do xUnit, que marca um método de teste como **parametrizado**: em vez de executar uma única vez, o método é executado **uma vez para cada conjunto de dados** fornecido pelos atributos **`[InlineData]`**. Cada `[InlineData]` representa um cenário com entradas e resultado esperado, permitindo cobrir múltiplas regras **sem duplicar código de teste**.

Cobertura implementada por suíte:

| Suíte de Testes | Método testado | Cenários (`[InlineData]`) |
|---|---|---|
| `NotaDesempenhoServiceTests` | `CalcularMediaPonderada` | `(7.0, 7.0, 7.0 → 7.0)` e `(10.0, 10.0, 5.0 → 8.0)` — `(30+30+20)/10 = 8.0` |
| | `ObterSituacaoAcademica` | `8.5 → APROVADO`, `6.0 → RECUPERACAO`, `4.2 → REPROVADO` |
| `FrequenciaServiceTests` | `CalcularPorcentagemPresenca` | `(80, 20 → 75.0%)` e `(100, 10 → 90.0%)` |
| | `AprovadoPorFrequencia` | `(80, 20 → true)` — exatamente 75%; `(80, 21 → false)` — abaixo de 75% |
| `MatriculaFinanceiraServiceTests` | `CalcularValorMensalidade` | Bolsista → `500.00`; não bolsista dia 4 → `900.00`; não bolsista dia 10 → `1000.00` |
| | `PodeRealizarRematricula` | Sem pendência + Aprovado → `true`; com pendência → `false`; Reprovado → `false` |

Os cenários incluem **caminho feliz**, **valores de fronteira** (ex.: exatamente 75% de presença) e **casos de bloqueio/falha**, garantindo que cada regra de negócio seja validada automaticamente a cada execução de `dotnet test`.

São **6 métodos `[Theory]`** que geram os **15 cenários** (2 + 3 + 2 + 2 + 3 + 3). A matriz completa **requisito × caso de teste × técnica de teste** (partição de equivalência, análise de valor-limite e tabela-decisão) está em [`docs/RELATORIO-QUALIDADE.md`](docs/RELATORIO-QUALIDADE.md#5-matriz-de-rastreabilidade--requisito--caso-de-teste).

## Gestão do Repositório (Dev 3)

| Item | Arquivo | Descrição |
|---|---|---|
| Repositório público | — | [`Lebot007/edutech-platform-xunit`](https://github.com/Lebot007/edutech-platform-xunit), branch padrão `main` |
| **`.gitignore`** | [`.gitignore`](.gitignore) | Template **oficial** do .NET (`dotnet new gitignore`, 482 linhas). Ignora artefatos de build (`bin/`, `obj/`, `artifacts/`, `publish/`), configurações locais de IDE (`.vs/`, `.idea/`, `.vshistory/` e `.vscode/*` com exceção de `settings.json`, `tasks.json`, `launch.json` e `extensions.json`), arquivos de usuário (`*.user`, `*.suo`, `*.userprefs`), credenciais (`.env`, `*.pfx`, `*.publishsettings`) e resultados de teste (`[Tt]est[Rr]esult*/`, `TestResult.xml`, `coverage*.xml`) |
| **Licença MIT** | [`LICENSE`](LICENSE) | Licença permissiva: permite uso, cópia, modificação e distribuição, exigindo apenas a manutenção do aviso de copyright e isentando os autores de responsabilidade. Reconhecida automaticamente pelo GitHub |
| Quebras de linha | [`.gitattributes`](.gitattributes) | `* text=auto` normaliza para **LF** no repositório; `*.sh` força LF (obrigatório no Linux) e `*.ps1` força CRLF (compatibilidade Windows). Evita diffs inteiros "sujos" ao trocar de sistema operacional |
| SDK fixado | [`global.json`](global.json) | SDK **10.0.402**, `rollForward: latestFeature` |
| Estilo de código | [`.editorconfig`](.editorconfig) | Indentação, codificação e nomenclatura C# padronizadas |

### Convenção de commits

Os commits seguem o padrão **[Conventional Commits](https://www.conventionalcommits.org/)** com o papel do desenvolvedor no escopo, o que permite ler o histórico como um relatório de entregas:

| Prefixo | Papel | Exemplo |
|---|---|---|
| `feat(dev1)` | Regras de Serviço (Backend/Core) | `feat(dev1): estrutura da solução .NET 10 e regras de negócio` |
| `test(dev2)` | Qualidade e Testes | `test(dev2): suítes de testes parametrizados com xUnit` |
| `docs(dev3)` / `ci(dev3)` | Documentação e DevOps | `docs(dev3): README técnico, licença MIT e .gitignore` |

### Publicação automatizada

Os scripts **`publicar.ps1`** (Windows/PowerShell) e **`publicar.sh`** (Linux/macOS) automatizam, **em um único comando**, todo o fluxo de validação e versionamento:

1. Verificação dos pré-requisitos (git, **.NET SDK 10**, `gh` autenticado e **identidade do git configurada**);
2. `dotnet restore` + `dotnet build /warnaserror` + `dotnet test` — a publicação **é abortada** se qualquer teste falhar;
3. Geração do relatório de cobertura (coverlet);
4. Commits semânticos separados por papel (Dev 1, Dev 2 e Dev 3);
5. Publicação: cria o repositório **público** `edutech-platform-xunit` na primeira execução (via GitHub CLI) ou apenas envia os commits se o `origin` já existir.

```powershell
# Windows (PowerShell no VS Code)
.\publicar.ps1
```

```bash
# Linux / macOS (Git Bash no Windows também funciona)
bash publicar.sh
```

## Integração Contínua (Dev 3)

O workflow [`.github/workflows/ci.yml`](.github/workflows/ci.yml) roda automaticamente em todo **push no `main`**, em todo **Pull Request** e também manualmente (`workflow_dispatch`):

| # | Etapa | Ação / Comando |
|---|---|---|
| 1 | Checkout | `actions/checkout@v4` |
| 2 | SDK do .NET (versão do `global.json`) | `actions/setup-dotnet@v6` |
| 3 | Restauração | `dotnet restore` |
| 4 | Compilação em Release | `dotnet build -c Release /warnaserror` |
| 5 | Testes + cobertura | `dotnet test --collect:"XPlat Code Coverage" --settings coverlet.runsettings` |
| 6 | Artefatos | `test-results-trx` e `code-coverage-cobertura` |

O resultado fica visível no badge no topo deste README e em **[Actions](https://github.com/Lebot007/edutech-platform-xunit/actions)**. É essa automação que impede que um commit quebrado permaneça no `main` sem que a equipe perceba.

> 🔐 **Recomendação:** ativar a proteção do branch `main` em *Settings → Branches → Add branch protection rule*, marcando *Require a pull request before merging*, *Require status checks to pass* (selecionando **`Build & Test (.NET 10)`**), *Do not allow force pushes* e *Do not allow deletions*.

## Divisão do Trabalho

A lista de exercícios prevê equipes de **até 05 alunos** com **entregas individuais**. Os papéis foram divididos entre os **4 integrantes** da equipe ([Equipe](#equipe)) assim:

| Papel | Responsabilidade | Integrante(s) | Arquivos entregues |
|---|---|---|---|
| **Dev 1** | Regras de Serviço (Backend / Core) | Rafael Luiz Ferreira de Souza | `EduTechPlatform.slnx`, `EduTechPlatform.App/*` (`NotaDesempenhoService`, `FrequenciaService`, `MatriculaFinanceiraService`, `Program.cs`) |
| **Dev 2** | Qualidade e Testes (xUnit) | João Vitor Alves Rodrigues | `EduTechPlatform.Tests/*`, `coverlet.runsettings`, `docs/RELATORIO-QUALIDADE.md` |
| **Dev 3** | Documentação e DevOps / Versionamento | Pietro Cardoso de Oliveira e Pedro Henrique Martins | `README.md`, `LICENSE`, `.gitignore`, `.gitattributes`, `global.json`, `.editorconfig`, `.github/workflows/ci.yml`, `publicar.ps1`, `publicar.sh` |

**Contribuidores do repositório:** cada integrante precisa ter ao menos um commit autoral para aparecer na lista de contribuidores → **[Contributors](https://github.com/Lebot007/edutech-platform-xunit/graphs/contributors)**.

> ⚠️ **Atenção para as entregas individuais.** No GitHub, o que vincula um commit a um usuário é o **e-mail do autor**, que precisa estar cadastrado na conta de cada integrante. Antes de commitar, cada aluno deve configurar a própria identidade:
>
> ```bash
> git config user.name  "Seu Nome Completo"
> git config user.email "SEU-ID+SEU-LOGIN@users.noreply.github.com"
> ```
>
> O e-mail exato pode ser consultado em <https://github.com/settings/emails>. Commits feitos sem essa configuração — ou com e-mail não vinculado à conta — aparecem como *unlinked* e **não contam** como contribuição visível.
>
> ⛔ **Nunca use `git push --force` no `main`.** Além de apagar o trabalho dos colegas, o force-push **remove os contribuidores** da lista do GitHub — já aconteceu duas vezes durante o desenvolvimento desta atividade.

## Licença

Este projeto está licenciado sob a [MIT License](LICENSE).

