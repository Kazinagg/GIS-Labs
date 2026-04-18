object dmBase: TdmBase
  Height = 749
  Width = 1180
  PixelsPerInch = 168
  object FDTable: TFDTable
    Connection = FDConnection
    Left = 70
    Top = 322
  end
  object FDQuery: TFDQuery
    Connection = FDConnection
    Left = 210
    Top = 322
  end
  object FDConnection: TFDConnection
    Params.Strings = (
      'DriverID=SQLite')
    LoginPrompt = False
    Transaction = FDTransaction
    Left = 252
    Top = 56
  end
  object FDPhysPgDriverLink: TFDPhysPgDriverLink
    VendorLib = 'C:\Program Files (x86)\PostgreSQL\9.5\bin\libpq.dll'
    Left = 70
    Top = 182
  end
  object FDGUIxWaitCursor: TFDGUIxWaitCursor
    Provider = 'FMX'
    Left = 252
    Top = 182
  end
  object DataSource: TDataSource
    DataSet = FDTable
    Left = 812
    Top = 70
  end
  object SQLQuery: TSQLQuery
    Params = <>
    Left = 756
    Top = 546
  end
  object SQLTable: TSQLTable
    Left = 630
    Top = 546
  end
  object SQLConnection: TSQLConnection
    Left = 896
    Top = 546
  end
  object SQLDataSet: TSQLDataSet
    Params = <>
    Left = 1036
    Top = 546
  end
  object FDManager: TFDManager
    ConnectionDefFileName = 'D:\Gexoblock\Data\GXConnections.ini'
    FormatOptions.AssignedValues = [fvMapRules]
    FormatOptions.OwnMapRules = True
    FormatOptions.MapRules = <>
    Active = True
    Left = 56
    Top = 56
  end
  object FDTransaction: TFDTransaction
    Connection = FDConnection
    Left = 434
    Top = 56
  end
  object FDCommand: TFDCommand
    Connection = FDConnection
    Left = 224
    Top = 476
  end
  object FDMemTable: TFDMemTable
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvSilentMode]
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvCheckRequired, uvAutoCommitUpdates]
    UpdateOptions.CheckRequired = False
    UpdateOptions.AutoCommitUpdates = True
    Left = 336
    Top = 322
  end
  object FDLocalSQL: TFDLocalSQL
    Left = 70
    Top = 630
  end
  object FDTableAdapter: TFDTableAdapter
    Left = 392
    Top = 476
  end
  object FDBatchMove: TFDBatchMove
    Mappings = <>
    LogFileName = 'Data.log'
    Left = 84
    Top = 476
  end
  object ClientDataSet: TClientDataSet
    Aggregates = <>
    MasterSource = DataSource
    PacketRecords = 0
    Params = <>
    Left = 966
    Top = 70
  end
  object FDPhysSQLiteDriverLink: TFDPhysSQLiteDriverLink
    Left = 462
    Top = 182
  end
end
