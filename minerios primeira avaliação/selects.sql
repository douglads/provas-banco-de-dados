use comercio;
/*Durante as entrevistas, uma fala da CEO dessa empresa foi transcrita:

"Precisamos o tempo todo consultar dados sobre os países. 
É interessante para nós saber, principalmente, a moeda corrente, sua capital, e produção de minérios a qual e medida em toneladas por ano.
Seria ótimo pra nossa organização conhecer a produção de minérios ano a ano."


Em seguida, a CEO destacou, como exemplo, alguns relatórios que o sistema deve fornecer:
*/

#1 - Um relatório que mostra todos os países de um continente
#informando o nome do país, sua capital e moeda oficial.
select pais.nome, pais.capital, pais.moeda 
	from pais join continente on pais.continente_id = idcontinente
    where continente.nome like "%america%";

#2 - O total de silício produzido na década de 2010 de cada país.
select pais.nome, producao_minerio.qtd_Producao as Produção_decada
	from producao_minerio 
	join pais on producao_minerio.idPais = pais.idPais
    join minerio on minerio_id = idminerio
    where minerio.nome like '%silicio%' and
    producao_minerio.ano between 2011 and 2020;
    
#3 - Todos os países que em 2019 registraram produção de ferro entre 2000000 e 5000000 de toneladas.
select pais.nome, producao_minerio.qtd_Producao as prodFerro
	from producao_minerio 
		join pais on producao_minerio.idPais = pais.idPais
        join minerio on producao_minerio.minerio_id = minerio.idminerio
        where minerio.nome like '%ferro%' and 
        producao_minerio.qtd_Producao > 2000000 and 
        producao_minerio.qtd_Producao < 5000000;

#4 - Todos os continentes informando seu nome, área e quantidade vulcões ativos.
select nome, area, numvulcoesativos from continente;

#5 - O pais com maior produção de bauxita em 2011.
select pais.nome, producao_minerio.qtd_Producao as prodBauxita
	from producao_minerio 
		join pais on producao_minerio.idPais = pais.idPais
        join minerio on producao_minerio.minerio_id = minerio.idminerio
        where minerio.nome like '%bauxita%' and producao_minerio.ano = 2011
        order by producao_minerio.qtd_Producao desc
        limit 1;
        
#6 - A média mundial de produção de diamante em 2012.
select minerio.nome, avg(producao_minerio.qtd_Producao) as Media_diamante_2012
	from producao_minerio 
		join pais on producao_minerio.idPais = pais.idPais
        join minerio on producao_minerio.minerio_id = minerio.idminerio
        where minerio.nome like '%diamante%'  and producao_minerio.ano = 2012;
        
#7 - O minério com maior produção em 2018.
select minerio.nome, producao_minerio.qtd_Producao as MaiorProd2018
	from producao_minerio 
		join pais on producao_minerio.idPais = pais.idPais
        join minerio on producao_minerio.minerio_id = minerio.idminerio
        where producao_minerio.ano = 2018
        order by producao_minerio.qtd_Producao desc
        limit 1;
        
#8 - A média de produção de cada minério em 2014.
select producao_minerio.qtd_Producao as Media_cada_2014, minerio.nome
	from producao_minerio 
        join minerio on producao_minerio.minerio_id = minerio.idminerio
        where producao_minerio.ano = 2014
        group by minerio.nome;

#9 - Todos os países que o nome termina com 'istão' ou 'lândia'.
select nome from pais where nome like '%istão%' or nome like '%lândia%';

#10 - Todos os países que produzem ouro e tungstênio no ano passado bem como as quantidades.
select minerio.nome ,producao_minerio.qtd_Producao as ProdAnoPassado
	from producao_minerio 
		join pais on producao_minerio.idPais = pais.idPais
        join minerio on producao_minerio.minerio_id = minerio.idminerio
        where ano=(YEAR(NOW())-1) and (minerio.nome like 'ouro' or minerio.nome like 'tungstênio');