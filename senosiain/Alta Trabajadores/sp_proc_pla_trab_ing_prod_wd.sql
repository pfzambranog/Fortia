Create or Replace Procedure sp_proc_pla_trab_ing_prod_wd
As
   w_error                  Number(1, 0)  := 0;
   w_desc_error             Varchar2(250);
   w_proceso                Varchar2(030) := 'PUESTOS TRABAJADOR';
   w_sql                    Varchar2(4000);
   w_comilla                Char(1) := Chr(39);
   w_compania               Char(4);
   w_supervisor             Char(10);
   w_puesto                 Char(15);
   w_sit_trabajador         Number(1, 0);
   w_y                      Number(1, 0)  := 1;
   w_linea                  Number(4, 0);
   w_plaza                  Number(4, 0);
   w_silla_sup              Number(8, 0);
   w_silla_ant              Number(8, 0);
   w_fecha_vigencia         Date;
   w_fecha_inicio           Date        := Sysdate;

   Cursor C_trab_new Is
   Select Compania, Trabajador, puesto, Causa_Cambio, IdSupervisor, Linea
   From   trabajadores_grales_ING_WD
   Where  Nvl(trim(Puesto),  ' ') != ' '   
   Order  by Linea;

Begin

   For X1 in C_trab_new Loop
       Begin
          Select Distinct 1
          Into   w_error
          From   bitacora_carga_ing_WD
          Where  Proceso = w_proceso
          And    Rownum  < 2;
          Exception When no_data_found Then
             Insert into bitacora_carga_ing_WD
             Values (w_proceso, 0, 0, 0);
       End;

       Update bitacora_carga_ing_WD
       Set    Registros_leidos = Registros_leidos + 1
       Where  Proceso = w_proceso;
       Commit;

       Begin
          Select Distinct 0, sit_trabajador
          Into   w_error,    w_sit_trabajador
          From   Trabajadores_grales
          Where  Compania   = x1.compania
          And    Trabajador = x1.trabajador
          And    Rownum      < 2;
          Exception When no_data_Found Then
             w_error := 1;
             w_desc_error := 'CODIGO DE TRABAJADOR NO EXISTE EN TRABAJADORES_GRALES.';
             sp_alta_errores_datos_ing_WD(w_Proceso, x1.trabajador, x1.Linea, w_desc_error);
             Update bitacora_carga_ing_WD
             Set    Registros_error = Registros_error + 1
             Where  Proceso = w_proceso;
             Commit;
       End;

       If w_Sit_trabajador = 2  And
          w_error          = 0 Then
          w_error := 1;
          w_desc_error := 'TRABAJADOR EN SITUACION DE BAJA.';
             sp_alta_errores_datos_ing_WD(w_Proceso, x1.trabajador, x1.Linea, w_desc_error);
             Update bitacora_carga_ing_WD
             Set    Registros_error = Registros_error + 1
             Where  Proceso = w_proceso;
             Commit;
       End If;

       If w_error = 0 Then
          Begin
             Select Compania,   Trabajador
             Into   w_compania, w_supervisor
             From   variables_trabajador a
             Where  secuencia           = 75
             And    variable_trabajador = to_number(x1.Idsupervisor)
             And    Exists              ( Select Distinct 1
                                          From   Trabajadores_grales
                                          Where  Compania       = a.compania
                                          And    Trabajador     = a.trabajador
                                          And    Sit_trabajador = 1
                                          And    Rownum         < 2)
             And    Rownum              < 2;
             Exception When no_data_Found Then
                w_error      := 1;
                w_desc_error := 'CODIGO ACHIEVE DEL SUPERVISOR NO EXISTE -'||x1.Idsupervisor;
                sp_alta_errores_datos_ing_WD(w_Proceso, x1.trabajador, x1.Linea, w_desc_error);
                Update bitacora_carga_ing_WD
                Set    Registros_error = Registros_error + 1
                Where  Proceso = w_proceso;
                Commit;
          End;
       End If;


       If w_error = 0 Then
          Begin
             Select Distinct 0, sit_trabajador
             Into   w_error,    w_sit_trabajador
             From   Trabajadores_grales
             Where  Compania   = w_compania
             And    Trabajador = w_supervisor
             And    Rownum      < 2;
             Exception When no_data_Found Then
                w_error      := 1;
                w_desc_error := 'CÓDIGO DE SUPERVISOR NO EXISTE EN TRABAJADORES_GRALES-'||w_supervisor;
                sp_alta_errores_datos_ing_WD(w_Proceso, x1.trabajador, x1.Linea, w_desc_error);
                Update bitacora_carga_ing_WD
                Set    Registros_error = Registros_error + 1
                Where  Proceso = w_proceso;
                Commit;
          End;
       End If;

       If w_Sit_trabajador = 2  And
          w_error          = 0 Then
          w_error      := 1;
          w_desc_error := 'SUPERVISOR EN SITUACIÓN DE BAJA-'||w_supervisor;
             sp_alta_errores_datos_ing_WD(w_Proceso, x1.trabajador, x1.Linea, w_desc_error);
             Update bitacora_carga_ing_WD
             Set    Registros_error = Registros_error + 1
             Where  Proceso = w_proceso;
             Commit;
       End If;


       If w_error = 0 Then
          Begin
             Select Silla
             Into   w_silla_sup
             From   Plazas
             Where  Compania   = w_compania
             And    Trabajador = w_supervisor
             And    Rownum      < 2;
             Exception When no_data_Found Then
                w_error      := 1;
                w_desc_error := 'CODIGO DE SUPERVISOR NO TIENE PLAZA ASIGNADA-'||w_supervisor;
                sp_alta_errores_datos_ing_WD(w_Proceso, x1.trabajador, x1.Linea, w_desc_error);
                Update bitacora_carga_ing_WD
                Set    Registros_error = Registros_error + 1
                Where  Proceso = w_proceso;
                Commit;
          End;
       End If;

       If w_error = 0 Then
          Begin
             Select puesto,   silla_superior, fecha_vigencia
             Into   w_puesto, w_silla_ant,    w_fecha_vigencia
             From   Plazas
             Where  Compania   = x1.compania
             And    trabajador = x1.trabajador
             And    rownum     < 2;
             Exception When no_data_found Then
                w_puesto     := ' ';
                w_silla_ant  := 0;
          End;

          If w_puesto    = x1.puesto    And
             w_silla_ant = w_silla_sup Then
             w_error := 1 ;
          End If;

          If w_error      = 0 Then

             If w_silla_ant != w_silla_sup  And
                w_puesto     = x1.puesto   Then
                w_fecha_inicio := w_fecha_vigencia;
             End If;

             w_y      := 0;

             Update Plazas
             Set    Trabajador = Null
             Where  Compania       = x1.Compania
             And    Trabajador     = x1.trabajador;
             Commit;
             
             Select Min(Plaza)
             Into   w_plaza
             From   Plazas a
             Where  Compania        = x1.Compania
             And    puesto          = x1.puesto
             And    trabajador     Is Null
             And    silla_superior  = w_silla_sup;

             If Nvl(w_plaza, 0) = 0 Then
                Select Max(Plaza)
                Into   w_plaza
                From   Plazas a
                Where  Compania        = x1.Compania
                And    puesto          = x1.puesto;

                w_plaza := Nvl(w_plaza, 0) + 1;

                Begin
                   sp_alta_plazas(x1.compania, x1.puesto, Null, w_silla_sup, 1, 'PE', x1.trabajador, w_plaza, x1.causa_cambio, 1, w_fecha_inicio );
                   Commit;
                   Exception When Others Then
                      Rollback;
                      w_desc_error := 'ERRROR AL CREAR PLAZA AL PUESTO.: '||to_char(sqlcode)||'-'||Substr(sqlerrm, 1, 150);
                      sp_alta_errores_datos_ing_WD(w_Proceso, x1.trabajador, x1.Linea, w_desc_error);
                      Update bitacora_carga_ing_WD
                      Set    Registros_error = Registros_error + 1
                      Where  Proceso = w_proceso;
                      Commit;
                End;
             Else
                Begin
                   sp_alta_plaza_principal (x1.compania, x1.puesto, w_plaza, x1.trabajador,  x1.causa_cambio, w_fecha_inicio);
                   Commit;
                   Exception When Others Then
                      Rollback;
                      w_desc_error := 'ERRROR AL ASIGNAR PUESTO.: '||to_char(sqlcode)||'-'||Substr(sqlerrm, 1, 150);
                      sp_alta_errores_datos_ing_WD(w_Proceso, x1.trabajador, x1.Linea, w_desc_error);
                      Update bitacora_carga_ing_WD
                      Set    Registros_error = Registros_error + 1
                      Where  Proceso = w_proceso;
                      Commit;
                End;
                
                If w_silla_ant != w_silla_sup  Then
                   Begin
                      Update Plazas
                      Set    Silla_superior = w_silla_sup
                      Where  Compania       = x1.Compania
                      And    Trabajador     = x1.trabajador;
                      Commit;
                      Exception When Others Then
                         Rollback;
                         w_desc_error := 'ERRROR AL ASIGNAR SILLA SUPERIOR.: '||to_char(sqlcode)||'-'||Substr(sqlerrm, 1, 150);
                         sp_alta_errores_datos_ing_WD(w_Proceso, x1.trabajador, x1.Linea, w_desc_error);
                         Update bitacora_carga_ing_WD
                         Set    Registros_error = Registros_error + 1
                         Where  Proceso = w_proceso;
                         Commit;
                   End;
                End If;
                
             End If;
          End If;
       End If;
       Commit;

   End Loop;
   Commit;
   Return;

End sp_proc_pla_trab_ing_prod_wd;
/

Create Or Replace Public Synonym sp_proc_pla_trab_ing_prod_wd for sp_proc_pla_trab_ing_prod_wd;
Grant  Execute on sp_proc_pla_trab_ing_prod_wd to Adama;

