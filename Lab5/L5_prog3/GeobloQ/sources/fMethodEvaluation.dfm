inherited FormMethodEvaluation: TFormMethodEvaluation
  Tag = 1
  Left = 316
  Top = 97
  HelpContext = 316
  Caption = 'Block Evaluation'
  ClientHeight = 496
  ClientWidth = 719
  Menu = MainMenu1
  StyleElements = [seFont, seClient, seBorder]
  ExplicitWidth = 745
  ExplicitHeight = 545
  TextHeight = 16
  inherited PanelTop: TPanel
    Width = 719
    Height = 193
    StyleElements = [seFont, seClient, seBorder]
    ExplicitWidth = 719
    ExplicitHeight = 193
    inherited GroupBoxInput: TGroupBox
      Width = 709
      Height = 183
      ExplicitWidth = 709
      ExplicitHeight = 183
      inherited PanelInputPath: TPanel
        Width = 705
        StyleElements = [seFont, seClient, seBorder]
        ExplicitWidth = 705
      end
      inherited PanelInputButtons: TPanel
        Width = 705
        StyleElements = [seFont, seClient, seBorder]
        ExplicitWidth = 705
        inherited ToolBarInput: TToolBar
          inherited ToolButtonHoles: TToolButton
            Visible = False
          end
          inherited ToolButtonPoints2D: TToolButton
            Visible = False
          end
          inherited ToolButtonPoints3D: TToolButton
            Visible = False
          end
          inherited ToolButtonPolygons: TToolButton
            Visible = False
          end
          inherited ToolButtonTins: TToolButton
            Visible = False
          end
          inherited ToolButtonSolids: TToolButton
            Visible = False
          end
          inherited ToolButtonGrids2D: TToolButton
            Visible = False
          end
          inherited ToolButtonGrids3D: TToolButton
            Down = True
          end
          inherited ToolButtonMeshes2D: TToolButton
            Visible = False
          end
          inherited ToolButtonMeshes3D: TToolButton
            Visible = False
          end
        end
        inherited ToolBarRight: TToolBar
          Left = 645
          ExplicitLeft = 645
        end
      end
      inherited GroupBoxRealAttribute: TGroupBox
        Left = 355
        Width = 352
        Height = 99
        ExplicitLeft = 355
        ExplicitWidth = 352
        ExplicitHeight = 99
        inherited ListBoxRealAttribute: TListBox
          Width = 348
          Height = 79
          StyleElements = [seFont, seClient, seBorder]
          ExplicitWidth = 348
          ExplicitHeight = 79
        end
      end
      inherited GroupBoxModel: TGroupBox
        Width = 353
        Height = 99
        ExplicitWidth = 353
        ExplicitHeight = 99
        inherited ListBoxInputNames: TListBox
          Width = 349
          Height = 79
          StyleElements = [seFont, seClient, seBorder]
          ExplicitWidth = 349
          ExplicitHeight = 79
        end
      end
    end
  end
  inherited PanelMiddle: TPanel
    Top = 193
    Width = 719
    Height = 257
    StyleElements = [seFont, seClient, seBorder]
    ExplicitTop = 193
    ExplicitWidth = 719
    ExplicitHeight = 257
    inherited GroupBoxOutput: TGroupBox
      Top = 193
      Width = 709
      Height = 59
      TabOrder = 4
      ExplicitTop = 193
      ExplicitWidth = 709
      ExplicitHeight = 59
      inherited ToolBarShowAs: TToolBar
        Width = 705
        Height = 23
        ButtonHeight = 23
        ExplicitWidth = 705
        ExplicitHeight = 23
        inherited ToolButton3: TToolButton
          ExplicitHeight = 23
        end
        inherited ToolButtonMap: TToolButton
          ExplicitHeight = 23
        end
        inherited ToolButtonTable: TToolButton
          ExplicitHeight = 23
        end
        inherited ToolButtonGraph: TToolButton
          ExplicitHeight = 23
        end
        inherited PanelOutPath: TPanel
          Width = 440
          Height = 23
          StyleElements = [seFont, seClient, seBorder]
          ExplicitWidth = 440
          ExplicitHeight = 23
        end
        inherited EditOutName: TEdit
          Left = 517
          Height = 23
          StyleElements = [seFont, seClient, seBorder]
          ExplicitLeft = 517
          ExplicitHeight = 23
        end
        inherited SpeedButtonOutputBrowse: TSpeedButton
          Left = 653
          Height = 23
          ExplicitLeft = 653
          ExplicitHeight = 23
        end
      end
    end
    object GroupBoxRecovery: TGroupBox
      Left = 368
      Top = 106
      Width = 342
      Height = 79
      Caption = 'Recovery'
      TabOrder = 0
      object RadioButtonConstant: TRadioButton
        Left = 16
        Top = 24
        Width = 113
        Height = 17
        Caption = 'Constant'
        Checked = True
        TabOrder = 0
        TabStop = True
      end
      object RadioButtonRecoveryField: TRadioButton
        Left = 16
        Top = 48
        Width = 233
        Height = 17
        Caption = 'Variable'
        Enabled = False
        TabOrder = 1
      end
      object EditScaleDoubleRecovery: TGBEditScaleDouble
        Left = 192
        Top = 18
        Width = 73
        Height = 24
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -15
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        TabOrder = 2
        Text = '90.5'
        Parent = GroupBoxRecovery
        EnabledConvert = True
        AsInteger = 90
        ValueType = vtDouble
        AsDouble = 90.500000000000000000
        AsFloat = 90.500000000000000000
        Error = False
        Precision = 0
        Value = 90.500000000000000000
      end
      object Edit6: TEdit
        Left = 288
        Top = 21
        Width = 25
        Height = 17
        AutoSelect = False
        BorderStyle = bsNone
        Color = clBtnFace
        ReadOnly = True
        TabOrder = 3
        Text = '%'
      end
    end
    object GroupBoxMiningCosts: TGroupBox
      Left = 6
      Top = 9
      Width = 350
      Height = 88
      Caption = 'Mining costs'
      TabOrder = 1
      object LabelValuableOre: TLabel
        Left = 16
        Top = 33
        Width = 28
        Height = 16
        Caption = 'Ore  '
      end
      object LabelWasteRocks: TLabel
        Left = 16
        Top = 64
        Width = 39
        Height = 16
        Caption = 'Waste'
      end
      object EditScaleDoubleOre: TGBEditScaleDouble
        Left = 169
        Top = 25
        Width = 56
        Height = 24
        TabOrder = 0
        Text = '80'
        Parent = GroupBoxMiningCosts
        EnabledConvert = True
        AsInteger = 80
        ValueType = vtDouble
        AsDouble = 80.000000000000000000
        AsFloat = 80.000000000000000000
        Error = False
        Precision = 0
        Value = 80.000000000000000000
      end
      object EditScaleDoubleWaste: TGBEditScaleDouble
        Left = 169
        Top = 56
        Width = 57
        Height = 24
        TabOrder = 1
        Text = '20'
        Parent = GroupBoxMiningCosts
        EnabledConvert = True
        AsInteger = 20
        ValueType = vtDouble
        AsDouble = 20.000000000000000000
        AsFloat = 20.000000000000000000
        Error = False
        Precision = 0
        Value = 20.000000000000000000
      end
      object Edit1: TEdit
        Left = 232
        Top = 29
        Width = 33
        Height = 17
        AutoSelect = False
        BorderStyle = bsNone
        Color = clBtnFace
        ReadOnly = True
        TabOrder = 2
        Text = '$/t'
      end
      object Edit2: TEdit
        Left = 232
        Top = 61
        Width = 33
        Height = 17
        AutoSelect = False
        BorderStyle = bsNone
        Color = clBtnFace
        ReadOnly = True
        TabOrder = 3
        Text = '$/t'
      end
    end
    object GroupBoxDensity: TGroupBox
      Left = 6
      Top = 106
      Width = 350
      Height = 79
      Caption = 'Density'
      TabOrder = 2
      object RadioButtonDensityConstant: TRadioButton
        Left = 16
        Top = 24
        Width = 113
        Height = 17
        Caption = 'Constant'
        Checked = True
        TabOrder = 0
        TabStop = True
      end
      object RadioButtonDensityField: TRadioButton
        Left = 16
        Top = 56
        Width = 233
        Height = 17
        Caption = 'Variable'
        Enabled = False
        TabOrder = 1
      end
      object EditScaleDoubleDensityConst: TGBEditScaleDouble
        Left = 169
        Top = 17
        Width = 56
        Height = 24
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -15
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        TabOrder = 2
        Text = '3.5'
        Parent = GroupBoxDensity
        EnabledConvert = True
        AsInteger = 4
        ValueType = vtDouble
        AsDouble = 3.500000000000000000
        AsFloat = 3.500000000000000000
        Error = False
        Precision = 0
        Value = 3.500000000000000000
      end
      object Edit3: TEdit
        Left = 232
        Top = 21
        Width = 41
        Height = 17
        AutoSelect = False
        BorderStyle = bsNone
        Color = clBtnFace
        ReadOnly = True
        TabOrder = 3
        Text = 'kg/m3'
      end
    end
    object GroupBoxComponent: TGroupBox
      Left = 362
      Top = 12
      Width = 342
      Height = 88
      Caption = 'Component'
      TabOrder = 3
      object LabelCutoff: TLabel
        Left = 26
        Top = 33
        Width = 33
        Height = 16
        Caption = 'Cutoff'
      end
      object LabelPrice: TLabel
        Left = 28
        Top = 65
        Width = 31
        Height = 16
        Caption = 'Price'
      end
      object Edit4: TEdit
        Left = 296
        Top = 29
        Width = 25
        Height = 17
        AutoSelect = False
        BorderStyle = bsNone
        Color = clBtnFace
        ReadOnly = True
        TabOrder = 0
        Text = '%'
      end
      object Edit5: TEdit
        Left = 296
        Top = 52
        Width = 33
        Height = 17
        AutoSelect = False
        BorderStyle = bsNone
        Color = clBtnFace
        ReadOnly = True
        TabOrder = 1
        Text = '$/t'
      end
      object GBEditValuePrice: TGBEditValue
        Left = 198
        Top = 54
        Width = 73
        Height = 24
        TabOrder = 2
        Text = '0'
        Parent = GroupBoxComponent
        EnabledConvert = True
        AsInteger = 0
        ValueType = vtDouble
        Error = False
        Precision = 0
      end
    end
  end
  inherited PanelBottom: TPanel
    Top = 450
    Width = 719
    StyleElements = [seFont, seClient, seBorder]
    ExplicitTop = 450
    ExplicitWidth = 719
    inherited ProgressBar: TProgressBar
      Width = 337
      ExplicitWidth = 337
    end
    inherited ButtonOK: TButton
      Left = 365
      ExplicitLeft = 365
    end
    inherited ButtonCancel: TButton
      Left = 484
      ExplicitLeft = 484
    end
    inherited ButtonHelp: TButton
      Left = 599
      ExplicitLeft = 599
    end
  end
  object GBEditScaleDoubleCutoff: TGBEditScaleDouble [3]
    Left = 560
    Top = 228
    Width = 73
    Height = 24
    TabOrder = 3
    Text = '0'
    Parent = Owner
    EnabledConvert = True
    AsInteger = 0
    ValueType = vtDouble
    Error = False
    Precision = 0
  end
  object MainMenu1: TMainMenu
    Left = 344
    Top = 24
  end
end
