inherited fmEditMemoField: TfmEditMemoField
  Left = 236
  Top = 236
  HelpContext = 200
  Caption = 'Edit Field'
  ClientHeight = 292
  ClientWidth = 446
  StyleElements = [seFont, seClient, seBorder]
  ExplicitWidth = 462
  ExplicitHeight = 331
  TextHeight = 16
  inherited PanelTop: TPanel
    Width = 446
    Height = 1
    StyleElements = [seFont, seClient, seBorder]
    ExplicitWidth = 446
    ExplicitHeight = 1
  end
  inherited PanelMiddle: TPanel
    Top = 1
    Width = 446
    Height = 243
    StyleElements = [seFont, seClient, seBorder]
    ExplicitTop = 1
    ExplicitWidth = 446
    ExplicitHeight = 243
    object DBMemo: TDBMemo
      Left = 1
      Top = 1
      Width = 444
      Height = 241
      Align = alClient
      ScrollBars = ssBoth
      TabOrder = 0
    end
  end
  inherited PanelBottom: TPanel
    Top = 244
    Width = 446
    StyleElements = [seFont, seClient, seBorder]
    ExplicitTop = 244
    ExplicitWidth = 446
    inherited ButtonOK: TButton
      Left = 124
      ExplicitLeft = 124
    end
    inherited ButtonCancel: TButton
      Left = 229
      ExplicitLeft = 229
    end
    inherited ButtonHelp: TButton
      Left = 335
      ExplicitLeft = 335
    end
  end
end
