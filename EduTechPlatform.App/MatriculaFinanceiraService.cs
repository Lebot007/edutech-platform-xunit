namespace EduTechPlatform.App;

/// <summary>
/// Serviço responsável pelas regras de negócio financeiras de matrícula (Dev 1 - Tarefa 4).
/// </summary>
public class MatriculaFinanceiraService
{
    /// <summary>
    /// Calcula o valor da mensalidade conforme bolsa e pontualidade de pagamento.
    /// Regras:
    /// - Se eBolsista == true: desconto fixo de 50% (valorBase * 0.50m),
    ///   independentemente do dia de pagamento;
    /// - Se não for bolsista e pagar até o dia 5: desconto de 10% por
    ///   pontualidade (valorBase * 0.90m);
    /// - Se não for bolsista e pagar após o dia 5: valor integral (valorBase).
    /// </summary>
    /// <param name="valorBase">Valor base da mensalidade.</param>
    /// <param name="diaPagamento">Dia do mês em que o pagamento será realizado.</param>
    /// <param name="eBolsista">Indica se o aluno é bolsista.</param>
    /// <returns>O valor final da mensalidade a ser pago.</returns>
    public decimal CalcularValorMensalidade(decimal valorBase, int diaPagamento, bool eBolsista)
    {
        if (eBolsista)
        {
            return valorBase * 0.50m;
        }

        if (diaPagamento <= 5)
        {
            return valorBase * 0.90m;
        }

        return valorBase;
    }

    /// <summary>
    /// Verifica se o aluno pode realizar a rematrícula.
    /// Retorna true apenas se possuiPendenciaFinanceira == false E a
    /// situacaoAcademica NÃO for "REPROVADO".
    /// </summary>
    /// <param name="possuiPendenciaFinanceira">Indica se o aluno possui pendência financeira.</param>
    /// <param name="situacaoAcademica">Situação acadêmica do aluno ("APROVADO", "RECUPERACAO" ou "REPROVADO").</param>
    /// <returns>True se o aluno estiver elegível para rematrícula; caso contrário, false.</returns>
    public bool PodeRealizarRematricula(bool possuiPendenciaFinanceira, string situacaoAcademica)
    {
        return !possuiPendenciaFinanceira && situacaoAcademica != "REPROVADO";
    }
}
