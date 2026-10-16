using EduTechPlatform.App;

namespace EduTechPlatform.Tests;

/// <summary>
/// Suíte de testes parametrizados para a classe MatriculaFinanceiraService (Dev 2 - Tarefa 3).
/// </summary>
public class MatriculaFinanceiraServiceTests
{
    private readonly MatriculaFinanceiraService _service = new();

    // Teste 1: Cálculo da Mensalidade
    [Theory]
    [InlineData(1000.00, 10, true, 500.00)]   // Bolsista -> 50% off
    [InlineData(1000.00, 4, false, 900.00)]   // Não bolsista, paga dia 4 -> 10% off
    [InlineData(1000.00, 10, false, 1000.00)] // Não bolsista, paga dia 10 -> sem desconto
    public void CalcularValorMensalidade_DeveRetornarValorEsperado(
        double valorBase, int diaPagamento, bool eBolsista, double valorEsperado)
    {
        // Act
        decimal resultado = _service.CalcularValorMensalidade(
            (decimal)valorBase, diaPagamento, eBolsista);

        // Assert
        Assert.Equal((decimal)valorEsperado, resultado);
    }

    // Teste 2: Elegibilidade para Rematrícula
    [Theory]
    [InlineData(false, "APROVADO", true)]   // Sem pendência + Aprovado -> Permite
    [InlineData(true, "APROVADO", false)]   // Com pendência + Aprovado -> Bloqueia
    [InlineData(false, "REPROVADO", false)] // Sem pendência + Reprovado -> Bloqueia
    public void PodeRealizarRematricula_DeveRetornarElegibilidadeEsperada(
        bool possuiPendenciaFinanceira, string situacaoAcademica, bool podeEsperado)
    {
        // Act
        bool resultado = _service.PodeRealizarRematricula(
            possuiPendenciaFinanceira, situacaoAcademica);

        // Assert
        Assert.Equal(podeEsperado, resultado);
    }
}
