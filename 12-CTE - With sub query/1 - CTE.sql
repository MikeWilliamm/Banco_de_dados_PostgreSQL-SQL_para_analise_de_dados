--CTE: 
	--Common Table Expressions
	--OU
	--Expressões de Tabela Comuns
	--"Uma CTE tem o uso bem similar ao de uma subquery ou tabela derivada, com a vantagem do
	--conjunto de dados poder ser utilizado mais de uma vez na consulta, ganhando performance (nessa
	--situação) e também, melhorando a legibilidade do código. Por estes motivos, o uso da CTE tem sido
	--bastante difundido como substituição à outras soluções citadas."

--Query sem utilizar CTE 
SELECT t1.artist
 ,t2.qtd_artist
 ,t1.song
 ,t3.qtd_song
Mike William Dopp - mike-william98@hotmail.com - IP: 138.185.4.22
FROM PUBLIC."Billboard" AS t1
LEFT JOIN (
 SELECT t1.artist
 ,count(*) AS qtd_artist
 FROM PUBLIC."Billboard" AS t1
 GROUP BY t1.artist
 ORDER BY t1.artist
 ) AS t2 ON (t1.artist = t2.artist)
LEFT JOIN (
 SELECT t1.song
 ,count(*) AS qtd_song
 FROM PUBLIC."Billboard" AS t1
 GROUP BY t1.song
 ORDER BY t1.song
 ) AS t3 ON (t1.song = t3.song);

--Query utilizando CTE 
WITH cte_artist
AS (
 SELECT t1.artist
 ,count(*) AS qtd_artist
 FROM PUBLIC."Billboard" AS t1
 GROUP BY t1.artist
 ORDER BY t1.artist
 )
 ,cte_song
AS (
 SELECT t1.song
 ,count(*) AS qtd_song
 FROM PUBLIC."Billboard" AS t1
 GROUP BY t1.song
 ORDER BY t1.song
 )
SELECT t1.artist
 ,t2.qtd_artist
 ,t1.song
 ,t3.qtd_song
FROM PUBLIC."Billboard" AS t1
LEFT JOIN cte_artist AS t2 ON (t1.artist = t2.artist)
LEFT JOIN cte_song AS t3 ON (t1.song = t3.song);

