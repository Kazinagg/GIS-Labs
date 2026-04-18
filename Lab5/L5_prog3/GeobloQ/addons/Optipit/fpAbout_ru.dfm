object FormAbout: TFormAbout
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  ClientHeight = 292
  ClientWidth = 415
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  Position = poMainFormCenter
  TextHeight = 13
  object PanelTop: TPanel
    Left = 0
    Top = 0
    Width = 415
    Height = 67
    Align = alTop
    Caption = 'OptiPit'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -27
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 0
    ExplicitWidth = 407
  end
  object PanelBottom: TPanel
    Left = 0
    Top = 251
    Width = 415
    Height = 41
    Align = alBottom
    TabOrder = 1
    ExplicitTop = 226
    ExplicitWidth = 407
    object Button1: TButton
      Left = 312
      Top = 6
      Width = 75
      Height = 25
      Caption = 'OK'
      ModalResult = 1
      TabOrder = 0
    end
  end
  object PanelMiddle: TPanel
    Left = 0
    Top = 67
    Width = 415
    Height = 184
    Align = alClient
    TabOrder = 2
    ExplicitWidth = 407
    ExplicitHeight = 159
    object Label1: TLabel
      Left = 25
      Top = 32
      Width = 370
      Height = 23
      Caption = #1054#1087#1090#1080#1084#1080#1079#1072#1094#1080#1103' '#1080#1079#1074#1083#1077#1095#1077#1085#1080#1103' '#1073#1083#1086#1082#1086#1074' '#1082#1072#1088#1100#1077#1088#1072
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -19
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object Label2: TLabel
      Left = 176
      Top = 72
      Width = 63
      Height = 16
      Caption = #1074#1077#1088#1089#1080#1103' 1.0'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object Label3: TLabel
      Left = 152
      Top = 126
      Width = 93
      Height = 16
      Caption = 'Copyright '#169' vPv'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object Label4: TLabel
      Left = 187
      Top = 165
      Width = 55
      Height = 13
      Caption = '2016, 2026'
    end
  end
end
