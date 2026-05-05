--CY HH giving
drop table if exists #tempCYHH
select 

	 HOH_ID
	 ,count(distinct ID) as IN_Donor
	,sum(rv_amount) as total_rev
	,CASE
		WHEN round(sum(rv_amount),0) > '0' and round(sum(rv_amount),0) < '100' then '1-99'
		WHEN round(sum(rv_amount),0) >= '100' and round(sum(rv_amount),0) < '1000' then '100-999'
		WHEN round(sum(rv_amount),0) >= '1000' and round(sum(rv_amount),0) < '5000' then '1,000-4,999'
		WHEN round(sum(rv_amount),0) >= '5000' and round(sum(rv_amount),0) < '10000' then '5,000-9,999'
		WHEN round(sum(rv_amount),0) >= '10000' and round(sum(rv_amount),0) < '25000' then '10,000-24,999'
		WHEN round(sum(rv_amount),0) >= '25000' and round(sum(rv_amount),0) < '50000' then '25,000-49,999'
		WHEN round(sum(rv_amount),0) >= '50000' and round(sum(rv_amount),0) < '100000' then '50,000-99,999'
		WHEN round(sum(rv_amount),0) >= '100000' and round(sum(rv_amount),0) < '250000' then '100,000-249,999'
		WHEN round(sum(rv_amount),0) >= '250000' and round(sum(rv_amount),0) < '500000' then '250,000-499,999'
		WHEN round(sum(rv_amount),0) >= '500000' and round(sum(rv_amount),0) < '1000000' then '500,000-999,999' 
		when round(sum(rv_amount),0) >= '1000000' then '1000000+'
	END AS category
	into #tempCYHH
	from fr101.dbo.COMMRECV rv
	join fr101.dbo.FUND
	on fu_key=RV_FUKEY
	join UJADW.dbo.UDRT_30Yr_Trend_Analysis on rv_id = id
	WHERE rv_CAMP= 'A'
	AND rv_CAMPYR = 2026
	and fu_type in ('UN','DD','TG')
	and FU_FUND not in ('1144','1145','1197')
	group by Hoh_id
	having round(sum(rv_amount),0) > 0

	--select * from #tempCY

--tempPYHH
drop table if exists #tempPYHH
select
	 HOH_ID
	 ,count(distinct ID) as IN_donor
	,sum(tz_amount) as total_rev
	,CASE
		WHEN round(sum(tz_amount),0) > '0' and sum(tz_amount) < '100' then '1-99'
		WHEN round(sum(tz_amount),0) >= '100' and round(sum(tz_amount),0) < '1000' then '100-999'
		WHEN round(sum(tz_amount),0) >= '1000' and round(sum(tz_amount),0) < '5000' then '1,000-4,999'
		WHEN round(sum(tz_amount),0) >= '5000' and round(sum(tz_amount),0) < '10000' then '5,000-9,999'
		WHEN round(sum(tz_amount),0) >= '10000' and round(sum(tz_amount),0) < '25000' then '10,000-24,999'
		WHEN round(sum(tz_amount),0) >= '25000' and round(sum(tz_amount),0) < '50000' then '25,000-49,999'
		WHEN round(sum(tz_amount),0) >= '50000' and round(sum(tz_amount),0) < '100000' then '50,000-99,999'
		WHEN round(sum(tz_amount),0) >= '100000' and round(sum(tz_amount),0) < '250000' then '100,000-249,999'
		WHEN round(sum(tz_amount),0) >= '250000' and round(sum(tz_amount),0) < '500000' then '250,000-499,999'
		WHEN round(sum(tz_amount),0) >= '500000' and round(sum(tz_amount),0) < '1000000' then '500,000-999,999'
		when round(sum(TZ_AMOUNT),0) >= '1000000' then '1000000+'
	END AS category
	into #tempPYHH
	from fr101.dbo.TRANDET_RV tz
	join fr101.dbo.FUND fu
	on fu.fu_key = tz.TZ_FUKEY
	join fr101.dbo.TRANSACT_RV tr
	on tr.TR_KEY = tz.TZ_TRKEY
	join fr101.dbo.COMMRECV rv
	on RV_KEY = TR_RVKEY
	join UJADW.dbo.UDRT_30Yr_Trend_Analysis on rv_id = id
	WHERE TZ_CAMP= 'A'
	AND TZ_CAMPYR = 2025
	and TR_DOCDATE < (SELECT DATEADD(YEAR, -1, cast(GETDATE() as date)))
	and fu_type in ('UN','DD','TG')
	and FU_FUND not in ('1144','1145','1197')
	group by HOH_ID
	having round(sum(tz_amount),0)> 0
	

--Temp Rev diff
drop table if exists #temprevdiffHH
select 
dr26.category
,dr26.total_rev as '2026 HH rev'
,dr25.total_rev as '2025 HH rev'
,dr26.total_rev - dr25.total_rev as '$ Diff'
,(dr26.total_rev - dr25.total_rev) * 100.0 / NULLIF(dr25.total_rev, 0) AS [% Diff]
into #TempRevDiffHH
from  (
--2026 donor revenue
	select 
	category,
	sum(total_rev) as total_rev
	from (
		select *
		from #tempCYHH
		) cat26
group by category
) dr26 
full outer join (
--2025 donor revenue
	select 
	category,
	sum(total_rev) as total_rev
	from (
		select *
		from #tempPYHH
		) cat25
	group by category

) dr25 on dr25.category = dr26.category


--donor count by category
drop table if exists #tempDCD
select 
dr26.category
,dr26.donor_count as '2026 HH donor'
,dr26.[2026_IN] as '2026 IN donor'
,dr25.donor_count as '2025 HH donor'
,dr25.[2025_IN] as '2025 IN donor'
,dr26.donor_count - dr25.donor_count as '# Diff'
,(dr26.donor_count - dr25.donor_count)*1.0/dr25.donor_count*100 as '% Diff'
into #tempDCD
from  (
--2026 donor revenue
	select
	category
	,count(distinct HOH_ID) as donor_count
	,sum( IN_Donor) as '2026_IN'
	from(	
		select *
		from #tempCYHH
		) cat26
	group by category
	  ) dr26 
full outer join (
--2025 donor count
	select
	category
	,count(distinct HOH_ID) as donor_count
	,sum(IN_donor) as '2025_IN'
	from(	select *
		from #tempPYHH ) cat26
	group by category--, IN_donor
) dr25 on dr25.category = dr26.category


--1k over under with totals rev
DROP TABLE IF EXISTS #Summary1kR;
WITH base AS (
    SELECT
        c.[1k Category],
        c.[2026],
        p.[2025]
    FROM (
        SELECT 
            CASE 
                WHEN category IN ('1-99','100-999') THEN 'Total under $1k'
                ELSE 'Total $1k+'
            END AS [1k Category],
            SUM(total_rev) AS [2026]
        FROM #tempCYHH
        GROUP BY 
            CASE 
                WHEN category IN ('1-99','100-999') THEN 'Total under $1k'
                ELSE 'Total $1k+'
            END
    ) c
    JOIN (
        SELECT 
            CASE 
                WHEN category IN ('1-99','100-999') THEN 'Total under $1k'
                ELSE 'Total $1k+'
            END AS [1k Category],
            SUM(total_rev) AS [2025]
        FROM #tempPYHH
        GROUP BY 
            CASE 
                WHEN category IN ('1-99','100-999') THEN 'Total under $1k'
                ELSE 'Total $1k+'
            END
    ) p
        ON p.[1k Category] = c.[1k Category]
)
SELECT *
INTO #Summary1kR
FROM (
    SELECT
        [1k Category],
        [2026],
        [2025],
        [2026] - [2025] AS [$Diff],
        ROUND((([2026] - [2025]) * 100.0) / NULLIF([2026], 0), 1) AS [%Diff]
    FROM base

    UNION ALL

    SELECT
        'Total' AS [1k Category],
        SUM([2026]) AS [2026],
        SUM([2025]) AS [2025],
        SUM([2026]) - SUM([2025]) AS [$Diff],
        ROUND(((SUM([2026]) - SUM([2025])) * 100.0) / NULLIF(SUM([2026]), 0), 1) AS [%Diff]
    FROM base
) x;

--Donor count
DROP TABLE IF EXISTS #Summary1kD;
WITH base AS (
    SELECT
        c.[1k Category],
        c.[2026],
		c.[IN 2026],
        p.[2025],
		p.IN_2025
    FROM (
        SELECT 
            CASE 
                WHEN category IN ('1-99','100-999') THEN 'Total under $1k'
                ELSE 'Total $1k+'
            END AS [1k Category],
            count(hoh_id) AS [2026]
			,sum(IN_Donor) as [IN 2026]
        FROM #tempCYHH
        GROUP BY 
            CASE 
                WHEN category IN ('1-99','100-999') THEN 'Total under $1k'
                ELSE 'Total $1k+'
            END
    ) c
    JOIN (
        SELECT 
            CASE 
                WHEN category IN ('1-99','100-999') THEN 'Total under $1k'
                ELSE 'Total $1k+'
            END AS [1k Category],
            count(hoh_id) AS [2025],
			sum(IN_donor) as [IN_2025]
        FROM #tempPYHH
        GROUP BY 
            CASE 
                WHEN category IN ('1-99','100-999') THEN 'Total under $1k'
                ELSE 'Total $1k+'
            END
    ) p
        ON p.[1k Category] = c.[1k Category]
)
SELECT *
INTO #Summary1kD
FROM (
    SELECT
        [1k Category],
        [2026],
		[IN 2026],
        [2025],
		[IN_2025],
        [2026] - [2025] AS [$Diff],
        ROUND((([2026] - [2025]) * 100.0) / NULLIF([2026], 0), 1) AS [%Diff]
    FROM base

    UNION ALL

    SELECT
        'Total' AS [1k Category],
        SUM([2026]) AS [2026],
		sum([IN 2026]) as [IN_2026],
        SUM([2025]) AS [2025],
		sum([IN_2025]) as [IN_2025],
        SUM([2026]) - SUM([2025]) AS [$Diff],
        ROUND(((SUM([2026]) - SUM([2025])) * 100.0) / NULLIF(SUM([2026]), 0), 1)  AS [%Diff]
    FROM base
) x;


--temp CY
drop table if exists #tempCY
select 

	 HOH_ID,
	 id
	,sum(rv_amount) as total_rev
	,CASE
		WHEN round(sum(rv_amount),0) > '0' and round(sum(rv_amount),0) < '100' then '1-99'
		WHEN round(sum(rv_amount),0) >= '100' and round(sum(rv_amount),0) < '1000' then '100-999'
		WHEN round(sum(rv_amount),0) >= '1000' and round(sum(rv_amount),0) < '5000' then '1,000-4,999'
		WHEN round(sum(rv_amount),0) >= '5000' and round(sum(rv_amount),0) < '10000' then '5,000-9,999'
		WHEN round(sum(rv_amount),0) >= '10000' and round(sum(rv_amount),0) < '25000' then '10,000-24,999'
		WHEN round(sum(rv_amount),0) >= '25000' and round(sum(rv_amount),0) < '50000' then '25,000-49,999'
		WHEN round(sum(rv_amount),0) >= '50000' and round(sum(rv_amount),0) < '100000' then '50,000-99,999'
		WHEN round(sum(rv_amount),0) >= '100000' and round(sum(rv_amount),0) < '250000' then '100,000-249,999'
		WHEN round(sum(rv_amount),0) >= '250000' and round(sum(rv_amount),0) < '500000' then '250,000-499,999'
		WHEN round(sum(rv_amount),0) >= '500000' and round(sum(rv_amount),0) < '1000000' then '500,000-999,999' 
		when round(sum(rv_amount),0) >= '1000000' then '1000000+'
	END AS category
	into #tempCY
	from fr101.dbo.COMMRECV rv
	join fr101.dbo.FUND
	on fu_key=RV_FUKEY
	join UJADW.dbo.UDRT_30Yr_Trend_Analysis on rv_id = id
	WHERE rv_CAMP= 'A'
	AND rv_CAMPYR = 2026
	and fu_type in ('UN','DD','TG')
	and FU_FUND not in ('1144','1145','1197')
	group by HOH_ID,id
	having round(sum(rv_amount),0) > 0

--tempPY
drop table if exists #tempPY
select
	 HOH_ID,
	 ID
	,sum(tz_amount) as total_rev
	,CASE
		WHEN sum(tz_amount) > '0' and sum(tz_amount) < '100' then '1-99'
		WHEN round(sum(tz_amount),0) >= '100' and round(sum(tz_amount),0) < '1000' then '100-999'
		WHEN round(sum(tz_amount),0) >= '1000' and round(sum(tz_amount),0) < '5000' then '1,000-4,999'
		WHEN round(sum(tz_amount),0) >= '5000' and round(sum(tz_amount),0) < '10000' then '5,000-9,999'
		WHEN round(sum(tz_amount),0) >= '10000' and round(sum(tz_amount),0) < '25000' then '10,000-24,999'
		WHEN round(sum(tz_amount),0) >= '25000' and round(sum(tz_amount),0) < '50000' then '25,000-49,999'
		WHEN round(sum(tz_amount),0) >= '50000' and round(sum(tz_amount),0) < '100000' then '50,000-99,999'
		WHEN round(sum(tz_amount),0) >= '100000' and round(sum(tz_amount),0) < '250000' then '100,000-249,999'
		WHEN round(sum(tz_amount),0) >= '250000' and round(sum(tz_amount),0) < '500000' then '250,000-499,999'
		WHEN round(sum(tz_amount),0) >= '500000' and round(sum(tz_amount),0) < '1000000' then '500,000-999,999'
		when round(sum(TZ_AMOUNT),0) >= '1000000' then '1000000+'
	END AS category
	into #tempPY
	from fr101.dbo.TRANDET_RV tz
	join fr101.dbo.FUND fu
	on fu.fu_key = tz.TZ_FUKEY
	join fr101.dbo.TRANSACT_RV tr
	on tr.TR_KEY = tz.TZ_TRKEY
	join fr101.dbo.COMMRECV rv
	on RV_KEY = TR_RVKEY
	join UJADW.dbo.UDRT_30Yr_Trend_Analysis on rv_id = id
	WHERE TZ_CAMP= 'A'
	AND TZ_CAMPYR = 2025
	and TR_DOCDATE < (SELECT DATEADD(YEAR, -1, cast(GETDATE() as date)))
	and fu_type in ('UN','DD','TG')
	and FU_FUND not in ('1144','1145','1197')
	group by HOH_ID,id
	having sum(tz_amount)> 0

--Temp Rev diff
drop table if exists #temprevdiff
select 
dr26.category
,dr26.total_rev as '2026 rev'
,dr25.total_rev as '2025 rev'
,dr26.total_rev - dr25.total_rev as '$ Diff'
,(dr26.total_rev - dr25.total_rev) * 100.0 / NULLIF(dr25.total_rev, 0) AS [% Diff]
into #TempRevDiff
from  (
--2026 donor revenue
	select 
	category,
	sum(total_rev) as total_rev
	from (
		select *
		from #tempCY
		) cat26
group by category
) dr26 
full outer join (
--2025 donor revenue
	select 
	category,
	sum(total_rev) as total_rev
	from (
		select *
		from #tempPY
		) cat25
	group by category

) dr25 on dr25.category = dr26.category

--donor count by category
drop table if exists #tempDCDD
select 
dr26.category
,dr26.donor_count as '2026 donor'
,dr25.donor_count as '2025 donor'
,dr26.donor_count - dr25.donor_count as '# Diff'
,(dr26.donor_count - dr25.donor_count)*1.0/dr25.donor_count*100 as '% Diff'
into #tempDCDD
from  (
--2026 donor revenue
	select
	category
	,count(id) as donor_count
	from(	
		select *
		from #tempCY
		) cat26
	group by category
	  ) dr26 
full outer join (
--2025 donor count
	select
	category
	,count(ID) as donor_count
	from(	select *
		from #tempPY ) cat26
	group by category
) dr25 on dr25.category = dr26.category


--1k over under with totals rev
DROP TABLE IF EXISTS #Summary1kRD;
WITH base AS (
    SELECT
        c.[1k Category],
        c.[2026],
        p.[2025]
    FROM (
        SELECT 
            CASE 
                WHEN category IN ('1-99','100-999') THEN 'Total under $1k'
                ELSE 'Total $1k+'
            END AS [1k Category],
            SUM(total_rev) AS [2026]
        FROM #tempCY
        GROUP BY 
            CASE 
                WHEN category IN ('1-99','100-999') THEN 'Total under $1k'
                ELSE 'Total $1k+'
            END
    ) c
    JOIN (
        SELECT 
            CASE 
                WHEN category IN ('1-99','100-999') THEN 'Total under $1k'
                ELSE 'Total $1k+'
            END AS [1k Category],
            SUM(total_rev) AS [2025]
        FROM #tempPY
        GROUP BY 
            CASE 
                WHEN category IN ('1-99','100-999') THEN 'Total under $1k'
                ELSE 'Total $1k+'
            END
    ) p
        ON p.[1k Category] = c.[1k Category]
)
SELECT *
INTO #Summary1kRD
FROM (
    SELECT
        [1k Category],
        [2026],
        [2025],
        [2026] - [2025] AS [$Diff],
        ROUND((([2026] - [2025]) * 100.0) / NULLIF([2026], 0), 1) AS [%Diff]
    FROM base

    UNION ALL

    SELECT
        'Total' AS [1k Category],
        SUM([2026]) AS [2026],
        SUM([2025]) AS [2025],
        SUM([2026]) - SUM([2025]) AS [$Diff],
        ROUND(((SUM([2026]) - SUM([2025])) * 100.0) / NULLIF(SUM([2026]), 0), 1) AS [%Diff]
    FROM base
) x;


--Donor count
DROP TABLE IF EXISTS #Summary1kDD;
WITH base AS (
    SELECT
        c.[1k Category],
        c.[2026],
        p.[2025]
    FROM (
        SELECT 
            CASE 
                WHEN category IN ('1-99','100-999') THEN 'Total under $1k'
                ELSE 'Total $1k+'
            END AS [1k Category],
            count(hoh_id) AS [2026]
        FROM #tempCY
        GROUP BY 
            CASE 
                WHEN category IN ('1-99','100-999') THEN 'Total under $1k'
                ELSE 'Total $1k+'
            END
    ) c
    JOIN (
        SELECT 
            CASE 
                WHEN category IN ('1-99','100-999') THEN 'Total under $1k'
                ELSE 'Total $1k+'
            END AS [1k Category],
            count(hoh_id) AS [2025]
        FROM #tempPY
        GROUP BY 
            CASE 
                WHEN category IN ('1-99','100-999') THEN 'Total under $1k'
                ELSE 'Total $1k+'
            END
    ) p
        ON p.[1k Category] = c.[1k Category]
)

SELECT *
INTO #Summary1kDD
FROM (
    SELECT
        [1k Category],
        [2026],
        [2025],
        [2026] - [2025] AS [$Diff],
        ROUND((([2026] - [2025]) * 100.0) / NULLIF([2026], 0), 1) AS [%Diff]
    FROM base

    UNION ALL

    SELECT
        'Total' AS [1k Category],
        SUM([2026]) AS [2026],
        SUM([2025]) AS [2025],
        SUM([2026]) - SUM([2025]) AS [$Diff],
        ROUND(((SUM([2026]) - SUM([2025])) * 100.0) / NULLIF(SUM([2026]), 0), 1)  AS [%Diff]
    FROM base
) x;



--Final Query
WITH Dollars AS (
    SELECT 
        base.category,
        base.[2026 rev],
        base.[2025 rev],
        base1.[2026 donor],
        base1.[2025 donor]
    FROM (
        SELECT * FROM #TempRevDiff
        UNION ALL
        SELECT * FROM #Summary1kRD
    ) base
    JOIN (
        SELECT * 
        FROM (
            SELECT * FROM #tempDCDD
            UNION ALL
            SELECT * FROM #Summary1kDD
        ) d
    ) base1
        ON base1.category = base.category
),
Households AS (
    SELECT 
        base.category,
        base.[2026 HH rev],
        base.[2025 HH rev],
        base.[$ Diff] AS [HH $ Diff],
        base.[% Diff] AS [HH % Diff],
        base1.[2026 HH donor],
        base1.[2026 IN donor],
        base1.[2025 HH donor],
        base1.[2025 IN donor],
        base1.[# Diff] AS [HH # Diff],
        base1.[% Diff] AS [HH Donor % Diff]
    FROM (
        SELECT * FROM #TempRevDiffHH
        UNION ALL
        SELECT
            [1k Category] AS category,
            [2026] AS [2026 HH rev],
            [2025] AS [2025 HH rev],
            [$Diff] AS [$ Diff],
            [%Diff] AS [% Diff]
        FROM #Summary1kR
    ) base
    JOIN (
        SELECT * FROM #tempDCD
        UNION ALL
        SELECT
            [1k Category] AS category,
            [2026] AS [2026 HH donor],
            [IN 2026] AS [2026 IN donor],
            [2025] AS [2025 HH donor],
            [IN_2025] AS [2025 IN donor],
            [$Diff] AS [# Diff],
            [%Diff] AS [% Diff]
        FROM #Summary1kD
    ) base1
        ON base1.category = base.category
)
SELECT
    d.category,
    d.[2026 rev],
    d.[2025 rev],
    d.[2026 donor],
    d.[2025 donor],
    h.[2026 HH rev],
    h.[2025 HH rev],
    h.[HH $ Diff],
    h.[HH % Diff],
    h.[2026 HH donor],
    h.[2026 IN donor],
    h.[2025 HH donor],
    h.[2025 IN donor],
    h.[HH # Diff],
    h.[HH Donor % Diff]
FROM Dollars d
JOIN Households h
    ON h.category = d.category
ORDER BY 
    CASE
        WHEN d.category = '1000000+' THEN 1
        WHEN d.category = '500,000-999,999' THEN 2
        WHEN d.category = '250,000-499,999' THEN 3
        WHEN d.category = '100,000-249,999' THEN 4
        WHEN d.category = '50,000-99,999' THEN 5
        WHEN d.category = '25,000-49,999' THEN 6
        WHEN d.category = '10,000-24,999' THEN 7
        WHEN d.category = '5,000-9,999' THEN 8
        WHEN d.category = '1,000-4,999' THEN 9
        WHEN d.category = '100-999' THEN 10
        WHEN d.category = 'Total $1k+' THEN 11
        WHEN d.category = '1-99' THEN 12
        WHEN d.category = 'Total under $1k' THEN 13
        WHEN d.category = 'Total' THEN 14
    END;