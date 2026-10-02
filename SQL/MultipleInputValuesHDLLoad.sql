INSERT INTO hdl_element_staging (
    assignment_id, 
    effective_date,
    in1, s1, 
    in2, s2, 
    in3, s3, 
    in4, s4, 
    in5, s5,
    in6, s6,
    in7, s7,
    in8, s8,
    in9, s9,
    in10, s10
)
SELECT 
    assignment_id,
    effective_date,
    -- Row 1 Pairs
    MAX(CASE WHEN rn = 1 THEN input END) AS in1,
    MAX(CASE WHEN rn = 1 THEN value END) AS s1,
    -- Row 2 Pairs
    MAX(CASE WHEN rn = 2 THEN input END) AS in2,
    MAX(CASE WHEN rn = 2 THEN value END) AS s2,
    -- Row 3 Pairs
    MAX(CASE WHEN rn = 3 THEN input END) AS in3,
    MAX(CASE WHEN rn = 3 THEN value END) AS s3,
    -- Row 4 Pairs
    MAX(CASE WHEN rn = 4 THEN input END) AS in4,
    MAX(CASE WHEN rn = 4 THEN value END) AS s4,
    -- Row 5 Pairs
    MAX(CASE WHEN rn = 5 THEN input END) AS in5,
    MAX(CASE WHEN rn = 5 THEN value END) AS s5,
    -- Row 6 Pairs (buffer for future/additional rows)
    MAX(CASE WHEN rn = 6 THEN input END) AS in6,
    MAX(CASE WHEN rn = 6 THEN value END) AS s6,
    -- Row 7 Pairs
    MAX(CASE WHEN rn = 7 THEN input END) AS in7,
    MAX(CASE WHEN rn = 7 THEN value END) AS s7,
    -- Row 8 Pairs
    MAX(CASE WHEN rn = 8 THEN input END) AS in8,
    MAX(CASE WHEN rn = 8 THEN value END) AS s8,
    -- Row 9 Pairs
    MAX(CASE WHEN rn = 9 THEN input END) AS in9,
    MAX(CASE WHEN rn = 9 THEN value END) AS s9,
    -- Row 10 Pairs
    MAX(CASE WHEN rn = 10 THEN input END) AS in10,
    MAX(CASE WHEN rn = 10 THEN value END) AS s10
FROM (
    SELECT 
        assignment_id,
        effective_date,
        input_name AS input,
        -- Standardize date fields dynamically across all employees
        CASE 
            WHEN input_name LIKE '%Date%' OR REGEXP_LIKE(value, '^\d{4}/\d{2}/\d{2}$') 
            THEN TO_CHAR(TO_DATE(value, 'YYYY/MM/DD'), 'YYYY/MM/DD')
            ELSE value 
        END AS value,
        -- Sequence each employee's rows independently starting from 1
        ROW_NUMBER() OVER (PARTITION BY assignment_id, effective_date ORDER BY display_sequence, input_name) AS rn
    FROM source_payroll_inputs
    WHERE status = 'NEW' -- Optional: filter for unprocessed records
)
GROUP BY assignment_id, effective_date;

COMMIT;
