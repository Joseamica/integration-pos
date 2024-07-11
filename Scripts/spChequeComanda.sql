GO
/****** Object:  StoredProcedure [dbo].[spChequeComanda]    Script Date: 11/07/2024 01:16:42 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[spChequeComanda]
(
    @Folio NVARCHAR(100), 
	@Mesa NVARCHAR(100), 
	@Status NVARCHAR(100), 
	@PrevStatus NVARCHAR(100), 
	@Impreso BIT
)
AS
BEGIN
    BEGIN TRANSACTION;

    -- Construcción de un JSON con los datos obtenidos
    DECLARE @jsonData NVARCHAR(MAX) = CONCAT(
        '{ "folio": "', REPLACE(@Folio, '"', '"'), 
        '", "mesa": "', REPLACE(@Mesa, '"', '"'), 
		'", "new_mesa": "', REPLACE('', '"', '"'),  
		'", "change_table": "', REPLACE('false', '"', '"'),  
        '", "status": "', REPLACE(@Status, '"', '"'), 
        '", "impreso": "', IIF(@Impreso = 1, 'true', 'false'), '" }' -- Asumiendo que @Impreso es un BIT
    );
    
    
		INSERT INTO [dbo].[InvokeApiAfterOrderLog] (Jsondata,TableName,IsSuccess)
		VALUES(@jsonData,'tempcheques',0);		
	COMMIT TRANSACTION;

	EXEC xp_cmdshell 'C:\servicesAvoqado\ServiceBroker_Consola.exe';
	UPDATE dbo.InvokeApiAfterOrderLog SET IsSuccess = 1;
	
END