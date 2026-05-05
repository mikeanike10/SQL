
--groups giving and labels as IEF or Non-IEF by house hould ID
drop table if exists #tempIEFAnn
select hoh_id, sum(rv_amount) giving, initiative, rv_campyr
into #tempIEFAnn 
from (
	select hoh_id, sum(rv_amount) rv_amount, rv_campyr,
	case 
     when FU_FUND in ('1144', '1145') then 'IEF' 
     when rv_campyr in (2023,2024, 2025, 2026) then 'Non-IEF'
	 end initiative

from fr101.dbo.COMMRECV c
join fr101.dbo.FUND f on c.RV_FUKEY = f.FU_KEY and c.RV_CAMP in ('A','AP') and (c.rv_campyr = 2023 or c.RV_CAMPYR = 2024 or RV_CAMPYR = 2025 or RV_CAMPYR = 2026)
join UJADW.dbo.UDRT_30Yr_Trend_Analysis t on rv_id = id
group by hoh_id, rv_id, FU_FUND, RV_CAMPYR, rv_camp) a
group by hoh_id,  rv_campyr, initiative

--calculates different year values and only keeps ones pertaining to our needs
drop table if exists #tempHHtotals
select t.HOH_ID
    ,sum(case when t.initiative = 'Non-IEF' and t.RV_CAMPYR='2023'  then t.giving else 0 end) as '23HHAnn'
    ,sum(case when t.initiative = 'IEF' and t.RV_CAMPYR='2024'  then t.giving else 0 end) as '24HHIEF'
    ,sum(case when t.initiative = 'Non-IEF' and t.RV_CAMPYR='2024'  then t.giving else 0 end) as '24HHAnn'
    ,sum(case when t.initiative = 'IEF' and t.RV_CAMPYR='2025'  then t.giving else 0 end) as '25HHIEF'
    ,sum(case when t.initiative = 'Non-IEF' and t.RV_CAMPYR='2025'  then t.giving else 0 end) as '25HHAnn'
    ,sum(case when t.initiative = 'IEF' and t.RV_CAMPYR='2026'  then t.giving else 0 end) as '26HHIEF'
    ,sum(case when t.initiative = 'Non-IEF' and t.RV_CAMPYR='2026'  then t.giving else 0 end) as '26HHAnn'
into #tempHHtotals
from #tempIEFAnn t
group by t.HOH_ID
HAVING 
   ( SUM(CASE WHEN t.initiative = 'Non-IEF' AND t.RV_CAMPYR = '2025' THEN t.giving ELSE 0 END) = 0
    AND SUM(CASE WHEN t.initiative = 'Non-IEF' AND t.RV_CAMPYR = '2026' THEN t.giving ELSE 0 END) = 0
    and sum(case when t.initiative = 'IEF' and t.RV_CAMPYR='2026'  then t.giving else 0 end)=0
    and sum(case when t.initiative = 'IEF' and t.RV_CAMPYR='2025'  then t.giving else 0 end)=0
    AND SUM(CASE WHEN t.initiative = 'IEF'     AND t.RV_CAMPYR = '2024' THEN t.giving ELSE 0 END) > 0)
ORDER BY t.HOH_ID;

--email table
drop table if exists #tempemails
select na_id, e.EE_Address, ROW_NUMBEr() over (partition by na_id order by ee_address) rn
into #tempemails
from 
fr101.dbo.name n
join fr101.dbo.email e on n.na_id = e.EE_ID and EE_Default = 1 --and EE_TYPE='B'


--summation of donor info 2026,2025,2024 Ann and IEF and 2023, as well as donor features
select a.*, isnull(e.EE_Address,'-No Email Address-') Email,
h.[23HHANN],h.[24HHAnn], h.[24HHIEF]
from 
(SELECT [id]
      ,a.[HOH_ID]
      ,[Const_Div]
      ,substring([Staff], 2, len([Staff]) - 2) as 'Fundraiser'
      ,substring([Name], 2, len([Name]) - 2) as 'Name'
      ,a.[Given_since_Year]
      ,[Const_Node]
      --,[Const_Node_Desc]
  FROM [UJADW].[dbo].[UDRT_30Yr_Trend_Analysis] a
join [UJADW].[dbo].[FR101_CommonReport_Name] crn on id = CRN_NA_ID and ltrim(rtrim(a.[Status])) like 'A%' 
join fr101.dbo.NODES n on left(crn.CRN_NA_Node, 3) = n.ND_NODE 
join fr101.dbo.name on crn.CRN_NA_ID = na_Id
where IsStaff=0 and Role='IN'
) a
left join #tempemails e on a.id = e.NA_ID and rn = 1
join #tempHHtotals h on h.HOH_ID = a.HOH_ID 
--and a.id =1756 or a.HOH_ID=1756
--and a.CurrPr02Amt=0
--and a.id=235518
order by a.HOH_ID




/*select a1.*,t.[23HHAnn],t.[24HHAnn],t.[24HHIEF],t.[25HHAnn],t.[25HHIEF],t.[26HHAnn],t.[26HHIEF] from (
SELECT  
      a.[HOH_ID],
     a.ID
  FROM [UJADW].[dbo].[UDRT_30Yr_Trend_Analysis] a
join [UJADW].[dbo].[FR101_CommonReport_Name] crn on id = CRN_NA_ID and ltrim(rtrim(a.[Status])) like 'A%' 
join fr101.dbo.NODES n on left(crn.CRN_NA_Node, 3) = n.ND_NODE 
join fr101.dbo.name on crn.CRN_NA_ID = na_Id
where IsStaff=0 and Role='IN'
group by a.HOH_ID, ID
/*HAVING (
        SUM(a.curAmt) = 0
        AND SUM(a.CurrPr01Amt) = 0
        AND SUM(a.CurrPr02Amt) > 0
        )*/
) a1
left join #tempHHtotals t on t.HOH_ID=a1.HOH_ID
--where /*a1.id =1756 or*/ a1.HOH_ID=1756
where t.[23HHAnn] is not null
order by a1.HOH_ID*/


