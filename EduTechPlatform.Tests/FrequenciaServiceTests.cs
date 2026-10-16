using EduTechPlatform.App;

namespace EduTechPlatform.Tests;

/// <summary>
/// Suíte de testes parametrizados para a classe FrequenciaService (Dev 2 - Tarefa 2).
/// </summary>
public class FrequenciaServiceTests
{
    private readonly FrequenciaService _service = new();

    // Teste 1: Cálculo de Percentual de Presença
    [Theory]
    [InlineData(80, 20, 75.0)]  // 60 presenças em 80 aulas = 75%
    [InlineData(100, 10, 90.0)] // 90 presenças em 100 aulas = 90%
    public void CalcularPorcentagemPresenca_DeveRetornarPercentualEsperado(
        int aulasTotais, int faltas, double percentualEsperado)
    {
        // Act
        double resultado = _service.CalcularPorcentagemPresenca(aulasTotais, faltas);

        // Assert
        Assert.Equal(percentualEsperado, resultado, precision: 2);
    }

    // Teste 2: Aprovação por Frequência (mínimo de 75%)
    [Theory]
    [InlineData(80, 20, true)]  // 75% de presença -> Aprovado
    [InlineData(80, 21, false)] // Abaixo de 75% -> Reprovado por falta
    public void AprovadoPorFrequencia_DeveRetornarResultadoEsperado(
        int aulasTotais, int faltas, bool aprovadoEsperado)
    {
        // Act
        bool resultado = _service.AprovadoPorFrequencia(aulasTotais, faltas);

        // Assert
        Assert.Equal(aprovadoEsperado, resultado);
    }
}
