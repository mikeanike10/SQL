/* =========================================
   Donor YoY Analysis (With Totals Added)
========================================= */

-------------------------
-- CY HH
-------------------------
DROP TABLE IF EXISTS #tempCYHH;

SELECT 
    HOH_ID,
    COUNT(DISTINCT ID) AS IN_Donor,
    SUM(rv_amount) AS total_rev,
    CASE
        WHEN ROUND(SUM(rv_amount),0) > 0 AND ROUND(SUM(rv_amount),0) < 100 THEN '1-99'
        WHEN ROUND(SUM(rv_amount),0) >= 100 AND ROUND(SUM(rv_amount),0) < 1000 THEN '100-999'
        WHEN ROUND(SUM(rv_amount),0) >= 1000 AND ROUND(SUM(rv_amount),0) < 5000 THEN '1,000-4,999'
        WHEN ROUND(SUM(rv_amount),0) >= 5000 AND ROUND(SUM(rv_amount),0) < 10000 THEN '5,000-9,999'
        WHEN ROUND(SUM(rv_amount),0) >= 10000 AND ROUND(SUM(rv_amount),0) < 25000 THEN '10,000-24,999'
        WHEN ROUND(SUM(rv_amount),0) >= 25000 AND ROUND(SUM(rv_amount),0) < 50000 THEN '25,000-49,999'
        WHEN ROUND(SUM(rv_amount),0) >= 50000 AND ROUND(SUM(rv_amount),0) < 100000 THEN '50,000-99,999'
        WHEN ROUND(SUM(rv_amount),0) >= 100000 AND ROUND(SUM(rv_amount),0) < 250000 THEN '100,000-249,999'
        WHEN ROUND(SUM(rv_amount),0) >= 250000 AND ROUND(SUM(rv_amount),0) < 500000 THEN '250,000-499,999'
        WHEN ROUND(SUM(rv_amount),0) >= 500000 AND ROUND(SUM(rv_amount),0) < 1000000 THEN '500,000-999,999'
        WHEN ROUND(SUM(rv_amount),0) >= 1000000 THEN '1000000+'
    END AS category
INTO #tempCYHH
FROM fr101.dbo.COMMRECV rv
JOIN fr101.dbo.FUND f ON f.fu_key = rv.RV_FUKEY
JOIN UJADW.dbo.UDRT_30Yr_Trend_Analysis t ON rv.rv_id = t.id
WHERE rv_CAMP = 'A'
  AND rv_CAMPYR = 2026
  AND f.fu_type IN ('UN','DD','TG')
  AND f.FU_FUND NOT IN ('1144','1145','1197')
GROUP BY HOH_ID
HAVING ROUND(SUM(rv_amount),0) > 0;

-------------------------
-- PY HH
-------------------------
DROP TABLE IF EXISTS #tempPYHH;

SELECT
    HOH_ID,
    COUNT(DISTINCT ID) AS IN_Donor,
    SUM(tz_amount) AS total_rev,
    CASE
        WHEN ROUND(SUM(tz_amount),0) > 0 AND ROUND(SUM(tz_amount),0) < 100 THEN '1-99'
        WHEN ROUND(SUM(tz_amount),0) >= 100 AND ROUND(SUM(tz_amount),0) < 1000 THEN '100-999'
        WHEN ROUND(SUM(tz_amount),0) >= 1000 AND ROUND(SUM(tz_amount),0) < 5000 THEN '1,000-4,999'
        WHEN ROUND(SUM(tz_amount),0) >= 5000 AND ROUND(SUM(tz_amount),0) < 10000 THEN '5,000-9,999'
        WHEN ROUND(SUM(tz_amount),0) >= 10000 AND ROUND(SUM(tz_amount),0) < 25000 THEN '10,000-24,999'
        WHEN ROUND(SUM(tz_amount),0) >= 25000 AND ROUND(SUM(tz_amount),0) < 50000 THEN '25,000-49,999'
        WHEN ROUND(SUM(tz_amount),0) >= 50000 AND ROUND(SUM(tz_amount),0) < 100000 THEN '50,000-99,999'
        WHEN ROUND(SUM(tz_amount),0) >= 100000 AND ROUND(SUM(tz_amount),0) < 250000 THEN '100,000-249,999'
        WHEN ROUND(SUM(tz_amount),0) >= 250000 AND ROUND(SUM(tz_amount),0) < 500000 THEN '250,000-499,999'
        WHEN ROUND(SUM(tz_amount),0) >= 500000 AND ROUND(SUM(tz_amount),0) < 1000000 THEN '500,000-999,999'
        WHEN ROUND(SUM(tz_amount),0) >= 1000000 THEN '1000000+'
    END AS category
INTO #tempPYHH
FROM fr101.dbo.TRANDET_RV tz
JOIN fr101.dbo.FUND f ON f.fu_key = tz.TZ_FUKEY
JOIN fr101.dbo.TRANSACT_RV tr ON tr.TR_KEY = tz.TZ_TRKEY
JOIN fr101.dbo.COMMRECV rv ON RV_KEY = TR_RVKEY
JOIN UJADW.dbo.UDRT_30Yr_Trend_Analysis t ON rv.rv_id = t.id
WHERE TZ_CAMP = 'A'
  AND TZ_CAMPYR = 2025
  AND tr.TR_DOCDATE < DATEADD(YEAR, -1, CAST(GETDATE() AS DATE))
  AND f.fu_type IN ('UN','DD','TG')
  AND f.FU_FUND NOT IN ('1144','1145','1197')
GROUP BY HOH_ID
HAVING ROUND(SUM(tz_amount),0) > 0;

-------------------------
-- HH Revenue Diff
-------------------------
DROP TABLE IF EXISTS #TempRevDiffHH;

SELECT 
    COALESCE(dr26.category, dr25.category) AS category,
    dr26.total_rev AS [2026 HH rev],
    dr25.total_rev AS [2025 HH rev],
    dr26.total_rev - dr25.total_rev AS [$ Diff],
    (dr26.total_rev - dr25.total_rev) * 100.0 / NULLIF(dr25.total_rev,0) AS [% Diff]
INTO #TempRevDiffHH
FROM (
    SELECT category, SUM(total_rev) AS total_rev
    FROM #tempCYHH
    GROUP BY category
) dr26
FULL OUTER JOIN (
    SELECT category, SUM(total_rev) AS total_rev
    FROM #tempPYHH
    GROUP BY category
) dr25
ON dr25.category = dr26.category;

-------------------------
-- ADD TOTALS
-------------------------
DROP TABLE IF EXISTS #FinalHH;

SELECT * INTO #FinalHH FROM #TempRevDiffHH

UNION ALL

-- $1K Split
SELECT
    CASE 
        WHEN category IN ('1-99','100-999') THEN 'Total under $1k'
        ELSE 'Total $1k+'
    END,
    SUM([2026 HH rev]),
    SUM([2025 HH rev]),
    SUM([$ Diff]),
    SUM([$ Diff]) * 100.0 / NULLIF(SUM([2025 HH rev]),0)
FROM #TempRevDiffHH
GROUP BY CASE 
    WHEN category IN ('1-99','100-999') THEN 'Total under $1k'
    ELSE 'Total $1k+'
END

UNION ALL

-- Grand Total
SELECT
    'Total',
    SUM([2026 HH rev]),
    SUM([2025 HH rev]),
    SUM([$ Diff]),
    SUM([$ Diff]) * 100.0 / NULLIF(SUM([2025 HH rev]),0)
FROM #TempRevDiffHH;

-------------------------
-- FINAL OUTPUT
-------------------------
SELECT *
FROM #FinalHH
ORDER BY 
    CASE
        WHEN category = '1000000+' THEN 1
        WHEN category = '500,000-999,999' THEN 2
        WHEN category = '250,000-499,999' THEN 3
        WHEN category = '100,000-249,999' THEN 4
        WHEN category = '50,000-99,999' THEN 5
        WHEN category = '25,000-49,999' THEN 6
        WHEN category = '10,000-24,999' THEN 7
        WHEN category = '5,000-9,999' THEN 8
        WHEN category = '1,000-4,999' THEN 9
        WHEN category = '100-999' THEN 10
        WHEN category = 'Total $1k+' THEN 11
        WHEN category = '1-99' THEN 12
        WHEN category = 'Total under $1k' THEN 13
        WHEN category = 'Total' THEN 14
    END;
