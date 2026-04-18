object FormBlankDialog: TFormBlankDialog
  Left = 308
  Top = 155
  BorderIcons = [biSystemMenu]
  BorderStyle = bsDialog
  ClientHeight = 448
  ClientWidth = 567
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Position = poScreenCenter
  Scaled = False
  TextHeight = 16
  object PanelTop: TPanel
    Left = 0
    Top = 0
    Width = 567
    Height = 41
    Align = alTop
    TabOrder = 0
    ExplicitWidth = 559
  end
  object PanelMiddle: TPanel
    Left = 0
    Top = 41
    Width = 567
    Height = 359
    Align = alClient
    TabOrder = 1
    ExplicitWidth = 559
    ExplicitHeight = 334
  end
  object PanelBottom: TPanel
    Left = 0
    Top = 400
    Width = 567
    Height = 48
    Align = alBottom
    TabOrder = 2
    ExplicitTop = 375
    ExplicitWidth = 559
    DesignSize = (
      567
      48)
    object ButtonOK: TButton
      Left = 158
      Top = 10
      Width = 98
      Height = 31
      Anchors = [akTop, akRight]
      Caption = 'OK'
      ModalResult = 1
      TabOrder = 0
      ExplicitLeft = 150
    end
    object ButtonCancel: TButton
      Left = 278
      Top = 10
      Width = 99
      Height = 31
      Anchors = [akTop, akRight]
      Cancel = True
      Caption = 'Cancel'
      ModalResult = 2
      TabOrder = 1
      ExplicitLeft = 270
    end
    object ButtonHelp: TButton
      Left = 400
      Top = 10
      Width = 96
      Height = 31
      Anchors = [akTop, akRight]
      Caption = '&Help'
      TabOrder = 2
      OnClick = ButtonHelpClick
      ExplicitLeft = 392
    end
  end
end
