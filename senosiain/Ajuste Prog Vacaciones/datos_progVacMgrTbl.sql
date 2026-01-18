Declare
   @Jsondata              Nvarchar(Max),
   @PnEstatus             Integer      = 0,
   @PsMensaje             Varchar(250) = Null)

Begin
   Set @Jsondata = '[
    {
        "ciclolaboral": "20252026  ",
        "compania": "LS  ",
        "idEstatus": false,
        "tipo_nomina": "M2",
        "trabajadores": "16433     "
    },
    {
        "ciclolaboral": "20042005  ",
        "compania": "LS  ",
        "idEstatus": false,
        "tipo_nomina": "M2",
        "trabajadores": "17277     "
    },
    {
        "ciclolaboral": "20042005  ",
        "compania": "LS  ",
        "idEstatus": false,
        "tipo_nomina": "M2",
        "trabajadores": "17279     "
    },
    {
        "ciclolaboral": "20042005  ",
        "compania": "LS  ",
        "idEstatus": false,
        "tipo_nomina": "M2",
        "trabajadores": "17387     "
    },
    {
        "ciclolaboral": "20042005  ",
        "compania": "LS  ",
        "idEstatus": false,
        "tipo_nomina": "M2",
        "trabajadores": "17406     "
    },
    {
        "ciclolaboral": "20042005  ",
        "compania": "LS  ",
        "idEstatus": false,
        "tipo_nomina": "M2",
        "trabajadores": "17414     "
    },
    {
        "ciclolaboral": "20042005  ",
        "compania": "LS  ",
        "idEstatus": false,
        "tipo_nomina": "M2",
        "trabajadores": "17415     "
    },
    {
        "ciclolaboral": "20042005  ",
        "compania": "LS  ",
        "idEstatus": false,
        "tipo_nomina": "M2",
        "trabajadores": "17576     "
    },
    {
        "ciclolaboral": "20042005  ",
        "compania": "LS  ",
        "idEstatus": false,
        "tipo_nomina": "M2",
        "trabajadores": "17589     "
    },
    {
        "ciclolaboral": "20042005  ",
        "compania": "LS  ",
        "idEstatus": false,
        "tipo_nomina": "M2",
        "trabajadores": "17590     "
    },
    {
        "ciclolaboral": "20042005  ",
        "compania": "LS  ",
        "idEstatus": false,
        "tipo_nomina": "M2",
        "trabajadores": "17868     "
    },
    {
        "ciclolaboral": "20042005  ",
        "compania": "LS  ",
        "idEstatus": false,
        "tipo_nomina": "M2",
        "trabajadores": "17915     "
    },
    {
        "ciclolaboral": "20042005  ",
        "compania": "LS  ",
        "idEstatus": false,
        "tipo_nomina": "M2",
        "trabajadores": "17957     "
    },
    {
        "ciclolaboral": "20232024  ",
        "compania": "LS  ",
        "idEstatus": false,
        "tipo_nomina": "M2",
        "trabajadores": "18616     "
    },
    {
        "ciclolaboral": "20242025  ",
        "compania": "LS  ",
        "idEstatus": false,
        "tipo_nomina": "M2",
        "trabajadores": "21480     "
    },
    {
        "ciclolaboral": "20222023  ",
        "compania": "LS  ",
        "idEstatus": false,
        "tipo_nomina": "M1",
        "trabajadores": "29938     "
    },
    {
        "ciclolaboral": "20232024  ",
        "compania": "LS  ",
        "idEstatus": false,
        "tipo_nomina": "M1",
        "trabajadores": "29938     "
    },
    {
        "ciclolaboral": "20242025  ",
        "compania": "LS  ",
        "idEstatus": false,
        "tipo_nomina": "M1",
        "trabajadores": "29938     "
    },
    {
        "ciclolaboral": "20202021  ",
        "compania": "LS  ",
        "idEstatus": false,
        "tipo_nomina": "M1",
        "trabajadores": "46137     "
    },
    {
        "ciclolaboral": "20212022  ",
        "compania": "LS  ",
        "idEstatus": false,
        "tipo_nomina": "M1",
        "trabajadores": "46137     "
    },
    {
        "ciclolaboral": "20232024  ",
        "compania": "LS  ",
        "idEstatus": false,
        "tipo_nomina": "M1",
        "trabajadores": "46137     "
    },
    {
        "ciclolaboral": "20242025  ",
        "compania": "LS  ",
        "idEstatus": false,
        "tipo_nomina": "M1",
        "trabajadores": "46137     "
    },
    {
        "ciclolaboral": "20242025  ",
        "compania": "LS  ",
        "idEstatus": false,
        "tipo_nomina": "M1",
        "trabajadores": "61018     "
    },
    {
        "ciclolaboral": "20232024  ",
        "compania": "LS  ",
        "idEstatus": false,
        "tipo_nomina": "M1",
        "trabajadores": "61022     "
    },
    {
        "ciclolaboral": "20242025  ",
        "compania": "LS  ",
        "idEstatus": false,
        "tipo_nomina": "M1",
        "trabajadores": "61022     "
    },
    {
        "ciclolaboral": "20232024  ",
        "compania": "LS  ",
        "idEstatus": false,
        "tipo_nomina": "M1",
        "trabajadores": "61071     "
    },
    {
        "ciclolaboral": "20242025  ",
        "compania": "LS  ",
        "idEstatus": false,
        "tipo_nomina": "M1",
        "trabajadores": "61071     "
    },
    {
        "ciclolaboral": "20232024  ",
        "compania": "LS  ",
        "idEstatus": false,
        "tipo_nomina": "M1",
        "trabajadores": "61075     "
    },
    {
        "ciclolaboral": "20242025  ",
        "compania": "LS  ",
        "idEstatus": false,
        "tipo_nomina": "M1",
        "trabajadores": "61075     "
    },
    {
        "ciclolaboral": "20242025  ",
        "compania": "LS  ",
        "idEstatus": false,
        "tipo_nomina": "M1",
        "trabajadores": "61077     "
    },
    {
        "ciclolaboral": "20232024  ",
        "compania": "LS  ",
        "idEstatus": false,
        "tipo_nomina": "M1",
        "trabajadores": "61082     "
    },
    {
        "ciclolaboral": "20242025  ",
        "compania": "LS  ",
        "idEstatus": false,
        "tipo_nomina": "M1",
        "trabajadores": "61082     "
    },
    {
        "ciclolaboral": "20232024  ",
        "compania": "LS  ",
        "idEstatus": false,
        "tipo_nomina": "M1",
        "trabajadores": "61083     "
    },
    {
        "ciclolaboral": "20242025  ",
        "compania": "LS  ",
        "idEstatus": false,
        "tipo_nomina": "M1",
        "trabajadores": "61083     "
    },
    {
        "ciclolaboral": "20232024  ",
        "compania": "LS  ",
        "idEstatus": false,
        "tipo_nomina": "M1",
        "trabajadores": "61174     "
    },
    {
        "ciclolaboral": "20242025  ",
        "compania": "LS  ",
        "idEstatus": false,
        "tipo_nomina": "M1",
        "trabajadores": "61174     "
    },
    {
        "ciclolaboral": "20232024  ",
        "compania": "LS  ",
        "idEstatus": false,
        "tipo_nomina": "M1",
        "trabajadores": "61175     "
    },
    {
        "ciclolaboral": "20242025  ",
        "compania": "LS  ",
        "idEstatus": false,
        "tipo_nomina": "M1",
        "trabajadores": "61175     "
    },
    {
        "ciclolaboral": "20232024  ",
        "compania": "LS  ",
        "idEstatus": false,
        "tipo_nomina": "M1",
        "trabajadores": "61176     "
    },
    {
        "ciclolaboral": "20242025  ",
        "compania": "LS  ",
        "idEstatus": false,
        "tipo_nomina": "M1",
        "trabajadores": "61176     "
    },
    {
        "ciclolaboral": "20232024  ",
        "compania": "LS  ",
        "idEstatus": false,
        "tipo_nomina": "M1",
        "trabajadores": "61185     "
    },
    {
        "ciclolaboral": "20242025  ",
        "compania": "LS  ",
        "idEstatus": false,
        "tipo_nomina": "M1",
        "trabajadores": "61185     "
    },
    {
        "ciclolaboral": "20232024  ",
        "compania": "LS  ",
        "idEstatus": false,
        "tipo_nomina": "M1",
        "trabajadores": "61190     "
    },
    {
        "ciclolaboral": "20242025  ",
        "compania": "LS  ",
        "idEstatus": false,
        "tipo_nomina": "M1",
        "trabajadores": "61190     "
    },
    {
        "ciclolaboral": "20242025  ",
        "compania": "LS  ",
        "idEstatus": false,
        "tipo_nomina": "M1",
        "trabajadores": "61223     "
    },
    {
        "ciclolaboral": "20242025  ",
        "compania": "LS  ",
        "idEstatus": false,
        "tipo_nomina": "M1",
        "trabajadores": "61273     "
    },
    {
        "ciclolaboral": "20232024  ",
        "compania": "LS  ",
        "idEstatus": false,
        "tipo_nomina": "M1",
        "trabajadores": "61282     "
    },
    {
        "ciclolaboral": "20242025  ",
        "compania": "LS  ",
        "idEstatus": false,
        "tipo_nomina": "M1",
        "trabajadores": "61282     "
    },
    {
        "ciclolaboral": "20242025  ",
        "compania": "LS  ",
        "idEstatus": false,
        "tipo_nomina": "M1",
        "trabajadores": "61318     "
    },
    {
        "ciclolaboral": "20242025  ",
        "compania": "LS  ",
        "idEstatus": false,
        "tipo_nomina": "M1",
        "trabajadores": "61326     "
    },
    {
        "ciclolaboral": "20242025  ",
        "compania": "LS  ",
        "idEstatus": false,
        "tipo_nomina": "M1",
        "trabajadores": "61327     "
    },
    {
        "ciclolaboral": "20242025  ",
        "compania": "LS  ",
        "idEstatus": false,
        "tipo_nomina": "M1",
        "trabajadores": "61328     "
    },
    {
        "ciclolaboral": "20242025  ",
        "compania": "LS  ",
        "idEstatus": false,
        "tipo_nomina": "M1",
        "trabajadores": "61329     "
    },
    {
        "ciclolaboral": "20242025  ",
        "compania": "LS  ",
        "idEstatus": false,
        "tipo_nomina": "M1",
        "trabajadores": "61331     "
    },
    {
        "ciclolaboral": "20242025  ",
        "compania": "LS  ",
        "idEstatus": false,
        "tipo_nomina": "M1",
        "trabajadores": "61333     "
    },
    {
        "ciclolaboral": "20242025  ",
        "compania": "LS  ",
        "idEstatus": false,
        "tipo_nomina": "M1",
        "trabajadores": "61350     "
    },
    {
        "ciclolaboral": "20242025  ",
        "compania": "LS  ",
        "idEstatus": false,
        "tipo_nomina": "M1",
        "trabajadores": "61379     "
    },
    {
        "ciclolaboral": "20242025  ",
        "compania": "LS  ",
        "idEstatus": false,
        "tipo_nomina": "M1",
        "trabajadores": "61380     "
    },
    {
        "ciclolaboral": "20242025  ",
        "compania": "LS  ",
        "idEstatus": false,
        "tipo_nomina": "M1",
        "trabajadores": "61383     "
    },
    {
        "ciclolaboral": "20242025  ",
        "compania": "LS  ",
        "idEstatus": false,
        "tipo_nomina": "M1",
        "trabajadores": "61384     "
    },
    {
        "ciclolaboral": "20242025  ",
        "compania": "LS  ",
        "idEstatus": false,
        "tipo_nomina": "M1",
        "trabajadores": "61389     "
    },
    {
        "ciclolaboral": "20242025  ",
        "compania": "LS  ",
        "idEstatus": false,
        "tipo_nomina": "M1",
        "trabajadores": "61461     "
    },
    {
        "ciclolaboral": "20202021  ",
        "compania": "LS  ",
        "idEstatus": false,
        "tipo_nomina": "M1",
        "trabajadores": "63518     "
    },
    {
        "ciclolaboral": "20212022  ",
        "compania": "LS  ",
        "idEstatus": false,
        "tipo_nomina": "M1",
        "trabajadores": "63518     "
    },
    {
        "ciclolaboral": "20232024  ",
        "compania": "LS  ",
        "idEstatus": false,
        "tipo_nomina": "M1",
        "trabajadores": "63518     "
    },
    {
        "ciclolaboral": "20242025  ",
        "compania": "LS  ",
        "idEstatus": false,
        "tipo_nomina": "M1",
        "trabajadores": "63518     "
    },
    {
        "ciclolaboral": "20202021  ",
        "compania": "LS  ",
        "idEstatus": false,
        "tipo_nomina": "M1",
        "trabajadores": "65467     "
    },
    {
        "ciclolaboral": "20212022  ",
        "compania": "LS  ",
        "idEstatus": false,
        "tipo_nomina": "M1",
        "trabajadores": "65467     "
    },
    {
        "ciclolaboral": "20232024  ",
        "compania": "LS  ",
        "idEstatus": false,
        "tipo_nomina": "M1",
        "trabajadores": "65467     "
    },
    {
        "ciclolaboral": "20252026  ",
        "compania": "LS  ",
        "idEstatus": false,
        "tipo_nomina": "M1",
        "trabajadores": "65467     "
    },
    {
        "ciclolaboral": "20202021  ",
        "compania": "LS  ",
        "idEstatus": false,
        "tipo_nomina": "M1",
        "trabajadores": "65590     "
    },
    {
        "ciclolaboral": "20212022  ",
        "compania": "LS  ",
        "idEstatus": false,
        "tipo_nomina": "M1",
        "trabajadores": "65590     "
    },
    {
        "ciclolaboral": "20232024  ",
        "compania": "LS  ",
        "idEstatus": false,
        "tipo_nomina": "M1",
        "trabajadores": "65590     "
    },
    {
        "ciclolaboral": "20242025  ",
        "compania": "LS  ",
        "idEstatus": false,
        "tipo_nomina": "M1",
        "trabajadores": "65590     "
    },
    {
        "ciclolaboral": "20202021  ",
        "compania": "LS  ",
        "idEstatus": false,
        "tipo_nomina": "M1",
        "trabajadores": "65684     "
    },
    {
        "ciclolaboral": "20212022  ",
        "compania": "LS  ",
        "idEstatus": false,
        "tipo_nomina": "M1",
        "trabajadores": "65684     "
    },
    {
        "ciclolaboral": "20242025  ",
        "compania": "LS  ",
        "idEstatus": false,
        "tipo_nomina": "M1",
        "trabajadores": "65684     "
    },
    {
        "ciclolaboral": "20202021  ",
        "compania": "LS  ",
        "idEstatus": false,
        "tipo_nomina": "M1",
        "trabajadores": "65957     "
    },
    {
        "ciclolaboral": "20212022  ",
        "compania": "LS  ",
        "idEstatus": false,
        "tipo_nomina": "M1",
        "trabajadores": "65957     "
    },
    {
        "ciclolaboral": "20232024  ",
        "compania": "LS  ",
        "idEstatus": false,
        "tipo_nomina": "M1",
        "trabajadores": "65957     "
    },
    {
        "ciclolaboral": "20242025  ",
        "compania": "LS  ",
        "idEstatus": false,
        "tipo_nomina": "M1",
        "trabajadores": "65957     "
    },
    {
        "ciclolaboral": "20252026  ",
        "compania": "LS  ",
        "idEstatus": false,
        "tipo_nomina": "M1",
        "trabajadores": "65957     "
    },
    {
        "ciclolaboral": "20202021  ",
        "compania": "LS  ",
        "idEstatus": false,
        "tipo_nomina": "M1",
        "trabajadores": "66005     "
    },
    {
        "ciclolaboral": "20212022  ",
        "compania": "LS  ",
        "idEstatus": false,
        "tipo_nomina": "M1",
        "trabajadores": "66005     "
    },
    {
        "ciclolaboral": "20252026  ",
        "compania": "LS  ",
        "idEstatus": false,
        "tipo_nomina": "M1",
        "trabajadores": "66005     "
    },
    {
        "ciclolaboral": "20202021  ",
        "compania": "LS  ",
        "idEstatus": false,
        "tipo_nomina": "M1",
        "trabajadores": "66298     "
    },
    {
        "ciclolaboral": "20212022  ",
        "compania": "LS  ",
        "idEstatus": false,
        "tipo_nomina": "M1",
        "trabajadores": "66298     "
    },
    {
        "ciclolaboral": "20232024  ",
        "compania": "LS  ",
        "idEstatus": false,
        "tipo_nomina": "M1",
        "trabajadores": "66298     "
    },
    {
        "ciclolaboral": "20242025  ",
        "compania": "LS  ",
        "idEstatus": false,
        "tipo_nomina": "M1",
        "trabajadores": "66298     "
    },
    {
        "ciclolaboral": "20062007  ",
        "compania": "LS  ",
        "idEstatus": false,
        "tipo_nomina": "M1",
        "trabajadores": "66786     "
    },
    {
        "ciclolaboral": "20082009  ",
        "compania": "LS  ",
        "idEstatus": false,
        "tipo_nomina": "M1",
        "trabajadores": "66786     "
    },
    {
        "ciclolaboral": "20162017  ",
        "compania": "LS  ",
        "idEstatus": false,
        "tipo_nomina": "M1",
        "trabajadores": "66786     "
    },
    {
        "ciclolaboral": "20182019  ",
        "compania": "LS  ",
        "idEstatus": false,
        "tipo_nomina": "M1",
        "trabajadores": "66786     "
    },
    {
        "ciclolaboral": "20212022  ",
        "compania": "LS  ",
        "idEstatus": false,
        "tipo_nomina": "M1",
        "trabajadores": "66786     "
    },
    {
        "ciclolaboral": "20222023  ",
        "compania": "LS  ",
        "idEstatus": false,
        "tipo_nomina": "M1",
        "trabajadores": "66786     "
    },
    {
        "ciclolaboral": "20242025  ",
        "compania": "LS  ",
        "idEstatus": false,
        "tipo_nomina": "M1",
        "trabajadores": "66786     "
    },
    {
        "ciclolaboral": "20202021  ",
        "compania": "LS  ",
        "idEstatus": false,
        "tipo_nomina": "M1",
        "trabajadores": "66797     "
    },
    {
        "ciclolaboral": "20212022  ",
        "compania": "LS  ",
        "idEstatus": false,
        "tipo_nomina": "M1",
        "trabajadores": "66797     "
    },
    {
        "ciclolaboral": "20222023  ",
        "compania": "LS  ",
        "idEstatus": false,
        "tipo_nomina": "M1",
        "trabajadores": "66797     "
    },
    {
        "ciclolaboral": "20242025  ",
        "compania": "LS  ",
        "idEstatus": false,
        "tipo_nomina": "M1",
        "trabajadores": "66797     "
    },
    {
        "ciclolaboral": "20202021  ",
        "compania": "LS  ",
        "idEstatus": false,
        "tipo_nomina": "M1",
        "trabajadores": "66996     "
    },
    {
        "ciclolaboral": "20212022  ",
        "compania": "LS  ",
        "idEstatus": false,
        "tipo_nomina": "M1",
        "trabajadores": "66996     "
    },
    {
        "ciclolaboral": "20232024  ",
        "compania": "LS  ",
        "idEstatus": false,
        "tipo_nomina": "M1",
        "trabajadores": "66996     "
    },
    {
        "ciclolaboral": "20202021  ",
        "compania": "LS  ",
        "idEstatus": false,
        "tipo_nomina": "M1",
        "trabajadores": "67022     "
    },
    {
        "ciclolaboral": "20212022  ",
        "compania": "LS  ",
        "idEstatus": false,
        "tipo_nomina": "M1",
        "trabajadores": "67022     "
    },
    {
        "ciclolaboral": "20242025  ",
        "compania": "LS  ",
        "idEstatus": false,
        "tipo_nomina": "M1",
        "trabajadores": "67022     "
    },
    {
        "ciclolaboral": "20252026  ",
        "compania": "LS  ",
        "idEstatus": false,
        "tipo_nomina": "M1",
        "trabajadores": "67022     "
    },
    {
        "ciclolaboral": "20202021  ",
        "compania": "LS  ",
        "idEstatus": false,
        "tipo_nomina": "M1",
        "trabajadores": "67107     "
    },
    {
        "ciclolaboral": "20212022  ",
        "compania": "LS  ",
        "idEstatus": false,
        "tipo_nomina": "M1",
        "trabajadores": "67107     "
    },
    {
        "ciclolaboral": "20232024  ",
        "compania": "LS  ",
        "idEstatus": false,
        "tipo_nomina": "M1",
        "trabajadores": "67107     "
    },
    {
        "ciclolaboral": "20242025  ",
        "compania": "LS  ",
        "idEstatus": false,
        "tipo_nomina": "M1",
        "trabajadores": "67107     "
    },
    {
        "ciclolaboral": "20252026  ",
        "compania": "LS  ",
        "idEstatus": false,
        "tipo_nomina": "M1",
        "trabajadores": "67107     "
    },
    {
        "ciclolaboral": "20202021  ",
        "compania": "LS  ",
        "idEstatus": false,
        "tipo_nomina": "M1",
        "trabajadores": "67110     "
    },
    {
        "ciclolaboral": "20212022  ",
        "compania": "LS  ",
        "idEstatus": false,
        "tipo_nomina": "M1",
        "trabajadores": "67110     "
    },
    {
        "ciclolaboral": "20232024  ",
        "compania": "LS  ",
        "idEstatus": false,
        "tipo_nomina": "M1",
        "trabajadores": "67110     "
    },
    {
        "ciclolaboral": "20242025  ",
        "compania": "LS  ",
        "idEstatus": false,
        "tipo_nomina": "M1",
        "trabajadores": "67110     "
    },
    {
        "ciclolaboral": "20252026  ",
        "compania": "LS  ",
        "idEstatus": false,
        "tipo_nomina": "M1",
        "trabajadores": "67110     "
    },
    {
        "ciclolaboral": "20202021  ",
        "compania": "LS  ",
        "idEstatus": false,
        "tipo_nomina": "M1",
        "trabajadores": "67129     "
    },
    {
        "ciclolaboral": "20212022  ",
        "compania": "LS  ",
        "idEstatus": false,
        "tipo_nomina": "M1",
        "trabajadores": "67129     "
    },
    {
        "ciclolaboral": "20242025  ",
        "compania": "LS  ",
        "idEstatus": false,
        "tipo_nomina": "M1",
        "trabajadores": "67129     "
    },
    {
        "ciclolaboral": "20202021  ",
        "compania": "LS  ",
        "idEstatus": false,
        "tipo_nomina": "M1",
        "trabajadores": "67170     "
    },
    {
        "ciclolaboral": "20212022  ",
        "compania": "LS  ",
        "idEstatus": false,
        "tipo_nomina": "M1",
        "trabajadores": "67170     "
    },
    {
        "ciclolaboral": "20222023  ",
        "compania": "LS  ",
        "idEstatus": false,
        "tipo_nomina": "M1",
        "trabajadores": "67170     "
    },
    {
        "ciclolaboral": "20232024  ",
        "compania": "LS  ",
        "idEstatus": false,
        "tipo_nomina": "M1",
        "trabajadores": "67170     "
    },
    {
        "ciclolaboral": "20242025  ",
        "compania": "LS  ",
        "idEstatus": false,
        "tipo_nomina": "M1",
        "trabajadores": "67170     "
    },
    {
        "ciclolaboral": "20252026  ",
        "compania": "LS  ",
        "idEstatus": false,
        "tipo_nomina": "M1",
        "trabajadores": "67170     "
    },
    {
        "ciclolaboral": "20042005  ",
        "compania": "LS  ",
        "idEstatus": false,
        "tipo_nomina": "M2",
        "trabajadores": "67210     "
    },
    {
        "ciclolaboral": "20202021  ",
        "compania": "LS  ",
        "idEstatus": false,
        "tipo_nomina": "M1",
        "trabajadores": "67234     "
    },
    {
        "ciclolaboral": "20212022  ",
        "compania": "LS  ",
        "idEstatus": false,
        "tipo_nomina": "M1",
        "trabajadores": "67234     "
    },
    {
        "ciclolaboral": "20232024  ",
        "compania": "LS  ",
        "idEstatus": false,
        "tipo_nomina": "M1",
        "trabajadores": "67234     "
    },
    {
        "ciclolaboral": "20242025  ",
        "compania": "LS  ",
        "idEstatus": false,
        "tipo_nomina": "M1",
        "trabajadores": "67234     "
    },
    {
        "ciclolaboral": "20202021  ",
        "compania": "LS  ",
        "idEstatus": false,
        "tipo_nomina": "M1",
        "trabajadores": "67385     "
    },
    {
        "ciclolaboral": "20212022  ",
        "compania": "LS  ",
        "idEstatus": false,
        "tipo_nomina": "M1",
        "trabajadores": "67385     "
    },
    {
        "ciclolaboral": "20232024  ",
        "compania": "LS  ",
        "idEstatus": false,
        "tipo_nomina": "M1",
        "trabajadores": "67385     "
    },
    {
        "ciclolaboral": "20242025  ",
        "compania": "LS  ",
        "idEstatus": false,
        "tipo_nomina": "M1",
        "trabajadores": "67385     "
    },
    {
        "ciclolaboral": "20202021  ",
        "compania": "LS  ",
        "idEstatus": false,
        "tipo_nomina": "M1",
        "trabajadores": "67656     "
    },
    {
        "ciclolaboral": "20212022  ",
        "compania": "LS  ",
        "idEstatus": false,
        "tipo_nomina": "M1",
        "trabajadores": "67656     "
    },
    {
        "ciclolaboral": "20232024  ",
        "compania": "LS  ",
        "idEstatus": false,
        "tipo_nomina": "M1",
        "trabajadores": "67656     "
    },
    {
        "ciclolaboral": "20242025  ",
        "compania": "LS  ",
        "idEstatus": false,
        "tipo_nomina": "M1",
        "trabajadores": "67656     "
    },
    {
        "ciclolaboral": "20202021  ",
        "compania": "LS  ",
        "idEstatus": false,
        "tipo_nomina": "M1",
        "trabajadores": "67685     "
    },
    {
        "ciclolaboral": "20212022  ",
        "compania": "LS  ",
        "idEstatus": false,
        "tipo_nomina": "M1",
        "trabajadores": "67685     "
    },
    {
        "ciclolaboral": "20232024  ",
        "compania": "LS  ",
        "idEstatus": false,
        "tipo_nomina": "M1",
        "trabajadores": "67685     "
    },
    {
        "ciclolaboral": "20242025  ",
        "compania": "LS  ",
        "idEstatus": false,
        "tipo_nomina": "M1",
        "trabajadores": "67685     "
    },
    {
        "ciclolaboral": "20202021  ",
        "compania": "LS  ",
        "idEstatus": false,
        "tipo_nomina": "M1",
        "trabajadores": "67703     "
    },
    {
        "ciclolaboral": "20212022  ",
        "compania": "LS  ",
        "idEstatus": false,
        "tipo_nomina": "M1",
        "trabajadores": "67703     "
    },
    {
        "ciclolaboral": "20242025  ",
        "compania": "LS  ",
        "idEstatus": false,
        "tipo_nomina": "M1",
        "trabajadores": "67703     "
    },
    {
        "ciclolaboral": "20212022  ",
        "compania": "LS  ",
        "idEstatus": false,
        "tipo_nomina": "M1",
        "trabajadores": "67741     "
    },
    {
        "ciclolaboral": "20222023  ",
        "compania": "LS  ",
        "idEstatus": false,
        "tipo_nomina": "M1",
        "trabajadores": "67741     "
    },
    {
        "ciclolaboral": "20232024  ",
        "compania": "LS  ",
        "idEstatus": false,
        "tipo_nomina": "M1",
        "trabajadores": "67741     "
    },
    {
        "ciclolaboral": "20242025  ",
        "compania": "LS  ",
        "idEstatus": false,
        "tipo_nomina": "M1",
        "trabajadores": "67741     "
    },
    {
        "ciclolaboral": "20202021  ",
        "compania": "LS  ",
        "idEstatus": false,
        "tipo_nomina": "M1",
        "trabajadores": "67870     "
    },
    {
        "ciclolaboral": "20212022  ",
        "compania": "LS  ",
        "idEstatus": false,
        "tipo_nomina": "M1",
        "trabajadores": "67870     "
    },
    {
        "ciclolaboral": "20222023  ",
        "compania": "LS  ",
        "idEstatus": false,
        "tipo_nomina": "M1",
        "trabajadores": "67870     "
    },
    {
        "ciclolaboral": "20232024  ",
        "compania": "LS  ",
        "idEstatus": false,
        "tipo_nomina": "M1",
        "trabajadores": "67870     "
    },
    {
        "ciclolaboral": "20242025  ",
        "compania": "LS  ",
        "idEstatus": false,
        "tipo_nomina": "M1",
        "trabajadores": "67870     "
    },
    {
        "ciclolaboral": "20202021  ",
        "compania": "LS  ",
        "idEstatus": false,
        "tipo_nomina": "M1",
        "trabajadores": "67911     "
    },
    {
        "ciclolaboral": "20212022  ",
        "compania": "LS  ",
        "idEstatus": false,
        "tipo_nomina": "M1",
        "trabajadores": "67911     "
    },
    {
        "ciclolaboral": "20232024  ",
        "compania": "LS  ",
        "idEstatus": false,
        "tipo_nomina": "M1",
        "trabajadores": "67911     "
    },
    {
        "ciclolaboral": "20242025  ",
        "compania": "LS  ",
        "idEstatus": false,
        "tipo_nomina": "M1",
        "trabajadores": "67911     "
    },
    {
        "ciclolaboral": "20202021  ",
        "compania": "LS  ",
        "idEstatus": false,
        "tipo_nomina": "M1",
        "trabajadores": "68017     "
    },
    {
        "ciclolaboral": "20212022  ",
        "compania": "LS  ",
        "idEstatus": false,
        "tipo_nomina": "M1",
        "trabajadores": "68017     "
    },
    {
        "ciclolaboral": "20232024  ",
        "compania": "LS  ",
        "idEstatus": false,
        "tipo_nomina": "M1",
        "trabajadores": "68017     "
    },
    {
        "ciclolaboral": "20242025  ",
        "compania": "LS  ",
        "idEstatus": false,
        "tipo_nomina": "M1",
        "trabajadores": "68017     "
    },
    {
        "ciclolaboral": "20202021  ",
        "compania": "LS  ",
        "idEstatus": false,
        "tipo_nomina": "M1",
        "trabajadores": "68108     "
    },
    {
        "ciclolaboral": "20212022  ",
        "compania": "LS  ",
        "idEstatus": false,
        "tipo_nomina": "M1",
        "trabajadores": "68108     "
    },
    {
        "ciclolaboral": "20242025  ",
        "compania": "LS  ",
        "idEstatus": false,
        "tipo_nomina": "M1",
        "trabajadores": "68108     "
    },
    {
        "ciclolaboral": "20252026  ",
        "compania": "LS  ",
        "idEstatus": false,
        "tipo_nomina": "M1",
        "trabajadores": "68108     "
    },
    {
        "ciclolaboral": "20202021  ",
        "compania": "LS  ",
        "idEstatus": false,
        "tipo_nomina": "M1",
        "trabajadores": "68224     "
    },
    {
        "ciclolaboral": "20212022  ",
        "compania": "LS  ",
        "idEstatus": false,
        "tipo_nomina": "M1",
        "trabajadores": "68224     "
    },
    {
        "ciclolaboral": "20232024  ",
        "compania": "LS  ",
        "idEstatus": false,
        "tipo_nomina": "M1",
        "trabajadores": "68224     "
    },
    {
        "ciclolaboral": "20242025  ",
        "compania": "LS  ",
        "idEstatus": false,
        "tipo_nomina": "M1",
        "trabajadores": "68224     "
    },
    {
        "ciclolaboral": "20202021  ",
        "compania": "LS  ",
        "idEstatus": false,
        "tipo_nomina": "M1",
        "trabajadores": "68332     "
    },
    {
        "ciclolaboral": "20212022  ",
        "compania": "LS  ",
        "idEstatus": false,
        "tipo_nomina": "M1",
        "trabajadores": "68332     "
    },
    {
        "ciclolaboral": "20222023  ",
        "compania": "LS  ",
        "idEstatus": false,
        "tipo_nomina": "M1",
        "trabajadores": "68332     "
    },
    {
        "ciclolaboral": "20232024  ",
        "compania": "LS  ",
        "idEstatus": false,
        "tipo_nomina": "M1",
        "trabajadores": "68332     "
    },
    {
        "ciclolaboral": "20242025  ",
        "compania": "LS  ",
        "idEstatus": false,
        "tipo_nomina": "M1",
        "trabajadores": "68332     "
    },
    {
        "ciclolaboral": "20242025  ",
        "compania": "LS  ",
        "idEstatus": false,
        "tipo_nomina": "M1",
        "trabajadores": "69276     "
    },
    {
        "ciclolaboral": "20212022  ",
        "compania": "LS  ",
        "idEstatus": false,
        "tipo_nomina": "M1",
        "trabajadores": "69545     "
    },
    {
        "ciclolaboral": "20222023  ",
        "compania": "LS  ",
        "idEstatus": false,
        "tipo_nomina": "M1",
        "trabajadores": "69545     "
    },
    {
        "ciclolaboral": "20232024  ",
        "compania": "LS  ",
        "idEstatus": false,
        "tipo_nomina": "M1",
        "trabajadores": "69545     "
    },
    {
        "ciclolaboral": "20242025  ",
        "compania": "LS  ",
        "idEstatus": false,
        "tipo_nomina": "M1",
        "trabajadores": "69545     "
    },
    {
        "ciclolaboral": "20232024  ",
        "compania": "LS  ",
        "idEstatus": false,
        "tipo_nomina": "M1",
        "trabajadores": "69586     "
    },
    {
        "ciclolaboral": "20242025  ",
        "compania": "LS  ",
        "idEstatus": false,
        "tipo_nomina": "M1",
        "trabajadores": "69586     "
    },
    {
        "ciclolaboral": "20232024  ",
        "compania": "LS  ",
        "idEstatus": false,
        "tipo_nomina": "M1",
        "trabajadores": "69612     "
    },
    {
        "ciclolaboral": "20242025  ",
        "compania": "LS  ",
        "idEstatus": false,
        "tipo_nomina": "M1",
        "trabajadores": "69612     "
    },
    {
        "ciclolaboral": "20232024  ",
        "compania": "LS  ",
        "idEstatus": false,
        "tipo_nomina": "M1",
        "trabajadores": "69613     "
    },
    {
        "ciclolaboral": "20242025  ",
        "compania": "LS  ",
        "idEstatus": false,
        "tipo_nomina": "M1",
        "trabajadores": "69613     "
    },
    {
        "ciclolaboral": "20212022  ",
        "compania": "LS  ",
        "idEstatus": false,
        "tipo_nomina": "M1",
        "trabajadores": "69639     "
    },
    {
        "ciclolaboral": "20222023  ",
        "compania": "LS  ",
        "idEstatus": false,
        "tipo_nomina": "M1",
        "trabajadores": "69639     "
    },
    {
        "ciclolaboral": "20232024  ",
        "compania": "LS  ",
        "idEstatus": false,
        "tipo_nomina": "M1",
        "trabajadores": "69639     "
    },
    {
        "ciclolaboral": "20242025  ",
        "compania": "LS  ",
        "idEstatus": false,
        "tipo_nomina": "M1",
        "trabajadores": "69639     "
    },
    {
        "ciclolaboral": "20232024  ",
        "compania": "LS  ",
        "idEstatus": false,
        "tipo_nomina": "M1",
        "trabajadores": "69672     "
    },
    {
        "ciclolaboral": "20242025  ",
        "compania": "LS  ",
        "idEstatus": false,
        "tipo_nomina": "M1",
        "trabajadores": "69672     "
    },
    {
        "ciclolaboral": "20232024  ",
        "compania": "LS  ",
        "idEstatus": false,
        "tipo_nomina": "M1",
        "trabajadores": "69700     "
    },
    {
        "ciclolaboral": "20242025  ",
        "compania": "LS  ",
        "idEstatus": false,
        "tipo_nomina": "M1",
        "trabajadores": "69700     "
    },
    {
        "ciclolaboral": "20232024  ",
        "compania": "LS  ",
        "idEstatus": false,
        "tipo_nomina": "M1",
        "trabajadores": "69745     "
    },
    {
        "ciclolaboral": "20242025  ",
        "compania": "LS  ",
        "idEstatus": false,
        "tipo_nomina": "M1",
        "trabajadores": "69745     "
    },
    {
        "ciclolaboral": "20232024  ",
        "compania": "LS  ",
        "idEstatus": false,
        "tipo_nomina": "M1",
        "trabajadores": "69782     "
    },
    {
        "ciclolaboral": "20242025  ",
        "compania": "LS  ",
        "idEstatus": false,
        "tipo_nomina": "M1",
        "trabajadores": "69782     "
    },
    {
        "ciclolaboral": "20252026  ",
        "compania": "LS  ",
        "idEstatus": false,
        "tipo_nomina": "M1",
        "trabajadores": "69782     "
    },
    {
        "ciclolaboral": "20232024  ",
        "compania": "LS  ",
        "idEstatus": false,
        "tipo_nomina": "M1",
        "trabajadores": "69879     "
    },
    {
        "ciclolaboral": "20242025  ",
        "compania": "LS  ",
        "idEstatus": false,
        "tipo_nomina": "M1",
        "trabajadores": "69879     "
    },
    {
        "ciclolaboral": "20242025  ",
        "compania": "LS  ",
        "idEstatus": false,
        "tipo_nomina": "M1",
        "trabajadores": "69881     "
    },
    {
        "ciclolaboral": "20232024  ",
        "compania": "LS  ",
        "idEstatus": false,
        "tipo_nomina": "M1",
        "trabajadores": "69899     "
    },
    {
        "ciclolaboral": "20242025  ",
        "compania": "LS  ",
        "idEstatus": false,
        "tipo_nomina": "M1",
        "trabajadores": "69899     "
    },
    {
        "ciclolaboral": "20202021  ",
        "compania": "LS  ",
        "idEstatus": false,
        "tipo_nomina": "M1",
        "trabajadores": "77065     "
    },
    {
        "ciclolaboral": "20212022  ",
        "compania": "LS  ",
        "idEstatus": false,
        "tipo_nomina": "M1",
        "trabajadores": "77065     "
    },
    {
        "ciclolaboral": "20232024  ",
        "compania": "LS  ",
        "idEstatus": false,
        "tipo_nomina": "M1",
        "trabajadores": "77065     "
    },
    {
        "ciclolaboral": "20242025  ",
        "compania": "LS  ",
        "idEstatus": false,
        "tipo_nomina": "M1",
        "trabajadores": "77065     "
    },
    {
        "ciclolaboral": "20042005  ",
        "compania": "LS  ",
        "idEstatus": false,
        "tipo_nomina": "M2",
        "trabajadores": "77357     "
    },
    {
        "ciclolaboral": "20042005  ",
        "compania": "LS  ",
        "idEstatus": false,
        "tipo_nomina": "M2",
        "trabajadores": "77715     "
    },
    {
        "ciclolaboral": "20262027  ",
        "compania": "LS  ",
        "idEstatus": false,
        "tipo_nomina": "M2",
        "trabajadores": "79813     "
    },
    {
        "ciclolaboral": "20082009  ",
        "compania": "LS  ",
        "idEstatus": false,
        "tipo_nomina": "MC",
        "trabajadores": "88861     "
    },
    {
        "ciclolaboral": "20232024  ",
        "compania": "LS  ",
        "idEstatus": false,
        "tipo_nomina": "MC",
        "trabajadores": "99998     "
    }
]';
   
   
   Execute dbo.sp_prog_vac_mgr @Jsondata, @PnEstatus Output, @PsMensaje Output
   Select  @PnEstatus, @PsMensaje;
   Return
End
Go
