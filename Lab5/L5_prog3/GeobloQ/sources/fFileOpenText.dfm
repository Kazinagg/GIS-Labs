inherited fmFileOpenText: TfmFileOpenText
  Left = 349
  Top = 204
  HelpContext = 115
  BorderIcons = [biSystemMenu, biMinimize, biMaximize]
  BorderStyle = bsSizeable
  Caption = 'Text'
  ClientHeight = 385
  ClientWidth = 565
  FormStyle = fsMDIChild
  Visible = True
  StyleElements = [seFont, seClient, seBorder]
  OnClose = FormClose
  ExplicitWidth = 581
  ExplicitHeight = 424
  TextHeight = 16
  inherited PanelTop: TPanel
    Width = 565
    Height = 1
    StyleElements = [seFont, seClient, seBorder]
    ExplicitWidth = 557
    ExplicitHeight = 1
  end
  inherited PanelMiddle: TPanel
    Top = 1
    Width = 565
    Height = 336
    StyleElements = [seFont, seClient, seBorder]
    ExplicitTop = 1
    ExplicitWidth = 557
    ExplicitHeight = 311
    object RichEdit: TRichEdit
      Left = 1
      Top = 1
      Width = 555
      Height = 309
      Align = alClient
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      ScrollBars = ssBoth
      TabOrder = 0
    end
  end
  inherited PanelBottom: TPanel
    Top = 337
    Width = 565
    StyleElements = [seFont, seClient, seBorder]
    ExplicitTop = 312
    ExplicitWidth = 557
    DesignSize = (
      565
      48)
    inherited ButtonOK: TButton
      OnClick = ButtonOKClick
      ExplicitLeft = 182
    end
    inherited ButtonCancel: TButton
      OnClick = ButtonCancelClick
      ExplicitLeft = 302
    end
    inherited ButtonHelp: TButton
      HelpContext = 115
      ExplicitLeft = 424
    end
  end
end
