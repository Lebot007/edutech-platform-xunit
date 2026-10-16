using EduTechPlatform.App;

namespace EduTechPlatform.Tests;

/// <summary>
/// Suíte de testes parametrizados para a classe NotaDesempenhoService (Dev 2 - Tarefa 1).
/// </summary>
public class NotaDesempenhoServiceTests
{
    private readonly NotaDesempenhoService _service = new();

    // Teste 1: Média Ponderada (pesos 3, 3 e 4)
    [Theory]
    [InlineData(7.0, 7.0, 7.0, 7.0)]
    [InlineData(10.0, 10.0, 5.0, 8.0)] // (30 + 30 + 20) / 10 = 8.0
    public void CalcularMediaPonderada_DeveRetornarMediaEsperada(
        double nota1, double nota2, double notaProjeto, double mediaEsperada)
    {
        // Act
        decimal resultado = _service.CalcularMediaPonderada(
            (decimal)nota1, (decimal)nota2, (decimal)notaProjeto);

        // Assert
        Assert.Equal((decimal)mediaEsperada, resultado);
    }

    // Teste 2: Situação Acadêmica
    [Theory]
    [InlineData(8.5, "APROVADO")]
    [InlineData(6.0, "RECUPERACAO")]
    [InlineData(4.2, "REPROVADO")]
    public void ObterSituacaoAcademica_DeveRetornarSituacaoEsperada(
        double mediaFinal, string situacaoEsperada)
    {
        // Act
        string resultado = _service.ObterSituacaoAcademica((decimal)mediaFinal);

        // Assert
        Assert.Equal(situacaoEsperada, resultado);
    }
}
