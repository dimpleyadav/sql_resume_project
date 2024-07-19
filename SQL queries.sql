-- Identifying missing data (2014)
select 
	count(*) as total_rows,
	count( case when state is null then 1 end) as missing_state,
    count( case when pc_name is null then 1 end) as missing_pc_name,
    count( case when candidate is null then 1 end) as missing_candidate,
	count( case when sex is null then 1 end) as missing_sex,
    count( case when age is null then 1 end) as missing_age,
    count( case when category is null then 1 end) as missing_category,
    count( case when party is null then 1 end) as missing_party,
    count( case when party_symbol is null then 1 end) as missing_party_symbol,
    count( case when general_votes is null then 1 end) as missing_general_votes,
    count( case when postal_votes is null then 1 end) as missing_postal_votes,
    count( case when total_votes is null then 1 end) as missing_total_votes,
    count( case when total_electors is null then 1 end) as missing_total_electors
from constituency_wise_results_2014;
    
-- Identifying missing data (2019)
select 
	count(*) as total_rows,
	count( case when state is null then 1 end) as missing_state,
    count( case when pc_name is null then 1 end) as missing_pc_name,
    count( case when candidate is null then 1 end) as missing_candidate,
	count( case when sex is null then 1 end) as missing_sex,
    count( case when age is null then 1 end) as missing_age,
    count( case when category is null then 1 end) as missing_category,
    count( case when party is null then 1 end) as missing_party,
    count( case when party_symbol is null then 1 end) as missing_party_symbol,
    count( case when general_votes is null then 1 end) as missing_general_votes,
    count( case when postal_votes is null then 1 end) as missing_postal_votes,
    count( case when total_votes is null then 1 end) as missing_total_votes,
    count( case when total_electors is null then 1 end) as missing_total_electors
from constituency_wise_results_2019;
 
      
-- Change in constituencies as Andhra Pradesh got bifurcated in 2014
update constituency_wise_results_2014
set state = 'Telangana'
where pc_name in (select distinct pc_name
from constituency_wise_results_2019
where state = 'Telangana');


-- Q1 Top 5 constituencies with high VTR 2014
select pc_name, round(((sum(total_votes)/total_electors)*100),2) as voter_turnout_ratio
from constituency_wise_results_2014
group by pc_name, state
order by voter_turnout_ratio desc
limit 5;


-- Top 5 constituencies with high VTR 2019
select pc_name, round(((sum(total_votes)/total_electors)*100),2) as voter_turnout_ratio
from constituency_wise_results_2019
group by pc_name, state
order by voter_turnout_ratio desc
limit 5;


-- Bottom 5 constituencies with low VTR 2014
select pc_name, round(((sum(total_votes)/total_electors)*100),2) as voter_turnout_ratio
from constituency_wise_results_2014
group by pc_name, state
order by voter_turnout_ratio 
limit 5;


-- Bottom 5 constituencies with low VTR 2019
select pc_name, round(((sum(total_votes)/total_electors)*100),2) as voter_turnout_ratio
from constituency_wise_results_2019
group by pc_name, state
order by voter_turnout_ratio 
limit 5;


-- Q2 Top 5 states with high VTR 2014
select state, round(sum(sum_votes)/sum(total_electors)*100,2) as voter_turnout_ratio
from(
-- find the sum of total votes for each constituency
select state, pc_name, sum(total_votes) as sum_votes, total_electors 
from constituency_wise_results_2014
group by pc_name,state)x
group by state
order by voter_turnout_ratio desc
limit 5;


-- Top 5 states with high VTR 2019
select state, round(sum(sum_votes)/sum(total_electors)*100,2) as voter_turnout_ratio
from(
-- find the sum of total votes for each constituency
select state, pc_name, sum(total_votes) as sum_votes, total_electors 
from constituency_wise_results_2019
group by pc_name,state)x
group by state
order by voter_turnout_ratio desc
limit 5;


-- Bottom 5 states with low VTR 2014
select state, round(sum(sum_votes)/sum(total_electors)*100,2) as voter_turnout_ratio
from(
-- find the sum of total votes for each constituency
select state, pc_name, sum(total_votes) as sum_votes, total_electors 
from constituency_wise_results_2014
group by pc_name,state)x
group by state
order by voter_turnout_ratio 
limit 5;


-- Bottom 5 states with low VTR 2019
select state, round(sum(sum_votes)/sum(total_electors)*100,2) as voter_turnout_ratio
from(
-- find the sum of total votes for each constituency
select state, pc_name, sum(total_votes) as sum_votes, total_electors 
from constituency_wise_results_2019
group by pc_name,state)x
group by state
order by voter_turnout_ratio 
limit 5;


-- Q3
with cte_2014 as
-- row_number() gets the winning party for each constituency at the top
(select state, pc_name,party, total_votes, row_number() over(partition by pc_name order by total_votes desc) as row1
from constituency_wise_results_2014),

-- row_number() gets the winning party for each constituency at the top
-- find the sum of total votes for each constituency (T)
cte_2019 as
(select state, pc_name,party, total_votes, sum(total_votes) over (partition by pc_name) as total_votes_2019, row_number() over(partition by pc_name order by total_votes desc) as row2
from constituency_wise_results_2019)

-- calculate the vote percentage C = (V\T) * 100 where V equals the number of votes for the candidate divided by the total number of votes (T) 
select cte_2014.pc_name, cte_2014.party as party_2014, cte_2019.party as party_2019, round(cte_2019.total_votes/cte_2019.total_votes_2019 * 100,2) as vote_percent_2019
from cte_2014
join cte_2019
on cte_2014.pc_name = cte_2019.pc_name and cte_2014.party = cte_2019.party
where cte_2014.row1 = 1 and cte_2019.row2 = 1
order by vote_percent_2019 desc;


-- Q4
-- calculate sum of total votes for each constituency (T) and order the rows to get winning party for each pc at the top
with cte_2014 as
(select state, pc_name,party, total_votes, sum(total_votes) over (partition by pc_name) as total_votes_2014, row_number() over(partition by pc_name order by total_votes desc) as row1
from constituency_wise_results_2014),

-- calculate sum of total votes for each constituency (T) and order the rows to get winning party for each pc at the top
cte_2019 as
(select state, pc_name,party, total_votes, sum(total_votes) over (partition by pc_name) as total_votes_2019, row_number() over(partition by pc_name order by total_votes desc) as row2
from constituency_wise_results_2019)

-- calculate the vote percentage C = (V\T) * 100 where V equals the number of votes for the candidate divided by the total number of votes (T)
select cte_2014.pc_name, cte_2014.party as party_2014, round(cte_2014.total_votes/cte_2014.total_votes_2014 * 100,2) as vote_percent_2014, cte_2019.party as party_2019, round(cte_2019.total_votes/cte_2019.total_votes_2019 * 100,2) as vote_percent_2019, abs(round(cte_2014.total_votes/cte_2014.total_votes_2014 * 100,2)-round(cte_2019.total_votes/cte_2019.total_votes_2019 * 100,2)) as vote_difference
from cte_2014
join cte_2019
on cte_2014.pc_name = cte_2019.pc_name and cte_2014.party != cte_2019.party
where cte_2014.row1 = 1 and cte_2019.row2 = 1
order by vote_difference desc
limit 10;


-- Q5 (2014)
-- row_number() gets the winning party for each constituency at the top
with cte_2014 as
(select state, pc_name, candidate, party, total_votes, row_number() over(partition by pc_name order by total_votes desc) as row_num
from constituency_wise_results_2014)

-- comparing the top candidate and the runner up candidate to get the margin difference
select c1.candidate, c1.pc_name, c1.party, (c1.total_votes - c2.total_votes) as margin_difference
from cte_2014 c1
join cte_2014 c2
on c1.pc_name = c2.pc_name and c1.row_num = 1 and c2.row_num = 2
where c1.row_num < 3
order by margin_difference desc
limit 5;

-- (2019)
-- row_number() gets the winning party for each constituency at the top
with cte_2019 as
(select state, pc_name, candidate, party, total_votes, row_number() over(partition by pc_name order by total_votes desc) as row_num
from constituency_wise_results_2019)

-- comparing the top candidate and the runner up candidate to get the margin difference
select c1.candidate, c1.pc_name, c1.party, (c1.total_votes - c2.total_votes) as margin_difference
from cte_2019 c1
join cte_2019 c2
on c1.pc_name = c2.pc_name and c1.row_num = 1 and c2.row_num = 2
where c1.row_num < 3
order by margin_difference desc
limit 5;


-- Q6
with cte_2014 as
-- sum of votes of all the parties
(select *, sum(total_votes_2014) over() as sum_votes_2014
from
-- sum of votes for each party
(select party, sum(total_votes) as total_votes_2014
from constituency_wise_results_2014
group by party)x ),

cte_2019 as
-- sum of votes of all the parties
(select *, sum(total_votes_2019) over() as sum_votes_2019
from
-- sum of votes for each party
(select party, sum(total_votes) as total_votes_2019
from constituency_wise_results_2019
group by party)x )

-- C = (V/T) * 100
select c14.party, c14.total_votes_2014, round(c14.total_votes_2014/c14.sum_votes_2014 * 100,2)  as percent_share_2014, c19.total_votes_2019, round(c19.total_votes_2019/c19.sum_votes_2019 * 100,2)  as percent_share_2019
from cte_2014 c14
join cte_2019 c19
on c14.party = c19.party
order by percent_share_2014 desc;


-- Q7
with cte_2014 as
-- sum of votes of all parties for each state
(select *, sum(total_votes_2014) over(partition by state) as sum_votes_2014
from
-- sum of votes for each party at state level
(select party, state, sum(total_votes) as total_votes_2014
from constituency_wise_results_2014
group by party,state)x
 )

-- C = (V/T) * 100
select state, party, total_votes_2014, round(total_votes_2014/sum_votes_2014 * 100,2)  as percent_share_2014
from cte_2014
group by state,party
order by percent_share_2014 desc;

with cte_2019 as
-- sum of votes of all parties for each state
(select *, sum(total_votes_2019) over(partition by state) as sum_votes_2019
from
-- sum of votes for each party at state level
(select party, state, sum(total_votes) as total_votes_2019
from constituency_wise_results_2019
group by party,state)x
 )

-- C = (V/T) * 100
select state, party, total_votes_2019, round(total_votes_2019/sum_votes_2019 * 100,2)  as percent_share_2019
from cte_2019
group by state,party
order by percent_share_2019 desc;


-- Q8 BJP
with cte_2019 as
-- retrieve only bjp party details
(select *
from
-- sum of votes for each constituency
(select state, pc_name, party, total_votes, sum(total_votes) over(partition by pc_name) as sum_votes_2019
from constituency_wise_results_2019)x
where party = 'bjp'),

cte_2014 as
-- retrieve only bjp party details
(select *
from
-- sum of votes for each constituency
(select state, pc_name, party, total_votes, sum(total_votes) over(partition by pc_name) as sum_votes_2014
from constituency_wise_results_2014)z
where party = 'bjp')

-- calculate vote share differnce
select c19.state, c19.pc_name, round(c14.total_votes/sum_votes_2014 * 100,2) as vote_share_2014, round(c19.total_votes/sum_votes_2019 * 100,2) as vote_share_2019, (round(c19.total_votes/sum_votes_2019 * 100,2) - round(c14.total_votes/sum_votes_2014 * 100,2)) as vote_share_diff
from cte_2014 c14
join cte_2019 c19
on c14.pc_name = c19.pc_name
order by vote_share_diff desc;


-- INC
-- retrieve only inc party details
with cte_2019 as
(select *
from
-- sum of votes for each constituency
(select state, pc_name, party, total_votes, sum(total_votes) over(partition by pc_name) as sum_votes_2019
from constituency_wise_results_2019)x
where party = 'inc'),

cte_2014 as
-- retrieve only inc party details
(select *
from
-- sum of votes for each constituency
(select state, pc_name, party, total_votes, sum(total_votes) over(partition by pc_name) as sum_votes_2014
from constituency_wise_results_2014)z
where party = 'inc')

-- calculate vote share difference (C = V/T *100)
select c19.state, c19.pc_name, round(c14.total_votes/sum_votes_2014 * 100,2) as vote_share_2014, round(c19.total_votes/sum_votes_2019 * 100,2) as vote_share_2019, (round(c19.total_votes/sum_votes_2019 * 100,2) - round(c14.total_votes/sum_votes_2014 * 100,2)) as vote_share_diff
from cte_2014 c14
join cte_2019 c19
on c14.pc_name = c19.pc_name
order by vote_share_diff desc;


-- Q9 BJP
with cte_2019 as
(select *
from
(select state, pc_name, party, total_votes, sum(total_votes) over(partition by pc_name) as sum_votes_2019
from constituency_wise_results_2019)x
where party = 'bjp'),

cte_2014 as
(select *
from
(select state, pc_name, party, total_votes, sum(total_votes) over(partition by pc_name) as sum_votes_2014
from constituency_wise_results_2014)z
where party = 'bjp')

select c19.state, c19.pc_name, round(c14.total_votes/sum_votes_2014 * 100,2) as vote_share_2014, round(c19.total_votes/sum_votes_2019 * 100,2) as vote_share_2019, (round(c19.total_votes/sum_votes_2019 * 100,2) - round(c14.total_votes/sum_votes_2014 * 100,2)) as vote_share_diff
from cte_2014 c14
join cte_2019 c19
on c14.pc_name = c19.pc_name
order by vote_share_diff;

-- INC
with cte_2019 as
(select *
from
(select state, pc_name, party, total_votes, sum(total_votes) over(partition by pc_name) as sum_votes_2019
from constituency_wise_results_2019)x
where party = 'inc'),

cte_2014 as
(select *
from
(select state, pc_name, party, total_votes, sum(total_votes) over(partition by pc_name) as sum_votes_2014
from constituency_wise_results_2014)z
where party = 'inc')

select c19.state, c19.pc_name, round(c14.total_votes/sum_votes_2014 * 100,2) as vote_share_2014, round(c19.total_votes/sum_votes_2019 * 100,2) as vote_share_2019, (round(c19.total_votes/sum_votes_2019 * 100,2) - round(c14.total_votes/sum_votes_2014 * 100,2)) as vote_share_diff
from cte_2014 c14
join cte_2019 c19
on c14.pc_name = c19.pc_name
order by vote_share_diff;


-- 10
-- Constituency voted most for NOTA
select state, pc_name, total_votes
from constituency_wise_results_2014
where party = 'NOTA'
order by total_votes desc
limit 1;


select state, pc_name, total_votes
from constituency_wise_results_2019
where party = 'NOTA'
order by total_votes desc
limit 1;


-- Q11
with cte as
(select * from 
(select state, pc_name, candidate, party, total_votes ,row_number() over(partition by pc_name order by total_votes desc) as ranks
from constituency_wise_results_2019) derived
where ranks = 1),

 cte_2019 as
(select *, sum(total_votes_2019) over(partition by state) as sum_votes_2019
from
(select party, state, pc_name, sum(total_votes) as total_votes_2019
from constituency_wise_results_2019
group by party,state)x
 )

select c2.state, c2.pc_name, c1.candidate, c1.party, round(total_votes_2019/sum_votes_2019 * 100,2)  as percent_share_2019
from cte c1
join cte_2019 c2
on c1.state = c2.state and c1.pc_name = c2.pc_name
where round(total_votes_2019/sum_votes_2019 * 100,2) between 1 and 10
order by percent_share_2019 ;

