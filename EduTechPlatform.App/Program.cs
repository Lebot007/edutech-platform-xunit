using EduTechPlatform.App;

// ============================================================
// EduTechPlatform - Demonstração das regras de negócio (Dev 1)
// A validação oficial é feita pelos testes unitários (Dev 2):
//   dotnet test
// ============================================================

var notaService = new NotaDesempenhoService();
var frequenciaService = new FrequenciaService();
var financeiraService = new MatriculaFinanceiraService();

Console.WriteLine("=== EduTechPlatform - Demonstração ===");
Console.WriteLine();

// Domínio 1: Notas e desempenho
decimal nota1 = 7.0m, nota2 = 8.0m, notaProjeto = 9.0m;
decimal media = notaService.CalcularMediaPonderada(nota1, nota2, notaProjeto);
Console.WriteLine($"Notas: {nota1} | {nota2} | Projeto: {notaProjeto}");
Console.WriteLine($"Média ponderada (pesos 3, 3, 4): {media}");
Console.WriteLine($"Situação acadêmica: {notaService.ObterSituacaoAcademica(media)}");
Console.WriteLine();

// Domínio 2: Frequência
int aulasTotais = 80, faltas = 12;
double presenca = frequenciaService.CalcularPorcentagemPresenca(aulasTotais, faltas);
Console.WriteLine($"Aulas: {aulasTotais} | Faltas: {faltas}");
Console.WriteLine($"Percentual de presença: {presenca:F2}%");
Console.WriteLine($"Aprovado por frequência (mín. 75%): {frequenciaService.AprovadoPorFrequencia(aulasTotais, faltas)}");
Console.WriteLine();

// Domínio 3: Matrícula financeira
decimal valorBase = 1000m;
Console.WriteLine($"Mensalidade base: {valorBase:C}");
Console.WriteLine($"Bolsista:                  {financeiraService.CalcularValorMensalidade(valorBase, 10, true):C}");
Console.WriteLine($"Não bolsista, dia 4:       {financeiraService.CalcularValorMensalidade(valorBase, 4, false):C}");
Console.WriteLine($"Não bolsista, dia 10:      {financeiraService.CalcularValorMensalidade(valorBase, 10, false):C}");
Console.WriteLine($"Rematrícula (sem pendência, APROVADO):  {financeiraService.PodeRealizarRematricula(false, "APROVADO")}");
Console.WriteLine($"Rematrícula (com pendência, APROVADO):  {financeiraService.PodeRealizarRematricula(true, "APROVADO")}");
Console.WriteLine($"Rematrícula (sem pendência, REPROVADO): {financeiraService.PodeRealizarRematricula(false, "REPROVADO")}");
