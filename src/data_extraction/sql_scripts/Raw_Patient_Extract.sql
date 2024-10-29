
-- Script to extract 20 pseudo-patient records for processing before being passed into the theograph tool.

WITH PatIDs AS (
    SELECT 610673 AS ID UNION ALL
    SELECT 2377686 UNION ALL
    SELECT 1684031 UNION ALL
    SELECT 1719111 UNION ALL
    SELECT 714765 UNION ALL
    SELECT 5329931 UNION ALL
    SELECT 2337077 UNION ALL
    SELECT 2813256 UNION ALL
    SELECT 5162922 UNION ALL
    SELECT 3055848 UNION ALL
    SELECT 5182896 UNION ALL
    SELECT 2839091 UNION ALL
    SELECT 2701908 UNION ALL
    SELECT 509825 UNION ALL
    SELECT 2752409 UNION ALL
    SELECT 4822061 UNION ALL
    SELECT 5330850 UNION ALL
    SELECT 3359779 UNION ALL
    SELECT 1920086 UNION ALL
    SELECT 3293167
),
EventRecords AS (
    SELECT DISTINCT
        pat.PK_Patient_ID,
        pat.Sex,
        pat.Dob,
        'event' AS eventtype,
        CONVERT(DATE, gpe.EventDate) AS date, -- Convert to 'yyyy-mm-dd' format
        gpe.SuppliedCode AS code,
        sct.term AS term,
        gpe.Episodicity,
        gpe.value,
        gpe.units
    FROM 
        PatIDs AS pid
    INNER JOIN 
        [Client_ICS].[vw_Cipha_SharedCare_Patient] AS pat
        ON pid.ID = pat.PK_Patient_ID 
    INNER JOIN 
        [Client_ICS].[vw_Cipha_SharedCare_GP_Events] AS gpe
        ON gpe.FK_Patient_ID = pat.PK_Patient_ID
    INNER JOIN 
        [Client_ICS].[vw_Cipha_SharedCare_Reference_SnomedCT] AS sct
        ON gpe.SuppliedCode = sct.ConceptID
    WHERE 
        gpe.EventDate > CAST('2020-01-01' AS DATE) 
        AND gpe.SourceTable LIKE 'EMIS%'
),
MedicationRecords AS (
    SELECT DISTINCT
        pat.PK_Patient_ID,
        pat.Sex,
        pat.Dob,
        'medication' AS eventtype,
        CONVERT(DATE, gpm.MedicationDate) AS date, -- Convert to 'yyyy-mm-dd' format
        gpm.SuppliedCode AS code,
        gpm.MedicationDescription AS term,
        gpm.Dosage AS episodicity,
        gpm.Quantity AS value,
        gpm.Units AS units
    FROM 
        PatIDs AS pid
    INNER JOIN 
        [Client_ICS].[vw_Cipha_SharedCare_Patient] AS pat
        ON pid.ID = pat.PK_Patient_ID 
    INNER JOIN 
        [Client_ICS].[vw_Cipha_SharedCare_GP_Medications] AS gpm
        ON gpm.FK_Patient_ID = pat.PK_Patient_ID
    WHERE 
        gpm.MedicationDate > CAST('2020-01-01' AS DATE)
)
SELECT * 
FROM EventRecords
UNION
SELECT * 
FROM MedicationRecords;
