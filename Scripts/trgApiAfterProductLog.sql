
GO
/****** Object:  Trigger [dbo].[trgApiAfterProductLog]    Script Date: 11/07/2024 01:21:31 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER TRIGGER [dbo].[trgApiAfterProductLog]
ON [dbo].[tempcheqdet]
AFTER INSERT
AS
BEGIN
    DECLARE @FolioDet NVARCHAR(100), @Orden NVARCHAR(100), @Movimiento NVARCHAR(100),
            @Cantidad NVARCHAR(100), @Nombre NVARCHAR(100), @Precio NVARCHAR(100),
            @Hora NVARCHAR(100), @Modificador NVARCHAR(100), @Mesa NVARCHAR(100)

    DECLARE @VenueId NVARCHAR(100) = 'VenueId'

    -- Obtiene los datos del registro insertado haciendo un JOIN con las tablas necesarias
    SELECT 
        @FolioDet = chd.foliodet, 
        @Orden = ch.orden, 
        @Movimiento = chd.movimiento, 
        @Cantidad = chd.cantidad, 
        @Nombre = p.descripcion, 
        @Precio = chd.precio,
        @Hora = chd.hora, 
        @Modificador = chd.modificador,
        @Mesa = ch.mesa
    FROM 
        inserted AS chd
        INNER JOIN productos AS p ON p.idproducto = chd.idproducto
        INNER JOIN tempcheques AS ch ON ch.folio = chd.foliodet

    -- Construye un JSON con los datos del registro insertado
    EXECUTE [dbo].[spChequeProduct] @FolioDet = @FolioDet, 
        @Orden = @Orden, 
        @Movimiento = @Movimiento, 
        @Cantidad = @Cantidad, 
        @Nombre = @Nombre, 
        @Precio = @Precio,
        @Hora = @Hora, 
        @Modificador = @Modificador,
        @Mesa = @Mesa;


END
