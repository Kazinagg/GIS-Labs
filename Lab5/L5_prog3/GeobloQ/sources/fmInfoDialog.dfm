inherited frmInfoDialog: TfrmInfoDialog
  Left = 317
  Top = 194
  HelpContext = 115
  BorderIcons = [biSystemMenu, biMinimize, biMaximize]
  Caption = 'Information'
  ClientHeight = 302
  ClientWidth = 500
  StyleElements = [seFont, seClient, seBorder]
  OnClose = FormClose
  ExplicitWidth = 516
  ExplicitHeight = 341
  TextHeight = 16
  inherited PanelTop: TPanel
    Width = 500
    Height = 1
    StyleElements = [seFont, seClient, seBorder]
    ExplicitWidth = 492
    ExplicitHeight = 1
  end
  inherited PanelMiddle: TPanel
    Top = 1
    Width = 500
    Height = 253
    StyleElements = [seFont, seClient, seBorder]
    ExplicitTop = 1
    ExplicitWidth = 492
    ExplicitHeight = 228
    object RichEdit: TRichEdit
      Left = 1
      Top = 1
      Width = 498
      Height = 251
      Align = alClient
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      ScrollBars = ssBoth
      TabOrder = 0
      ExplicitWidth = 490
      ExplicitHeight = 226
    end
  end
  inherited PanelBottom: TPanel
    Top = 254
    Width = 500
    StyleElements = [seFont, seClient, seBorder]
    ExplicitTop = 229
    ExplicitWidth = 492
    inherited ButtonOK: TButton
      Left = 131
      ExplicitLeft = 123
    end
    inherited ButtonCancel: TButton
      Left = 251
      ExplicitLeft = 243
    end
    inherited ButtonHelp: TButton
      Left = 373
      HelpContext = 115
      ExplicitLeft = 365
    end
  end
end
