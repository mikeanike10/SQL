/* =========================================
   IEF / Non-IEF Household Segmentation
========================================= */

-------------------------
-- Base: Household Giving by Initiative + Year
-------------------------
DROP TABLE IF EXISTS #tempIEFAnn;

SELECT 
    hoh_id,
    rv_campyr,
    CASE 
        WHEN f.FU_FUND IN ('1144','1145') THEN 'IEF'
        ELSE 'Non-IEF'
    END AS initiative,
    SUM(c.rv_amount) AS giving
INTO #tempIEFAnn
FROM fr101.dbo.COMMRECV c
JOIN fr101.dbo.FUND f 
    ON c.RV_FUKEY = f.FU_KEY
JOIN UJADW.dbo.UDRT_30Yr_Trend_Analysis t 
    ON c.rv_id = t.id
WHERE c.RV_CAMP IN ('A','AP')
  AND c.RV_CAMPYR IN (2023, 2024, 2025, 2026)
GROUP BY 
    hoh_id,
    rv_campyr,
    CASE 
        WHEN f.FU_FUND IN ('1144','1145') THEN 'IEF'
        ELSE 'Non-IEF'
    END;

-------------------------
-- Household Totals by Year + Initiative
-------------------------
DROP TABLE IF EXISTS #tempHHtotals;

SELECT 
    t.HOH_ID,

    SUM(CASE WHEN t.initiative = 'Non-IEF' AND t.RV_CAMPYR = 2023 THEN t.giving ELSE 0 END) AS [23HHAnn],
    SUM(CASE WHEN t.initiative = 'IEF'     AND t.RV_CAMPYR = 2024 THEN t.giving ELSE 0 END) AS [24HHIEF],
    SUM(CASE WHEN t.initiative = 'Non-IEF' AND t.RV_CAMPYR = 2024 THEN t.giving ELSE 0 END) AS [24HHAnn],
    SUM(CASE WHEN t.initiative = 'IEF'     AND t.RV_CAMPYR = 2025 THEN t.giving ELSE 0 END) AS [25HHIEF],
    SUM(CASE WHEN t.initiative = 'Non-IEF' AND t.RV_CAMPYR = 2025 THEN t.giving ELSE 0 END) AS [25HHAnn],
    SUM(CASE WHEN t.initiative = 'IEF'     AND t.RV_CAMPYR = 2026 THEN t.giving ELSE 0 END) AS [26HHIEF],
    SUM(CASE WHEN t.initiative = 'Non-IEF' AND t.RV_CAMPYR = 2026 THEN t.giving ELSE 0 END) AS [26HHAnn]

INTO #tempHHtotals
FROM #tempIEFAnn t
GROUP BY t.HOH_ID
HAVING 
    SUM(CASE WHEN t.initiative = 'Non-IEF' AND t.RV_CAMPYR = 2025 THEN t.giving ELSE 0 END) = 0
AND SUM(CASE WHEN t.initiative = 'Non-IEF' AND t.RV_CAMPYR = 2026 THEN t.giving ELSE 0 END) = 0
AND SUM(CASE WHEN t.initiative = 'IEF'     AND t.RV_CAMPYR = 2026 THEN t.giving ELSE 0 END) = 0
AND SUM(CASE WHEN t.initiative = 'IEF'     AND t.RV_CAMPYR = 2025 THEN t.giving ELSE 0 END) = 0
AND SUM(CASE WHEN t.initiative = 'IEF'     AND t.RV_CAMPYR = 2024 THEN t.giving ELSE 0 END) > 0;

-------------------------
-- Email Table (Cleaner Selection)
-------------------------
DROP TABLE IF EXISTS #tempemails;

SELECT 
    n.na_id,
    e.EE_Address,
    ROW_NUMBER() OVER (
        PARTITION BY n.na_id 
        ORDER BY e.EE_Default DESC, e.EE_Address
    ) AS rn
INTO #tempemails
FROM fr101.dbo.name n
JOIN fr101.dbo.email e 
    ON n.na_id = e.EE_ID
WHERE e.EE_Default = 1;

-------------------------
-- Final Output
-------------------------
SELECT 
    a.*,
    ISNULL(e.EE_Address,'-No Email Address-') AS Email,
    h.[23HHAnn],
    h.[24HHAnn],
    h.[24HHIEF]

FROM (
    SELECT 
        a.[id],
        a.[HOH_ID],
        a.[Const_Div],
        SUBSTRING(a.[Staff], 2, LEN(a.[Staff]) - 2) AS Fundraiser,
        SUBSTRING(a.[Name], 2, LEN(a.[Name]) - 2) AS Name,
        a.[Given_since_Year],
        a.[Const_Node]
    FROM UJADW.dbo.UDRT_30Yr_Trend_Analysis a
    JOIN UJADW.dbo.FR101_CommonReport_Name crn 
        ON a.id = crn.CRN_NA_ID 
       AND LTRIM(RTRIM(a.[Status])) LIKE 'A%'
    JOIN fr101.dbo.NODES n 
        ON LEFT(crn.CRN_NA_Node, 3) = n.ND_NODE 
    JOIN fr101.dbo.name nm 
        ON crn.CRN_NA_ID = nm.na_id
    WHERE a.IsStaff = 0 
      AND nm.Role = 'IN'
) a

LEFT JOIN #tempemails e 
    ON a.id = e.na_id 
   AND e.rn = 1

JOIN #tempHHtotals h 
    ON h.HOH_ID = a.HOH_ID

ORDER BY a.HOH_ID;
