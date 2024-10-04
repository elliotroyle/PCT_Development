/*

Patient demographics details are in 


*/
IF OBJECT_ID('tempdb..#patids') IS NOT NULL DROP TABLE #patids;
CREATE TABLE #patids (ID INT);

INSERT INTO #patids (ID) VALUES (610673),(2377686),(1684031),(1719111),(714765),
                          (5329931),(2337077),(2813256),(5162922),(3055848),
                          (5182896),(2839091),(2701908),(509825),(2752409),
                          (4822061),(5330850),(3359779),(1920086),(3293167);


SELECT DISTINCT 
   *
--INTO 
--  [Client_SystemP_RW].[PGS_DYNAIRX_potential_sample_gpe]*/
FROM(
  SELECT DISTINCT TOP(100)
    pat.PK_Patient_ID,
    pat.Sex,
    pat.Dob,
    'event' AS eventtype,
    gpe.Eventdate AS date,
    gpe.SuppliedCode AS code,
    sct.term AS term,
    gpe.Episodicity,
    gpe.value,
    gpe.units
  FROM 
    #patids AS pid
  INNER JOIN 
    [Client_SystemP].[Patient] AS pat
    ON pid.ID=pat.PK_Patient_ID 
  INNER JOIN 
    [CLient_SystemP].[GP_Events] AS gpe
    ON gpe.FK_Patient_ID=pat.PK_Patient_ID
   INNER JOIN 
    [UKHD_REF].[SNOMED_Text_Definition_SCD] AS sct
    ON gpe.SuppliedCode=sct.Concept_ID
  WHERE 
  gpe.EventDate > CAST('2020-01-01' AS DATE) AND
  gpe.SourceTable LIKE 'EMIS%'

  UNION

  SELECT DISTINCT TOP(100)
    pat.PK_Patient_ID,
    pat.Sex,
    pat.Dob,
    'medication' AS eventype,
    gpm.MedicationDate AS date,
    gpm.SuppliedCode AS code,
    gpm.MedicationDescription AS term,
    gpm.Dosage AS episodicity,
    gpm.Quantity AS value,
    gpm.Units AS units
  FROM 
    #patids AS pid
  INNER JOIN 
    [Client_SystemP].[Patient] AS pat
    ON pid.ID=pat.PK_Patient_ID 
  INNER JOIN 
    [CLient_SystemP].[GP_Medications] AS gpm
    ON gpm.FK_Patient_ID=pat.PK_Patient_ID
  WHERE 
    gpm.MedicationDate > CAST('2020-01-01' AS DATE) 
) AS tmp