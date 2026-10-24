Use Adam
Go

Truncate table dbo.catEstadosSATTbl

Insert dbo.catEstadosSATTbl
(idPais, idEstado, descripcion, idEstatus, fechaAct, ipAct, macAddressAct)
Select N'MEX  ', N'BCN', N'Baja California',     1, Getdate(), dbo.Fn_BuscaDireccionIp(), dbo.Fn_Busca_DireccionMac()
Union
Select N'MEX  ', N'BCS', N'Baja California Sur', 1, Getdate(), dbo.Fn_BuscaDireccionIp(), dbo.Fn_Busca_DireccionMac()
Union
Select N'MEX  ', N'CAM', N'Campeche',            1, Getdate(), dbo.Fn_BuscaDireccionIp(), dbo.Fn_Busca_DireccionMac()
Union
Select N'MEX  ', N'CHH', N'Chihuahua',           1, Getdate(), dbo.Fn_BuscaDireccionIp(), dbo.Fn_Busca_DireccionMac()
Union
Select N'MEX  ', N'CHP', N'Chiapas',             1, Getdate(), dbo.Fn_BuscaDireccionIp(), dbo.Fn_Busca_DireccionMac()
Union
Select N'MEX  ', N'COA', N'Coahuila',            1, Getdate(), dbo.Fn_BuscaDireccionIp(), dbo.Fn_Busca_DireccionMac()
Union
Select N'MEX  ', N'COL', N'Colima',              1, Getdate(), dbo.Fn_BuscaDireccionIp(), dbo.Fn_Busca_DireccionMac()
Union
Select N'MEX  ', N'DIF', N'Ciudad de México',    1, Getdate(), dbo.Fn_BuscaDireccionIp(), dbo.Fn_Busca_DireccionMac()
Union
Select N'MEX  ', N'DUR', N'Durango',             1, Getdate(), dbo.Fn_BuscaDireccionIp(), dbo.Fn_Busca_DireccionMac()
Union
Select N'MEX  ', N'GRO', N'Guerrero',            1, Getdate(), dbo.Fn_BuscaDireccionIp(), dbo.Fn_Busca_DireccionMac()
Union
Select N'MEX  ', N'GUA', N'Guanajuato',          1, Getdate(), dbo.Fn_BuscaDireccionIp(), dbo.Fn_Busca_DireccionMac()
Union
Select N'MEX  ', N'HID', N'Hidalgo',             1, Getdate(), dbo.Fn_BuscaDireccionIp(), dbo.Fn_Busca_DireccionMac()
Union
Select N'MEX  ', N'JAL', N'Jalisco',             1, Getdate(), dbo.Fn_BuscaDireccionIp(), dbo.Fn_Busca_DireccionMac()
Union
Select N'MEX  ', N'MEX', N'Estado de México',    1, Getdate(), dbo.Fn_BuscaDireccionIp(), dbo.Fn_Busca_DireccionMac()
Union
Select N'MEX  ', N'MIC', N'Michoacán',           1, Getdate(), dbo.Fn_BuscaDireccionIp(), dbo.Fn_Busca_DireccionMac()
Union
Select N'MEX  ', N'MOR', N'Morelos',             1, Getdate(), dbo.Fn_BuscaDireccionIp(), dbo.Fn_Busca_DireccionMac()
Union
Select N'MEX  ', N'NAY', N'Nayarit',             1, Getdate(), dbo.Fn_BuscaDireccionIp(), dbo.Fn_Busca_DireccionMac()
Union
Select N'MEX  ', N'NLE', N'Nuevo León',          1, Getdate(), dbo.Fn_BuscaDireccionIp(), dbo.Fn_Busca_DireccionMac()
Union
Select N'MEX  ', N'OAX', N'Oaxaca',              1, Getdate(), dbo.Fn_BuscaDireccionIp(), dbo.Fn_Busca_DireccionMac()
Union
Select N'MEX  ', N'PUE', N'Puebla',              1, Getdate(), dbo.Fn_BuscaDireccionIp(), dbo.Fn_Busca_DireccionMac()
Union
Select N'MEX  ', N'QUE', N'Querétaro',           1, Getdate(), dbo.Fn_BuscaDireccionIp(), dbo.Fn_Busca_DireccionMac()
Union
Select N'MEX  ', N'ROO', N'Quintana Roo',        1, Getdate(), dbo.Fn_BuscaDireccionIp(), dbo.Fn_Busca_DireccionMac()
Union
Select N'MEX  ', N'SIN', N'Sinaloa',             1, Getdate(), dbo.Fn_BuscaDireccionIp(), dbo.Fn_Busca_DireccionMac()
Union
Select N'MEX  ', N'SLP', N'San Luis Potosí',     1, Getdate(), dbo.Fn_BuscaDireccionIp(), dbo.Fn_Busca_DireccionMac()
Union
Select N'MEX  ', N'SON', N'Sonora',              1, Getdate(), dbo.Fn_BuscaDireccionIp(), dbo.Fn_Busca_DireccionMac()
Union
Select N'MEX  ', N'TAB', N'Tabasco',             1, Getdate(), dbo.Fn_BuscaDireccionIp(), dbo.Fn_Busca_DireccionMac()
Union
Select N'MEX  ', N'TAM', N'Tamaulipas',          1, Getdate(), dbo.Fn_BuscaDireccionIp(), dbo.Fn_Busca_DireccionMac()
Union
Select N'MEX  ', N'TLA', N'Tlaxcala',            1, Getdate(), dbo.Fn_BuscaDireccionIp(), dbo.Fn_Busca_DireccionMac()
Union
Select N'MEX  ', N'VER', N'Veracruz',            1, Getdate(), dbo.Fn_BuscaDireccionIp(), dbo.Fn_Busca_DireccionMac()
Union
Select N'MEX  ', N'YUC', N'Yucatán',             1, Getdate(), dbo.Fn_BuscaDireccionIp(), dbo.Fn_Busca_DireccionMac()
Union
Select N'MEX  ', N'ZAC', N'Zacatecas',           1, Getdate(), dbo.Fn_BuscaDireccionIp(), dbo.Fn_Busca_DireccionMac()
