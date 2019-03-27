/*
    Dit script verwijderd all foreign constraints die naar een tabel verwijzen.

    LET OP: De EXEC functie staat standaard uitgecommentarieerd, zodat je in eerste instantie
    alleen het result ziet zonder de uitvoering ervan
*/
DECLARE @schemaName varchar(10) = ''
DECLARE @tableName varchar(50) = ''

DECLARE @SQL10 varchar(MAX)
DECLARE MyCursor CURSOR FOR
    -- ALTER drop statement for all foreign constraints connected to primary key column
    SELECT
        'ALTER TABLE '+FK.TABLE_SCHEMA+'.'+FK.TABLE_NAME+' DROP CONSTRAINT '+C.CONSTRAINT_NAME AS Constraint_Name
    FROM INFORMATION_SCHEMA.REFERENTIAL_CONSTRAINTS C
    INNER JOIN INFORMATION_SCHEMA.TABLE_CONSTRAINTS FK ON C.CONSTRAINT_NAME = FK.CONSTRAINT_NAME
    INNER JOIN INFORMATION_SCHEMA.TABLE_CONSTRAINTS PK ON C.UNIQUE_CONSTRAINT_NAME = PK.CONSTRAINT_NAME
    INNER JOIN (
        SELECT i1.TABLE_NAME, i2.COLUMN_NAME
        FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS i1
        INNER JOIN INFORMATION_SCHEMA.KEY_COLUMN_USAGE i2 ON i1.CONSTRAINT_NAME = i2.CONSTRAINT_NAME
        WHERE i1.CONSTRAINT_TYPE = 'PRIMARY KEY'
        ) PT ON PT.TABLE_NAME = PK.TABLE_NAME
    WHERE PK.CONSTRAINT_SCHEMA = @schemaName AND PK.TABLE_NAME = @tableName
OPEN MyCursor
FETCH NEXT FROM MyCursor INTO @SQL10
WHILE @@FETCH_STATUS = 0
BEGIN
    PRINT @SQL10
    --EXEC (@SQL10)
    FETCH NEXT FROM MyCursor INTO @SQL10
END
CLOSE MyCursor
DEALLOCATE MyCursor
