<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>

<jsp:useBean id="data" class="java.util.Date" />

<fmt:formatDate var="dataAtual" value="${data}"
	pattern="dd 'de' MMMM 'de' yyyy" />

<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Insert title here</title>

<!-- Folhas de estilo CSS -->
<link rel="stylesheet" href="resources/css/bootstrap.min.css" />

<link rel="stylesheet" href="//cdn.datatables.net/1.10.23/css/jquery.dataTables.min.css"/>

</head>
<body>

	<!-- MENU DO SISTEMA -->
	<nav class="navbar navbar-expand-lg navbar-dark bg-primary">
		<div class="container-fluid">
			<a class="navbar-brand" href="#">Agenda de Compromissos</a>
			<button class="navbar-toggler" type="button"
				data-bs-toggle="collapse" data-bs-target="#navbarSupportedContent"
				aria-controls="navbarSupportedContent" aria-expanded="false"
				aria-label="Toggle navigation">
				<span class="navbar-toggler-icon"></span>
			</button>
			<div class="collapse navbar-collapse" id="navbarSupportedContent">
				<ul class="navbar-nav me-auto mb-2 mb-lg-0">
					<li class="nav-item"><a class="nav-link active"
						aria-current="page" href="/springMvc02/home">Página inicial</a></li>
					<li class="nav-item dropdown"><a
						class="nav-link dropdown-toggle" href="#" id="navbarDropdown"
						role="button" data-bs-toggle="dropdown" aria-expanded="false">
							Gerenciar Compromissos </a>
						<ul class="dropdown-menu" aria-labelledby="navbarDropdown">
							<li><a class="dropdown-item"
								href="/springMvc02/cadastro-compromisso">Cadastrar
									Compromissos</a></li>
							<li><a class="dropdown-item"
								href="/springMvc02/consulta-compromisso">Consultar
									Compromissos</a></li>
							<li><hr class="dropdown-divider"></li>
							<li><a class="dropdown-item"
								href="/springMvc02/relatorio-compromisso">Relatório de
									Compromissos</a></li>
						</ul></li>
				</ul>
			</div>
		</div>
	</nav>

	<c:if test="${not empty mensagem_sucesso}">

		<div class="alert alert-success alert-dismissible fade show"
			role="alert">
			<strong>Sucesso!</strong> ${mensagem_sucesso}
			<button type="button" class="btn-close" data-bs-dismiss="alert"
				aria-label="Close"></button>
		</div>

	</c:if>

	<c:if test="${not empty mensagem_erro}">

		<div class="alert alert-danger alert-dismissible fade show"
			role="alert">
			<strong>Erro!</strong> ${mensagem_erro}
			<button type="button" class="btn-close" data-bs-dismiss="alert"
				aria-label="Close"></button>
		</div>

	</c:if>
	
	<div class="container mt-4 mb-5">

		<div class="row">
			<div class="col-md-6">
				<h5>Seja bem vindo à Agenda de Compromissos</h5>
				<p>${dataAtual}</p>
			</div>
			<div class="col-md-6 text-end">
				<strong>${usuario_autenticado.nome}</strong> <small>${usuario_autenticado.email}</small> 
				<br />
				
				<a href="/springMvc02/logout" onclick="return confirm('Deseja realmente sair do sistema?')">
					Sair do Sistema
				</a>
				
			</div>
		</div>

		<hr />
		
		<div class="row">
			<div class="col-md-8">
			
				<h5>Compromissos a partir de hoje:</h5>
				
				<table id="tabelaCompromissos" class="table table-hover">
					<thead>
						<tr>
							<th>Nome do Compromisso</th>
							<th>Data</th>
							<th>Hora</th>
							<th>Tipo</th>
							<th>Prioridade</th>
						</tr>	
					</thead>
					<tbody>
						<c:forEach items="${compromissos}" var="item">
							<tr>
								<td>${item.nome}</td>
								<td><fmt:formatDate pattern="dd/MM/yyyy" value="${item.dataCompromisso}" /></td>
								<td>${item.horaCompromisso}</td>
								<td>${item.tipo}</td>
								<td>${item.prioridade}</td>
							</tr>
						</c:forEach>
					</tbody>
					<tfoot>
						<tr>
							<td colspan="5">Quantidade de compromissos: ${compromissos.size()}</td>
						</tr>
					</tfoot>
				</table>
			
			</div>
			<div class="col-md-4">
			
				<!-- Área do gráfico de tipos -->
				<div id="graficoTipos" style="height: 300px;"></div>
			
				<!-- Área do gráfico de prioridades -->
				<div id="graficoPrioridades" style="height: 300px;"></div>
			
			</div>
		</div>		

	</div>

	<!-- Arquivos javascript -->
	<script src="resources/js/bootstrap.min.js"></script>
	
	<script src="resources/js/jquery-3.5.1.min.js"></script>
	<script src="//cdn.datatables.net/1.10.23/js/jquery.dataTables.min.js"></script>
	
	<!-- bibliotecas do HighCharts -->
	<script src="resources/js/highcharts.js"></script>
	<script src="resources/js/highcharts-3d.js"></script>
	<script src="resources/js/exporting.js"></script>
	<script src="resources/js/export-data.js"></script>
	
	<script>
		$(document).ready(function(){
			
			//aplicando a formatação do datatable
			$('#tabelaCompromissos').DataTable({
				language: {
		            url: '//cdn.datatables.net/plug-ins/1.10.22/i18n/Portuguese-Brasil.json'
		        }
			});		
			
			carregarGraficoDeCompromissosPorTipo();
			carregarGraficoDeCompromissosPorPrioridade();
			
		})
				
		//função para carregar o gráfico de compromissos por tipo
		function carregarGraficoDeCompromissosPorTipo(){
			//criando o gráfico de compromissos por tipo..
			//dados provisórios em formato JSON..
			var result = [
				{ data: [${totalTipoTrabalho}], name : "Trabalho" },
				{ data: [${totalTipoFamilia}], name : "Familia" }, 
				{ data: [${totalTipoLazer}], name : "Lazer"  }, 
				{ data: [${totalTipoEstudo}], name : "Estudo" }
			];
			
			//montando um gráfico a partir dos das acima..
			var array = [];
			for(var i = 0; i < result.length; i++){
				array.push([
					result[i].name, result[i].data[0]
				]);
			}
			
			new Highcharts.Chart({
				chart : {
					type : 'pie',
					renderTo : 'graficoTipos'
				},
				title : {
					text : 'Compromissos<br/>por Tipo',
					verticalAlign: 'middle',
					floating: true
				},
				exporting : { enabled: false },
				credits : { enabled: false },
				series: [
					{ data: array }
				],
				plotOptions: {
					pie: {
						innerSize: '70%',
						dataLabels: { enabled : true, alignTo: 'connectors' }
					}
				}
			});
		}
		
		//função para carregar o gráfico de compromissos por prioridade
		function carregarGraficoDeCompromissosPorPrioridade(){
			//criando o gráfico de compromissos por tipo..
			//dados provisórios em formato JSON..
			var result = [
				{ data: [${totalPrioridadeAlta}], name : "Alta" },
				{ data: [${totalPrioridadeMedia}], name : "Media" }, 
				{ data: [${totalPrioridadeBaixa}], name : "Baixa"  }
			];
			
			//montando um gráfico a partir dos das acima..
			var array = [];
			for(var i = 0; i < result.length; i++){
				array.push([
					result[i].name, result[i].data[0]
				]);
			}
			
			new Highcharts.Chart({
				chart : {
					type : 'pie',
					renderTo : 'graficoPrioridades'
				},
				title : {
					text : 'Compromissos<br/>por Prioridade',
					verticalAlign: 'middle',
					floating: true
				},
				exporting : { enabled: false },
				credits : { enabled: false },
				series: [
					{ data: array }
				],
				plotOptions: {
					pie: {
						innerSize: '70%',
						dataLabels: { enabled : true, alignTo: 'connectors' }
					}
				}
			});
		}
		
	</script>

</body>
</html>