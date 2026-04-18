inherited fmEditDeleteField: TfmEditDeleteField
  Left = 350
  Top = 214
  HelpContext = 231
  Caption = 'Delete Field'
  ClientHeight = 288
  ClientWidth = 383
  StyleElements = [seFont, seClient, seBorder]
  ExplicitWidth = 399
  ExplicitHeight = 327
  TextHeight = 16
  inherited PanelTop: TPanel
    Width = 383
    Height = 1
    StyleElements = [seFont, seClient, seBorder]
    ExplicitWidth = 383
    ExplicitHeight = 1
  end
  inherited PanelMiddle: TPanel
    Top = 1
    Width = 383
    Height = 239
    StyleElements = [seFont, seClient, seBorder]
    ExplicitTop = 1
    ExplicitWidth = 383
    ExplicitHeight = 239
    object CheckListBoxFields: TCheckListBox
      Left = 32
      Top = 16
      Width = 313
      Height = 209
      TabOrder = 0
    end
  end
  inherited PanelBottom: TPanel
    Top = 240
    Width = 383
    StyleElements = [seFont, seClient, seBorder]
    ExplicitTop = 240
    ExplicitWidth = 383
    inherited ButtonOK: TButton
      Left = 21
      ExplicitLeft = 21
    end
    inherited ButtonCancel: TButton
      Left = 142
      ExplicitLeft = 142
    end
    inherited ButtonHelp: TButton
      Left = 264
      ExplicitLeft = 264
    end
  end
end
