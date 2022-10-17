--Criando tabela fixa com Query, informação ficara gravada, sempre que precisar a informação estara pronta e será a mesma até que seja executada novamente.
--create table as
drop table if exists public.tb_web_site cascade;
create table public.tb_web_site as ( --Também é possivel fazer com "select * into from ()"
with cte_dedup as(
	SELECT 
		t1."date",
	 	t1."rank",
	 	t1.song,
	 	t1.artist,
	 	row_number() over(partition by t1.artist, t1.song order by t1.artist,t1.song, t1."date") as dedup_song ,
	 	row_number() over(partition by t1.artist order by t1.artist, t1."date") as dedup_artist
	FROM PUBLIC."Billboard1" AS t1 order by t1.artist , t1."date"
)
select 
	t1."date",
 	t1."rank",
 	t1.artist,
 	t1.song
from cte_dedup as t1
where t1.artist like 'AC/%' and t1.dedup_song = 1
--and t1.dedup_artist = 1
)
;

select * from public.tb_web_site;

------
--select into
drop table if exists public.tb_web_site cascade;
SELECT * INTO public.tb_web_site FROM (
create table public.tb_web_site as ( --Também é possivel fazer com "select * into from ()"
with cte_dedup as(
	SELECT 
		t1."date",
	 	t1."rank",
	 	t1.song,
	 	t1.artist,
	 	row_number() over(partition by t1.artist, t1.song order by t1.artist,t1.song, t1."date") as dedup_song ,
	 	row_number() over(partition by t1.artist order by t1.artist, t1."date") as dedup_artist
	FROM PUBLIC."Billboard1" AS t1 order by t1.artist , t1."date"
)
select 
	t1."date",
 	t1."rank",
 	t1.artist,
 	t1.song
from cte_dedup as t1
where t1.artist like 'AC/%' and t1.dedup_song = 1
--and t1.dedup_artist = 1
) as r;
------------------------------------------------------------------------
--Inserindo dados em tabela já existente com Query
insert into public.tb_web_site (
with cte_dedup as(
	SELECT 
		t1."date",
	 	t1."rank",
	 	t1.song,
	 	t1.artist,
	 	row_number() over(partition by t1.artist, t1.song order by t1.artist,t1.song, t1."date") as dedup_song ,
	 	row_number() over(partition by t1.artist order by t1.artist, t1."date") as dedup_artist
	FROM PUBLIC."Billboard1" AS t1 order by t1.artist , t1."date"
)
select 
	t1."date",
 	t1."rank",
 	t1.artist,
 	t1.song
from cte_dedup as t1
where t1.artist ilike '%elvis%' and t1.dedup_song = 1
);

select * from public.tb_web_site;
------------------------------------------------------------------------
--VIEW
--Criando View com Query, uma vizão sobre os dados que eu já tenho, consulta em tempo real, atravez da view não é possivel acessar a tabela principal, somente o conteudo gerado pela view.
drop view if exists public.vw_tb_web_site;
create view public.vw_tb_web_site as (
with cte_dedup as(
	SELECT 
		t1."date",
	 	t1."rank",
	 	t1.song,
	 	t1.artist,
	 	row_number() over(partition by t1.artist, t1.song order by t1.artist,t1.song, t1."date") as dedup_song ,
	 	row_number() over(partition by t1.artist order by t1.artist, t1."date") as dedup_artist
	FROM PUBLIC."Billboard1" AS t1 order by t1.artist , t1."date"
)
select 
	t1."date",
 	t1."rank",
 	t1.artist,
 	t1.song
from cte_dedup as t1
where t1.artist like '%' and t1.dedup_song = 1
);

select * from vw_tb_web_site;

drop view  public.vw_tb_web_site; -- apagando view 

------------------------------------------------------------------------

--Alterando View
--create or replace view:
	--tenta criar a view, se já existir altera a mesma, obs: colunas devem ser as mesmas, quando existe alteração nas colunas, é necessário apagar a view e criar novamente.
	-- Utilizar o create or replace view somente quando realmente for necessário um replace, para não correr o risco de substituir uma view sem querer.
create or replace view public.vw_tb_web_site as ( 
with cte_dedup as(
	SELECT 
		t1."date",
	 	t1."rank",
	 	t1.song,
	 	row_number() over(partition by t1.song order by t1.song, t1."date") as dedup_song
	FROM PUBLIC."Billboard1" AS t1 order by t1.song , t1."date"
)
select 
	t1."date",
 	t1."rank",
 	t1.song
from cte_dedup as t1
where t1.dedup_song = 1 --and t1.song ilike 'AC%'
);

drop view if exists public.vw_tb_web_site;
select * from vw_tb_web_site;
