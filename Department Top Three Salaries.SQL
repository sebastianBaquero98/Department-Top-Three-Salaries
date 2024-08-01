WITH flags AS (
    SELECT
        departmentId,
        name,
        salary,
        (CASE
            WHEN LEAD(salary) OVER (PARTITION BY departmentId ORDER BY salary) = salary THEN 0
            ELSE 1
            END
        ) AS flag
    FROM
        Employee
    ORDER BY
        departmentId, salary DESC
),
sums AS (
SELECT
    departmentId,
    name,
    salary,
    flag,
    SUM(flag) OVER (PARTITION BY departmentId ORDER BY salary DESC ) AS r
FROM
    flags
ORDER BY
    departmentId, salary DESC
)

SELECT
    d.name as Department,
    s.name as Employee,
    salary as Salary
FROM
    sums as s JOIN Department as d on s.departmentId = d.id
WHERE
    r <=3
