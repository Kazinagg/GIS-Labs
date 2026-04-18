object fmMain: TfmMain
  Left = 266
  Top = 194
  Margins.Left = 5
  Margins.Top = 5
  Margins.Right = 5
  Margins.Bottom = 5
  BorderStyle = bsDialog
  Caption = 'Periodic Table'
  ClientHeight = 840
  ClientWidth = 1153
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -19
  Font.Name = 'Tahoma'
  Font.Style = []
  Position = poMainFormCenter
  OnActivate = FormActivate
  OnCreate = FormCreate
  PixelsPerInch = 168
  TextHeight = 23
  object PanelTable: TPanel
    Left = 0
    Top = 0
    Width = 863
    Height = 840
    Margins.Left = 5
    Margins.Top = 5
    Margins.Right = 5
    Margins.Bottom = 5
    Align = alClient
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -21
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 0
    object SpeedButtonUn: TSpeedButton
      Tag = 110
      Left = 422
      Top = 455
      Width = 47
      Height = 47
      Margins.Left = 5
      Margins.Top = 5
      Margins.Right = 5
      Margins.Bottom = 5
      GroupIndex = 1
      Caption = 'Un'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clPurple
      Font.Height = -21
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      OnClick = SpeedButtonElementClick
    end
    object SpeedButtonH: TSpeedButton
      Tag = 1
      Left = 12
      Top = 103
      Width = 48
      Height = 48
      Margins.Left = 5
      Margins.Top = 5
      Margins.Right = 5
      Margins.Bottom = 5
      GroupIndex = 1
      Caption = 'H'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clRed
      Font.Height = -21
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      Transparent = False
      OnClick = SpeedButtonElementClick
    end
    object LabelIA: TLabel
      Left = 23
      Top = 68
      Width = 16
      Height = 25
      Margins.Left = 5
      Margins.Top = 5
      Margins.Right = 5
      Margins.Bottom = 5
      Caption = 'Ia'
    end
    object LabelIIA: TLabel
      Left = 68
      Top = 68
      Width = 21
      Height = 25
      Margins.Left = 5
      Margins.Top = 5
      Margins.Right = 5
      Margins.Bottom = 5
      Caption = 'IIa'
    end
    object LabelIIIB: TLabel
      Left = 109
      Top = 70
      Width = 26
      Height = 25
      Margins.Left = 5
      Margins.Top = 5
      Margins.Right = 5
      Margins.Bottom = 5
      Caption = 'IIIb'
    end
    object LabelIIIA: TLabel
      Left = 558
      Top = 68
      Width = 26
      Height = 25
      Margins.Left = 5
      Margins.Top = 5
      Margins.Right = 5
      Margins.Bottom = 5
      Caption = 'IIIa'
    end
    object LabelVIIIA: TLabel
      Left = 786
      Top = 68
      Width = 40
      Height = 25
      Margins.Left = 5
      Margins.Top = 5
      Margins.Right = 5
      Margins.Bottom = 5
      Caption = 'VIIIa'
    end
    object LabelVIIA: TLabel
      Left = 740
      Top = 68
      Width = 35
      Height = 25
      Margins.Left = 5
      Margins.Top = 5
      Margins.Right = 5
      Margins.Bottom = 5
      Caption = 'VIIa'
    end
    object LabelLanthanide: TLabel
      Left = 23
      Top = 467
      Width = 97
      Height = 25
      Margins.Left = 5
      Margins.Top = 5
      Margins.Right = 5
      Margins.Bottom = 5
      Caption = 'Lanthanide'
      Color = clBtnFace
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -21
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentColor = False
      ParentFont = False
    end
    object LabelActinide: TLabel
      Left = 23
      Top = 513
      Width = 70
      Height = 25
      Margins.Left = 5
      Margins.Top = 5
      Margins.Right = 5
      Margins.Bottom = 5
      Caption = 'Actinide'
    end
    object LabelIVB: TLabel
      Left = 154
      Top = 70
      Width = 30
      Height = 25
      Margins.Left = 5
      Margins.Top = 5
      Margins.Right = 5
      Margins.Bottom = 5
      Caption = 'IVb'
    end
    object LabelVB: TLabel
      Left = 200
      Top = 70
      Width = 25
      Height = 25
      Margins.Left = 5
      Margins.Top = 5
      Margins.Right = 5
      Margins.Bottom = 5
      Caption = 'Vb'
    end
    object Label1VIB: TLabel
      Left = 245
      Top = 70
      Width = 30
      Height = 25
      Margins.Left = 5
      Margins.Top = 5
      Margins.Right = 5
      Margins.Bottom = 5
      Caption = 'VIb'
    end
    object LabelVIIB: TLabel
      Left = 291
      Top = 70
      Width = 35
      Height = 25
      Margins.Left = 5
      Margins.Top = 5
      Margins.Right = 5
      Margins.Bottom = 5
      Caption = 'VIIb'
    end
    object LabelIIB: TLabel
      Left = 518
      Top = 70
      Width = 21
      Height = 25
      Margins.Left = 5
      Margins.Top = 5
      Margins.Right = 5
      Margins.Bottom = 5
      Caption = 'IIb'
    end
    object Label1IB: TLabel
      Left = 473
      Top = 70
      Width = 16
      Height = 25
      Margins.Left = 5
      Margins.Top = 5
      Margins.Right = 5
      Margins.Bottom = 5
      Caption = 'Ib'
    end
    object LabelIVA: TLabel
      Left = 604
      Top = 68
      Width = 30
      Height = 25
      Margins.Left = 5
      Margins.Top = 5
      Margins.Right = 5
      Margins.Bottom = 5
      Caption = 'IVa'
    end
    object LabelVA: TLabel
      Left = 649
      Top = 68
      Width = 25
      Height = 25
      Margins.Left = 5
      Margins.Top = 5
      Margins.Right = 5
      Margins.Bottom = 5
      Caption = 'Va'
    end
    object LabelVIA: TLabel
      Left = 695
      Top = 68
      Width = 30
      Height = 25
      Margins.Left = 5
      Margins.Top = 5
      Margins.Right = 5
      Margins.Bottom = 5
      Caption = 'VIa'
    end
    object SpeedButtonLi: TSpeedButton
      Tag = 3
      Left = 12
      Top = 149
      Width = 48
      Height = 47
      Margins.Left = 5
      Margins.Top = 5
      Margins.Right = 5
      Margins.Bottom = 5
      GroupIndex = 1
      Caption = 'Li'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clAqua
      Font.Height = -21
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      OnClick = SpeedButtonElementClick
    end
    object SpeedButtonNa: TSpeedButton
      Tag = 11
      Left = 12
      Top = 194
      Width = 48
      Height = 48
      Margins.Left = 5
      Margins.Top = 5
      Margins.Right = 5
      Margins.Bottom = 5
      GroupIndex = 1
      Caption = 'Na'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clAqua
      Font.Height = -21
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      OnClick = SpeedButtonElementClick
    end
    object SpeedButtonK: TSpeedButton
      Tag = 19
      Left = 12
      Top = 240
      Width = 48
      Height = 47
      Margins.Left = 5
      Margins.Top = 5
      Margins.Right = 5
      Margins.Bottom = 5
      GroupIndex = 1
      Caption = 'K'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clAqua
      Font.Height = -21
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      OnClick = SpeedButtonElementClick
    end
    object SpeedButtonRb: TSpeedButton
      Tag = 37
      Left = 12
      Top = 285
      Width = 48
      Height = 48
      Margins.Left = 5
      Margins.Top = 5
      Margins.Right = 5
      Margins.Bottom = 5
      GroupIndex = 1
      Caption = 'Rb'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clAqua
      Font.Height = -21
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      OnClick = SpeedButtonElementClick
    end
    object SpeedButtonCs: TSpeedButton
      Tag = 55
      Left = 12
      Top = 331
      Width = 48
      Height = 47
      Margins.Left = 5
      Margins.Top = 5
      Margins.Right = 5
      Margins.Bottom = 5
      GroupIndex = 1
      Caption = 'Cs'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clAqua
      Font.Height = -21
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      OnClick = SpeedButtonElementClick
    end
    object SpeedButtonFr: TSpeedButton
      Tag = 87
      Left = 12
      Top = 376
      Width = 48
      Height = 48
      Margins.Left = 5
      Margins.Top = 5
      Margins.Right = 5
      Margins.Bottom = 5
      GroupIndex = 1
      Caption = 'Fr'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clAqua
      Font.Height = -21
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      OnClick = SpeedButtonElementClick
    end
    object SpeedButtonBe: TSpeedButton
      Tag = 4
      Left = 58
      Top = 149
      Width = 47
      Height = 47
      Margins.Left = 5
      Margins.Top = 5
      Margins.Right = 5
      Margins.Bottom = 5
      GroupIndex = 1
      Caption = 'Be'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clTeal
      Font.Height = -21
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      OnClick = SpeedButtonElementClick
    end
    object SpeedButtonMg: TSpeedButton
      Tag = 12
      Left = 58
      Top = 194
      Width = 47
      Height = 48
      Margins.Left = 5
      Margins.Top = 5
      Margins.Right = 5
      Margins.Bottom = 5
      GroupIndex = 1
      Caption = 'Mg'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clTeal
      Font.Height = -21
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      OnClick = SpeedButtonElementClick
    end
    object SpeedButtonCa: TSpeedButton
      Tag = 20
      Left = 58
      Top = 240
      Width = 47
      Height = 47
      Margins.Left = 5
      Margins.Top = 5
      Margins.Right = 5
      Margins.Bottom = 5
      GroupIndex = 1
      Caption = 'Ca'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clTeal
      Font.Height = -21
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      OnClick = SpeedButtonElementClick
    end
    object SpeedButtonSr: TSpeedButton
      Tag = 38
      Left = 58
      Top = 285
      Width = 47
      Height = 48
      Margins.Left = 5
      Margins.Top = 5
      Margins.Right = 5
      Margins.Bottom = 5
      GroupIndex = 1
      Caption = 'Sr'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clTeal
      Font.Height = -21
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      OnClick = SpeedButtonElementClick
    end
    object SpeedButtonBa: TSpeedButton
      Tag = 56
      Left = 58
      Top = 331
      Width = 47
      Height = 47
      Margins.Left = 5
      Margins.Top = 5
      Margins.Right = 5
      Margins.Bottom = 5
      GroupIndex = 1
      Caption = 'Ba'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clTeal
      Font.Height = -21
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      OnClick = SpeedButtonElementClick
    end
    object SpeedButtonRa: TSpeedButton
      Tag = 88
      Left = 58
      Top = 376
      Width = 47
      Height = 48
      Margins.Left = 5
      Margins.Top = 5
      Margins.Right = 5
      Margins.Bottom = 5
      GroupIndex = 1
      Caption = 'Ra'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clTeal
      Font.Height = -21
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      OnClick = SpeedButtonElementClick
    end
    object SpeedButtonSc: TSpeedButton
      Tag = 21
      Left = 103
      Top = 240
      Width = 48
      Height = 47
      Margins.Left = 5
      Margins.Top = 5
      Margins.Right = 5
      Margins.Bottom = 5
      GroupIndex = 1
      Caption = 'Sc'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clPurple
      Font.Height = -21
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      OnClick = SpeedButtonElementClick
    end
    object SpeedButtonY: TSpeedButton
      Tag = 39
      Left = 103
      Top = 285
      Width = 48
      Height = 48
      Margins.Left = 5
      Margins.Top = 5
      Margins.Right = 5
      Margins.Bottom = 5
      GroupIndex = 1
      Caption = 'Y'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clPurple
      Font.Height = -21
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      OnClick = SpeedButtonElementClick
    end
    object SpeedButtonLa: TSpeedButton
      Tag = 57
      Left = 103
      Top = 331
      Width = 48
      Height = 47
      Margins.Left = 5
      Margins.Top = 5
      Margins.Right = 5
      Margins.Bottom = 5
      GroupIndex = 1
      Caption = 'La'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clPurple
      Font.Height = -21
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold, fsUnderline]
      ParentFont = False
      OnClick = SpeedButtonElementClick
    end
    object SpeedButtonAc: TSpeedButton
      Tag = 89
      Left = 103
      Top = 376
      Width = 48
      Height = 48
      Margins.Left = 5
      Margins.Top = 5
      Margins.Right = 5
      Margins.Bottom = 5
      GroupIndex = 1
      Caption = 'Ac'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clPurple
      Font.Height = -21
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold, fsUnderline]
      ParentFont = False
      OnClick = SpeedButtonElementClick
    end
    object SpeedButtonTi: TSpeedButton
      Tag = 22
      Left = 149
      Top = 240
      Width = 47
      Height = 47
      Margins.Left = 5
      Margins.Top = 5
      Margins.Right = 5
      Margins.Bottom = 5
      GroupIndex = 1
      Caption = 'Ti'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clPurple
      Font.Height = -21
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      OnClick = SpeedButtonElementClick
    end
    object SpeedButtonZr: TSpeedButton
      Tag = 40
      Left = 149
      Top = 285
      Width = 47
      Height = 48
      Margins.Left = 5
      Margins.Top = 5
      Margins.Right = 5
      Margins.Bottom = 5
      GroupIndex = 1
      Caption = 'Zr'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clPurple
      Font.Height = -21
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      OnClick = SpeedButtonElementClick
    end
    object SpeedButtonHf: TSpeedButton
      Tag = 72
      Left = 149
      Top = 331
      Width = 47
      Height = 47
      Margins.Left = 5
      Margins.Top = 5
      Margins.Right = 5
      Margins.Bottom = 5
      GroupIndex = 1
      Caption = 'Hf'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clPurple
      Font.Height = -21
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      OnClick = SpeedButtonElementClick
    end
    object SpeedButtonDb: TSpeedButton
      Tag = 104
      Left = 149
      Top = 376
      Width = 47
      Height = 48
      Margins.Left = 5
      Margins.Top = 5
      Margins.Right = 5
      Margins.Bottom = 5
      GroupIndex = 1
      Caption = 'Db'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clPurple
      Font.Height = -21
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      OnClick = SpeedButtonElementClick
    end
    object SpeedButtonV: TSpeedButton
      Tag = 23
      Left = 194
      Top = 240
      Width = 48
      Height = 47
      Margins.Left = 5
      Margins.Top = 5
      Margins.Right = 5
      Margins.Bottom = 5
      GroupIndex = 1
      Caption = 'V'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clPurple
      Font.Height = -21
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      OnClick = SpeedButtonElementClick
    end
    object SpeedButtonNb: TSpeedButton
      Tag = 41
      Left = 194
      Top = 285
      Width = 48
      Height = 48
      Margins.Left = 5
      Margins.Top = 5
      Margins.Right = 5
      Margins.Bottom = 5
      GroupIndex = 1
      Caption = 'Nb'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clPurple
      Font.Height = -21
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      OnClick = SpeedButtonElementClick
    end
    object SpeedButtonTa: TSpeedButton
      Tag = 73
      Left = 194
      Top = 331
      Width = 48
      Height = 47
      Margins.Left = 5
      Margins.Top = 5
      Margins.Right = 5
      Margins.Bottom = 5
      GroupIndex = 1
      Caption = 'Ta'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clPurple
      Font.Height = -21
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      OnClick = SpeedButtonElementClick
    end
    object SpeedButtonJl: TSpeedButton
      Tag = 105
      Left = 194
      Top = 376
      Width = 48
      Height = 48
      Margins.Left = 5
      Margins.Top = 5
      Margins.Right = 5
      Margins.Bottom = 5
      GroupIndex = 1
      Caption = 'Jl'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clPurple
      Font.Height = -21
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      OnClick = SpeedButtonElementClick
    end
    object SpeedButtonCr: TSpeedButton
      Tag = 24
      Left = 240
      Top = 240
      Width = 47
      Height = 47
      Margins.Left = 5
      Margins.Top = 5
      Margins.Right = 5
      Margins.Bottom = 5
      GroupIndex = 1
      Caption = 'Cr'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clPurple
      Font.Height = -21
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      OnClick = SpeedButtonElementClick
    end
    object SpeedButtonMo: TSpeedButton
      Tag = 42
      Left = 240
      Top = 285
      Width = 47
      Height = 48
      Margins.Left = 5
      Margins.Top = 5
      Margins.Right = 5
      Margins.Bottom = 5
      GroupIndex = 1
      Caption = 'Mo'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clPurple
      Font.Height = -21
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      OnClick = SpeedButtonElementClick
    end
    object SpeedButtonW: TSpeedButton
      Tag = 74
      Left = 240
      Top = 331
      Width = 47
      Height = 47
      Margins.Left = 5
      Margins.Top = 5
      Margins.Right = 5
      Margins.Bottom = 5
      GroupIndex = 1
      Caption = 'W'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clPurple
      Font.Height = -21
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      OnClick = SpeedButtonElementClick
    end
    object SpeedButtonMn: TSpeedButton
      Tag = 25
      Left = 285
      Top = 240
      Width = 48
      Height = 47
      Margins.Left = 5
      Margins.Top = 5
      Margins.Right = 5
      Margins.Bottom = 5
      GroupIndex = 1
      Caption = 'Mn'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clPurple
      Font.Height = -21
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      OnClick = SpeedButtonElementClick
    end
    object SpeedButtonTc: TSpeedButton
      Tag = 43
      Left = 285
      Top = 285
      Width = 48
      Height = 48
      Margins.Left = 5
      Margins.Top = 5
      Margins.Right = 5
      Margins.Bottom = 5
      GroupIndex = 1
      Caption = 'Tc'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clPurple
      Font.Height = -21
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      OnClick = SpeedButtonElementClick
    end
    object SpeedButtonRe: TSpeedButton
      Tag = 75
      Left = 285
      Top = 331
      Width = 48
      Height = 47
      Margins.Left = 5
      Margins.Top = 5
      Margins.Right = 5
      Margins.Bottom = 5
      GroupIndex = 1
      Caption = 'Re'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clPurple
      Font.Height = -21
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      OnClick = SpeedButtonElementClick
    end
    object SpeedButtonFe: TSpeedButton
      Tag = 26
      Left = 331
      Top = 240
      Width = 47
      Height = 47
      Margins.Left = 5
      Margins.Top = 5
      Margins.Right = 5
      Margins.Bottom = 5
      GroupIndex = 1
      Caption = 'Fe'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clPurple
      Font.Height = -21
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      OnClick = SpeedButtonElementClick
    end
    object SpeedButtonRu: TSpeedButton
      Tag = 44
      Left = 331
      Top = 285
      Width = 47
      Height = 48
      Margins.Left = 5
      Margins.Top = 5
      Margins.Right = 5
      Margins.Bottom = 5
      GroupIndex = 1
      Caption = 'Ru'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clPurple
      Font.Height = -21
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      OnClick = SpeedButtonElementClick
    end
    object SpeedButtonOs: TSpeedButton
      Tag = 76
      Left = 331
      Top = 331
      Width = 47
      Height = 47
      Margins.Left = 5
      Margins.Top = 5
      Margins.Right = 5
      Margins.Bottom = 5
      GroupIndex = 1
      Caption = 'Os'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clPurple
      Font.Height = -21
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      OnClick = SpeedButtonElementClick
    end
    object SpeedButtonCo: TSpeedButton
      Tag = 27
      Left = 376
      Top = 240
      Width = 48
      Height = 47
      Margins.Left = 5
      Margins.Top = 5
      Margins.Right = 5
      Margins.Bottom = 5
      GroupIndex = 1
      Caption = 'Co'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clPurple
      Font.Height = -21
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      OnClick = SpeedButtonElementClick
    end
    object SpeedButtonRh: TSpeedButton
      Tag = 45
      Left = 376
      Top = 285
      Width = 48
      Height = 48
      Margins.Left = 5
      Margins.Top = 5
      Margins.Right = 5
      Margins.Bottom = 5
      GroupIndex = 1
      Caption = 'Rh'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clPurple
      Font.Height = -21
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      OnClick = SpeedButtonElementClick
    end
    object SpeedButtonIr: TSpeedButton
      Tag = 77
      Left = 376
      Top = 331
      Width = 48
      Height = 47
      Margins.Left = 5
      Margins.Top = 5
      Margins.Right = 5
      Margins.Bottom = 5
      GroupIndex = 1
      Caption = 'Ir'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clPurple
      Font.Height = -21
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      OnClick = SpeedButtonElementClick
    end
    object SpeedButtonNi: TSpeedButton
      Tag = 28
      Left = 422
      Top = 240
      Width = 47
      Height = 47
      Margins.Left = 5
      Margins.Top = 5
      Margins.Right = 5
      Margins.Bottom = 5
      GroupIndex = 1
      Caption = 'Ni'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clPurple
      Font.Height = -21
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      OnClick = SpeedButtonElementClick
    end
    object SpeedButtonPd: TSpeedButton
      Tag = 46
      Left = 422
      Top = 285
      Width = 47
      Height = 48
      Margins.Left = 5
      Margins.Top = 5
      Margins.Right = 5
      Margins.Bottom = 5
      GroupIndex = 1
      Caption = 'Pd'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clPurple
      Font.Height = -21
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      OnClick = SpeedButtonElementClick
    end
    object SpeedButtonPt: TSpeedButton
      Tag = 78
      Left = 422
      Top = 331
      Width = 47
      Height = 47
      Margins.Left = 5
      Margins.Top = 5
      Margins.Right = 5
      Margins.Bottom = 5
      GroupIndex = 1
      Caption = 'Pt'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clPurple
      Font.Height = -21
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      OnClick = SpeedButtonElementClick
    end
    object SpeedButtonCu: TSpeedButton
      Tag = 29
      Left = 467
      Top = 240
      Width = 48
      Height = 47
      Margins.Left = 5
      Margins.Top = 5
      Margins.Right = 5
      Margins.Bottom = 5
      GroupIndex = 1
      Caption = 'Cu'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clPurple
      Font.Height = -21
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      OnClick = SpeedButtonElementClick
    end
    object SpeedButtonAg: TSpeedButton
      Tag = 47
      Left = 467
      Top = 285
      Width = 48
      Height = 48
      Margins.Left = 5
      Margins.Top = 5
      Margins.Right = 5
      Margins.Bottom = 5
      GroupIndex = 1
      Caption = 'Ag'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clPurple
      Font.Height = -21
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      OnClick = SpeedButtonElementClick
    end
    object SpeedButtonAu: TSpeedButton
      Tag = 79
      Left = 467
      Top = 331
      Width = 48
      Height = 47
      Margins.Left = 5
      Margins.Top = 5
      Margins.Right = 5
      Margins.Bottom = 5
      GroupIndex = 1
      Caption = 'Au'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clPurple
      Font.Height = -21
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      OnClick = SpeedButtonElementClick
    end
    object SpeedButtonZn: TSpeedButton
      Tag = 30
      Left = 513
      Top = 240
      Width = 47
      Height = 47
      Margins.Left = 5
      Margins.Top = 5
      Margins.Right = 5
      Margins.Bottom = 5
      GroupIndex = 1
      Caption = 'Zn'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clPurple
      Font.Height = -21
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      OnClick = SpeedButtonElementClick
    end
    object SpeedButtonCd: TSpeedButton
      Tag = 48
      Left = 513
      Top = 285
      Width = 47
      Height = 48
      Margins.Left = 5
      Margins.Top = 5
      Margins.Right = 5
      Margins.Bottom = 5
      GroupIndex = 1
      Caption = 'Cd'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clPurple
      Font.Height = -21
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      OnClick = SpeedButtonElementClick
    end
    object SpeedButtonHg: TSpeedButton
      Tag = 80
      Left = 513
      Top = 331
      Width = 47
      Height = 47
      Margins.Left = 5
      Margins.Top = 5
      Margins.Right = 5
      Margins.Bottom = 5
      GroupIndex = 1
      Caption = 'Hg'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clPurple
      Font.Height = -21
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      OnClick = SpeedButtonElementClick
    end
    object SpeedButtonB: TSpeedButton
      Tag = 5
      Left = 558
      Top = 149
      Width = 48
      Height = 47
      Margins.Left = 5
      Margins.Top = 5
      Margins.Right = 5
      Margins.Bottom = 5
      GroupIndex = 1
      Caption = 'B'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clRed
      Font.Height = -21
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      OnClick = SpeedButtonElementClick
    end
    object SpeedButtonAl: TSpeedButton
      Tag = 13
      Left = 558
      Top = 194
      Width = 48
      Height = 48
      Margins.Left = 5
      Margins.Top = 5
      Margins.Right = 5
      Margins.Bottom = 5
      GroupIndex = 1
      Caption = 'Al'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clGray
      Font.Height = -21
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      OnClick = SpeedButtonElementClick
    end
    object SpeedButtonGa: TSpeedButton
      Tag = 31
      Left = 558
      Top = 240
      Width = 48
      Height = 47
      Margins.Left = 5
      Margins.Top = 5
      Margins.Right = 5
      Margins.Bottom = 5
      GroupIndex = 1
      Caption = 'Ga'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clGray
      Font.Height = -21
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      OnClick = SpeedButtonElementClick
    end
    object SpeedButtonIn: TSpeedButton
      Tag = 49
      Left = 558
      Top = 285
      Width = 48
      Height = 48
      Margins.Left = 5
      Margins.Top = 5
      Margins.Right = 5
      Margins.Bottom = 5
      GroupIndex = 1
      Caption = 'In'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clGray
      Font.Height = -21
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      OnClick = SpeedButtonElementClick
    end
    object SpeedButtonTl: TSpeedButton
      Tag = 81
      Left = 558
      Top = 331
      Width = 48
      Height = 47
      Margins.Left = 5
      Margins.Top = 5
      Margins.Right = 5
      Margins.Bottom = 5
      GroupIndex = 1
      Caption = 'Tl'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clGray
      Font.Height = -21
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      OnClick = SpeedButtonElementClick
    end
    object SpeedButtonC: TSpeedButton
      Tag = 6
      Left = 604
      Top = 149
      Width = 47
      Height = 47
      Margins.Left = 5
      Margins.Top = 5
      Margins.Right = 5
      Margins.Bottom = 5
      GroupIndex = 1
      Caption = 'C'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clRed
      Font.Height = -21
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      OnClick = SpeedButtonElementClick
    end
    object SpeedButtonSi: TSpeedButton
      Tag = 14
      Left = 604
      Top = 194
      Width = 47
      Height = 48
      Margins.Left = 5
      Margins.Top = 5
      Margins.Right = 5
      Margins.Bottom = 5
      GroupIndex = 1
      Caption = 'Si'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clRed
      Font.Height = -21
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      OnClick = SpeedButtonElementClick
    end
    object SpeedButtonGe: TSpeedButton
      Tag = 32
      Left = 604
      Top = 240
      Width = 47
      Height = 47
      Margins.Left = 5
      Margins.Top = 5
      Margins.Right = 5
      Margins.Bottom = 5
      GroupIndex = 1
      Caption = 'Ge'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clGray
      Font.Height = -21
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      OnClick = SpeedButtonElementClick
    end
    object SpeedButtonSn: TSpeedButton
      Tag = 50
      Left = 604
      Top = 285
      Width = 47
      Height = 48
      Margins.Left = 5
      Margins.Top = 5
      Margins.Right = 5
      Margins.Bottom = 5
      GroupIndex = 1
      Caption = 'Sn'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clGray
      Font.Height = -21
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      OnClick = SpeedButtonElementClick
    end
    object SpeedButtonPb: TSpeedButton
      Tag = 82
      Left = 604
      Top = 331
      Width = 47
      Height = 47
      Margins.Left = 5
      Margins.Top = 5
      Margins.Right = 5
      Margins.Bottom = 5
      GroupIndex = 1
      Caption = 'Pb'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clGray
      Font.Height = -21
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      OnClick = SpeedButtonElementClick
    end
    object SpeedButtonN: TSpeedButton
      Tag = 7
      Left = 649
      Top = 149
      Width = 48
      Height = 47
      Margins.Left = 5
      Margins.Top = 5
      Margins.Right = 5
      Margins.Bottom = 5
      GroupIndex = 1
      Caption = 'N'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clRed
      Font.Height = -21
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      OnClick = SpeedButtonElementClick
    end
    object SpeedButtonP: TSpeedButton
      Tag = 15
      Left = 649
      Top = 194
      Width = 48
      Height = 48
      Margins.Left = 5
      Margins.Top = 5
      Margins.Right = 5
      Margins.Bottom = 5
      GroupIndex = 1
      Caption = 'P'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clRed
      Font.Height = -21
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      OnClick = SpeedButtonElementClick
    end
    object SpeedButtonAs: TSpeedButton
      Tag = 33
      Left = 649
      Top = 240
      Width = 48
      Height = 47
      Margins.Left = 5
      Margins.Top = 5
      Margins.Right = 5
      Margins.Bottom = 5
      GroupIndex = 1
      Caption = 'As'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clRed
      Font.Height = -21
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      OnClick = SpeedButtonElementClick
    end
    object SpeedButtonSb: TSpeedButton
      Tag = 51
      Left = 649
      Top = 285
      Width = 48
      Height = 48
      Margins.Left = 5
      Margins.Top = 5
      Margins.Right = 5
      Margins.Bottom = 5
      GroupIndex = 1
      Caption = 'Sb'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clGray
      Font.Height = -21
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      OnClick = SpeedButtonElementClick
    end
    object SpeedButtonBi: TSpeedButton
      Tag = 83
      Left = 649
      Top = 331
      Width = 48
      Height = 47
      Margins.Left = 5
      Margins.Top = 5
      Margins.Right = 5
      Margins.Bottom = 5
      GroupIndex = 1
      Caption = 'Bi'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clGray
      Font.Height = -21
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      OnClick = SpeedButtonElementClick
    end
    object SpeedButtonO: TSpeedButton
      Tag = 8
      Left = 695
      Top = 149
      Width = 47
      Height = 47
      Margins.Left = 5
      Margins.Top = 5
      Margins.Right = 5
      Margins.Bottom = 5
      GroupIndex = 1
      Caption = 'O'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clRed
      Font.Height = -21
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      OnClick = SpeedButtonElementClick
    end
    object SpeedButtonS: TSpeedButton
      Tag = 16
      Left = 695
      Top = 194
      Width = 47
      Height = 48
      Margins.Left = 5
      Margins.Top = 5
      Margins.Right = 5
      Margins.Bottom = 5
      GroupIndex = 1
      Caption = 'S'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clRed
      Font.Height = -21
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      OnClick = SpeedButtonElementClick
    end
    object SpeedButtonSe: TSpeedButton
      Tag = 34
      Left = 695
      Top = 240
      Width = 47
      Height = 47
      Margins.Left = 5
      Margins.Top = 5
      Margins.Right = 5
      Margins.Bottom = 5
      GroupIndex = 1
      Caption = 'Se'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clRed
      Font.Height = -21
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      OnClick = SpeedButtonElementClick
    end
    object SpeedButtonTe: TSpeedButton
      Tag = 52
      Left = 695
      Top = 285
      Width = 47
      Height = 48
      Margins.Left = 5
      Margins.Top = 5
      Margins.Right = 5
      Margins.Bottom = 5
      GroupIndex = 1
      Caption = 'Te'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clRed
      Font.Height = -21
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      OnClick = SpeedButtonElementClick
    end
    object SpeedButtonPo: TSpeedButton
      Tag = 84
      Left = 695
      Top = 331
      Width = 47
      Height = 47
      Margins.Left = 5
      Margins.Top = 5
      Margins.Right = 5
      Margins.Bottom = 5
      GroupIndex = 1
      Caption = 'Po'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clGray
      Font.Height = -21
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      OnClick = SpeedButtonElementClick
    end
    object SpeedButtonF: TSpeedButton
      Tag = 9
      Left = 740
      Top = 149
      Width = 48
      Height = 47
      Margins.Left = 5
      Margins.Top = 5
      Margins.Right = 5
      Margins.Bottom = 5
      GroupIndex = 1
      Caption = 'F'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clLime
      Font.Height = -21
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      OnClick = SpeedButtonElementClick
    end
    object SpeedButtonCl: TSpeedButton
      Tag = 17
      Left = 740
      Top = 194
      Width = 48
      Height = 48
      Margins.Left = 5
      Margins.Top = 5
      Margins.Right = 5
      Margins.Bottom = 5
      GroupIndex = 1
      Caption = 'Cl'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clLime
      Font.Height = -21
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      OnClick = SpeedButtonElementClick
    end
    object SpeedButtonBr: TSpeedButton
      Tag = 35
      Left = 740
      Top = 240
      Width = 48
      Height = 47
      Margins.Left = 5
      Margins.Top = 5
      Margins.Right = 5
      Margins.Bottom = 5
      GroupIndex = 1
      Caption = 'Br'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clLime
      Font.Height = -21
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      OnClick = SpeedButtonElementClick
    end
    object SpeedButtonI: TSpeedButton
      Tag = 53
      Left = 740
      Top = 285
      Width = 48
      Height = 48
      Margins.Left = 5
      Margins.Top = 5
      Margins.Right = 5
      Margins.Bottom = 5
      GroupIndex = 1
      Caption = 'I'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clLime
      Font.Height = -21
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      OnClick = SpeedButtonElementClick
    end
    object SpeedButtonAt: TSpeedButton
      Tag = 85
      Left = 740
      Top = 331
      Width = 48
      Height = 47
      Margins.Left = 5
      Margins.Top = 5
      Margins.Right = 5
      Margins.Bottom = 5
      GroupIndex = 1
      Caption = 'At'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clLime
      Font.Height = -21
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      OnClick = SpeedButtonElementClick
    end
    object SpeedButtonHe: TSpeedButton
      Tag = 2
      Left = 786
      Top = 103
      Width = 47
      Height = 48
      Margins.Left = 5
      Margins.Top = 5
      Margins.Right = 5
      Margins.Bottom = 5
      GroupIndex = 1
      Caption = 'He'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clYellow
      Font.Height = -21
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      OnClick = SpeedButtonElementClick
    end
    object SpeedButtonNe: TSpeedButton
      Tag = 10
      Left = 786
      Top = 149
      Width = 47
      Height = 47
      Margins.Left = 5
      Margins.Top = 5
      Margins.Right = 5
      Margins.Bottom = 5
      GroupIndex = 1
      Caption = 'Ne'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clYellow
      Font.Height = -21
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      OnClick = SpeedButtonElementClick
    end
    object SpeedButtonAr: TSpeedButton
      Tag = 18
      Left = 786
      Top = 194
      Width = 47
      Height = 48
      Margins.Left = 5
      Margins.Top = 5
      Margins.Right = 5
      Margins.Bottom = 5
      GroupIndex = 1
      Caption = 'Ar'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clYellow
      Font.Height = -21
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      OnClick = SpeedButtonElementClick
    end
    object SpeedButtonKr: TSpeedButton
      Tag = 36
      Left = 786
      Top = 240
      Width = 47
      Height = 47
      Margins.Left = 5
      Margins.Top = 5
      Margins.Right = 5
      Margins.Bottom = 5
      GroupIndex = 1
      Caption = 'Kr'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clYellow
      Font.Height = -21
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      OnClick = SpeedButtonElementClick
    end
    object SpeedButtonXe: TSpeedButton
      Tag = 54
      Left = 786
      Top = 285
      Width = 47
      Height = 48
      Margins.Left = 5
      Margins.Top = 5
      Margins.Right = 5
      Margins.Bottom = 5
      GroupIndex = 1
      Caption = 'Xe'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clYellow
      Font.Height = -21
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      OnClick = SpeedButtonElementClick
    end
    object SpeedButtonRn: TSpeedButton
      Tag = 86
      Left = 786
      Top = 331
      Width = 47
      Height = 47
      Margins.Left = 5
      Margins.Top = 5
      Margins.Right = 5
      Margins.Bottom = 5
      GroupIndex = 1
      Caption = 'Rn'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clYellow
      Font.Height = -21
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      OnClick = SpeedButtonElementClick
    end
    object SpeedButtonCe: TSpeedButton
      Tag = 58
      Left = 149
      Top = 455
      Width = 47
      Height = 49
      Margins.Left = 5
      Margins.Top = 5
      Margins.Right = 5
      Margins.Bottom = 5
      GroupIndex = 1
      Caption = 'Ce'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clOlive
      Font.Height = -21
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      OnClick = SpeedButtonElementClick
    end
    object SpeedButtonTh: TSpeedButton
      Tag = 90
      Left = 149
      Top = 501
      Width = 47
      Height = 49
      Margins.Left = 5
      Margins.Top = 5
      Margins.Right = 5
      Margins.Bottom = 5
      GroupIndex = 1
      Caption = 'Th'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clOlive
      Font.Height = -21
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      OnClick = SpeedButtonElementClick
    end
    object SpeedButtonPr: TSpeedButton
      Tag = 59
      Left = 194
      Top = 455
      Width = 48
      Height = 49
      Margins.Left = 5
      Margins.Top = 5
      Margins.Right = 5
      Margins.Bottom = 5
      GroupIndex = 1
      Caption = 'Pr'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clOlive
      Font.Height = -21
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      OnClick = SpeedButtonElementClick
    end
    object SpeedButtonPa: TSpeedButton
      Tag = 91
      Left = 194
      Top = 501
      Width = 48
      Height = 49
      Margins.Left = 5
      Margins.Top = 5
      Margins.Right = 5
      Margins.Bottom = 5
      GroupIndex = 1
      Caption = 'Pa'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clOlive
      Font.Height = -21
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      OnClick = SpeedButtonElementClick
    end
    object SpeedButtonNd: TSpeedButton
      Tag = 60
      Left = 240
      Top = 455
      Width = 47
      Height = 49
      Margins.Left = 5
      Margins.Top = 5
      Margins.Right = 5
      Margins.Bottom = 5
      GroupIndex = 1
      Caption = 'Nd'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clOlive
      Font.Height = -21
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      OnClick = SpeedButtonElementClick
    end
    object SpeedButtonU: TSpeedButton
      Tag = 92
      Left = 240
      Top = 501
      Width = 47
      Height = 49
      Margins.Left = 5
      Margins.Top = 5
      Margins.Right = 5
      Margins.Bottom = 5
      GroupIndex = 1
      Caption = 'U'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clOlive
      Font.Height = -21
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      OnClick = SpeedButtonElementClick
    end
    object SpeedButtonPm: TSpeedButton
      Tag = 61
      Left = 285
      Top = 455
      Width = 48
      Height = 49
      Margins.Left = 5
      Margins.Top = 5
      Margins.Right = 5
      Margins.Bottom = 5
      GroupIndex = 1
      Caption = 'Pm'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clOlive
      Font.Height = -21
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      OnClick = SpeedButtonElementClick
    end
    object SpeedButtonNp: TSpeedButton
      Tag = 93
      Left = 285
      Top = 501
      Width = 48
      Height = 49
      Margins.Left = 5
      Margins.Top = 5
      Margins.Right = 5
      Margins.Bottom = 5
      GroupIndex = 1
      Caption = 'Np'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clOlive
      Font.Height = -21
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      OnClick = SpeedButtonElementClick
    end
    object SpeedButtonSm: TSpeedButton
      Tag = 62
      Left = 331
      Top = 455
      Width = 47
      Height = 49
      Margins.Left = 5
      Margins.Top = 5
      Margins.Right = 5
      Margins.Bottom = 5
      GroupIndex = 1
      Caption = 'Sm'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clOlive
      Font.Height = -21
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      OnClick = SpeedButtonElementClick
    end
    object SpeedButtonPu: TSpeedButton
      Tag = 94
      Left = 331
      Top = 501
      Width = 47
      Height = 49
      Margins.Left = 5
      Margins.Top = 5
      Margins.Right = 5
      Margins.Bottom = 5
      GroupIndex = 1
      Caption = 'Pu'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clOlive
      Font.Height = -21
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      OnClick = SpeedButtonElementClick
    end
    object SpeedButtonEu: TSpeedButton
      Tag = 63
      Left = 376
      Top = 455
      Width = 48
      Height = 49
      Margins.Left = 5
      Margins.Top = 5
      Margins.Right = 5
      Margins.Bottom = 5
      GroupIndex = 1
      Caption = 'Eu'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clOlive
      Font.Height = -21
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      OnClick = SpeedButtonElementClick
    end
    object SpeedButtonAm: TSpeedButton
      Tag = 95
      Left = 376
      Top = 501
      Width = 48
      Height = 49
      Margins.Left = 5
      Margins.Top = 5
      Margins.Right = 5
      Margins.Bottom = 5
      GroupIndex = 1
      Caption = 'Am'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clOlive
      Font.Height = -21
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      OnClick = SpeedButtonElementClick
    end
    object SpeedButtonGd: TSpeedButton
      Tag = 64
      Left = 422
      Top = 455
      Width = 47
      Height = 49
      Margins.Left = 5
      Margins.Top = 5
      Margins.Right = 5
      Margins.Bottom = 5
      GroupIndex = 1
      Caption = 'Gd'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clOlive
      Font.Height = -21
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      OnClick = SpeedButtonElementClick
    end
    object SpeedButtonCm: TSpeedButton
      Tag = 96
      Left = 422
      Top = 501
      Width = 47
      Height = 49
      Margins.Left = 5
      Margins.Top = 5
      Margins.Right = 5
      Margins.Bottom = 5
      GroupIndex = 1
      Caption = 'Cm'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clOlive
      Font.Height = -21
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      OnClick = SpeedButtonElementClick
    end
    object SpeedButtonTb: TSpeedButton
      Tag = 65
      Left = 467
      Top = 455
      Width = 48
      Height = 49
      Margins.Left = 5
      Margins.Top = 5
      Margins.Right = 5
      Margins.Bottom = 5
      GroupIndex = 1
      Caption = 'Tb'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clOlive
      Font.Height = -21
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      OnClick = SpeedButtonElementClick
    end
    object SpeedButtonBk: TSpeedButton
      Tag = 97
      Left = 467
      Top = 501
      Width = 48
      Height = 49
      Margins.Left = 5
      Margins.Top = 5
      Margins.Right = 5
      Margins.Bottom = 5
      GroupIndex = 1
      Caption = 'Bk'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clOlive
      Font.Height = -21
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      OnClick = SpeedButtonElementClick
    end
    object SpeedButtonDy: TSpeedButton
      Tag = 66
      Left = 513
      Top = 455
      Width = 47
      Height = 49
      Margins.Left = 5
      Margins.Top = 5
      Margins.Right = 5
      Margins.Bottom = 5
      GroupIndex = 1
      Caption = 'Dy'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clOlive
      Font.Height = -21
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      OnClick = SpeedButtonElementClick
    end
    object SpeedButtonCf: TSpeedButton
      Tag = 98
      Left = 513
      Top = 501
      Width = 47
      Height = 49
      Margins.Left = 5
      Margins.Top = 5
      Margins.Right = 5
      Margins.Bottom = 5
      GroupIndex = 1
      Caption = 'Cf'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clOlive
      Font.Height = -21
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      OnClick = SpeedButtonElementClick
    end
    object SpeedButtonHo: TSpeedButton
      Tag = 67
      Left = 558
      Top = 455
      Width = 48
      Height = 49
      Margins.Left = 5
      Margins.Top = 5
      Margins.Right = 5
      Margins.Bottom = 5
      GroupIndex = 1
      Caption = 'Ho'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clOlive
      Font.Height = -21
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      OnClick = SpeedButtonElementClick
    end
    object SpeedButtonEs: TSpeedButton
      Tag = 99
      Left = 558
      Top = 501
      Width = 48
      Height = 49
      Margins.Left = 5
      Margins.Top = 5
      Margins.Right = 5
      Margins.Bottom = 5
      GroupIndex = 1
      Caption = 'Es'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clOlive
      Font.Height = -21
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      OnClick = SpeedButtonElementClick
    end
    object SpeedButtonEr: TSpeedButton
      Tag = 68
      Left = 604
      Top = 455
      Width = 47
      Height = 49
      Margins.Left = 5
      Margins.Top = 5
      Margins.Right = 5
      Margins.Bottom = 5
      GroupIndex = 1
      Caption = 'Er'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clOlive
      Font.Height = -21
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      OnClick = SpeedButtonElementClick
    end
    object SpeedButtonFm: TSpeedButton
      Tag = 100
      Left = 604
      Top = 501
      Width = 47
      Height = 49
      Margins.Left = 5
      Margins.Top = 5
      Margins.Right = 5
      Margins.Bottom = 5
      GroupIndex = 1
      Caption = 'Fm'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clOlive
      Font.Height = -21
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      OnClick = SpeedButtonElementClick
    end
    object SpeedButtonTm: TSpeedButton
      Tag = 69
      Left = 649
      Top = 455
      Width = 48
      Height = 49
      Margins.Left = 5
      Margins.Top = 5
      Margins.Right = 5
      Margins.Bottom = 5
      GroupIndex = 1
      Caption = 'Tm'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clOlive
      Font.Height = -21
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      OnClick = SpeedButtonElementClick
    end
    object SpeedButtonMd: TSpeedButton
      Tag = 101
      Left = 649
      Top = 501
      Width = 48
      Height = 49
      Margins.Left = 5
      Margins.Top = 5
      Margins.Right = 5
      Margins.Bottom = 5
      GroupIndex = 1
      Caption = 'Md'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clOlive
      Font.Height = -21
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      OnClick = SpeedButtonElementClick
    end
    object SpeedButtonYb: TSpeedButton
      Tag = 70
      Left = 695
      Top = 455
      Width = 47
      Height = 49
      Margins.Left = 5
      Margins.Top = 5
      Margins.Right = 5
      Margins.Bottom = 5
      GroupIndex = 1
      Caption = 'Yb'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clOlive
      Font.Height = -21
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      OnClick = SpeedButtonElementClick
    end
    object SpeedButtonNo: TSpeedButton
      Tag = 102
      Left = 695
      Top = 501
      Width = 47
      Height = 49
      Margins.Left = 5
      Margins.Top = 5
      Margins.Right = 5
      Margins.Bottom = 5
      GroupIndex = 1
      Caption = 'No'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clOlive
      Font.Height = -21
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      OnClick = SpeedButtonElementClick
    end
    object SpeedButtonLu: TSpeedButton
      Tag = 71
      Left = 740
      Top = 455
      Width = 48
      Height = 49
      Margins.Left = 5
      Margins.Top = 5
      Margins.Right = 5
      Margins.Bottom = 5
      GroupIndex = 1
      Caption = 'Lu'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clOlive
      Font.Height = -21
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      OnClick = SpeedButtonElementClick
    end
    object SpeedButtonLr: TSpeedButton
      Tag = 103
      Left = 740
      Top = 501
      Width = 48
      Height = 49
      Margins.Left = 5
      Margins.Top = 5
      Margins.Right = 5
      Margins.Bottom = 5
      GroupIndex = 1
      Caption = 'Lr'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clOlive
      Font.Height = -21
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      OnClick = SpeedButtonElementClick
    end
    object SpeedButtonRf: TSpeedButton
      Tag = 106
      Left = 240
      Top = 376
      Width = 47
      Height = 48
      Margins.Left = 5
      Margins.Top = 5
      Margins.Right = 5
      Margins.Bottom = 5
      GroupIndex = 1
      Caption = 'Rf'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clPurple
      Font.Height = -21
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      OnClick = SpeedButtonElementClick
    end
    object SpeedButtonBh: TSpeedButton
      Tag = 107
      Left = 285
      Top = 376
      Width = 48
      Height = 48
      Margins.Left = 5
      Margins.Top = 5
      Margins.Right = 5
      Margins.Bottom = 5
      GroupIndex = 1
      Caption = 'Bh'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clPurple
      Font.Height = -21
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      OnClick = SpeedButtonElementClick
    end
    object SpeedButtonHn: TSpeedButton
      Tag = 108
      Left = 331
      Top = 376
      Width = 47
      Height = 48
      Margins.Left = 5
      Margins.Top = 5
      Margins.Right = 5
      Margins.Bottom = 5
      GroupIndex = 1
      Caption = 'Hn'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clPurple
      Font.Height = -21
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      OnClick = SpeedButtonElementClick
    end
    object SpeedButtonMt: TSpeedButton
      Tag = 109
      Left = 375
      Top = 376
      Width = 47
      Height = 48
      Margins.Left = 5
      Margins.Top = 5
      Margins.Right = 5
      Margins.Bottom = 5
      GroupIndex = 1
      Caption = 'Mt'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clPurple
      Font.Height = -21
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      OnClick = SpeedButtonElementClick
    end
    object GroupBoxVIII: TGroupBox
      Left = 341
      Top = 68
      Width = 126
      Height = 25
      Margins.Left = 5
      Margins.Top = 5
      Margins.Right = 5
      Margins.Bottom = 5
      Caption = 'VIII'
      TabOrder = 0
    end
    object PanelBottom: TPanel
      Left = 1
      Top = 771
      Width = 861
      Height = 68
      HelpContext = 702
      Margins.Left = 5
      Margins.Top = 5
      Margins.Right = 5
      Margins.Bottom = 5
      Align = alBottom
      TabOrder = 1
      object ButtonCancel: TButton
        Left = 471
        Top = 7
        Width = 140
        Height = 44
        Margins.Left = 5
        Margins.Top = 5
        Margins.Right = 5
        Margins.Bottom = 5
        Cancel = True
        Caption = 'Cancel'
        ModalResult = 2
        TabOrder = 0
      end
      object ButtonOK: TButton
        Left = 278
        Top = 7
        Width = 142
        Height = 44
        Margins.Left = 5
        Margins.Top = 5
        Margins.Right = 5
        Margins.Bottom = 5
        Caption = 'OK'
        ModalResult = 1
        TabOrder = 1
      end
      object ButtonPrint: TButton
        Left = 32
        Top = 12
        Width = 126
        Height = 44
        Margins.Left = 5
        Margins.Top = 5
        Margins.Right = 5
        Margins.Bottom = 5
        Caption = 'Print...'
        TabOrder = 2
        OnClick = ButtonPrintClick
      end
      object ButtonHelp: TButton
        Left = 665
        Top = 7
        Width = 138
        Height = 44
        Margins.Left = 5
        Margins.Top = 5
        Margins.Right = 5
        Margins.Bottom = 5
        Caption = '&Help'
        TabOrder = 3
        OnClick = ButtonHelpClick
      end
    end
    object PageControlLegend: TPageControl
      Left = 4
      Top = 632
      Width = 847
      Height = 135
      Margins.Left = 5
      Margins.Top = 5
      Margins.Right = 5
      Margins.Bottom = 5
      ActivePage = TabSheetChemistry
      Align = alCustom
      Anchors = [akLeft, akBottom]
      TabOrder = 2
      OnChange = PageControlLegendChange
      object TabSheetChemistry: TTabSheet
        Margins.Left = 5
        Margins.Top = 5
        Margins.Right = 5
        Margins.Bottom = 5
        Caption = 'Chemistry'
        object LabelAlkaliMetals: TLabel
          Left = 25
          Top = 11
          Width = 124
          Height = 25
          Margins.Left = 5
          Margins.Top = 5
          Margins.Right = 5
          Margins.Bottom = 5
          Caption = 'Alkali Metals'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clAqua
          Font.Height = -21
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object LabelRareEarthMetals: TLabel
          Left = 25
          Top = 33
          Width = 173
          Height = 25
          Margins.Left = 5
          Margins.Top = 5
          Margins.Right = 5
          Margins.Bottom = 5
          Caption = 'Rare Earth Metals'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clOlive
          Font.Height = -21
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object LabelTransitionMetals: TLabel
          Left = 25
          Top = 56
          Width = 167
          Height = 25
          Margins.Left = 5
          Margins.Top = 5
          Margins.Right = 5
          Margins.Bottom = 5
          Caption = 'Transition Metals'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clPurple
          Font.Height = -21
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object LabelAlkaliEarthMetals: TLabel
          Left = 331
          Top = 11
          Width = 181
          Height = 25
          Margins.Left = 5
          Margins.Top = 5
          Margins.Right = 5
          Margins.Bottom = 5
          Caption = 'Alkali Earth Metals'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clTeal
          Font.Height = -21
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object LabelOtherMetals: TLabel
          Left = 331
          Top = 33
          Width = 125
          Height = 25
          Margins.Left = 5
          Margins.Top = 5
          Margins.Right = 5
          Margins.Bottom = 5
          Caption = 'Other Metals'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clGray
          Font.Height = -21
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object LabelOtherNonmetals: TLabel
          Left = 331
          Top = 56
          Width = 163
          Height = 25
          Margins.Left = 5
          Margins.Top = 5
          Margins.Right = 5
          Margins.Bottom = 5
          Caption = 'Other Nonmetals'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clRed
          Font.Height = -21
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object LabelHalogens: TLabel
          Left = 604
          Top = 33
          Width = 92
          Height = 25
          Margins.Left = 5
          Margins.Top = 5
          Margins.Right = 5
          Margins.Bottom = 5
          Caption = 'Halogens'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clLime
          Font.Height = -21
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object LabelNobleGases: TLabel
          Left = 604
          Top = 56
          Width = 125
          Height = 25
          Margins.Left = 5
          Margins.Top = 5
          Margins.Right = 5
          Margins.Bottom = 5
          Caption = 'Noble Gases'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clYellow
          Font.Height = -21
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
        end
      end
      object TabSheetMetallurgy: TTabSheet
        Margins.Left = 5
        Margins.Top = 5
        Margins.Right = 5
        Margins.Bottom = 5
        Caption = 'Metallurgy'
        ImageIndex = 1
        object LabelFerrousMetals: TLabel
          Left = 23
          Top = 35
          Width = 145
          Height = 25
          Margins.Left = 5
          Margins.Top = 5
          Margins.Right = 5
          Margins.Bottom = 5
          Caption = 'Ferrous Metals'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -21
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object LabelNonFerrousMetals: TLabel
          Left = 23
          Top = 58
          Width = 185
          Height = 25
          Margins.Left = 5
          Margins.Top = 5
          Margins.Right = 5
          Margins.Bottom = 5
          Caption = 'Non-ferrous Metals'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clMaroon
          Font.Height = -21
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object LabelRareElements: TLabel
          Left = 536
          Top = 35
          Width = 141
          Height = 25
          Margins.Left = 5
          Margins.Top = 5
          Margins.Right = 5
          Margins.Bottom = 5
          Caption = 'Rare Elements'
          Color = clBtnFace
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clOlive
          Font.Height = -21
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentColor = False
          ParentFont = False
        end
        object LabelPreciousMetals: TLabel
          Left = 263
          Top = 35
          Width = 155
          Height = 25
          Margins.Left = 5
          Margins.Top = 5
          Margins.Right = 5
          Margins.Bottom = 5
          Caption = 'Precious Metals'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWhite
          Font.Height = -21
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object LabelRadioactiveElements: TLabel
          Left = 263
          Top = 58
          Width = 208
          Height = 25
          Margins.Left = 5
          Margins.Top = 5
          Margins.Right = 5
          Margins.Bottom = 5
          Caption = 'Radioactive Elements'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clFuchsia
          Font.Height = -21
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object LabelNonmetallicElements: TLabel
          Left = 536
          Top = 58
          Width = 216
          Height = 25
          Margins.Left = 5
          Margins.Top = 5
          Margins.Right = 5
          Margins.Bottom = 5
          Caption = 'Non-metallic Elements'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clGreen
          Font.Height = -21
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
        end
      end
    end
    object PanelMendeleevTable: TPanel
      Left = 1
      Top = 1
      Width = 861
      Height = 45
      Margins.Left = 5
      Margins.Top = 5
      Margins.Right = 5
      Margins.Bottom = 5
      Align = alTop
      Caption = 'Mendeleev Table'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -28
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 3
    end
  end
  object Panel1: TPanel
    Left = 863
    Top = 0
    Width = 290
    Height = 840
    Margins.Left = 5
    Margins.Top = 5
    Margins.Right = 5
    Margins.Bottom = 5
    Align = alRight
    BevelOuter = bvLowered
    TabOrder = 1
    object LabelDensity: TLabel
      Left = 12
      Top = 354
      Width = 157
      Height = 23
      Margins.Left = 5
      Margins.Top = 5
      Margins.Right = 5
      Margins.Bottom = 5
      Caption = 'Density, grams/cc)'
    end
    object LabelBoilingPoint: TLabel
      Left = 12
      Top = 308
      Width = 142
      Height = 23
      Margins.Left = 5
      Margins.Top = 5
      Margins.Right = 5
      Margins.Bottom = 5
      Caption = 'Boiling point,  *C'
    end
    object LabelMeltingPoint: TLabel
      Left = 12
      Top = 263
      Width = 148
      Height = 23
      Margins.Left = 5
      Margins.Top = 5
      Margins.Right = 5
      Margins.Bottom = 5
      Caption = 'Melting point,  *C'
    end
    object LabelState: TLabel
      Left = 12
      Top = 217
      Width = 43
      Height = 23
      Margins.Left = 5
      Margins.Top = 5
      Margins.Right = 5
      Margins.Bottom = 5
      Caption = 'State'
    end
    object LabelValence: TLabel
      Left = 12
      Top = 172
      Width = 65
      Height = 23
      Margins.Left = 5
      Margins.Top = 5
      Margins.Right = 5
      Margins.Bottom = 5
      Caption = 'Valence'
    end
    object LabelAtomicWeight: TLabel
      Left = 12
      Top = 126
      Width = 118
      Height = 23
      Margins.Left = 5
      Margins.Top = 5
      Margins.Right = 5
      Margins.Bottom = 5
      Caption = 'Atomic weight'
    end
    object LabelAtomicNumber: TLabel
      Left = 12
      Top = 81
      Width = 128
      Height = 23
      Margins.Left = 5
      Margins.Top = 5
      Margins.Right = 5
      Margins.Bottom = 5
      Caption = 'Atomic number'
    end
    object LabelName: TLabel
      Left = 12
      Top = 35
      Width = 49
      Height = 23
      Margins.Left = 5
      Margins.Top = 5
      Margins.Right = 5
      Margins.Bottom = 5
      Caption = 'Name'
    end
    object LabelDescription: TLabel
      Left = 1
      Top = 511
      Width = 288
      Height = 23
      Margins.Left = 5
      Margins.Top = 5
      Margins.Right = 5
      Margins.Bottom = 5
      Align = alBottom
      Caption = 'Description'
      ExplicitTop = 512
      ExplicitWidth = 93
    end
    object LabelMainMinerals: TLabel
      Left = 1
      Top = 690
      Width = 288
      Height = 23
      Margins.Left = 5
      Margins.Top = 5
      Margins.Right = 5
      Margins.Bottom = 5
      Align = alBottom
      Caption = 'Main minerals'
      ExplicitTop = 691
      ExplicitWidth = 116
    end
    object DBEditName: TDBEdit
      Left = 103
      Top = 19
      Width = 172
      Height = 33
      Margins.Left = 5
      Margins.Top = 5
      Margins.Right = 5
      Margins.Bottom = 5
      BiDiMode = bdRightToLeft
      Color = clBtnFace
      DataField = 'NAME'
      DataSource = DataSourceElements
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -21
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentBiDiMode = False
      ParentFont = False
      TabOrder = 0
    end
    object DBEditAtomicNumber: TDBEdit
      Left = 194
      Top = 67
      Width = 81
      Height = 33
      Margins.Left = 5
      Margins.Top = 5
      Margins.Right = 5
      Margins.Bottom = 5
      Color = clBtnFace
      DataField = 'ATOMNUMBER'
      DataSource = DataSourceElements
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -21
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 1
    end
    object DBEditWeight: TDBEdit
      Left = 194
      Top = 112
      Width = 81
      Height = 31
      Margins.Left = 5
      Margins.Top = 5
      Margins.Right = 5
      Margins.Bottom = 5
      Color = clBtnFace
      DataField = 'ATOMMASS'
      DataSource = DataSourceElements
      TabOrder = 2
    end
    object DBEditValence: TDBEdit
      Left = 194
      Top = 158
      Width = 81
      Height = 31
      Margins.Left = 5
      Margins.Top = 5
      Margins.Right = 5
      Margins.Bottom = 5
      Color = clBtnFace
      DataField = 'VALENCE'
      DataSource = DataSourceElements
      TabOrder = 3
    end
    object DBEditState: TDBEdit
      Left = 126
      Top = 205
      Width = 149
      Height = 31
      Margins.Left = 5
      Margins.Top = 5
      Margins.Right = 5
      Margins.Bottom = 5
      BiDiMode = bdRightToLeft
      Color = clBtnFace
      DataField = 'STATE'
      DataSource = DataSourceElements
      ParentBiDiMode = False
      TabOrder = 4
    end
    object DBEditMeltingPoint: TDBEdit
      Left = 194
      Top = 250
      Width = 81
      Height = 31
      Margins.Left = 5
      Margins.Top = 5
      Margins.Right = 5
      Margins.Bottom = 5
      Color = clBtnFace
      DataField = 'MELTING'
      DataSource = DataSourceElements
      TabOrder = 5
    end
    object DBEditBoilingPoint: TDBEdit
      Left = 194
      Top = 296
      Width = 81
      Height = 31
      Margins.Left = 5
      Margins.Top = 5
      Margins.Right = 5
      Margins.Bottom = 5
      Color = clBtnFace
      DataField = 'BOILING'
      DataSource = DataSourceElements
      TabOrder = 6
    end
    object DBEditDensity: TDBEdit
      Left = 194
      Top = 341
      Width = 81
      Height = 31
      Margins.Left = 5
      Margins.Top = 5
      Margins.Right = 5
      Margins.Bottom = 5
      Color = clBtnFace
      DataField = 'DENSITY'
      DataSource = DataSourceElements
      TabOrder = 7
    end
    object DBListBoxMainMinerals: TDBListBox
      Left = 1
      Top = 713
      Width = 288
      Height = 126
      Margins.Left = 5
      Margins.Top = 5
      Margins.Right = 5
      Margins.Bottom = 5
      Align = alBottom
      DataSource = DataSourceMinerals
      ItemHeight = 23
      TabOrder = 8
    end
    object DBRichEditDescription: TDBRichEdit
      Left = 1
      Top = 534
      Width = 288
      Height = 156
      Margins.Left = 5
      Margins.Top = 5
      Margins.Right = 5
      Margins.Bottom = 5
      Align = alBottom
      Color = clBtnFace
      DataSource = DataSourceElements
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clBlack
      Font.Height = -12
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ReadOnly = True
      TabOrder = 9
    end
  end
  object DataSourceElements: TDataSource
    DataSet = TableElements
    Left = 536
    Top = 336
  end
  object DataSourceMinerals: TDataSource
    DataSet = TableMainMinerals
    Left = 224
    Top = 80
  end
  object TableElements: TTable
    TableName = 'Elements'
    Left = 136
    Top = 80
  end
  object TableMainMinerals: TTable
    Left = 536
    Top = 416
  end
end
