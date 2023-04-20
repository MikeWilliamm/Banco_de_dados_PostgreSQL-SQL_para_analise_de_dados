select
regexp_replace(initcap(o.loja), E'[\\n\\r]+', ' ', 'g') as store_name, --remove linhas em branco
regexp_replace(o.loja, '\r?\n', '') as store_name
from orders03 as o 
inner join orders04 o2 on o.store_id = o2.store_id 
