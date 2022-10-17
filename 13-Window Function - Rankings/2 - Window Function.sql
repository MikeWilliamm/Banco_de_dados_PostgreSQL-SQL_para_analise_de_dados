--Window Function > base: https://www.kaggle.com/datasets/dhruvildave/billboard-the-hot-100-songs
--numeração de registros: ROW_NUMBER()
--ranqueamento: RANK(), DENSE_RANK(), PERCENT_RANK()
--subdivisão: NTILE(), LAG(), lead)
--recuperação de registros: FIRST_VALUE(), LAST_VALUE(), NTH_VALUE()
--distancia relativa: CUME_DIST()

drop table if exists public.Window_Function cascade; 
select * into public.Window_Function from ( --Salva resultado de toda query em uma tabela
WITH 
cte_billboard AS (
SELECT DISTINCT
	t1.artist ,
	t1.song
FROM public."Billboard1" AS t1
order by t1.artist, t1.song
)

select *,
	row_number () over (order by artist, song) as "row_number", --Cria numeração ordenada, ordernado por artist e song
	row_number () over (partition by artist order by artist, song) as "row_number_artist", --Cria numeração de ordenada, particionado por artist e ordernado por artist e song
	rank() over (partition by artist order by artist, song) as "Rank", --Cria rankeamento, particionado por artist e ordernado por artist  e song, mesmo resultado de row_number 
	lag(song,1) over (partition by artist order by artist, song) as "lag_song", --Seta o valor(song) anterior particionado por artist, Ex: linha atual é a 4, nesse campo setara o valor da linha 3
	lead(song,1) over (partition by artist order by artist, song) as "lead_song", --Seta o próximo valor(song) particionado por artist, Ex: linha atual é a 3,, nesse campo setara o valor da linha 4
	first_value(song) over (partition by artist order by artist, song) as "first_song", --Seta o primeiro valor da partição feita por artist e que foi ordernada por artist e song
	last_value(song) over (partition by artist order by artist, song range between unbounded preceding and unbounded following) as "last_song" --Em tempo real de processamento seta o ultimo valor, mas como é em tempo real de processamento o ultimo valor será ele mesmo, para isso se utiliza o between.
from cte_billboard
)  as r;

------------------------------------------------------------------------------
--Exemplo todos Window Function
WITH T(StyleID, ID, Nome) AS (
 SELECT 1,1, 'Rhuan' UNION ALL
 SELECT 1,1, 'Andre' UNION ALL
 SELECT 1,2, 'Ana' UNION ALL
 SELECT 1,2, 'Maria' UNION ALL
 SELECT 1,3, 'Letícia' UNION ALL
 SELECT 1,3, 'Lari' UNION ALL
 SELECT 1,4, 'Edson' UNION ALL
 SELECT 1,4, 'Marcos' UNION ALL
 SELECT 1,5, 'Rhuan' UNION ALL
 SELECT 1,5, 'Lari' UNION ALL
 SELECT 1,6, 'Daisy' UNION ALL
 SELECT 1,6, 'João'
 )
SELECT *,
 ROW_NUMBER() OVER(PARTITION BY StyleID ORDER BY ID) as "ROW_NUMBER",
 RANK() OVER(PARTITION BY StyleID ORDER BY ID) AS "RANK",
 DENSE_RANK() OVER(PARTITION BY StyleID ORDER BY ID) as "DENSE_RANK",
 PERCENT_RANK() OVER(PARTITION BY StyleID ORDER BY ID) as "PERCENT_RANK",
 CUME_DIST() OVER(PARTITION BY StyleID ORDER BY ID) AS "CUME_DIST",
 CUME_DIST() OVER(PARTITION BY StyleID ORDER BY ID DESC) as "CUME_DIST_DESC",
 FIRST_VALUE(Nome) OVER(PARTITION by StyleID ORDER BY ID) as "FIRST_VALUE",
 LAST_VALUE(Nome) OVER(PARTITION by StyleID ORDER BY ID) as "LAST_VALUE",
 NTH_VALUE(Nome,5) OVER(PARTITION by StyleID ORDER BY ID) as "NTH_VALUE",
 NTILE (5) OVER (ORDER BY StyleID) as "NTILE_5",
 LAG(Nome, 1) over(order by ID) as "LAG_NOME",
 LEAD(Nome, 1) over(order by ID) as "LEAD_NOME"
FROM T 
