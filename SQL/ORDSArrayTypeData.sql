SELECT 
    e.element_name,
    JSON_ARRAYAGG(
        JSON_OBJECT(
            'input_value'      VALUE iv.input_value_name,
            'input_value_type' VALUE iv.input_value_type
        )
        RETURNING CLOB
    ) AS input_types
FROM 
    app_elements e
LEFT JOIN 
    app_input_values iv ON e.element_name = iv.element_name
GROUP BY 
    e.element_name;
