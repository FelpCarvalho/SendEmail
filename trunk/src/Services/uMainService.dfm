object ServiceMain: TServiceMain
  DisplayName = 'ServiceMain'
  Height = 366
  Width = 712
  PixelsPerInch = 96
  object ACBrMail: TACBrMail
    Host = '127.0.0.1'
    Port = '25'
    SetSSL = False
    SetTLS = False
    Attempts = 3
    DefaultCharset = UTF_8
    IDECharset = CP1252
    Left = 72
    Top = 160
  end
  object qryTmp: TFDQuery
    Connection = cnx
    SQL.Strings = (
      'select * from log')
    Left = 328
    Top = 24
  end
  object cnx: TFDConnection
    Params.Strings = (
      'Database=F:\Projetos\RAD\11.0\SendEmail\db.db'
      'LockingMode=Normal'
      'DriverID=SQLite')
    LoginPrompt = False
    Left = 56
    Top = 16
  end
  object FDGUIxWaitCursor1: TFDGUIxWaitCursor
    Provider = 'Forms'
    Left = 176
    Top = 16
  end
  object FDPhysSQLiteDriverLink1: TFDPhysSQLiteDriverLink
    Left = 208
    Top = 112
  end
end
