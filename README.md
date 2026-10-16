# EduTechPlatform

> Plataforma acadêmica de **gestão de notas, frequência e financeiro de alunos**.

![.NET](https://img.shields.io/badge/.NET-10.0-512BD4?logo=dotnet&logoColor=white)
![xUnit](https://img.shields.io/badge/tests-xUnit-green)
![License](https://img.shields.io/badge/license-MIT-blue)

Projeto desenvolvido como atividade da disciplina **Garantia da Qualidade de Software** (Gestão e Qualidade de Software — Prof. Daniel Henrique Matos de Paiva).

O projeto demonstra boas práticas de qualidade de software:

- **Separação de responsabilidades**: cada domínio de negócio possui sua própria classe de serviço;
- **Testes unitários automatizados**: cobertura das regras de negócio com **xUnit** e testes parametrizados (`[Theory]` + `[InlineData]`);
- **Versionamento e documentação**: repositório público com `.gitignore` oficial do .NET, licença MIT, README técnico e commits semânticos.

---

## Sumário

- [Visão Geral](#visão-geral)
- [Estrutura da Solução](#estrutura-da-solução)
- [Requisitos do Ambiente](#requisitos-do-ambiente)
- [Classes de Serviço](#classes-de-serviço--responsabilidades-dev-1)
- [Guia de Execução](#guia-de-execução-cli)
- [Testes Parametrizados](#testes-parametrizados-com-theory-e-inlinedata-dev-2)
- [Publicação do Repositório](#publicação-do-repositório-dev-3)
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

## Estrutura da Solução

```
edutech-platform-xunit/
├── EduTechPlatform.slnx                  # Solução (.NET 10 — formato slnx gerado por `dotnet new sln`)
├── EduTechPlatform.App/                  # Projeto console — regras de negócio (Dev 1)
│   ├── NotaDesempenhoService.cs
│   ├── FrequenciaService.cs
│   ├── MatriculaFinanceiraService.cs
│   └── Program.cs                        # Demonstração de uso dos serviços
├── EduTechPlatform.Tests/                # Projeto de testes xUnit (Dev 2)
│   ├── NotaDesempenhoServiceTests.cs
│   ├── FrequenciaServiceTests.cs
│   └── MatriculaFinanceiraServiceTests.cs
├── .gitignore                            # Ignora bin/, obj/, .vs/ etc. (Dev 3)
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

> Recomendado: **Visual Studio Code** com a extensão **C# Dev Kit** para abrir a solução `EduTechPlatform.slnx`.

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
# 1. Restaurar as dependências (pacotes NuGet)
dotnet restore

# 2. Compilar a solução
dotnet build

# 3. Executar o aplicativo console (demonstração das regras de negócio)
dotnet run --project EduTechPlatform.App

# 4. Executar os testes unitários (validação oficial — Dev 2, Tarefa 4)
dotnet test
```

Saída esperada do `dotnet test`: **15 testes aprovados, 0 falhas**

```
Passed!  - Failed: 0, Passed: 15, Skipped: 0, Total: 15
```

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

## Publicação do Repositório (Dev 3)

Os scripts `publicar.ps1` (Windows/PowerShell) e `publicar.sh` (Linux/macOS) automatizam, **em um único comando**, todo o fluxo de versionamento:

1. Verificação dos pré-requisitos (git, `gh` autenticado e identidade do git);
2. Execução dos testes (`dotnet test`) — a publicação só continua se tudo passar;
3. `git init` + commits semânticos separados por papel (Dev 1, Dev 2 e Dev 3);
4. Criação do repositório **público** `edutech-platform-xunit` no GitHub via GitHub CLI e `git push`.

```powershell
# Windows (PowerShell no VS Code)
.\publicar.ps1
```

```bash
# Linux / macOS
bash publicar.sh
```
## Licença

Este projeto está licenciado sob a [MIT License](LICENSE).
