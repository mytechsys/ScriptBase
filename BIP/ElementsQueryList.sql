SELECT 
    ldg.name AS ldg_name,                         -- Name of the Legislative Data Group (LDG)
    ldg.legislation_code,                         -- ISO Country code linked to the LDG (e.g., US, GB, IN)
    et.element_name AS base_element_name,         -- Official name of the Payroll Element
    et.processing_type AS recurring_flag,         -- Processing type: 'R' for Recurring, 'N' for Non-recurring
    ec.classification_name                        -- Primary element classification (e.g., Earnings, Voluntary Deductions)
FROM 
    pay_element_types_vl et,                      -- Secured public view for Element Types
    per_legislative_data_groups_vl ldg,           -- Secured public view for Legislative Data Groups
    pay_ele_classifications_vl ec                 -- Secured public view for Element Classifications
WHERE 
    et.legislative_data_group_id = ldg.legislative_data_group_id(+) -- Outer join matching elements to their LDG
    AND et.classification_id = ec.classification_id               -- Joins elements to their structural classification
    -- AND et.element_name = 'Regular Salary'                     -- Optional filter: uncomment to target a specific element name
    AND TRUNC(SYSDATE) BETWEEN et.effective_start_date AND et.effective_end_date  -- Filters for currently active element definitions
