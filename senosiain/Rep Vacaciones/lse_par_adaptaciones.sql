USE [ADAMP]
GO

/****** Object:  Table [dbo].[lse_par_adaptaciones]    Script Date: 04/09/2025 11:18:19 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[lse_par_adaptaciones](
	[idParametro] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[IdModulo] [int] NULL,
	[compania] [char](4) NOT NULL,
	[cla_parametro] [char](30) NOT NULL,
	[descripcion] [varchar](250) NOT NULL,
	[num_entero] [int] NULL,
	[num_decimal] [decimal](19, 6) NULL,
	[alfanumerico] [varchar](250) NULL,
	[fecha_hora] [datetime] NULL,
	[Tipo] [varchar](15) NULL,
	[Query] [varchar](3000) NULL,
	[Control] [varchar](15) NULL,
	[CampoValor] [varchar](20) NULL,
	[CampoTexto] [varchar](20) NULL,
 CONSTRAINT [PK_lse_par_adaptaciones] PRIMARY KEY CLUSTERED 
(
	[idParametro] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO


