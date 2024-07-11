
GO
/****** Object:  Trigger [dbo].[trgChequeComanda]    Script Date: 11/07/2024 01:19:39 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER TRIGGER [dbo].[trgChequeComanda]
ON [dbo].[tempcheques]
AFTER INSERT, UPDATE
AS
BEGIN
	--SELECT 1
	--PRINT('trigger Called')
    DECLARE @Folio NVARCHAR(100), @Mesa NVARCHAR(100), --@Articulos NVARCHAR(100),
           -- @Total NVARCHAR(100), 
		   @Status NVARCHAR(100), @PrevStatus NVARCHAR(100), @Impreso BIT

    IF NOT EXISTS(SELECT * FROM deleted) -- Es un INSERT
    BEGIN
        SELECT @Folio = folio, @Mesa = mesa,-- @Articulos = totalarticulos,
             --  @Total = total, 
			 @Status = CASE WHEN pagado = 1 THEN 'PAID' 
                                              WHEN cancelado = 1 THEN 'CANCELED' 
                                              ELSE 'OPEN' END, -- Aquí he puesto 'Abierta' como valor por defecto
               @Impreso = impreso
        FROM inserted
    END
    ELSE -- Es un UPDATE
    BEGIN
        SELECT @Folio = folio, @Mesa = mesa,-- @Articulos = totalarticulos, 
               --@Total = total,
			    @Status = CASE WHEN pagado = 1 THEN 'PAID' 
                                              WHEN cancelado = 1 THEN 'CANCELED' 
                                              ELSE 'OPEN' END,
               @Impreso = impreso
        FROM inserted

        SELECT @PrevStatus = CASE WHEN pagado = 1 THEN 'PAID' 
                                  WHEN cancelado = 1 THEN 'CANCELED' 
                                  ELSE 'OPEN' END
        FROM deleted
        
        -- Si el valor de Status no ha cambiado, no se hace nada más
        IF @Status = @PrevStatus
            RETURN
    END

 
     EXECUTE [dbo].[spChequeComanda]  @Folio =  @Folio, @Mesa = @Mesa,@Status = @Status,@PrevStatus = @PrevStatus, @Impreso= @Impreso ;
	
END