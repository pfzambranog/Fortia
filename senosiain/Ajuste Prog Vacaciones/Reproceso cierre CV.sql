-- Select *
-- into   saldos_vacaciones_back
-- from   saldos_vacaciones

-- Select *
-- into   programacion_vacaciones_back
-- from   programacion_vacaciones


Declare
   @w_tabla          Sysname,
   @w_compania       Char(4),
   @w_id_calendario  Integer,
   @w_secuencia      Integer,
   @w_sql            Varchar(Max);

Begin
   Delete transacciones_ns

   Select top 1 @w_secuencia      = secuencia,
                @w_tabla          = tabla,
                @w_compania       = compania,
                @w_id_calendario  = id_calendario
   From   dbo.TablasMgrTbl
   Where  existe = 0;
   If @@Rowcount = 0
      Begin
         Select 'No Hay tablas por Procesar';
         Return
      End

 
   Set @w_sql = Concat('Select * ',
                       'From   dbo.', @w_tabla);

   Insert Into transacciones_ns
   Execute (@w_sql);
   Select @@Rowcount "Registros Nuevos"

   Execute  sp_rest_resp_cierre     @w_compania, @w_id_calendario, 5
        
   Execute  sp_cierre_nomina_cv_ns  @w_compania, @w_id_calendario

   Update   dbo.TablasMgrTbl
   Set      existe = 1
   Where    secuencia = @w_secuencia
   
   Return;
   
End;
Go
