Use ADAM
Go

If Not Exists ( Select *
                from   Operaciones
                Where  operacion = 'BBDISP01')
   Begin
      Execute dbo.sp_alta_operaciones  @operacion        = 'BBDISP01',
                                       @descripcion_ope  = 'Generación de Dispersión para Banco Bajío ',
                                       @icono            = 1,
                                       @tipo_operacion   = 2,
                                       @ejecuta_llamada  = Null,
                                       @parametros       = Null,
                                       @tipo_ejecucion   = Null,
                                       @usuario          = 'ADAM';
   End
Go

If Not Exists ( Select *
                from   aut_operaciones
                Where  operacion = 'BBDISP01'
                And    usuario   = 'ADAM')
   Begin
      Execute dbo.sp_alta_aut_operaciones @usuario         = 'ADAM',
                                          @operacion       = 'BBDISP01',
                                          @nivel_seguridad = 4;
   End
Go

