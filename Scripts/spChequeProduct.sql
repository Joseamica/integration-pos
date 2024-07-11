
GO
/****** Object:  StoredProcedure [dbo].[spChequeProduct]    Script Date: 11/07/2024 01:18:13 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[spChequeProduct]
(
    @FolioDet NVARCHAR(100), @Orden NVARCHAR(100), @Movimiento NVARCHAR(100),
    @Cantidad NVARCHAR(100), @Nombre NVARCHAR(100), @Precio NVARCHAR(100),
    @Hora NVARCHAR(100), @Modificador NVARCHAR(100), @Mesa NVARCHAR(100)

)
AS
BEGIN
	DECLARE @VenueId NVARCHAR(100) = 'VenueId';
    DECLARE @jsonData NVARCHAR(MAX) = CONCAT(
       '{ ',
        '"foliodet": "', REPLACE(@FolioDet, '"', '\"'), 
        '", "orden": "', REPLACE(@Orden, '"', '\"'), 
        '", "movimiento": "', REPLACE(@Movimiento, '"', '\"'), 
        '", "cantidad": "', REPLACE(@Cantidad, '"', '\"'), 
        '", "nombre": "', REPLACE(@Nombre, '"', '\"'), 
        '", "precio": "', REPLACE(@Precio, '"', '\"'), 
        '", "mesa": "', REPLACE(@Mesa, '"', '\"'),
        '", "hora": "', REPLACE(@Hora, '"', '\"'), 
        '", "modificador": "', REPLACE(@Modificador, '"', '\"'), 
        '", "venueId": "', REPLACE(@VenueId, '"', '\"'), 
        '" }'
    );

    -- Aquí insertamos el JSON en la tabla de log
   INSERT INTO [dbo].[InvokeApiAfterProductLog] (Jsondata,TableName,IsSuccess)
    VALUES(@jsonData,'tempcheqdet',0);

	Exec xp_cmdshell 'C:\servicesAvoqado\ServiceBroker_Consola.exe';
	UPDATE dbo.InvokeApiAfterProductLog SET IsSuccess = 1
END