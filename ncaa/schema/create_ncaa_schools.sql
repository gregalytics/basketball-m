begin;

create table ncaa.players (
       player_id	  integer,
       name_last	  text,
       name_first	  text,
       primary key (player_id)
);

create temporary table last_year (
       player_id	  integer,
       year		  integer,
       games		  integer,       
       primary key (player_id)
);

insert into last_year
(player_id,year,games)
(
select player_id,year,max(games)
from ncaa.statistics
where (player_id,year) in
(
select player_id,max(year)
from ncaa.statistics
where
    player_id is not null
and player_name is not null
group by player_id
)
group by player_id,year
);

insert into ncaa.players
(player_id,name_last,name_first)
(
select
s.player_id,
split_part(s.player_name,', ',1),
split_part(s.player_name,', ',2)
from ncaa.statistics s
join last_year l
  on (l.player_id,l.year,l.games)=(s.player_id,s.year,s.games)
where
    s.player_id is not null
and s.player_name is not null
);

commit;
