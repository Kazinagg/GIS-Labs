inherited fmComposeCenters: TfmComposeCenters
  Tag = 1
  Left = 207
  Top = 145
  HelpContext = 302
  Caption = 'Coordinates of Centers'
  ClientHeight = 493
  ClientWidth = 627
  StyleElements = [seFont, seClient, seBorder]
  ExplicitWidth = 653
  ExplicitHeight = 542
  TextHeight = 16
  inherited PanelTop: TPanel
    Width = 627
    StyleElements = [seFont, seClient, seBorder]
    ExplicitWidth = 627
    inherited GroupBoxInput: TGroupBox
      Width = 617
      ParentFont = False
      ExplicitWidth = 617
      inherited PanelInputPath: TPanel
        Width = 613
        ParentFont = False
        StyleElements = [seFont, seClient, seBorder]
        ExplicitWidth = 613
      end
      inherited PanelInputButtons: TPanel
        Width = 613
        ParentFont = False
        StyleElements = [seFont, seClient, seBorder]
        ExplicitTop = 12
        ExplicitWidth = 613
        inherited ToolBarInput: TToolBar
          Width = 257
          ExplicitWidth = 257
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
          inherited ToolButton2: TToolButton
            Width = 19
            ExplicitWidth = 19
          end
        end
        inherited ToolBarRight: TToolBar
          Left = 553
          ExplicitLeft = 553
        end
      end
      inherited GroupBoxRealAttribute: TGroupBox
        Left = 297
        Width = 318
        ParentFont = False
        ExplicitLeft = 297
        ExplicitWidth = 318
        inherited ListBoxRealAttribute: TListBox
          Width = 314
          ExtendedSelect = False
          ParentFont = False
          StyleElements = [seFont, seClient, seBorder]
          ExplicitWidth = 314
        end
        object CheckBoxAll: TCheckBox
          Left = 264
          Top = 0
          Width = 49
          Height = 17
          Caption = 'All'
          Checked = True
          State = cbChecked
          TabOrder = 1
          OnClick = CheckBoxAllClick
        end
      end
      inherited GroupBoxModel: TGroupBox
        Width = 295
        ParentFont = False
        ExplicitWidth = 295
        inherited ListBoxInputNames: TListBox
          Width = 291
          ParentFont = False
          StyleElements = [seFont, seClient, seBorder]
          ExplicitWidth = 291
        end
      end
    end
  end
  inherited PanelMiddle: TPanel
    Width = 627
    Height = 200
    StyleElements = [seFont, seClient, seBorder]
    ExplicitWidth = 627
    ExplicitHeight = 200
    inherited GroupBoxOutput: TGroupBox
      Top = 141
      Width = 617
      TabOrder = 2
      ExplicitTop = 141
      ExplicitWidth = 617
      inherited ToolBarShowAs: TToolBar
        Width = 613
        Height = 23
        ButtonHeight = 23
        ExplicitWidth = 613
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
          Width = 344
          Height = 23
          StyleElements = [seFont, seClient, seBorder]
          ExplicitWidth = 344
          ExplicitHeight = 23
        end
        inherited EditOutName: TEdit
          Left = 421
          Height = 23
          StyleElements = [seFont, seClient, seBorder]
          ExplicitLeft = 421
          ExplicitHeight = 23
        end
        inherited SpeedButtonOutputBrowse: TSpeedButton
          Left = 557
          Height = 23
          ExplicitLeft = 557
          ExplicitHeight = 23
        end
        object ToolButton4: TToolButton
          Left = 580
          Top = 0
        end
      end
    end
    object GroupBoxMode: TGroupBox
      Left = 203
      Top = 5
      Width = 184
      Height = 136
      Align = alLeft
      Caption = 'Mode'
      TabOrder = 0
      object RadioButtonAveraging: TRadioButton
        Left = 25
        Top = 73
        Width = 112
        Height = 16
        Caption = 'Averaging'
        TabOrder = 0
      end
      object RadioButtonUndercutting: TRadioButton
        Left = 25
        Top = 41
        Width = 112
        Height = 16
        Caption = 'Undercutting'
        Checked = True
        TabOrder = 1
        TabStop = True
      end
    end
    object GroupBoxParameters: TGroupBox
      Left = 387
      Top = 5
      Width = 235
      Height = 136
      Align = alClient
      Caption = 'Parameters'
      TabOrder = 1
      object LabelOrigin: TLabel
        Left = 18
        Top = 41
        Width = 35
        Height = 16
        Caption = 'Origin'
      end
      object LabelThickness: TLabel
        Left = 16
        Top = 73
        Width = 62
        Height = 16
        Caption = 'Thickness'
      end
      object LabelNumber: TLabel
        Left = 16
        Top = 105
        Width = 48
        Height = 16
        Caption = 'Number'
      end
      object LabelZ: TLabel
        Left = 120
        Top = 40
        Width = 8
        Height = 16
        Caption = 'Z'
      end
      object GBEditValueOrigin: TGBEditValue
        Left = 144
        Top = 32
        Width = 65
        Height = 24
        TabOrder = 0
        Text = '0'
        Parent = GroupBoxParameters
        EnabledConvert = True
        AsInteger = 0
        ValueType = vtDouble
        Error = False
        Precision = 0
      end
      object GBEditValueThickness: TGBEditValue
        Left = 144
        Top = 62
        Width = 65
        Height = 24
        TabOrder = 1
        Text = '0'
        Parent = GroupBoxParameters
        EnabledConvert = True
        AsInteger = 0
        ValueType = vtDouble
        Error = False
        Precision = 0
      end
      object GBEditValueNumber: TGBEditValue
        Left = 144
        Top = 96
        Width = 65
        Height = 24
        TabOrder = 2
        Text = '0'
        Parent = GroupBoxParameters
        EnabledConvert = True
        AsInteger = 0
        ValueType = vtDouble
        Error = False
        Precision = 0
      end
    end
    object RadioGroupInterval: TRadioGroup
      Left = 5
      Top = 5
      Width = 198
      Height = 136
      Align = alLeft
      Caption = 'Interval'
      ItemIndex = 0
      Items.Strings = (
        'Sample'
        'Layer'
        'Segment')
      TabOrder = 3
      OnClick = RadioGroupIntervalClick
    end
  end
  inherited PanelBottom: TPanel
    Top = 447
    Width = 627
    StyleElements = [seFont, seClient, seBorder]
    ExplicitTop = 447
    ExplicitWidth = 627
    inherited ButtonOK: TButton
      Left = 284
      ExplicitLeft = 284
    end
    inherited ButtonCancel: TButton
      Left = 403
      ExplicitLeft = 403
    end
    inherited ButtonHelp: TButton
      Left = 518
      ExplicitLeft = 518
    end
  end
end
