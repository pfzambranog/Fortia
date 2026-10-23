Use Adam
Go

/*
Select dbo.fn_detallaNombre(nombre, 1), dbo.fn_detallaNombre(nombre, 2),
       dbo.fn_detallaNombre(nombre,3),  dbo.fn_detallaNombre(nombre, 4),
       dbo.fn_detallaNombre(nombre, 5), dbo.fn_detallaNombre(nombre, 6)
From   trabajadores

*/

If Exists (Select Top 1 1
           From   Sysobjects
           Where  Uid  = 1
           And    Type = 'Fn'
           And    Name = 'fn_detallaNombre')
   Begin
      Drop Function dbo.fn_detallaNombre
   End
Go

Create Function dbo.fn_detallaNombre
  (@PsNombre   Char(100),
   @PnTipo     Integer)     -- 1 = Apellido Paterno, 2 = Apellido Materno, 3 = Nombres, 4 = Primer Nombre, 5 = Segundo Nombre, 6 = Apellido Paterno + Primer Nombre
Returns Char(100)
AS

Begin

Declare
   @w_posicion1        Integer,
   @w_posicion2        Integer,
   @w_x                Integer,
   @w_z                Integer,
   @w_y                Integer,
   @w_salida           Char(100),
   @w_apellidoPaterno  Varchar(100),
   @w_nombres          Varchar(100);


/*
  Autor:          Pedro Zambrano
  Descripción:    Función que extrae datos de nombre, apellido segun la opción seleccionada.
  Creacion:       20-oct-2026.
  Version:        1.0
*/

   Set @w_salida = ' '

   Select @w_posicion1 = Charindex('/', @PsNombre),
          @w_x         = @w_posicion1 + 1,
          @w_y         = Len(@PsNombre),
          @w_z         = 0;

   While @w_x <= @w_y
   Begin
      If Substring(@PsNombre, @w_x, 1) = '/'
         Begin
            Select @w_posicion2 = @w_x,
                   @w_x         = @w_y + 1
         End

      Set @w_x = @w_x + 1
   End

   Set @w_apellidoPaterno = Substring(@PsNombre, 1, @w_posicion1 - 1);

   If @PnTipo = 1
      Begin
         Set @w_salida = @w_apellidoPaterno
         Goto Salida
      End

   If @PnTipo = 2
      Begin
         Select @w_posicion2 = @w_posicion2 - @w_posicion1 - 1,
                @w_salida    = Substring(@PsNombre, @w_posicion1 + 1, @w_posicion2);

         Goto Salida;
      End

   Set @w_nombres    = Substring(@PsNombre, @w_posicion2 + 1, @w_y)

   If @PnTipo = 3
      Begin
         Set @w_salida = @w_nombres;

         Goto Salida;
      End

   Select @w_y         = Len(@w_nombres),
          @w_x         = 1,
          @w_posicion1 = @w_y + 1

   While @w_x <= @w_y
   Begin
      If Substring(@w_nombres, @w_x, 1) In (Char(32), Char(9))
         Begin
            Select @w_posicion1 = @w_x,
                   @w_x = @w_y + 1
         End
      Set @w_x = @w_x + 1
   End

   Select @w_salida = Case When @PnTipo = 4
                           Then Substring(@w_nombres, 1, @w_posicion1 - 1)
                           When @PnTipo = 5
                           Then Substring(@w_nombres, (@w_posicion1 - 1) + 1, @w_y)
                           When @PnTipo = 6
                           Then Rtrim(Ltrim(Substring(@w_nombres, 1, @w_posicion1 - 1))) + '/' + Rtrim(Ltrim(@w_apellidoPaterno))
                           Else Char(32)
                      End

Salida:

    Return Isnull(@w_salida, '')
End
GO

--
-- Comentarios
--

Declare
   @w_valor          Nvarchar(250) = 'Función que extrae datos de nombre, apellido segun la opción seleccionada.',
   @w_procedimiento  NVarchar(250) = 'fn_detallaNombre';

If Not Exists (Select Top 1 1
               From   sys.extended_properties a
               Join   sysobjects  b
               On     b.xtype   = 'Fn'
               And    b.name    = @w_procedimiento
               And    b.id      = a.major_id)
   Begin
      Execute  sp_addextendedproperty @name       = N'MS_Description',
                                      @value      = @w_valor,
                                      @level0type = 'Schema',
                                      @level0name = N'dbo',
                                      @level1type = 'Function', 
                                      @level1name = @w_procedimiento

   End
Else
   Begin
      Execute sp_updateextendedproperty @name       = 'MS_Description',
                                        @value      = @w_valor,
                                        @level0type = 'Schema',
                                        @level0name = N'dbo',
                                        @level1type = 'Function', 
                                        @level1name = @w_procedimiento
   End
Go 