drop database if exists logistica;
create database logistica;
use logistica;

create table tipoVeiculo(
	id integer primary key auto_increment,
    tipo varchar(20)
);

insert into tipoVeiculo (tipo) values
("Automóvel"),
("Bonde"),
("Caminhão"),
("Caminhonete"),
("Camioneta"),
("Ciclomotor"),
("Microônibus"),
("Motocicleta"),
("Motoneta"),
("Ônibus"),
("Quadriciclo"),
("Trator de esteiras"),
("Trator de rodas"),
("Trator misto"),
("Triciclo"),
("Veículo de tração"),
("Veículo Misto");

create table condutor(
	id integer auto_increment primary key,
    nome varchar(50),
    cnhNum bigint default 0,
    tipoCnh varchar(2)
);

insert into condutor values
(null, 'João batista', null, null),
(null, "Helena", 77395354670, "AB"),
(null, "Alice", 44897837268, "AC"),
(null, "Laura",  74944310850, "D"),
(null, "Manuela", 17531854136, "AB"),
(null, "Sophia", 12097889236, "AC"),
(null, "Isabella", null, null),
(null, "Luísa", 15901814400, "E"),
(null, "Heloísa", 84190006854, "AB"),
(null, "Miguel", 83162647525, "AE"),
(null, "Arthur", 64593165640, "AC"),
(null, "Théo", null, null),
(null, "Heitor", 83282745863, "E"),
(null, "Gael", 47833442073, "AB"),
(null, "Davi", 66416418178, "B"),
(null, "Bernardo", 97172837218, "A"),
(null, "Gabriel", null, null),
(null, "Ravi", 96154513512, "C"),
(null, "Noah", 83207251178, "AC")
;
create table veiculo(
	id integer auto_increment primary key,
	placa varchar(8) unique not null,
    tipo integer not null default 3,
    montadora varchar(50),
    modelo varchar(50),
    constraint FK_TipoVeiculo foreign key (tipo) references tipoVeiculo(id)
);

insert into veiculo values
(null, "ACE-8572", 1, " volkswagen", " fusca"),
(null, "GEQ-6665", 1, " chevrolet", " celta"),
(null, "FWA-3293", 1, " fiat", " strada"),
(null, "HKR-7773", 3, " volvo", " fh2323"),
(null, "SRJ-1120", 3, " volvo", " fh2324"),
(null, "KGJ-6792", 3, " volvo", " fh2325"),
(null, "HTR-2386", 3, " volvo", " fh2326"),
(null, "HJR-8734", 3, " ford", " cargo"),
(null, "QSA-3391", 3, " ford", " cargo"),
(null, "QGH-4561", 3, " ford", " cargo"),
(null, "QCB-4015", 3, " mercedes", " L 1113"),
(null, "HYR-2843", 3, " mercedes", " L 1114"),
(null, "UIH-7681", 8, " honda", " cg-150"),
(null, "HBF-3186", 8, " honda", " cg-150"),
(null, "TUI-4291", 8, " honda", " cg-150"),
(null, "LJB-6211", 4, " toyota", " hilux"),
(null, "ABJ-5278", 4, " toyota", " hilux"),
(null, "GAY-4693", 4, " mitsubishi", " L200");

create table cidades(
	id integer auto_increment primary key,
    nome varchar(50) not null
);

insert into cidades(nome) values 
("Sorocaba"),
("Capela do Alto"),
("São Roque"),
("Tatui"),
("Sarapui"),
("São Paulo"),
("Osasco"),
("Itapevi"),
("Itapetininga"),
("Quadra"),
("Alambari");

#6 - (1 ponto) - A origem deve ser sempre diferente do destino e a distância sempre maior que zero, seja a viagem registrada por procedures ou pelos comandos insert e update.
create table rotas(
	id integer not null auto_increment,
	origem integer not null,
    destino integer not null,
    quilometragem integer,
    constraint FK_Origem foreign key (origem)  references cidades(id),
    constraint FK_Destino foreign key (destino)  references cidades(id),
    primary key (id),
    check (quilometragem > 0),
    check(origem <> destino),
    check(destino <> origem)
);

insert into rotas values 
(null, 1, 2, 40), 
(null, 2, 1, 40),
(null, 4, 2, 20), 
(null, 2, 4, 20),
(null, 2, 6, 120),
(null, 6, 2, 120),
(null, 1, 6, 80),
(null, 6, 1, 80),
(null, 7, 1, null);

create table viagem(
	id integer auto_increment primary key,
	v_placa varchar(8) not null,
    condutor integer not null,
	diaSaida date not null,
    rotas integer not null,
    constraint FK_v_Placa foreign key (v_placa) references veiculo(placa),
    constraint FK_condutor foreign key (condutor) references condutor(id),
    constraint FK_rotas foreign key (rotas) references rotas(id)
);

create table logViagem(
	id integer primary key auto_increment,    
	quando datetime,
    quem varchar(60),
	viagem_id integer,
	v_placa varchar(8) not null,
    condutor integer not null,
	diaSaida date not null,
    rotas integer not null
);

#1 - (1 ponto) - Crie o digrama lógico do banco de dados
#2 - (1 ponto) - Crie o script que cria as tabelas, seus relacionamentos e restrições
#3 - (1 ponto) - Crie uma function que, dado a placa do veículo, retorna quantas viagens já fez.

drop function if exists numero_Viages;
delimiter $
create function numero_Viages(placa varchar(8))
	returns integer deterministic
    begin
		set @cont = (select count(v_placa) as qtd_viagem from viagem where v_placa = placa);
        return @cont;
	end$
delimiter ;
	
#4 - (1 ponto) - Crie uma procedure que, recebe apenas 4 parâmetros: cidade de orgiem, destino, condutor e veículo e registra uma viagem com data de saída no dia seguinte.

drop procedure if exists criaViagem;
delimiter $
create procedure criaViagem(
placa varchar(8),
condutor varchar(50),
origens varchar(50),
destinos varchar(50))
begin
	set @vOrigem = (select id from cidades where nome = origens);
	set @vDestino = (select id from cidades where nome = destinos);    
    set @vRotas = (select id from rotas where origem = @vOrigem and destino = @vDestino);
	set @vCondutor = (select id from condutor where nome = condutor);
    insert into viagem values (null, placa, @vCondutor, DATE_ADD(NOW(), INTERVAL 1 DAY), @vRotas);
end$
delimiter ;
call criaViagem('HKR-7773', 'Helena', 'Sorocaba', 'Capela do Alto');
call criaViagem('SRJ-1120', 'Manuela', 'Capela do Alto', 'Tatui');
call criaViagem('ACE-8572', 'Bernardo', 'São Paulo', 'Capela do Alto');
call criaViagem('ABJ-5278', 'Noah', 'Sorocaba', 'São Paulo');
call criaViagem('TUI-4291', 'Alice', 'Capela do Alto', 'São Paulo');
call criaViagem('KGJ-6792', 'Manuela', 'Tatui', 'Capela do Alto');

#5 - (1 ponto) - Sempre que uma viagem for alterada, registre essa ocorrência em uma tabela apropriada.
delimiter $
create trigger logViagem after update on viagem
	for each row
begin
	insert into logViagem values(null, sysdate(), user(), old.id, old.v_placa, old.condutor, old.diaSaida, old.rotas);
end$
delimiter ;
update viagem set condutor = 5 where id = 1;

#7 - (1 ponto) - Crie uma view que exibe os detalhes de todas as viagens, como nome das cidades, nome do condutor, placa e nome do veículo, data e etc.

create view mostra_viagem as
select viagem.id, viagem.v_placa as placa, veiculo.modelo, viagem.diaSaida, condutor.nome, cidOrigem.nome as 'Origem', cidDestino.nome as 'Destino' 
from viagem
join rotas on viagem.rotas = rotas.id
join cidades cidOrigem on rotas.origem = cidOrigem.id
join cidades cidDestino on rotas.destino = cidDestino.id
join veiculo on viagem.v_placa = veiculo.placa
join condutor on viagem.condutor = condutor.id;
SELECT * FROM mostra_viagem;
#8 - (1 ponto) - Selecione as distâncias entre todos os pares de cidades.
select quilometragem from rotas;
#9 - (1 ponto) - Crie uma função que dado duas cidades, retorna a distância entre elas, ou lance um erro caso a distância ou as cidades não estiverem previamente definidas.

drop function if exists distancia;
delimiter $
create function distancia (Origens varchar(50), Destinos varchar(50))
	returns varchar(50) deterministic
begin
	set @Origem = (select id from cidades where nome like Origens);
	set @Destino = (select id from cidades where nome like Destinos);
    set @quilometragem = (select quilometragem from rotas where origem = @Origem and destino = @Destino);
    
    if @Origem <=> null then
		#lança erro
        signal sqlstate '45000'
        set message_text = 'Campo de origem não determinado',
        mysql_errno = 2022;
	elseif @Destino <=> null then
		#lança erro
        signal sqlstate '45000'
        set message_text = 'Campo de destino não determinado',
        mysql_errno = 2022;
	elseif @quilometragem <=> null then
		#lança erro
        signal sqlstate '45000'
        set message_text = 'Campo de quilometragem em rotas não foi definido',
        mysql_errno = 2022;
	end if;
		return @quilometragem;
end$
delimiter ;
select distancia('Capela do Alto', 'Sorocaba');

#10 - (1 ponto) - Selecione todos os condutores sem CNH informada.
SELECT nome as 'Condutores s/ CNH' FROM condutor where cnhNum <=> null;

#9 - está aqui em baixo porque ira disparar erro, como foi programado no código

select distancia('Sorocaba', 'Osasco');
select distancia('', 'Capela do Alto');
select distancia('Sorocaba', '');