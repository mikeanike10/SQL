--Joint Addressee
drop table if exists #JointAddressee
SELECT ae_id AS ID, 
string_agg(LTRIM(RTRIM(AE_JOINTADDRESSEE)),', ') AS COMPANY
into #JointAddressee
FROM fr101.dbo.ADDRESSEE
join fr101.dbo.name on na_id = ae_id
WHERE AE_TYPE = 'B' AND AE_STATUS = 'c'  AND AE_PRIMARY = 1
AND
(
ae_jointaddressee  LIKE 'Barclays Capital%' OR
ae_jointaddressee LIKE 'IBM%' OR
ae_jointaddressee LIKE 'AllianceB%' OR
ae_jointaddressee LIKE 'Alliance Bernstein%' OR
ae_jointaddressee LIKE 'SalesForce%' OR
ae_jointaddressee LIKE '%Merrill Lynch%' OR
--ae_jointaddressee LIKE 'Bank of America%' OR
ae_jointaddressee LIKE 'Kirkland%' OR
ae_jointaddressee LIKE 'Pfizer%' OR
ae_jointaddressee LIKE 'Royal Bank of Canada%' OR
ae_jointaddressee LIKE 'RBC%' OR
ae_jointaddressee LIKE 'Davis Polk%' OR
ae_jointaddressee LIKE 'Jefferies%' OR
ae_jointaddressee LIKE 'Deutsche Bank%' OR
ae_jointaddressee LIKE 'Sony music%' OR
ae_jointaddressee LIKE 'morgan stanley%' OR
ae_jointaddressee LIKE 'Mizuho%' OR
ae_jointaddressee LIKE 'houlihan lokey%' OR
ae_jointaddressee LIKE 'microsoft%' OR
ae_jointaddressee LIKE 'hearst%' OR
ae_jointaddressee LIKE 'paramount%' OR
ae_jointaddressee LIKE 'ares management%' OR
ae_jointaddressee LIKE 'Johnson & Johnson%' OR
ae_jointaddressee like 'Arch Insurance%'
)
group by AE_ID;

drop table if exists #IDtable
select ae_id as ID
into #IDtable
from fr101.dbo.ADDRESSEE
WHERE AE_TYPE = 'B' AND AE_STATUS = 'c'  AND AE_PRIMARY = 1
AND
(
ae_jointaddressee  LIKE 'Barclays Capital%' OR
ae_jointaddressee LIKE 'IBM%' OR
ae_jointaddressee LIKE 'AllianceB%' OR
ae_jointaddressee LIKE 'Alliance Bernstein%' OR
ae_jointaddressee LIKE 'SalesForce%' OR
ae_jointaddressee LIKE '%Merrill Lynch%' OR
--ae_jointaddressee LIKE 'Bank of America%' OR
ae_jointaddressee LIKE 'Kirkland%' OR
ae_jointaddressee LIKE 'Pfizer%' OR
ae_jointaddressee LIKE 'Royal Bank of Canada%' OR
ae_jointaddressee LIKE 'RBC%' OR
ae_jointaddressee LIKE 'Davis Polk%' OR
ae_jointaddressee LIKE 'Jefferies%' OR
ae_jointaddressee LIKE 'Deutsche Bank%' OR
ae_jointaddressee LIKE 'Sony music%' OR
ae_jointaddressee LIKE 'morgan stanley%' OR
ae_jointaddressee LIKE 'Mizuho%' OR
ae_jointaddressee LIKE 'houlihan lokey%' OR
ae_jointaddressee LIKE 'microsoft%' OR
ae_jointaddressee LIKE 'hearst%' OR
ae_jointaddressee LIKE 'paramount%' OR
ae_jointaddressee LIKE 'ares management%' OR
ae_jointaddressee LIKE 'Johnson & Johnson%' OR
ae_jointaddressee like 'Arch Insurance%'
)
group by AE_ID


--future #jointaddressee temp table
DROP TABLE IF EXISTS #jointaddressee1;
SELECT 
    AE_ID AS ID,
    CASE 
        WHEN COUNT(NULLIF(LTRIM(RTRIM(AE_JOINTADDRESSEE)), '')) = 0 
            THEN 'Empty'
        ELSE STRING_AGG(LTRIM(RTRIM(AE_JOINTADDRESSEE)), ', ')
    END AS Company,
    CASE 
        WHEN AE_ID IN (SELECT ID FROM #IDtable) THEN 'Yes' 
        ELSE 'No' 
    END AS Company_Lower20
INTO #jointaddressee1
FROM fr101.dbo.ADDRESSEE
WHERE AE_TYPE = 'B' AND AE_STATUS = 'c'  AND AE_PRIMARY = 1
  --and AE_ID IN (SELECT ID FROM #IDtable)
GROUP BY AE_ID;

----Company Name
--Select
--na_id ID
--,na_company Company
--from dbo.name
--where
--(
--na_company   LIKE 'Barclays Capital%' OR
--na_company LIKE 'IBM%' OR
--na_company LIKE 'AllianceB%' OR
--na_company like 'Alliance Bernstein%' OR
--na_company LIKE 'SalesForce%' OR
--na_company LIKE 'Merrill Lynch%' OR
--na_company LIKE 'Bank of America%' OR
--na_company LIKE 'Kirkland%' OR
--na_company LIKE 'Pfizer%' OR
--na_company LIKE 'Royal Bank of Canada%' OR
--na_company LIKE 'RBC%' OR
--na_company LIKE 'Davis Polk%' OR
--na_company LIKE 'Jefferies%' OR
--na_company LIKE 'Deutsche Bank%' OR
--na_company LIKE 'Sony music%' OR
--na_company LIKE 'Morgan stanley%' OR
--na_company LIKE 'Mizuho%' OR
--na_company LIKE 'Houlihan lokey%' OR
--na_company LIKE 'Microsoft%' OR
--na_company LIKE 'Hearst%' OR
--na_company LIKE 'Paramount%' OR
--na_company LIKE 'Ares Management%' OR
--na_company LIKE 'Johnson & Johnson%' OR
--na_company LIKE 'Arch Insurance%'
--)
--and na_type = 'i'
--;


----Business Addressee
--SELECT ae_id AS ID, AE_TYPE, AE_STATUS, AE_PRIMARY, LTRIM(RTRIM(AE_ADDRESSEE)) AS COMPANY
--FROM fr101.dbo.ADDRESSEE
--join dbo.name on na_id = ae_id
--WHERE AE_TYPE = 'B' AND AE_STATUS = 'c'  AND AE_PRIMARY = 1
--AND
--(
--ae_addressee LIKE '%Barclays Capital%' OR
--ae_addressee LIKE '%IBM%' OR
--ae_addressee LIKE '%AllianceB%' OR
--ae_addressee LIKE '%Alliance Bernstein%' OR
--ae_addressee LIKE '%SalesForce%' OR
--ae_addressee LIKE '%Merrill Lynch%' OR
--ae_addressee LIKE '%Bank of America%' OR
--ae_addressee LIKE '%Kirkland & Ellis%' OR
--ae_addressee LIKE '%Pfizer%' OR
--ae_addressee LIKE '%Royal Bank of Canada%' OR
--ae_addressee LIKE '%RBC%' OR
--ae_addressee LIKE '%Davis Polk%' OR
--ae_addressee LIKE '%Jefferies%' OR
--ae_addressee LIKE '%Deutsche Bank%' OR
--ae_addressee LIKE '%Sony music%' OR
--ae_addressee LIKE '%morgan stanley%' OR
--ae_addressee LIKE '%Mizuho%' OR
--ae_addressee LIKE '%houlihan lokey%' OR
--ae_addressee LIKE '%microsoft%' OR
--ae_addressee LIKE '%hearst%' OR
--ae_addressee LIKE '%paramount%' OR
--ae_addressee LIKE '%ares management%' OR
--ae_addressee LIKE '%Johnson & Johnson%'
--);

--SELECT 
--    ae_id AS ID, 
--    AE_TYPE, 
--    AE_STATUS, 
--    AE_PRIMARY, 
--    LTRIM(RTRIM(AE_ADDRESSEE)) AS COMPANY
--FROM fr101.dbo.ADDRESSEE
--JOIN dbo.name 
--    ON na_id = ae_id

--CROSS APPLY (
--    SELECT CleanAddressee =
--        ' ' + REPLACE(REPLACE(REPLACE(ae_addressee, CHAR(13), ' '), CHAR(10), ' '), CHAR(9), ' ') + ' '
--) ca

--WHERE 
--    AE_TYPE = 'B' 
--    AND AE_STATUS = 'c'  
--    AND AE_PRIMARY = 1
--    AND
--    (
--        ca.CleanAddressee LIKE '% Barclays Capital %' OR
--        ca.CleanAddressee LIKE '% IBM %' OR
--        ca.CleanAddressee LIKE '% AllianceB %' OR
--        ca.CleanAddressee LIKE '% Alliance Bernstein %' OR
--        ca.CleanAddressee LIKE '% SalesForce %' OR
--        ca.CleanAddressee LIKE '% Merrill Lynch %' OR
--        ca.CleanAddressee LIKE '% Bank of America %' OR
--        ca.CleanAddressee LIKE '% Kirkland & Ellis %' OR
--        ca.CleanAddressee LIKE '% Pfizer %' OR
--        ca.CleanAddressee LIKE '% Royal Bank of Canada %' OR
--        ca.CleanAddressee LIKE '% RBC %' OR
--        ca.CleanAddressee LIKE '% Davis Polk %' OR
--        ca.CleanAddressee LIKE '% Jefferies %' OR
--        ca.CleanAddressee LIKE '% Deutsche Bank %' OR
--        ca.CleanAddressee LIKE '% Sony music %' OR
--        ca.CleanAddressee LIKE '% morgan stanley %' OR
--        ca.CleanAddressee LIKE '% Mizuho %' OR
--        ca.CleanAddressee LIKE '% houlihan lokey %' OR
--        ca.CleanAddressee LIKE '% microsoft %' OR
--        ca.CleanAddressee LIKE '% hearst %' OR
--        ca.CleanAddressee LIKE '% paramount %' OR
--        ca.CleanAddressee LIKE '% ares management %' OR
--        ca.CleanAddressee LIKE '% Johnson & Johnson %'
--    );


--BusinessAddressee
    drop table if exists #BusinessAddressee
	SELECT 
    ae_id AS ID, 
    --AE_TYPE, 
    --AE_STATUS, 
   -- AE_PRIMARY, 
    string_agg(LTRIM(RTRIM(AE_ADDRESSEE)),', ') AS COMPANY
	into #BusinessAddressee
FROM fr101.dbo.ADDRESSEE
JOIN fr101.dbo.name 
    ON na_id = ae_id

CROSS APPLY (
    SELECT CleanAddressee =
        ' ' + REPLACE(REPLACE(REPLACE(ae_addressee, CHAR(13), ' '), CHAR(10), ' '), CHAR(9), ' ') + ' '
) ca

WHERE 
    AE_TYPE = 'B' 
    AND AE_STATUS = 'c'  
    AND AE_PRIMARY = 1
    AND
    (
        ae_addressee LIKE '%Barclays Capital%' OR
        ae_addressee LIKE '%AllianceB%' OR
        ae_addressee LIKE '%Alliance Bernstein%' OR
        ae_addressee LIKE '%SalesForce%' OR
        ae_addressee LIKE '%Merrill Lynch%' OR
        --ae_addressee LIKE '%Bank of America%' OR
        ae_addressee LIKE '%Kirkland & Ellis%' OR
        ae_addressee LIKE '%Kirkland and Ellis%' OR
        ae_addressee LIKE '%Pfizer%' OR
        ae_addressee LIKE '%Royal Bank of Canada%' OR
        ae_addressee LIKE '%RBC%' OR
        ae_addressee LIKE '%Davis Polk%' OR
        ae_addressee LIKE '%Jefferies%' OR
        ae_addressee LIKE '%Deutsche Bank%' OR
        ae_addressee LIKE '%Sony music%' OR
        ae_addressee LIKE '%morgan stanley%' OR
        ae_addressee LIKE '%Mizuho%' OR
        ae_addressee LIKE '%houlihan lokey%' OR
        ae_addressee LIKE '%microsoft%' OR
        ae_addressee LIKE '%paramount%' OR
        ae_addressee LIKE '%ares management%' OR
        ae_addressee LIKE '%Johnson & Johnson%' OR
        ae_addressee like '%Arch Insurance%' OR

        -- stricter matching only where needed
        ca.CleanAddressee LIKE '% IBM %' OR
        ca.CleanAddressee LIKE '% Hearst %' OR
        ca.CleanAddressee LIKE '% Hearst %' OR
        ca.CleanAddressee LIKE '% Hearst/%' OR
        ca.CleanAddressee LIKE '% Hearst-%'
    )
    group by AE_ID;


drop table if exists #strictIDtable
SELECT 
    ae_id AS ID
	into #strictIDtable
FROM fr101.dbo.ADDRESSEE
JOIN fr101.dbo.name 
    ON na_id = ae_id
CROSS APPLY (
    SELECT CleanAddressee =
        ' ' + REPLACE(REPLACE(REPLACE(ae_addressee, CHAR(13), ' '), CHAR(10), ' '), CHAR(9), ' ') + ' '
) ca
WHERE 
    AE_TYPE = 'B' 
    AND AE_STATUS = 'c'  
    AND AE_PRIMARY = 1
    AND
    (
        ae_addressee LIKE '%Barclays Capital%' OR
        ae_addressee LIKE '%AllianceB%' OR
        ae_addressee LIKE '%Alliance Bernstein%' OR
        ae_addressee LIKE '%SalesForce%' OR
        ae_addressee LIKE '%Merrill Lynch%' OR
        --ae_addressee LIKE '%Bank of America%' OR
        ae_addressee LIKE '%Kirkland & Ellis%' OR
        ae_addressee LIKE '%Kirkland and Ellis%' OR
        ae_addressee LIKE '%Pfizer%' OR
        ae_addressee LIKE '%Royal Bank of Canada%' OR
        ae_addressee LIKE '%RBC%' OR
        ae_addressee LIKE '%Davis Polk%' OR
        ae_addressee LIKE '%Jefferies%' OR
        ae_addressee LIKE '%Deutsche Bank%' OR
        ae_addressee LIKE '%Sony music%' OR
        ae_addressee LIKE '%morgan stanley%' OR
        ae_addressee LIKE '%Mizuho%' OR
        ae_addressee LIKE '%houlihan lokey%' OR
        ae_addressee LIKE '%microsoft%' OR
        ae_addressee LIKE '%paramount%' OR
        ae_addressee LIKE '%ares management%' OR
        ae_addressee LIKE '%Johnson & Johnson%' OR
        ae_addressee like '%Arch Insurance%' OR

        -- stricter matching only where needed
        ca.CleanAddressee LIKE '% IBM %' OR
        ca.CleanAddressee LIKE '% Hearst %' OR
        ca.CleanAddressee LIKE '% Hearst %' OR
        ca.CleanAddressee LIKE '% Hearst/%' OR
        ca.CleanAddressee LIKE '% Hearst-%'
    )
    group by AE_ID;

--future #businessaddressee table
drop table if exists #businessaddressee1
SELECT 
    ae_id AS ID, 
    string_agg(LTRIM(RTRIM(AE_ADDRESSEE)),', ') AS COMPANY
	,case when ae_id in (select ID from #strictIDtable) then 'Yes' else 'No' end BusinessID_Lower20
into #businessaddressee1
FROM fr101.dbo.ADDRESSEE
JOIN fr101.dbo.name 
    ON na_id = ae_id

CROSS APPLY (
    SELECT CleanAddressee =
        ' ' + REPLACE(REPLACE(REPLACE(ae_addressee, CHAR(13), ' '), CHAR(10), ' '), CHAR(9), ' ') + ' '
) ca

WHERE 
    AE_TYPE = 'B' 
    AND AE_STATUS = 'c'  
    AND AE_PRIMARY = 1
	--and ae_id in (select ID from #strictIDtable)
group by AE_ID;





--Business Name (where the Business Name is an FR101 ID)
drop table if exists #BusinessID
SELECT ae_id AS ID,
--AE_TYPE, 
--AE_STATUS,
--AE_PRIMARY,
string_agg((RTRIM(crn_na_name)),', ') AS COMPANY
into #BusinessID
FROM fr101.dbo.ADDRESSEE
join fr101.dbo.name on na_id = ae_busid
join ujadw.dbo.fr101_commonreport_name on crn_na_id = na_id
WHERE AE_TYPE = 'B' AND AE_STATUS = 'c'  AND AE_PRIMARY = 1
AND
(
NA_RECSORT  LIKE 'Barclays Capital%' OR
na_recsort LIKE 'IBM%' OR
na_recsort LIKE 'AllianceB%' OR
na_recsort like 'Alliance Bernstein%' OR
na_recsort LIKE 'SalesForce%' OR
na_recsort LIKE '%Merrill Lynch%' OR
--na_recsort LIKE 'Bank of America%' OR
na_recsort LIKE 'Kirkland%' OR
na_recsort LIKE 'Pfizer%' OR
na_recsort LIKE 'Royal Bank of Canada%' OR
na_recsort LIKE 'RBC%' OR
na_recsort LIKE 'Davis Polk%' OR
na_recsort LIKE 'Jefferies%' OR
na_recsort LIKE 'Deutsche Bank%' OR
na_recsort LIKE 'Sony music%' OR
na_recsort LIKE 'Morgan stanley%' OR
na_recsort LIKE 'Mizuho%' OR
na_recsort LIKE 'Houlihan lokey%' OR
na_recsort LIKE 'Microsoft%' OR
na_recsort LIKE 'Hearst%' OR
na_recsort LIKE 'Paramount%' OR
na_recsort LIKE 'Ares Management%' OR
na_recsort LIKE 'Johnson & Johnson%' OR
na_recsort LIKE 'Arch Insurance%'
)
group by AE_ID;

drop table if exists #recsorttable
select ae_id as ID
into #Recsorttable
from fr101.dbo.ADDRESSEE
join fr101.dbo.name on na_id = ae_busid
join ujadw.dbo.fr101_commonreport_name on crn_na_id = na_id
WHERE AE_TYPE = 'B' AND AE_STATUS = 'c'  AND AE_PRIMARY = 1
AND
(
NA_recsort  LIKE 'Barclays Capital%' OR
NA_recsort LIKE 'IBM%' OR
NA_recsort LIKE 'AllianceB%' OR
NA_recsort LIKE 'Alliance Bernstein%' OR
NA_recsort LIKE 'SalesForce%' OR
NA_recsort LIKE '%Merrill Lynch%' OR
--NA_recsort LIKE 'Bank of America%' OR
NA_recsort LIKE 'Kirkland%' OR
NA_recsort LIKE 'Pfizer%' OR
NA_recsort LIKE 'Royal Bank of Canada%' OR
NA_recsort LIKE 'RBC%' OR
NA_recsort LIKE 'Davis Polk%' OR
NA_recsort LIKE 'Jefferies%' OR
NA_recsort LIKE 'Deutsche Bank%' OR
NA_recsort LIKE 'Sony music%' OR
NA_recsort LIKE 'morgan stanley%' OR
NA_recsort LIKE 'Mizuho%' OR
NA_recsort LIKE 'houlihan lokey%' OR
NA_recsort LIKE 'microsoft%' OR
NA_recsort LIKE 'hearst%' OR
NA_recsort LIKE 'paramount%' OR
NA_recsort LIKE 'ares management%' OR
NA_recsort LIKE 'Johnson & Johnson%' OR
NA_recsort like 'Arch Insurance%'
)


--future #businessID table
drop table if exists #businessID1
select
ae_id AS ID,
string_agg((RTRIM(crn_na_name)),', ') AS COMPANY,
CASE when AE_ID in (select ID from #Recsorttable) then 'Yes' else 'No' end businessID_Lower20
into #businessID1
FROM fr101.dbo.ADDRESSEE
join fr101.dbo.name on na_id = ae_busid
join ujadw.dbo.fr101_commonreport_name on crn_na_id = NA_ID
WHERE AE_TYPE = 'B' AND AE_STATUS = 'c'  AND AE_PRIMARY = 1
--and AE_ID in (select ID from #Recsorttable)
group by AE_ID


--Employment  -- Make sure all really do qualify (Type)
DROP TABLE IF EXISTS #Employment;
SELECT DISTINCT
    n.na_id AS ID,
    n.na_recsort AS ConstituentName,
    string_agg(crn_na_name,', ') AS Employer
    --,em_current AS CurrentEmp
    --,em_class AS Class
        --,em_enddate EndDate
INTO #Employment
FROM fr101.dbo.NAME n
JOIN fr101.dbo.EMPLOY e ON n.na_id = e.em_empid
JOIN fr101.dbo.NAME n2 ON n2.na_id = e.EM_BUSID
JOIN ujadw.dbo.FR101_CommonReport_Name ON crn_na_id = n2.na_id
WHERE em_current = 1 AND (EM_ENDDATE IS NULL OR EM_ENDDATE > getdate()) AND EM_CLASS = 'e'
AND
(
n2.na_recsort   LIKE 'Barclays Capital%' OR
n2.na_recsort LIKE 'IBM%' OR
n2.na_recsort LIKE 'AllianceB%' OR
n2.na_recsort like 'Alliance Bernstein%' OR
n2.na_recsort LIKE 'SalesForce%' OR
n2.na_recsort LIKE '%Merrill Lynch%' OR
--n2.na_recsort LIKE 'Bank of America%' OR
n2.na_recsort LIKE 'Kirkland%' OR
n2.na_recsort LIKE 'Pfizer%' OR
n2.na_recsort LIKE 'Royal Bank of Canada%' OR
n2.na_recsort LIKE 'RBC%' OR
n2.na_recsort LIKE 'Davis Polk%' OR
n2.na_recsort LIKE 'Jefferies%' OR
n2.na_recsort LIKE 'Deutsche Bank%' OR
n2.na_recsort LIKE 'Sony music%' OR
n2.na_recsort LIKE 'Morgan stanley%' OR
n2.na_recsort LIKE 'Mizuho%' OR
n2.na_recsort LIKE 'Houlihan lokey%' OR
n2.na_recsort LIKE 'Microsoft%' OR
n2.na_recsort LIKE 'Hearst%' OR
n2.na_recsort LIKE 'Paramount%' OR
n2.na_recsort LIKE 'Ares Management%' OR
n2.na_recsort LIKE 'Johnson & Johnson%' OR
n2.na_recsort LIKE 'Arch Insurance%'
)
group by n.NA_ID,n.NA_RECSORT ;


drop table if exists #EmploymentID
SELECT DISTINCT
    n.na_id AS ID
into #EmploymentID
FROM fr101.dbo.NAME n
JOIN fr101.dbo.EMPLOY e ON n.na_id = e.em_empid
JOIN fr101.dbo.NAME n2 ON n2.na_id = e.EM_BUSID
JOIN ujadw.dbo.FR101_CommonReport_Name ON crn_na_id = n2.na_id
WHERE em_current = 1 AND (EM_ENDDATE IS NULL OR EM_ENDDATE > getdate()) AND EM_CLASS = 'e'
AND
(
n2.na_recsort   LIKE 'Barclays Capital%' OR
n2.na_recsort LIKE 'IBM%' OR
n2.na_recsort LIKE 'AllianceB%' OR
n2.na_recsort like 'Alliance Bernstein%' OR
n2.na_recsort LIKE 'SalesForce%' OR
n2.na_recsort LIKE '%Merrill Lynch%' OR
--n2.na_recsort LIKE 'Bank of America%' OR
n2.na_recsort LIKE 'Kirkland%' OR
n2.na_recsort LIKE 'Pfizer%' OR
n2.na_recsort LIKE 'Royal Bank of Canada%' OR
n2.na_recsort LIKE 'RBC%' OR
n2.na_recsort LIKE 'Davis Polk%' OR
n2.na_recsort LIKE 'Jefferies%' OR
n2.na_recsort LIKE 'Deutsche Bank%' OR
n2.na_recsort LIKE 'Sony music%' OR
n2.na_recsort LIKE 'Morgan stanley%' OR
n2.na_recsort LIKE 'Mizuho%' OR
n2.na_recsort LIKE 'Houlihan lokey%' OR
n2.na_recsort LIKE 'Microsoft%' OR
n2.na_recsort LIKE 'Hearst%' OR
n2.na_recsort LIKE 'Paramount%' OR
n2.na_recsort LIKE 'Ares Management%' OR
n2.na_recsort LIKE 'Johnson & Johnson%' OR
n2.na_recsort LIKE 'Arch Insurance%'
) ;

--future #Employment table
drop table if exists #Employment1
SELECT DISTINCT
    n.na_id AS ID,
    n.na_recsort AS ConstituentName,
    string_agg(crn_na_name,', ') AS Employer
   ,case when n.NA_ID in (select ID from #EmploymentID) then 'Yes' else 'No' end Employer_Lower20
into #Employment1
FROM fr101.dbo.NAME n
JOIN fr101.dbo.EMPLOY e ON n.na_id = e.em_empid
JOIN fr101.dbo.NAME n2 ON n2.na_id = e.EM_BUSID
JOIN ujadw.dbo.FR101_CommonReport_Name ON crn_na_id = n2.na_id
WHERE em_current = 1 AND (EM_ENDDATE IS NULL OR EM_ENDDATE > getdate()) AND EM_CLASS = 'e'
--and n.NA_ID in (select ID from #EmploymentID)
group by n.NA_ID,n.NA_RECSORT 


-- Relationships
DROP TABLE IF EXISTS #Relationships;
SELECT DISTINCT
    p.NR_ID AS ID,
    string_agg(crn_na_name,', ') AS Relatee
INTO #Relationships
FROM FR101.dbo.NA2RE p
JOIN fr101.dbo.RELATION pr ON pr.RE_KEY = p.NR_REKEY AND pr.RE_CURRENT = 1
JOIN fr101.dbo.NA2RE s ON s.NR_REKEY = pr.RE_KEY AND s.NR_ID <> p.NR_ID
JOIN fr101.dbo.NAME ns ON ns.NA_ID = s.NR_ID
JOIN ujadw.dbo.FR101_CommonReport_Name ON crn_na_id = ns.NA_ID
WHERE s.NR_RELAT IN ('FIRM', 'BUS')
and
(
crn_na_name   LIKE 'Barclays Capital%' OR
crn_na_name LIKE 'IBM%' OR
crn_na_name LIKE 'AllianceB%' OR
crn_na_name like 'Alliance Bernstein%' OR
crn_na_name LIKE 'SalesForce%' OR
crn_na_name LIKE '%Merrill Lynch%' OR
--crn_na_name LIKE 'Bank of America%' OR
crn_na_name LIKE 'Kirkland%' OR
crn_na_name LIKE 'Pfizer%' OR
crn_na_name LIKE 'Royal Bank of Canada%' OR
crn_na_name LIKE 'RBC%' OR
crn_na_name LIKE 'Davis Polk%' OR
crn_na_name LIKE 'Jefferies%' OR
crn_na_name LIKE 'Deutsche Bank%' OR
crn_na_name LIKE 'Sony music%' OR
crn_na_name LIKE 'Morgan stanley%' OR
crn_na_name LIKE 'Mizuho%' OR
crn_na_name LIKE 'Houlihan lokey%' OR
crn_na_name LIKE 'Microsoft%' OR
crn_na_name LIKE 'Hearst%' OR
crn_na_name LIKE 'Paramount%' OR
crn_na_name LIKE 'Ares Management%' OR
crn_na_name LIKE 'Johnson & Johnson%' OR
crn_na_name LIKE 'Arch Insurance%'
)
group by p.NR_ID
;


DROP TABLE IF EXISTS #RelationshipsID;
SELECT DISTINCT
    p.NR_ID AS ID
INTO #RelationshipsID
FROM FR101.dbo.NA2RE p
JOIN fr101.dbo.RELATION pr ON pr.RE_KEY = p.NR_REKEY AND pr.RE_CURRENT = 1
JOIN fr101.dbo.NA2RE s ON s.NR_REKEY = pr.RE_KEY AND s.NR_ID <> p.NR_ID
JOIN fr101.dbo.NAME ns ON ns.NA_ID = s.NR_ID
JOIN ujadw.dbo.FR101_CommonReport_Name ON crn_na_id = ns.NA_ID
WHERE s.NR_RELAT IN ('FIRM', 'BUS')
and
(
crn_na_name   LIKE 'Barclays Capital%' OR
crn_na_name LIKE 'IBM%' OR
crn_na_name LIKE 'AllianceB%' OR
crn_na_name like 'Alliance Bernstein%' OR
crn_na_name LIKE 'SalesForce%' OR
crn_na_name LIKE '%Merrill Lynch%' OR
--crn_na_name LIKE 'Bank of America%' OR
crn_na_name LIKE 'Kirkland%' OR
crn_na_name LIKE 'Pfizer%' OR
crn_na_name LIKE 'Royal Bank of Canada%' OR
crn_na_name LIKE 'RBC%' OR
crn_na_name LIKE 'Davis Polk%' OR
crn_na_name LIKE 'Jefferies%' OR
crn_na_name LIKE 'Deutsche Bank%' OR
crn_na_name LIKE 'Sony music%' OR
crn_na_name LIKE 'Morgan stanley%' OR
crn_na_name LIKE 'Mizuho%' OR
crn_na_name LIKE 'Houlihan lokey%' OR
crn_na_name LIKE 'Microsoft%' OR
crn_na_name LIKE 'Hearst%' OR
crn_na_name LIKE 'Paramount%' OR
crn_na_name LIKE 'Ares Management%' OR
crn_na_name LIKE 'Johnson & Johnson%' OR
crn_na_name LIKE 'Arch Insurance%'
);


--future #relationship table 
drop table if exists #Relationship1
SELECT DISTINCT
    p.NR_ID AS ID,
    string_agg(crn_na_name,', ') AS Relatee
	,case when p.NR_ID in (select ID from #RelationshipsID) then 'Yes' else 'No' end Relationship_Lower20
into #Relationship1
FROM FR101.dbo.NA2RE p
JOIN fr101.dbo.RELATION pr ON pr.RE_KEY = p.NR_REKEY AND pr.RE_CURRENT = 1
JOIN fr101.dbo.NA2RE s ON s.NR_REKEY = pr.RE_KEY AND s.NR_ID <> p.NR_ID
JOIN fr101.dbo.NAME ns ON ns.NA_ID = s.NR_ID
JOIN ujadw.dbo.FR101_CommonReport_Name ON crn_na_id = ns.NA_ID
WHERE s.NR_RELAT IN ('FIRM', 'BUS')
--and p.NR_ID in (select ID from #RelationshipsID)
group by p.NR_ID
order by p.NR_ID
;


--Emails
drop table if exists #Email
SELECT DISTINCT
    ee_id ID,
    string_agg(ee_address,', ') Email
	into #Email
FROM fr101.dbo.email
WHERE
    ee_address LIKE '%@archinsurance.com'
 OR ee_address LIKE '%@aresmgmt.com'
 OR ee_address LIKE '%barcap%'
 OR ee_address LIKE '%@bernstein.com%'
 OR ee_address LIKE '%@davispolk.com'
 OR ee_address LIKE '%@db.com'
 OR ee_address LIKE '%@hearst%'
 OR ee_address LIKE '%@HL.com'
 OR ee_address LIKE '%@ibm.com'
 OR ee_address LIKE '%@jefferies.com'
 OR ee_address LIKE '%@Kirkland.com'
 OR ee_address LIKE '%@microsoft.com'
 OR ee_address LIKE '%@mizuhogroup.com'
 OR ee_address LIKE '%@morganstanley.com'
 OR ee_address LIKE '%@pfizer.com'
 OR ee_address LIKE '%@SalesForce.com'
 OR ee_address LIKE '%@sonymusic.com'
 OR ee_address LIKE '%@ml.com'
 --OR ee_address LIKE '%@bofa.com'
 OR ee_address LIKE '%@rbc.com'
 OR ee_address LIKE '%jnj.com'
group by EE_ID
;

drop table if exists #EmailID
SELECT DISTINCT
    ee_id ID
	into #EmailID
FROM fr101.dbo.email
WHERE
    ee_address LIKE '%@archinsurance.com'
 OR ee_address LIKE '%@aresmgmt.com'
 OR ee_address LIKE '%barcap%'
 OR ee_address LIKE '%@bernstein.com%'
 OR ee_address LIKE '%@davispolk.com'
 OR ee_address LIKE '%@db.com'
 OR ee_address LIKE '%@hearst%'
 OR ee_address LIKE '%@HL.com'
 OR ee_address LIKE '%@ibm.com'
 OR ee_address LIKE '%@jefferies.com'
 OR ee_address LIKE '%@Kirkland.com'
 OR ee_address LIKE '%@microsoft.com'
 OR ee_address LIKE '%@mizuhogroup.com'
 OR ee_address LIKE '%@morganstanley.com'
 OR ee_address LIKE '%@pfizer.com'
 OR ee_address LIKE '%@SalesForce.com'
 OR ee_address LIKE '%@sonymusic.com'
 OR ee_address LIKE '%@ml.com'
 --OR ee_address LIKE '%@bofa.com'
 OR ee_address LIKE '%@rbc.com'
 OR ee_address LIKE '%jnj.com'
;

--future #emails table
drop table if exists #emails1
SELECT DISTINCT
    ee_id ID,
    string_agg(ee_address,', ') Email
	,case when EE_ID in (select * from #EmailID) then 'Yes' else 'No' end email_lower20
into #emails1
FROM fr101.dbo.email
--WHERE EE_ID in (select * from #EmailID)
group by EE_ID
;

--Nodes
drop table if exists #Nodes
Select
na_id ID
,nd_description NodeDescription
into #Nodes
from fr101.dbo.name
join fr101.dbo.nodes on nd_key = NA_DEFNODEKEY and
nd_node in
(
'043'
,'044'
,'856'
,'zpf'
,'rbc'
,'dpw'
,'420'
,'db1'
,'816'
)

drop table if exists #NodesID
Select
na_id ID
into #NodesID
from fr101.dbo.name
join fr101.dbo.nodes on nd_key = NA_DEFNODEKEY and
nd_node in
(
'043'
,'044'
,'856'
,'zpf'
,'rbc'
,'dpw'
,'420'
,'db1'
,'816'
)


--future #nodes table
drop table if exists #nodes1
Select
na_id ID
,nd_description NodeDescription
,case when na_id in (select ID from #NodesID) then 'Yes' else 'No' end nodes_lower20
into #nodes1
from fr101.dbo.name
join fr101.dbo.nodes on nd_key = NA_DEFNODEKEY
--where  na_id in (select ID from #NodesID)
order by NA_ID

---------------------------------------------------------------
/*SELECT DISTINCT
   	case when isnull(g.curAmt,0) >0 or isnull(g.CurrPr01Amt,0) >0 or isnull(g.CurrPr02Amt,0) >0 or isnull(CurrPr03Amt,0) >0 then 1 else 0 end as RecentDonor,

    a.na_id AS ID,
	CRN_NA_NAME ConsituentName,
isnull(crn_na_status,'') ConstituentStatus,
isnull(crn_na_node,'') ConstituentNode
,isnull(crn_na_fundraisersort,'') ConstituentFundraiser
,isnull(crn_na_division,'') ConstituentDivision

	--a.na_recsort Recsort,
 --   a.na_status AS ConstituentStatus,
 --   a.na_type AS ConstituentType
    

/*,case when a.na_isstaff = 0 then cast(isnull(g.curAmt,0) as varchar) else 'Confidential' end A2026
,case when a.na_isstaff = 0 then cast(isnull(g.CurrPr01Amt,0) as varchar) else 'Confidential' end A2025
,case when a.na_isstaff = 0 then cast(isnull(g.CurrPr02Amt,0) as varchar) else 'Confidential' end A2024
,case when a.na_isstaff = 0 then cast(isnull(g.CurrPr03Amt,0) as varchar) else 'Confidential' end A2023*/

, isnull(g.curAmt,0)  A2026
, isnull(g.CurrPr01Amt,0) A2025
, isnull(g.CurrPr02Amt,0) A2024
, isnull(g.CurrPr03Amt,0) A2023

		
/*,case when na_id in (Select ID from #JointAddressee) then jt.company else '' end JointAddressee
,case when na_id in (Select ID from #JointAddressee) then 'Yes' else 'No' end JointAddressee_Second20
,case when na_id in (Select ID from #BUsinessAddressee) then addr.company else '' end BusinessAddressee
,case when na_id in (Select ID from #BUsinessAddressee) then 'Yes' else 'No' end BusinessAddressee_Second20
,case when na_id in (Select ID from #BusinessID) then id.COMPANY else '' end BusinessNameisFR101ID
,case when na_id in (Select ID from #BusinessID) then 'Yes' else 'No' end BusinessNameisFR101ID_Second20
,case when na_id in (Select ID from #Employment) then emp.Employer else '' end Employer
,case when na_id in (Select ID from #Employment) then 'Yes' else 'No' end Employer_Second20
,case when na_id in (Select ID from #Relationships) then rel.Relatee else '' end Relative
,case when na_id in (Select ID from #Relationships) then 'Yes' else 'No' end Relative_Second20
,case when na_id in (Select ID from #Email) then Email else '' end Email
,case when na_id in (Select ID from #Email) then 'Yes' else 'No' end Email_Second20
,case when na_id in (Select ID from #Nodes) then NodeDescription else '' end NodeDescription
,case when na_id in (Select ID from #Nodes) then 'Yes' else 'No' end NodeDescription_Second20*/


, isnull(jt.company,'Empty') JointAddressee_from_Addressee_field
,case when na_id in (Select ID from #JointAddressee) then 'Yes' else 'No' end JointAddressee_Second20
, isnull(addr.company,'Empty')  BusinessAddressee_from_Addresssee_field
,case when na_id in (Select ID from #BUsinessAddressee) then 'Yes' else 'No' end BusinessAddressee_Second20
, isnull(id.COMPANY,'Empty') BusinessNameisFR101ID
,case when na_id in (Select ID from #BusinessID) then 'Yes' else 'No' end BusinessNameisFR101ID_Second20
,isnull(emp.Employer,'Empty') Employer_from_employment_field
,case when na_id in (Select ID from #Employment) then 'Yes' else 'No' end Employer_Second20
, isnull(rel.Relatee,'Empty') Relative
,case when na_id in (Select ID from #Relationships) then 'Yes' else 'No' end Relative_Second20
,isnull( Email,'Empty') Email
,case when na_id in (Select ID from #Email) then 'Yes' else 'No' end Email_Second20
,isnull(NodeDescription,'Empty') NodeDescription
,case when na_id in (Select ID from #Nodes) then 'Yes' else 'No' end NodeDescription_Second20



FROM fr101.dbo.NAME a

--show the joint business addressee
left join #JointAddressee jt on jt.id = na_id

--show the business addressee
left join #BusinessAddressee addr on addr.id = na_id

--show if the business name is an fr101 ID
left join #BusinessID id on id.id = na_id

--show if employment
left join #Employment emp on emp.id = na_id

--show if relationship
left join #Relationships rel on rel.id = na_id

--show if email
left join #email e on e.id = na_id

--show if node
left join #nodes nd on nd.id = na_id

--get the PR3 - CY Giving
left join ujadw.dbo.udrt_30yr_trend_analysis g on g.id = a.NA_ID  

--left join to the common name table
left join ujadw.dbo.FR101_CommonReport_Name crn on crn.CRN_NA_ID = a.na_id


WHERE
a.na_status in ('A', 'ANA', 'AP')
AND a.na_type = 'i'
AND a.na_recsort NOT LIKE '%foundation%'
AND a.na_recsort NOT LIKE '%charitable%'
AND a.na_recsort NOT LIKE '%, Estate of%'
and
(
--joint addressee
na_id in (Select ID from #JointAddressee)
or
--Business Addresse
na_id in (Select ID from #BusinessAddressee)
or
--Company Name is an FR101 ID
na_id in (Select ID from #BusinessID)
or
--Employment
na_id in (Select ID from #Employment)
or
--Relationships
na_id in (Select ID from #Relationships)
or
--Email
na_id in (Select ID from #Email)
or
--Node
na_id in (Select ID from #Nodes)
)
--and a.NA_ISSTAFF=1
--group by
--case when isnull(g.curAmt,0) >0 or isnull(g.CurrPr01Amt,0) >0 or isnull(g.CurrPr02Amt,0) >0 or isnull(CurrPr03Amt,0) >0 then 1 else 0 end,
-- a.na_id,
--	--a.na_recsort Recsort,
--	crn_na_name ,
--    --a.na_status AS ConstituentStatus,
--    --a.na_type AS ConstituentType,
--isnull(crn_na_status,'')
--,isnull(crn_na_node,'') 
--,isnull(crn_na_fundraisersort,'') 
--,isnull(crn_na_division,'') 

--,case when a.na_isstaff = 0 then cast(isnull(g.curAmt,0) as varchar) else 'Confidential' end 
--,case when a.na_isstaff = 0 then cast(isnull(g.CurrPr01Amt,0) as varchar) else 'Confidential' end 
--,case when a.na_isstaff = 0 then cast(isnull(g.CurrPr02Amt,0) as varchar) else 'Confidential' end 
--,case when a.na_isstaff = 0 then cast(isnull(g.CurrPr03Amt,0) as varchar) else 'Confidential' end 



ORDER BY
ID
;*/
----------------------------------------------------------------------------
--V.2


Select *
from (
SELECT DISTINCT
   	case when isnull(g.curAmt,0) >0 or isnull(g.CurrPr01Amt,0) >0 or isnull(g.CurrPr02Amt,0) >0 or isnull(CurrPr03Amt,0) >0 then 1 else 0 end as RecentDonor,

a.na_id AS ID,
CRN_NA_NAME ConsituentName,
isnull(crn_na_status,'') ConstituentStatus,
isnull(crn_na_node,'') ConstituentNode
,isnull(crn_na_fundraisersort,'') ConstituentFundraiser
,isnull(crn_na_division,'') ConstituentDivision

	--a.na_recsort Recsort,
 --   a.na_status AS ConstituentStatus,
 --   a.na_type AS ConstituentType
    

,case when a.na_isstaff = 0 then cast(isnull(g.curAmt,0) as varchar) else 'Confidential' end A2026
,case when a.na_isstaff = 0 then cast(isnull(g.CurrPr01Amt,0) as varchar) else 'Confidential' end A2025
,case when a.na_isstaff = 0 then cast(isnull(g.CurrPr02Amt,0) as varchar) else 'Confidential' end A2024
,case when a.na_isstaff = 0 then cast(isnull(g.CurrPr03Amt,0) as varchar) else 'Confidential' end A2023

/*, isnull(g.curAmt,0)  A2026
, isnull(g.CurrPr01Amt,0) A2025
, isnull(g.CurrPr02Amt,0) A2024
, isnull(g.CurrPr03Amt,0) A2023*/

		
/*,case when na_id in (Select ID from #JointAddressee) then jt.company else '' end JointAddressee
,case when na_id in (Select ID from #JointAddressee) then 'Yes' else 'No' end JointAddressee_Second20
,case when na_id in (Select ID from #BUsinessAddressee) then addr.company else '' end BusinessAddressee
,case when na_id in (Select ID from #BUsinessAddressee) then 'Yes' else 'No' end BusinessAddressee_Second20
,case when na_id in (Select ID from #BusinessID) then id.COMPANY else '' end BusinessNameisFR101ID
,case when na_id in (Select ID from #BusinessID) then 'Yes' else 'No' end BusinessNameisFR101ID_Second20
,case when na_id in (Select ID from #Employment) then emp.Employer else '' end Employer
,case when na_id in (Select ID from #Employment) then 'Yes' else 'No' end Employer_Second20
,case when na_id in (Select ID from #Relationships) then rel.Relatee else '' end Relative
,case when na_id in (Select ID from #Relationships) then 'Yes' else 'No' end Relative_Second20
,case when na_id in (Select ID from #Email) then Email else '' end Email
,case when na_id in (Select ID from #Email) then 'Yes' else 'No' end Email_Second20
,case when na_id in (Select ID from #Nodes) then NodeDescription else '' end NodeDescription
,case when na_id in (Select ID from #Nodes) then 'Yes' else 'No' end NodeDescription_Second20*/


,isnull(jt.company,'Empty') JointAddressee_from_Addressee_field
,isnull(jt.Company_Lower20,'No') as jointaddressee_second20
,isnull(addr.company,'Empty')  BusinessAddressee_from_Addresssee_field
,isnull(addr.BusinessID_Lower20,'No') BusinessAddressee_Second20
,isnull(id.COMPANY,'Empty') BusinessNameisFR101ID
,isnull(id.businessID_Lower20,'No') BusinessNameisFR101ID_Second20
,isnull(emp.Employer,'Empty') Employer_from_employment_field
,isnull(emp.Employer_Lower20,'No') Employer_Second20
,isnull(rel.Relatee,'Empty') Relative
,isnull(rel.Relationship_Lower20,'No') Relative_Second20
,isnull( Email,'Empty') Email
,isnull(email_lower20,'No') Email_Second20
,isnull(NodeDescription,'Empty') NodeDescription
,nodes_lower20 NodeDescription_Second20

FROM fr101.dbo.NAME a

--show the joint business addressee
left join #jointaddressee1 jt on jt.id = na_id

--show the business addressee
left join #businessaddressee1 addr on addr.id = na_id

--show if the business name is an fr101 ID
left join #businessID1 id on id.id = na_id

--show if employment
left join #Employment1 emp on emp.id = na_id

--show if relationship
left join #relationship1 rel on rel.id = na_id

--show if email
left join #emails1 e on e.id = na_id

--show if node
left join #nodes1 nd on nd.id = na_id

--get the PR3 - CY Giving
left join ujadw.dbo.udrt_30yr_trend_analysis g on g.id = a.NA_ID  

--left join to the common name table
left join ujadw.dbo.FR101_CommonReport_Name crn on crn.CRN_NA_ID = a.na_id


WHERE
a.na_status in ('A', 'ANA', 'AP')
AND a.na_type = 'i'
AND a.na_recsort NOT LIKE '%foundation%'
AND a.na_recsort NOT LIKE '%charitable%'
AND a.na_recsort NOT LIKE '%, Estate of%'
--and a.NA_ISSTAFF=0
--and a.NA_ISSTAFF=1
--group by
--case when isnull(g.curAmt,0) >0 or isnull(g.CurrPr01Amt,0) >0 or isnull(g.CurrPr02Amt,0) >0 or isnull(CurrPr03Amt,0) >0 then 1 else 0 end,
-- a.na_id,
--	--a.na_recsort Recsort,
--	crn_na_name ,
--    --a.na_status AS ConstituentStatus,
--    --a.na_type AS ConstituentType,
--isnull(crn_na_status,'')
--,isnull(crn_na_node,'') 
--,isnull(crn_na_fundraisersort,'') 
--,isnull(crn_na_division,'') 

--,case when a.na_isstaff = 0 then cast(isnull(g.curAmt,0) as varchar) else 'Confidential' end 
--,case when a.na_isstaff = 0 then cast(isnull(g.CurrPr01Amt,0) as varchar) else 'Confidential' end 
--,case when a.na_isstaff = 0 then cast(isnull(g.CurrPr02Amt,0) as varchar) else 'Confidential' end 
--,case when a.na_isstaff = 0 then cast(isnull(g.CurrPr03Amt,0) as varchar) else 'Confidential' end 



/*ORDER BY
ID*/
) main 
where(
JointAddressee_Second20='Yes'
or BusinessAddressee_Second20='Yes'
or BusinessNameisFR101ID_Second20='Yes'
or Employer_Second20='Yes'
or Relative_Second20='Yes'
or Email_Second20='Yes'
or NodeDescription_Second20='Yes'
) 
--and A2026='Confidential'
--and jointaddressee_second20='Yes'
--and BusinessNameisFR101ID_Second20='No'

order by ID

