USE procinal;
GO

DECLARE 
    @id_pelicula INT,
    @titulo VARCHAR(100),
    @total_proyecciones INT;

DECLARE cursor_peliculas CURSOR FOR
    SELECT id_pelicula, titulo
    FROM dbo.Pelicula;

    OPEN cursor_peliculas;

    FETCH NEXT FROM cursor_peliculas 
    INTO @id_pelicula, @titulo;

    WHILE @@FETCH_STATUS = 0
    BEGIN
        SET @total_proyecciones = dbo.fn_TotalProyecciones(@id_pelicula);

        PRINT 'Película: ' + @titulo 
            + ' | Total de proyecciones: ' 
            + CAST(@total_proyecciones AS VARCHAR(10));

        FETCH NEXT FROM cursor_peliculas 
        INTO @id_pelicula, @titulo;
END;

CLOSE cursor_peliculas;
DEALLOCATE cursor_peliculas;
GO