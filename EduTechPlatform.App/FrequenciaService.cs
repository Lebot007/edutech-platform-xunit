namespace EduTechPlatform.App;

/// <summary>
/// Serviço responsável pelas regras de negócio de frequência do aluno (Dev 1 - Tarefa 3).
/// </summary>
public class FrequenciaService
{
    /// <summary>
    /// Percentual mínimo de presença exigido para aprovação por frequência.
    /// </summary>
    public const double PercentualMinimoPresenca = 75.0;

    /// <summary>
    /// Calcula o percentual de presença do aluno.
    /// Fórmula: ((aulasTotais - faltas) / (double)aulasTotais) * 100.
    /// </summary>
    /// <param name="aulasTotais">Total de aulas ministradas.</param>
    /// <param name="faltas">Quantidade de faltas do aluno.</param>
    /// <returns>O percentual de presença (ex.: 75.0 para 75%).</returns>
    public double CalcularPorcentagemPresenca(int aulasTotais, int faltas)
    {
        return ((aulasTotais - faltas) / (double)aulasTotais) * 100;
    }

    /// <summary>
    /// Verifica se o aluno foi aprovado por frequência.
    /// O aluno precisa ter no mínimo 75% de presença para ser aprovado (true).
    /// Caso contrário, retorna false.
    /// </summary>
    /// <param name="aulasTotais">Total de aulas ministradas.</param>
    /// <param name="faltas">Quantidade de faltas do aluno.</param>
    /// <returns>True se a presença for maior ou igual a 75%; caso contrário, false.</returns>
    public bool AprovadoPorFrequencia(int aulasTotais, int faltas)
    {
        return CalcularPorcentagemPresenca(aulasTotais, faltas) >= PercentualMinimoPresenca;
    }
}
