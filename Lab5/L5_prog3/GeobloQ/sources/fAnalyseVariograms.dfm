inherited FormAnalyseVariograms: TFormAnalyseVariograms
  Left = 146
  Top = 154
  HelpContext = 722
  Caption = 'Calculate Variograms'
  ClientHeight = 538
  ClientWidth = 628
  StyleElements = [seFont, seClient, seBorder]
  ExplicitWidth = 654
  ExplicitHeight = 587
  TextHeight = 16
  inherited PanelTop: TPanel
    Width = 628
    Height = 209
    StyleElements = [seFont, seClient, seBorder]
    ExplicitWidth = 628
    ExplicitHeight = 209
    inherited GroupBoxInput: TGroupBox
      Width = 618
      Height = 199
      ExplicitWidth = 618
      ExplicitHeight = 199
      inherited PanelInputPath: TPanel
        Width = 614
        StyleElements = [seFont, seClient, seBorder]
        ExplicitWidth = 614
      end
      inherited PanelInputButtons: TPanel
        Width = 614
        StyleElements = [seFont, seClient, seBorder]
        ExplicitWidth = 614
        inherited ToolBarInput: TToolBar
          inherited ToolButtonHoles: TToolButton
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
            Visible = False
          end
          inherited ToolButtonMeshes2D: TToolButton
            Visible = False
          end
          inherited ToolButtonMeshes3D: TToolButton
            Visible = False
          end
        end
        inherited ToolBarRight: TToolBar
          Left = 554
          ExplicitLeft = 554
        end
      end
      inherited GroupBoxRealAttribute: TGroupBox
        Width = 351
        Height = 115
        ExplicitWidth = 351
        ExplicitHeight = 115
        inherited ListBoxRealAttribute: TListBox
          Width = 347
          Height = 95
          StyleElements = [seFont, seClient, seBorder]
          ExplicitWidth = 347
          ExplicitHeight = 95
        end
      end
      inherited GroupBoxModel: TGroupBox
        Height = 115
        ExplicitHeight = 115
        inherited ListBoxInputNames: TListBox
          Height = 95
          StyleElements = [seFont, seClient, seBorder]
          ExplicitHeight = 95
        end
      end
    end
  end
  inherited PanelMiddle: TPanel
    Top = 209
    Width = 628
    Height = 283
    StyleElements = [seFont, seClient, seBorder]
    ExplicitTop = 209
    ExplicitWidth = 628
    ExplicitHeight = 283
    object LabelVariogramType: TLabel [0]
      Left = 9
      Top = 1
      Width = 32
      Height = 16
      Caption = 'Type'
    end
    inherited GroupBoxOutput: TGroupBox
      Top = 224
      Width = 618
      ExplicitTop = 224
      ExplicitWidth = 618
      inherited ToolBarShowAs: TToolBar
        Width = 614
        ExplicitWidth = 614
        inherited ToolButtonMap: TToolButton
          Visible = False
        end
        inherited PanelOutPath: TPanel
          StyleElements = [seFont, seClient, seBorder]
        end
        inherited EditOutName: TEdit
          StyleElements = [seFont, seClient, seBorder]
        end
      end
    end
    object ComboBoxVariogramType: TComboBox
      Left = 9
      Top = 23
      Width = 195
      Height = 24
      Style = csDropDownList
      TabOrder = 1
      Items.Strings = (
        'Variogram'
        'Covariance'
        'Correlogram'
        'General relative variogram'
        'Pairwise relative variogram'
        'Variogram of logarithms'
        'Madogram')
    end
    object GroupBoxLagData: TGroupBox
      Left = 6
      Top = 64
      Width = 198
      Height = 127
      Caption = 'Lag'
      TabOrder = 2
      object LabelLagsNumber: TLabel
        Left = 9
        Top = 26
        Width = 48
        Height = 16
        Caption = 'Number'
      end
      object LabelLagSeparationDistance: TLabel
        Left = 9
        Top = 58
        Width = 53
        Height = 16
        Caption = 'Distance'
      end
      object LabelLagTolerance: TLabel
        Left = 9
        Top = 88
        Width = 62
        Height = 16
        Caption = 'Tolerance'
      end
      object SpinEditLagsNumber: TSpinEdit
        Left = 123
        Top = 24
        Width = 62
        Height = 26
        MaxValue = 20
        MinValue = 1
        TabOrder = 0
        Value = 1
      end
      object EditLagSeparationDistance: TEdit
        Left = 123
        Top = 56
        Width = 62
        Height = 24
        TabOrder = 1
      end
      object EditLagTolerance: TEdit
        Left = 123
        Top = 86
        Width = 62
        Height = 24
        TabOrder = 2
      end
    end
    object GroupBoxDirection: TGroupBox
      Left = 210
      Top = -3
      Width = 317
      Height = 194
      Caption = 'Direction'
      TabOrder = 3
      object LabelDirectionsNumber: TLabel
        Left = 17
        Top = 26
        Width = 48
        Height = 16
        Caption = 'Number'
      end
      object SpinEditDirectionsNumber: TSpinEdit
        Left = 17
        Top = 48
        Width = 56
        Height = 26
        MaxValue = 20
        MinValue = 1
        TabOrder = 0
        Value = 1
        OnChange = SpinEditDirectionsNumberChange
      end
      object ListBoxDirections: TListBox
        Left = 17
        Top = 80
        Width = 96
        Height = 105
        TabOrder = 1
        OnClick = ListBoxDirectionsClick
      end
      object GroupBoxAzimuth: TGroupBox
        Left = 128
        Top = 9
        Width = 185
        Height = 88
        Caption = 'Azimuth'
        TabOrder = 2
        object LabelAzimuth: TLabel
          Left = 12
          Top = 19
          Width = 35
          Height = 16
          Caption = 'Angle'
        end
        object LabelAzimuthTolerance: TLabel
          Left = 11
          Top = 41
          Width = 62
          Height = 16
          Caption = 'Tolerance'
        end
        object LabelAzimuthBandwidth: TLabel
          Left = 11
          Top = 63
          Width = 62
          Height = 16
          Caption = 'Bandwidth'
        end
        object EditAzimuthBandwidth: TEdit
          Left = 119
          Top = 59
          Width = 57
          Height = 24
          TabOrder = 2
          OnExit = DirectionPropertyChange
        end
        object EditAzimuthTolerance: TEdit
          Left = 119
          Top = 36
          Width = 57
          Height = 24
          TabOrder = 1
          OnExit = DirectionPropertyChange
        end
        object EditAzimuth: TEdit
          Left = 119
          Top = 13
          Width = 57
          Height = 24
          TabOrder = 0
          OnExit = DirectionPropertyChange
        end
      end
      object GroupBoxDip: TGroupBox
        Left = 129
        Top = 103
        Width = 185
        Height = 88
        Caption = 'Dip'
        TabOrder = 3
        object LabelDip: TLabel
          Left = 11
          Top = 19
          Width = 35
          Height = 16
          Caption = 'Angle'
        end
        object LabelDipTolerance: TLabel
          Left = 11
          Top = 41
          Width = 62
          Height = 16
          Caption = 'Tolerance'
        end
        object LabelDipBandwidth: TLabel
          Left = 11
          Top = 63
          Width = 62
          Height = 16
          Caption = 'Bandwidth'
        end
        object EditDip: TEdit
          Left = 119
          Top = 13
          Width = 57
          Height = 24
          TabOrder = 0
          OnExit = DirectionPropertyChange
        end
        object EditDipTolerance: TEdit
          Left = 119
          Top = 35
          Width = 57
          Height = 24
          TabOrder = 1
          OnExit = DirectionPropertyChange
        end
        object EditDipBandwidth: TEdit
          Left = 119
          Top = 57
          Width = 57
          Height = 24
          TabOrder = 2
          OnExit = DirectionPropertyChange
        end
      end
    end
    object CheckBoxStandardized: TCheckBox
      Left = 12
      Top = 197
      Width = 169
      Height = 17
      Caption = 'Standardized'
      TabOrder = 4
    end
    object ButtonReset: TButton
      Left = 433
      Top = 197
      Width = 90
      Height = 28
      Caption = 'Reset'
      TabOrder = 5
      OnClick = ButtonResetClick
    end
  end
  inherited PanelBottom: TPanel
    Top = 492
    Width = 628
    StyleElements = [seFont, seClient, seBorder]
    ExplicitTop = 492
    ExplicitWidth = 628
    inherited ButtonOK: TButton
      Left = 360
      Top = 1
      ExplicitLeft = 360
      ExplicitTop = 1
    end
    inherited ButtonCancel: TButton
      Left = 645
      ExplicitLeft = 645
    end
    inherited ButtonHelp: TButton
      Left = 749
      ExplicitLeft = 749
    end
  end
end
