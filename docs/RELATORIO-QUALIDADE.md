# 🧪 Relatório de Garantia da Qualidade — EduTechPlatform

**Disciplina:** Garantia da Qualidade de Software — Gestão e Qualidade de Software
**Professor:** Daniel Henrique Matos de Paiva
**Repositório:** [Lebot007/edutech-platform-xunit](https://github.com/Lebot007/edutech-platform-xunit)
**Base validada:** commit `41d08d6` (`main`)
**Data da validação:** 17/10/2026
**Ambiente:** .NET SDK **10.0.402** · xUnit **2.9.3** · xunit.runner.visualstudio **3.1.4** · Microsoft.NET.Test.Sdk **17.14.1** · coverlet.collector **6.0.4**

---

## 1. Objetivo

Registrar a **evidência de validação** exigida pela **Tarefa 4 do Desenvolvedor 2** ("Execução e Validação"), documentando a rastreabilidade entre cada regra de negócio descrita na lista de exercícios e o caso de teste que a verifica, os indicadores de cobertura de código e as não conformidades de gestão de configuração encontradas durante a revisão final.

---

## 2. Comandos executados

```bash
dotnet restore
dotnet build --configuration Release --no-restore /warnaserror
dotnet test  --configuration Release --no-build --logger "console;verbosity=normal"
dotnet test  --configuration Release --no-build --collect:"XPlat Code Coverage" --settings coverlet.runsettings
```

---

## 3. Resultado da compilação

```
EduTechPlatform.App   -> bin/Release/net10.0/EduTechPlatform.App.dll
EduTechPlatform.Tests -> bin/Release/net10.0/EduTechPlatform.Tests.dll

Build succeeded.
    0 Warning(s)
    0 Error(s)
```

A compilação foi feita com `/warnaserror` (qualquer aviso vira erro), que é o mesmo critério usado pelo pipeline de CI.

---

## 4. Resultado da execução dos testes (`dotnet test`)

```
Test run for EduTechPlatform.Tests/bin/Release/net10.0/EduTechPlatform.Tests.dll (.NETCoreApp,Version=v10.0)
A total of 1 test files matched the specified pattern.
[xUnit.net] xUnit.net VSTest Adapter v3.1.4 (64-bit .NET 10.0.13)
[xUnit.net]   Discovering: EduTechPlatform.Tests
[xUnit.net]   Discovered:  EduTechPlatform.Tests
[xUnit.net]   Starting:    EduTechPlatform.Tests

  Passed NotaDesempenhoServiceTests.CalcularMediaPonderada_DeveRetornarMediaEsperada(nota1: 7,  nota2: 7,  notaProjeto: 7, mediaEsperada: 7)
  Passed NotaDesempenhoServiceTests.CalcularMediaPonderada_DeveRetornarMediaEsperada(nota1: 10, nota2: 10, notaProjeto: 5, mediaEsperada: 8)
  Passed NotaDesempenhoServiceTests.ObterSituacaoAcademica_DeveRetornarSituacaoEsperada(mediaFinal: 8.5, situacaoEsperada: "APROVADO")
  Passed NotaDesempenhoServiceTests.ObterSituacaoAcademica_DeveRetornarSituacaoEsperada(mediaFinal: 6,   situacaoEsperada: "RECUPERACAO")
  Passed NotaDesempenhoServiceTests.ObterSituacaoAcademica_DeveRetornarSituacaoEsperada(mediaFinal: 4.2, situacaoEsperada: "REPROVADO")
  Passed FrequenciaServiceTests.CalcularPorcentagemPresenca_DeveRetornarPercentualEsperado(aulasTotais: 80,  faltas: 20, percentualEsperado: 75)
  Passed FrequenciaServiceTests.CalcularPorcentagemPresenca_DeveRetornarPercentualEsperado(aulasTotais: 100, faltas: 10, percentualEsperado: 90)
  Passed FrequenciaServiceTests.AprovadoPorFrequencia_DeveRetornarResultadoEsperado(aulasTotais: 80, faltas: 20, aprovadoEsperado: True)
  Passed FrequenciaServiceTests.AprovadoPorFrequencia_DeveRetornarResultadoEsperado(aulasTotais: 80, faltas: 21, aprovadoEsperado: False)
  Passed MatriculaFinanceiraServiceTests.CalcularValorMensalidade_DeveRetornarValorEsperado(valorBase: 1000, diaPagamento: 10, eBolsista: True,  valorEsperado: 500)
  Passed MatriculaFinanceiraServiceTests.CalcularValorMensalidade_DeveRetornarValorEsperado(valorBase: 1000, diaPagamento: 4,  eBolsista: False, valorEsperado: 900)
  Passed MatriculaFinanceiraServiceTests.CalcularValorMensalidade_DeveRetornarValorEsperado(valorBase: 1000, diaPagamento: 10, eBolsista: False, valorEsperado: 1000)
  Passed MatriculaFinanceiraServiceTests.PodeRealizarRematricula_DeveRetornarElegibilidadeEsperada(possuiPendenciaFinanceira: False, situacaoAcademica: "APROVADO",  podeEsperado: True)
  Passed MatriculaFinanceiraServiceTests.PodeRealizarRematricula_DeveRetornarElegibilidadeEsperada(possuiPendenciaFinanceira: True,  situacaoAcademica: "APROVADO",  podeEsperado: False)
  Passed MatriculaFinanceiraServiceTests.PodeRealizarRematricula_DeveRetornarElegibilidadeEsperada(possuiPendenciaFinanceira: False, situacaoAcademica: "REPROVADO", podeEsperado: False)

[xUnit.net]   Finished:    EduTechPlatform.Tests

Test Run Successful.
Total tests: 15
     Passed: 15
 Total time: 1.3605 Seconds
```

**Resumo:** `Failed: 0 · Passed: 15 · Skipped: 0 · Total: 15` ✅

> Os 15 casos são gerados a partir de **6 métodos** marcados com `[Theory]`, cada um expandido pelos seus atributos `[InlineData]`: 2 + 3 + 2 + 2 + 3 + 3 = **15 cenários**.

---

## 5. Matriz de rastreabilidade — Requisito × Caso de Teste

### 5.1 `NotaDesempenhoService` (Dev 1 — Tarefa 2)

| # | Requisito da lista | Método testado | Entrada (`[InlineData]`) | Saída esperada | Técnica de teste | Resultado |
|---|---|---|---|---|---|---|
| R1.1 | Média ponderada com pesos 3, 3 e 4 | `CalcularMediaPonderada` | `7.0, 7.0, 7.0` | `7.0` | Valor típico | ✅ |
| R1.2 | Fórmula `((n1*3)+(n2*3)+(np*4))/10` | `CalcularMediaPonderada` | `10.0, 10.0, 5.0` | `8.0` → `(30+30+20)/10` | Valor típico (pesos distintos) | ✅ |
| R1.3 | `mediaFinal >= 7.0` → `APROVADO` | `ObterSituacaoAcademica` | `8.5` | `"APROVADO"` | Partição de equivalência | ✅ |
| R1.4 | `5.0 <= mediaFinal <= 6.99` → `RECUPERACAO` | `ObterSituacaoAcademica` | `6.0` | `"RECUPERACAO"` | Partição de equivalência | ✅ |
| R1.5 | `mediaFinal < 5.0` → `REPROVADO` | `ObterSituacaoAcademica` | `4.2` | `"REPROVADO"` | Partição de equivalência | ✅ |

### 5.2 `FrequenciaService` (Dev 1 — Tarefa 3)

| # | Requisito da lista | Método testado | Entrada (`[InlineData]`) | Saída esperada | Técnica de teste | Resultado |
|---|---|---|---|---|---|---|
| R2.1 | `((aulas - faltas) / (double)aulas) * 100` | `CalcularPorcentagemPresenca` | `80, 20` | `75.0` | Valor típico | ✅ |
| R2.2 | Idem, com outra base de aulas | `CalcularPorcentagemPresenca` | `100, 10` | `90.0` | Valor típico | ✅ |
| R2.3 | Presença mínima de 75% → `true` | `AprovadoPorFrequencia` | `80, 20` | `true` | **Análise de valor-limite** (exatamente 75%) | ✅ |
| R2.4 | Abaixo de 75% → `false` | `AprovadoPorFrequencia` | `80, 21` | `false` | **Análise de valor-limite** (73,75%) | ✅ |

### 5.3 `MatriculaFinanceiraService` (Dev 1 — Tarefa 4)

| # | Requisito da lista | Método testado | Entrada (`[InlineData]`) | Saída esperada | Técnica de teste | Resultado |
|---|---|---|---|---|---|---|
| R3.1 | Bolsista → desconto fixo de 50%, independente do dia | `CalcularValorMensalidade` | `1000.00, 10, true` | `500.00` | Partição de equivalência | ✅ |
| R3.2 | Não bolsista, pagamento até o dia 5 → 10% off | `CalcularValorMensalidade` | `1000.00, 4, false` | `900.00` | **Valor-limite** (dia < 5) | ✅ |
| R3.3 | Não bolsista, pagamento após o dia 5 → valor integral | `CalcularValorMensalidade` | `1000.00, 10, false` | `1000.00` | **Valor-limite** (dia > 5) | ✅ |
| R3.4 | Sem pendência **E** não reprovado → permite rematrícula | `PodeRealizarRematricula` | `false, "APROVADO"` | `true` | Caminho feliz | ✅ |
| R3.5 | Com pendência financeira → bloqueia | `PodeRealizarRematricula` | `true, "APROVADO"` | `false` | Tabela-decisão (1ª condição falsa) | ✅ |
| R3.6 | Situação `REPROVADO` → bloqueia | `PodeRealizarRematricula` | `false, "REPROVADO"` | `false` | Tabela-decisão (2ª condição falsa) | ✅ |

**Total: 15 requisitos rastreáveis (R1.1–R1.5, R2.1–R2.4, R3.1–R3.6) cobertos por 15 cenários parametrizados — 1 requisito validado por 1 caso de teste, sem requisito órfão e sem teste sem requisito.**

### 5.4 Casos ainda não cobertos (oportunidade de melhoria)

Os cenários exigidos pela lista estão 100% atendidos. Para uma suíte de regressão mais robusta, sugere-se acrescentar futuramente:

| Cenário sugerido | Motivo |
|---|---|
| `ObterSituacaoAcademica(7.0)` e `(5.0)` | Fronteiras exatas entre `REPROVADO`/`RECUPERACAO`/`APROVADO` (hoje testadas só por dentro de cada classe de equivalência) |
| `AprovadoPorFrequencia(0, 0)` | Divisão por zero em `CalcularPorcentagemPresenca` → `NaN`; o comportamento esperado precisa ser definido |
| `CalcularValorMensalidade(1000, 5, false)` | Fronteira exata do dia 5 (`<=` vs. `<`) |
| `CalcularMediaPonderada` com valores negativos ou acima de 10 | Validação de entrada (hoje os métodos não validam domínio) |

---

## 6. Cobertura de código

Medição obtida com `--collect:"XPlat Code Coverage" --settings coverlet.runsettings` (formato Cobertura XML):

| Classe | Linhas cobertas | Cobertura de linhas | Cobertura de branches |
|---|---|---|---|
| `NotaDesempenhoService` | 12/12 | **100%** | **100%** |
| `FrequenciaService` | 4/4 | **100%** | **100%** |
| `MatriculaFinanceiraService` | 12/12 | **100%** | **100%** |
| **Total das regras de negócio** | **14/14** | **100%** | **100% (10/10)** |

> **Nota técnica sobre o escopo da medição.** `Program.cs` é o ponto de entrada de demonstração do projeto console: apenas instancia os serviços e imprime resultados no terminal, sem conter regra de negócio. Incluí-lo na medição derruba o índice total para **~36%** (14 de 39 linhas), o que mascara o resultado real. Por isso ele é excluído em `coverlet.runsettings` — critério documentado aqui para que a métrica seja auditável, e não inflada artificialmente.

---

## 7. Verificações de conformidade com a lista de exercícios

### 7.1 Regras gerais da lista

| Item | Status | Evidência |
|---|---|---|
| Algoritmos escritos em C# | ✅ | 3 classes de serviço + 3 suítes de teste em C# |
| Todos os algoritmos devidamente indentados | ✅ | 4 espaços em todos os arquivos; `.editorconfig` na raiz + `.gitattributes` (LF) |
| Equipe de até 05 alunos / entregas individuais | ⚠️ | Ver §9 — falta vincular os commits às contas dos demais integrantes |

### 7.2 Desenvolvedor 1 — Regras de Serviço

| Tarefa | Status | Evidência |
|---|---|---|
| T1 — Solução e projetos via .NET CLI | ✅ | `EduTechPlatform.slnx`; `App` (console, `net10.0`); `Tests` (xUnit, `net10.0`) com `ProjectReference` para o `App` |
| T2 — `NotaDesempenhoService` | ✅ | Pesos 3/3/4 e classificação `APROVADO`/`RECUPERACAO`/`REPROVADO` |
| T3 — `FrequenciaService` | ✅ | Percentual de presença e mínimo de 75% (`PercentualMinimoPresenca`) |
| T4 — `MatriculaFinanceiraService` | ✅ | Bolsa 50%, pontualidade 10% até o dia 5, valor integral; rematrícula |

### 7.3 Desenvolvedor 2 — Qualidade e Testes

| Tarefa | Status | Evidência |
|---|---|---|
| T1 — `NotaDesempenhoServiceTests` | ✅ | 2 `[Theory]` com os `[InlineData]` exatos da lista (5 cenários) |
| T2 — `FrequenciaServiceTests` | ✅ | 2 `[Theory]` com os `[InlineData]` exatos da lista (4 cenários) |
| T3 — `MatriculaFinanceiraServiceTests` | ✅ | 2 `[Theory]` com os `[InlineData]` exatos da lista (6 cenários) |
| **T4 — Execução e Validação (`dotnet test`)** | ✅ | **Seção 4 deste relatório: 15/15 aprovados, 0 falhas** |

### 7.4 Desenvolvedor 3 — Documentação e DevOps

| Tarefa | Status | Evidência |
|---|---|---|
| T1 — Repositório público `edutech-platform-xunit` | ✅ | [github.com/Lebot007/edutech-platform-xunit](https://github.com/Lebot007/edutech-platform-xunit) |
| T1 — `.gitignore` adequado para soluções .NET 10 | ✅ | Template oficial (`dotnet new gitignore`), 482 linhas; ignora `bin/`, `obj/`, `artifacts/`, `publish/`, `.vs/`, `.idea/`, `.vshistory/`, `*.user`, `*.suo`, `.env`, `*.pfx` e `[Tt]est[Rr]esult*/` / `coverage*.xml` |
| T1 — Licença MIT | ✅ | `LICENSE` (reconhecido pelo GitHub como MIT) |
| T2 — Visão geral da plataforma | ✅ | `README.md` → *Visão Geral* (+ *Estrutura da Solução* e os comandos da .NET CLI) |
| T2 — Requisitos do ambiente (.NET 10 SDK) | ✅ | `README.md` → *Requisitos do Ambiente* + `global.json` fixando o SDK 10.0.402 |
| T2 — Responsabilidade de cada uma das 3 classes | ✅ | `README.md` → *Classes de Serviço — Responsabilidades (Dev 1)*, itens 1, 2 e 3 |
| T2 — Guia de execução dos comandos CLI | ✅ | `README.md` → *Guia de Execução (CLI)*: restore, build, run, test, cobertura e evidência real |
| T2 — Explicação da cobertura com `[Theory]` e `[InlineData]` | ✅ | `README.md` → *Testes Parametrizados com `[Theory]` e `[InlineData]` (Dev 2)* |
| Contribuidores visíveis no repositório | ⚠️ | 2 integrantes (de até 5) com commit autoral — ver §9 |

---

## 8. Não conformidades encontradas durante a revisão final

| ID | Severidade | Tipo | Descrição | Ação corretiva |
|---|---|---|---|---|
| NC-01 | **Alta** | Gestão de configuração | O branch `main` sofreu **force-push** e teve o histórico reescrito: os commits `2a8af07` (Dev 3), `85fc43b` e `667597b` deixaram de existir no remoto. Junto com eles foram **removidos `README.md`, `LICENSE`, `publicar.ps1`, `publicar.sh` e `.github/`**, ou seja, **todo o entregável do Dev 3 desapareceu** e o repositório ficou sem documentação e sem licença. | `README.md` recriado por um integrante no commit `41d08d6`; os demais entregáveis do Dev 3 (`LICENSE`, `.github/`, `global.json`, `.editorconfig`, `publicar.*`) reconstruídos e revalidados nesta revisão. **Proteção do branch `main` recomendada** (ver §10) para impedir novo force-push. |
| NC-02 | **Alta** | Gestão de configuração | No estado anterior ao force-push, o commit `667597b` havia **excluído `EduTechPlatform.App/MatriculaFinanceiraService.cs`** do `main`, causando `CS0246` em `Program.cs`: o projeto **não compilava e nenhum teste rodava**. | Arquivo restaurado. O defeito motivou a criação do pipeline de CI, que passaria a bloquear esse tipo de commit. |
| NC-03 | Média | Processo | Ausência total de verificação automatizada: os testes só eram executados manualmente na máquina de quem lembrava de rodá-los — razão direta de NC-01 e NC-02 passarem despercebidos. | Adicionado `.github/workflows/ci.yml`: restore, build com `/warnaserror`, 15 testes e cobertura a cada push/PR, com badge no README e artefatos TRX/Cobertura. |
| NC-04 | Média | Processo | **Entregas individuais parcialmente evidenciadas**: o `main` passou a ter 2 autores (`@Lebot007` em `f70da29`/`bc9a233` e `@PedroHenriqueM2005` em `41d08d6`), mas a lista prevê equipe de até 05 alunos e os demais integrantes ainda não possuem commit autoral vinculado à própria conta. | Documentado no README (*Divisão do Trabalho*) o procedimento de identidade (`git config user.email` com o e-mail cadastrado na conta GitHub); cada integrante pendente precisa de ao menos 1 commit autoral ou Pull Request mergeado. |
| NC-05 | Baixa | Ambiente | Versão do SDK não fixada, permitindo divergência de comportamento entre as máquinas da equipe e o CI. | Adicionado `global.json` (SDK 10.0.402, `rollForward: latestFeature`), consumido automaticamente pelo `actions/setup-dotnet`. |
| NC-06 | Baixa | Documentação | O título do `README.md` (versão anterior ao force-push) continha texto indevido: `# 🎓 EduTechPlatform -0987654321`. | README reescrito; título corrigido. |
| NC-07 | Baixa | Produto | `coverlet.runsettings` inicialmente inválido: um comentário XML continha `--` (em `--collect:`), o que violava a especificação XML e fazia o `dotnet test` abortar com *"Settings file provided does not conform to required format"*. | Comentário reescrito sem `--`; arquivo validado por parser XML e pelo próprio `dotnet test`. |
| NC-08 | Melhoria | Produto | A medição de cobertura incluía `Program.cs` (ponto de entrada sem regra de negócio), distorcendo o indicador para ~36%. | Exclusão configurada em `coverlet.runsettings` e critério documentado na §6. |
| NC-09 | Média | Documentação | O `README.md` do commit `41d08d6` documentava arquivos que **não existiam** no repositório (`LICENSE`, `publicar.ps1`, `publicar.sh`) e o sumário apontava para uma seção *Divisão do Trabalho* que não estava escrita — 2 dos 10 links do sumário estavam quebrados. Além disso, faltavam as evidências de execução/cobertura e a descrição da gestão do repositório. | README **completado preservando integralmente o texto original do autor**: arquivos referenciados foram criados, âncoras do sumário corrigidas e verificadas uma a uma, e acrescentadas as seções *Gestão do Repositório*, *Integração Contínua* e *Divisão do Trabalho*. |
| NC-10 | Baixa | Ambiente | `dotnet test` executado na raiz da solução retorna `error MSB1003: Especifique um arquivo de solução ou de projeto` em SDKs anteriores ao .NET 10, porque a solução usa o formato **`.slnx`**. | Documentado no README (*Guia de Execução*) com o contorno `dotnet test EduTechPlatform.slnx`; o `global.json` passa a exigir SDK 10. Não reproduz no SDK 10.0.402, onde `dotnet test` sem argumentos funciona. |

---

## 9. Equipe, contribuidores e entregas individuais

Papéis definidos pela lista de exercícios:

| Papel | Responsabilidade | Arquivos entregues |
|---|---|---|
| **Dev 1** | Regras de Serviço (Backend/Core) | `EduTechPlatform.slnx`, `EduTechPlatform.App/*` |
| **Dev 2** | Qualidade e Testes (xUnit) | `EduTechPlatform.Tests/*`, `coverlet.runsettings`, este relatório |
| **Dev 3** | Documentação e DevOps/Versionamento | `README.md`, `LICENSE`, `.gitignore`, `.gitattributes`, `global.json`, `.editorconfig`, `.github/workflows/ci.yml`, `publicar.ps1`, `publicar.sh` |

**Situação atual dos contribuidores no GitHub** ([Contributors](https://github.com/Lebot007/edutech-platform-xunit/graphs/contributors)):

| Integrante | GitHub | Commits autorais no `main` |
|---|---|---|
| João Vitor Alves Rodrigues | [@Lebot007](https://github.com/Lebot007) | `f70da29` (Dev 1) e `bc9a233` (Dev 2) |
| Pedro Henrique Martins | [@PedroHenriqueM2005](https://github.com/PedroHenriqueM2005) | `41d08d6` (README) |
| Demais integrantes | — | ⚠️ **pendente** — necessário ao menos 1 commit autoral cada |

Para que os integrantes pendentes apareçam como contribuidores (requisito da lista), cada um deve:

1. Configurar a própria identidade **antes** de commitar — o e-mail precisa estar cadastrado na conta GitHub do aluno:
   ```bash
   git config user.name  "Nome Completo do Integrante"
   git config user.email "ID+login@users.noreply.github.com"
   ```
2. Fazer pelo menos um commit autoral no `main` (ou um Pull Request mergeado), mesmo que seja de revisão;
3. **Nunca** usar `git push --force` no `main`: além de apagar o trabalho dos colegas, isso **remove os contribuidores** da lista do GitHub, exatamente como ocorreu em NC-01.

---

## 10. Recomendações

1. **Proteger o branch `main`** (Settings → Branches → Branch protection rules): exigir Pull Request, impedir *force pushes* e *deletions*, e tornar o check `Build & Test (.NET 10)` obrigatório. Isso evita a repetição de NC-01 e NC-02.
2. **Usar Pull Requests** em vez de push direto: permite revisão por um segundo integrante e gera commits de merge que reforçam a autoria individual.
3. **Não commitar artefatos**: `bin/`, `obj/` e `TestResults/` já estão no `.gitignore`; mantê-los assim preserva o histórico limpo.
4. **Ampliar a suíte** com os casos de fronteira listados em §5.4 (dia 5 exato, média 7.0 e 5.0 exatas, `aulasTotais = 0`).
5. **Adicionar validação de entrada** nos serviços (notas fora de 0–10, `aulasTotais <= 0`, `diaPagamento` fora de 1–31), hoje inexistente, e testar o comportamento esperado.
6. **Configurar o GitHub Pages ou um badge de cobertura dinâmico** caso a disciplina passe a exigir acompanhamento contínuo do indicador.

---

## 11. Conclusão

As regras de negócio dos três domínios (desempenho acadêmico, frequência e financeiro/matrícula) estão implementadas **exatamente conforme a especificação** da lista de exercícios e são cobertas por **15 cenários de teste parametrizados** (`[Theory]` + `[InlineData]`), com **100% de cobertura de linhas e de branches** nas três classes de serviço. O `dotnet test` é executado com sucesso (`Failed: 0 · Passed: 15`) e passa a ser verificado automaticamente pelo CI a cada push ou Pull Request.

Os entregáveis dos três papéis estão presentes no repositório. As duas pendências remanescentes **não são técnicas, mas de processo**: (i) vincular os commits às contas GitHub dos demais integrantes para evidenciar as entregas individuais e (ii) proteger o `main` contra novos force-pushes, que já causaram perda de entregáveis duas vezes durante o desenvolvimento.
