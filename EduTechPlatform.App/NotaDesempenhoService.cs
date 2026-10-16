namespace EduTechPlatform.App;

/// <summary>
/// Serviço responsável pelas regras de negócio de notas e desempenho acadêmico (Dev 1 - Tarefa 2).
/// </summary>
public class NotaDesempenhoService
{
    /// <summary>
    /// Calcula a média ponderada do aluno.
    /// Pesos: Nota 1 (peso 3), Nota 2 (peso 3), Nota Projeto (peso 4).
    /// Fórmula: ((nota1 * 3) + (nota2 * 3) + (notaProjeto * 4)) / 10.
    /// </summary>
    /// <param name="nota1">Primeira nota do aluno.</param>
    /// <param name="nota2">Segunda nota do aluno.</param>
    /// <param name="notaProjeto">Nota do projeto do aluno.</param>
    /// <returns>A média final ponderada.</returns>
    public decimal CalcularMediaPonderada(decimal nota1, decimal nota2, decimal notaProjeto)
    {
        return ((nota1 * 3) + (nota2 * 3) + (notaProjeto * 4)) / 10;
    }

    /// <summary>
    /// Obtém a situação acadêmica do aluno com base na média final.
    /// Regras:
    /// - mediaFinal >= 7.0m  -> "APROVADO";
    /// - mediaFinal entre 5.0m e 6.99m -> "RECUPERACAO";
    /// - mediaFinal < 5.0m   -> "REPROVADO".
    /// </summary>
    /// <param name="mediaFinal">Média final ponderada do aluno.</param>
    /// <returns>A situação acadêmica: "APROVADO", "RECUPERACAO" ou "REPROVADO".</returns>
    public string ObterSituacaoAcademica(decimal mediaFinal)
    {
        if (mediaFinal >= 7.0m)
        {
            return "APROVADO";
        }

        if (mediaFinal >= 5.0m)
        {
            return "RECUPERACAO";
        }

        return "REPROVADO";
    }
}
