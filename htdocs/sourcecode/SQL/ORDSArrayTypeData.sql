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



-- When ORDS (Oracle REST Data Services) returns a JSON array as a "justified string" (meaning it is being escaped and treated as a plain text string like "[{\"input_value\":\"A\"}]" 
-- instead of a true JSON structure), it usually happens because the SQL query result is being implicitly converted to a string by the database or ORDS, or the content type isn't set to application/json.
-- To fix this, you can use JSON_OBJECTAGG or JSON_QUERY with explicit formatting in your ORDS source query to ensure Oracle returns it as native JSON data.
    
SELECT 
    e.element_name,
    JSON_QUERY(
        ('[' || LISTAGG('"' || iv.input_value_name || '"', ',') WITHIN GROUP (ORDER BY iv.input_value_name) || ']'),
        '$' 
        RETURNING CLOB
    ) AS input_types
FROM 
    app_elements e
LEFT JOIN 
    app_input_values iv ON e.element_name = iv.element_name
GROUP BY 
    e.element_name;
