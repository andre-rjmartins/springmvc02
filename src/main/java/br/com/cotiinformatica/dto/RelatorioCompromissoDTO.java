package br.com.cotiinformatica.dto;

import br.com.cotiinformatica.enums.FormatoRelatorio;

public class RelatorioCompromissoDTO {

	private String dataInicio;
	private String dataFim;
	private FormatoRelatorio formato;

	public String getDataInicio() {
		return dataInicio;
	}

	public void setDataInicio(String dataInicio) {
		this.dataInicio = dataInicio;
	}

	public String getDataFim() {
		return dataFim;
	}

	public void setDataFim(String dataFim) {
		this.dataFim = dataFim;
	}

	public FormatoRelatorio getFormato() {
		return formato;
	}

	public void setFormato(FormatoRelatorio formato) {
		this.formato = formato;
	}

}
