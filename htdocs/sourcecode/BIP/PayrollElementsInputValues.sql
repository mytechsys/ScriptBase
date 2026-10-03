SELECT 
    ldg.name AS ldg_name,                         -- Name of the Legislative Data Group (LDG)
    ldg.legislation_code,                         -- ISO Country code linked to the LDG (e.g., US, GB, IN)
    et.element_name AS base_element_name,         -- Official name of the Payroll Element
    et.processing_type AS recurring_flag,         -- Processing type: 'R' for Recurring, 'N' for Non-recurring
    ec.classification_name,                       -- Primary element classification (e.g., Earnings, Voluntary Deductions)
    iv.base_name,                                 -- Base (untranslated) technical name of the input value
    iv.name AS input_value_name,                  -- Localized name of the input value (e.g., Days Traveled)
    iv.display_sequence,                          -- UI rendering order sequence number (e.g., 20)
    --iv.special_purpose,                           -- Internal special purpose categorization tag (e.g., Days, Hours)
    iv.uom AS unit_of_measure,                    -- Unit of Measure code (e.g., 'M' = Money, 'N' = Number, 'C' = Character)
    iv.effective_start_date,                      -- Date from which this input value configuration is active
    iv.effective_end_date,                        -- Date until which this input value configuration is active
    iv.mandatory_flag AS required_flag,           -- Indicates if filling out this input value is mandatory ('Y'/'N')
    iv.default_value,                             -- Default value automatically populated during entry creation
    iv.hot_default_flag AS allow_user_entry_flag, -- Governs default entry override rules ('Y'/'N')
    iv.generate_db_items_flag AS create_db_item,   -- Indicates if Fast Formula Database Items are auto-generated ('Y'/'N')
    iv.USER_DISPLAY_FLAG  ,
    iv.USER_ENTERABLE_FLAG
FROM 
    pay_element_types_vl et,                      -- Secured public view for Element Types
    per_legislative_data_groups_vl ldg,           -- Secured public view for Legislative Data Groups
    pay_ele_classifications_vl ec,                -- Secured public view for Element Classifications
    pay_input_values_vl iv                        -- Secured public view for Input Values
WHERE 
    et.legislative_data_group_id = ldg.legislative_data_group_id(+) -- Outer join matching elements to their LDG
    AND et.classification_id = ec.classification_id               -- Joins elements to their structural classification
    AND et.element_type_id = iv.element_type_id                   -- Joins elements to their associated input values children
    -- AND et.element_name = 'Regular Salary'                     -- Optional filter: uncomment to target a specific element name
    -- AND iv.name = 'Days Traveled'                              -- Optional filter: uncomment to target a specific input value name
    AND TRUNC(SYSDATE) BETWEEN et.effective_start_date AND et.effective_end_date  -- Filters for currently active element definitions
    AND TRUNC(SYSDATE) BETWEEN iv.effective_start_date AND iv.effective_end_date -- Filters for currently active input value definitions
