inherited fmComposeOreIntervals: TfmComposeOreIntervals
  Tag = 1
  Left = 236
  Top = 135
  HelpContext = 304
  Caption = 'Ore Intervals'
  ClientHeight = 461
  ClientWidth = 650
  StyleElements = [seFont, seClient, seBorder]
  ExplicitWidth = 676
  ExplicitHeight = 510
  TextHeight = 16
  inherited PanelTop: TPanel
    Width = 650
    StyleElements = [seFont, seClient, seBorder]
    ExplicitWidth = 650
    inherited GroupBoxInput: TGroupBox
      Width = 640
      ExplicitWidth = 640
      inherited PanelInputPath: TPanel
        Width = 636
        StyleElements = [seFont, seClient, seBorder]
        ExplicitWidth = 636
      end
      inherited PanelInputButtons: TPanel
        Width = 636
        StyleElements = [seFont, seClient, seBorder]
        ExplicitWidth = 636
        inherited ToolBarInput: TToolBar
          inherited ToolButtonHoles: TToolButton
            Down = True
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
          Left = 576
          ExplicitLeft = 576
        end
      end
      inherited GroupBoxRealAttribute: TGroupBox
        Left = 321
        Width = 317
        ExplicitLeft = 321
        ExplicitWidth = 317
        inherited ListBoxRealAttribute: TListBox
          Width = 313
          ExtendedSelect = False
          MultiSelect = False
          StyleElements = [seFont, seClient, seBorder]
          ExplicitWidth = 313
        end
      end
      inherited GroupBoxModel: TGroupBox
        Width = 319
        ExplicitWidth = 319
        inherited ListBoxInputNames: TListBox
          Width = 315
          StyleElements = [seFont, seClient, seBorder]
          ExplicitWidth = 315
        end
      end
    end
  end
  inherited PanelMiddle: TPanel
    Width = 650
    Height = 168
    StyleElements = [seFont, seClient, seBorder]
    ExplicitWidth = 650
    ExplicitHeight = 168
    inherited GroupBoxOutput: TGroupBox
      Top = 109
      Width = 640
      TabOrder = 1
      ExplicitTop = 109
      ExplicitWidth = 640
      inherited ToolBarShowAs: TToolBar
        Width = 636
        ExplicitWidth = 636
        inherited PanelOutPath: TPanel
          Width = 352
          StyleElements = [seFont, seClient, seBorder]
          ExplicitWidth = 352
        end
        inherited EditOutName: TEdit
          Left = 429
          Width = 139
          StyleElements = [seFont, seClient, seBorder]
          ExplicitLeft = 429
          ExplicitWidth = 139
        end
        inherited SpeedButtonOutputBrowse: TSpeedButton
          Left = 568
          ExplicitLeft = 568
        end
      end
    end
    object GroupBoxConditions: TGroupBox
      Left = 5
      Top = 5
      Width = 640
      Height = 104
      Align = alClient
      Caption = 'Conditions'
      TabOrder = 0
      object LabelMinOreInterval: TLabel
        Left = 16
        Top = 32
        Width = 122
        Height = 16
        Caption = 'Minimum ore interval'
      end
      object LabelMaxWasteInterval: TLabel
        Left = 16
        Top = 72
        Width = 141
        Height = 16
        Caption = 'Maximum waste interval'
      end
      object LabelCutoffGrade: TLabel
        Left = 351
        Top = 32
        Width = 72
        Height = 16
        Caption = 'Cutoff grade'
      end
      object LabelOutputField: TLabel
        Left = 352
        Top = 72
        Width = 66
        Height = 16
        Caption = 'Output field'
      end
      object evMinOreInterval: TGBEditValue
        Left = 230
        Top = 24
        Width = 54
        Height = 24
        TabOrder = 0
        Text = '0'
        Parent = GroupBoxConditions
        EnabledConvert = True
        AsInteger = 0
        ValueType = vtDouble
        Error = False
        Precision = 0
      end
      object evMaxWasteInterval: TGBEditValue
        Left = 230
        Top = 64
        Width = 54
        Height = 24
        TabOrder = 1
        Text = '0'
        Parent = GroupBoxConditions
        EnabledConvert = True
        AsInteger = 0
        ValueType = vtDouble
        Error = False
        Precision = 0
      end
      object evCutOffGrade: TGBEditValue
        Left = 558
        Top = 24
        Width = 54
        Height = 24
        TabOrder = 2
        Text = '0'
        Parent = GroupBoxConditions
        EnabledConvert = True
        AsInteger = 0
        ValueType = vtDouble
        Error = False
        Precision = 0
      end
    end
  end
  inherited PanelBottom: TPanel
    Top = 415
    Width = 650
    StyleElements = [seFont, seClient, seBorder]
    ExplicitTop = 415
    ExplicitWidth = 650
    inherited ButtonOK: TButton
      Left = 306
      ExplicitLeft = 306
    end
    inherited ButtonCancel: TButton
      Left = 426
      ExplicitLeft = 426
    end
    inherited ButtonHelp: TButton
      Left = 540
      ExplicitLeft = 540
    end
  end
  object EditOutputFieldName: TEdit [3]
    Left = 456
    Top = 318
    Width = 161
    Height = 24
    TabOrder = 3
    Text = 'ORETYPE'
  end
end
