
If Not Exists ( Select *
                from   Operaciones
                Where  operacion = 'BBOPER01')
   Begin
      Execute dbo.sp_alta_operaciones  @operacion        = 'BBOPER01',  
                                       @descripcion_ope  = 'Alta Empleados Interface Banco Bajío ',  
                                       @icono            = 1,  
                                       @tipo_operacion   = 2,  
                                       @ejecuta_llamada  = Null,  
                                       @parametros       = Null,  
                                       @tipo_ejecucion   = Null,  
                                       @usuario          = 'ADAM';
   End
Go

If Not Exists ( Select *
                from   Operaciones
                Where  operacion = 'BBOPER02')
   Begin
      Execute dbo.sp_alta_operaciones  @operacion        = 'BBOPER02',  
                                       @descripcion_ope  = 'Generación de Layout Banco Bajío ',  
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
                Where  operacion = 'BBOPER01'
                And    usuario   = 'ADAM')
   Begin
      Execute dbo.sp_alta_aut_operaciones @usuario         = 'ADAM',  
                                          @operacion       = 'BBOPER01',  
                                          @nivel_seguridad = 4;
   End
Go

If Not Exists ( Select *
                from   aut_operaciones
                Where  operacion  = 'BBOPER02'
                And    usuario    = 'ADAM')
   Begin
      Execute dbo.sp_alta_aut_operaciones @usuario         = 'ADAM',  
                                          @operacion       = 'BBOPER02',  
                                          @nivel_seguridad = 4;
   End
Go
