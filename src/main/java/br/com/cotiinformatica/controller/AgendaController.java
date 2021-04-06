package br.com.cotiinformatica.controller;

import java.util.Date;
import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import br.com.cotiinformatica.entities.Compromisso;
import br.com.cotiinformatica.entities.Usuario;
import br.com.cotiinformatica.enums.PrioridadeCompromisso;
import br.com.cotiinformatica.enums.TipoCompromisso;
import br.com.cotiinformatica.services.CompromissoService;

@Controller
public class AgendaController {

	@Autowired
	private CompromissoService compromissoService;
	
	@RequestMapping("/home")
	public ModelAndView home(HttpServletRequest request) {
		
		ModelAndView modelAndView = new ModelAndView();
		
		//variáveis para capturar os valores totais
		Integer totalTipoFamilia = 0;
		Integer totalTipoEstudo = 0;
		Integer totalTipoTrabalho = 0;
		Integer totalTipoLazer = 0;
		
		Integer totalPrioridadeAlta = 0;
		Integer totalPrioridadeMedia = 0;
		Integer totalPrioridadeBaixa = 0;
		
		//obtendo o usuário armazenado na sessão..
		Usuario usuario = (Usuario) request.getSession().getAttribute("usuario_autenticado");
		
		//verificar se o usuário está autenticado..
		if(usuario != null) {
			modelAndView.setViewName("agenda/home");
			
			try {
				List<Compromisso> compromissos = compromissoService.find(usuario.getIdUsuario(), new Date());
				
				for(Compromisso item : compromissos) {
					if(item.getTipo() == TipoCompromisso.Familia) totalTipoFamilia++;
					else if(item.getTipo() == TipoCompromisso.Estudo) totalTipoEstudo++;
					else if(item.getTipo() == TipoCompromisso.Lazer) totalTipoLazer++;
					else if(item.getTipo() == TipoCompromisso.Trabalho) totalTipoTrabalho++;
					
					if(item.getPrioridade() == PrioridadeCompromisso.Alta) totalPrioridadeAlta++;
					else if(item.getPrioridade() == PrioridadeCompromisso.Media) totalPrioridadeMedia++;
					else if(item.getPrioridade() == PrioridadeCompromisso.Baixa) totalPrioridadeBaixa++;
				}
				
				modelAndView.addObject("compromissos", compromissos);	
				
				modelAndView.addObject("totalTipoFamilia", totalTipoFamilia);
				modelAndView.addObject("totalTipoEstudo", totalTipoEstudo);
				modelAndView.addObject("totalTipoTrabalho", totalTipoTrabalho);
				modelAndView.addObject("totalTipoLazer", totalTipoLazer);
				
				modelAndView.addObject("totalPrioridadeAlta", totalPrioridadeAlta);
				modelAndView.addObject("totalPrioridadeMedia", totalPrioridadeMedia);
				modelAndView.addObject("totalPrioridadeBaixa", totalPrioridadeBaixa);
			}
			catch(Exception e) {
				modelAndView.addObject("mensagem_erro", e.getMessage());
			}			
		}
		else {
			//redirecionando para o raiz do projeto..
			modelAndView.setViewName("redirect:/");
		}
		
		return modelAndView;
	}
}
