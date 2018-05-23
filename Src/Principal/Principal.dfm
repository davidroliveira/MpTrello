object FrmPrincipal: TFrmPrincipal
  Left = 0
  Top = 0
  ClientHeight = 561
  ClientWidth = 709
  Caption = 'FrmPrincipal'
  OldCreateOrder = False
  MonitoredKeys.Keys = <>
  PixelsPerInch = 96
  TextHeight = 13
  object UniButton1: TUniButton
    Left = 58
    Top = 28
    Width = 75
    Height = 25
    Hint = ''
    Caption = 'UniButton1'
    TabOrder = 0
    OnClick = UniButton1Click
  end
  object UniDBGrid1: TUniDBGrid
    Left = 156
    Top = 86
    Width = 500
    Height = 160
    Hint = ''
    DataSource = DSQuadros
    LoadMask.Message = 'Loading data...'
    TabOrder = 1
  end
  object QryQuadros: TFDMemTable
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvSilentMode]
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvCheckRequired, uvAutoCommitUpdates]
    UpdateOptions.CheckRequired = False
    UpdateOptions.AutoCommitUpdates = True
    Left = 48
    Top = 82
  end
  object QryLista: TFDMemTable
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvSilentMode]
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvCheckRequired, uvAutoCommitUpdates]
    UpdateOptions.CheckRequired = False
    UpdateOptions.AutoCommitUpdates = True
    Left = 50
    Top = 196
  end
  object QryCards: TFDMemTable
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvSilentMode]
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvCheckRequired, uvAutoCommitUpdates]
    UpdateOptions.CheckRequired = False
    UpdateOptions.AutoCommitUpdates = True
    Left = 52
    Top = 278
  end
  object DSQuadros: TDataSource
    DataSet = QryQuadros
    Left = 98
    Top = 82
  end
end
