Begin
   Delete dbo.aut_operaciones  
   Where operacion =  'BBDISP01';
   Delete dbo.Rel_Priv_usu     
   Where operacion =  'BBDISP01';
   Delete dbo.Rel_oper_modulos 
   Where operacion =  'BBDISP01';
   Delete dbo.rel_oper_menus   
   Where ejecuta_operacion =  'BBDISP01';
   Delete dbo.parametros_oper
   Where operacion =  'BBDISP01';
   Delete dbo.Operaciones      
   Where operacion =  'BBDISP01';

   Insert Into dbo.operaciones       
   Values ('BBDISP01', 'Dispersión Banco Bajío',  1, 2,'C:\Program Files (x86)\ADAM Technologies\Fiscal\DisBajio.exe', null, null, null);
   
   Insert Into dbo.Rel_oper_modulos  
   
   Values ('BBDISP01', 'NS');
   Insert Into dbo.Rel_priv_usu      
   Values ('ADAM', 'BBDISP01');
   Insert Into dbo.rel_oper_menus    
   Values ('NS', 40, 6, 2, Null, 'BBDISP01');
   Insert Into dbo.Aut_operaciones   
   Values ('ADAM', 'BBDISP01',4);
-- 
   Insert Into dbo.parametros_oper
  (operacion, secuencia, tipo_campo, parametro)
   Select 'BBDISP01', 1,  5,   'dsn'      
   Union
   Select 'BBDISP01', 2,  3,   'userid'
   Union
   Select 'BBDISP01', 3,  4,   'password'
   Union
   Select 'BBDISP01', 4,  2,   'compania'

End;
Go
