inherited fmComposeOreSorts: TfmComposeOreSorts
  Left = 385
  Top = 86
  HelpContext = 303
  Caption = 'Ore Sorting'
  ClientHeight = 570
  ClientWidth = 621
  StyleElements = [seFont, seClient, seBorder]
  ExplicitWidth = 647
  ExplicitHeight = 619
  TextHeight = 16
  inherited PanelTop: TPanel
    Width = 621
    StyleElements = [seFont, seClient, seBorder]
    ExplicitWidth = 621
    inherited GroupBoxInput: TGroupBox
      Width = 611
      ExplicitWidth = 611
      inherited PanelInputPath: TPanel
        Width = 607
        StyleElements = [seFont, seClient, seBorder]
        ExplicitWidth = 607
      end
      inherited PanelInputButtons: TPanel
        Width = 607
        StyleElements = [seFont, seClient, seBorder]
        ExplicitWidth = 607
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
          Left = 547
          ExplicitLeft = 547
        end
      end
      inherited GroupBoxRealAttribute: TGroupBox
        Left = 297
        Width = 312
        ExplicitLeft = 297
        ExplicitWidth = 312
        inherited ListBoxRealAttribute: TListBox
          Width = 308
          ExtendedSelect = False
          MultiSelect = False
          StyleElements = [seFont, seClient, seBorder]
          ExplicitWidth = 308
        end
      end
      inherited GroupBoxModel: TGroupBox
        Width = 295
        ExplicitWidth = 295
        inherited ListBoxInputNames: TListBox
          Width = 291
          StyleElements = [seFont, seClient, seBorder]
          ExplicitWidth = 291
        end
      end
    end
  end
  inherited PanelMiddle: TPanel
    Width = 621
    Height = 277
    StyleElements = [seFont, seClient, seBorder]
    ExplicitWidth = 621
    ExplicitHeight = 277
    inherited GroupBoxOutput: TGroupBox
      Top = 218
      Width = 611
      ExplicitTop = 217
      ExplicitWidth = 611
      inherited ToolBarShowAs: TToolBar
        Width = 607
        ExplicitWidth = 607
        inherited PanelOutPath: TPanel
          Width = 328
          StyleElements = [seFont, seClient, seBorder]
          ExplicitWidth = 328
        end
        inherited EditOutName: TEdit
          Left = 405
          Width = 152
          StyleElements = [seFont, seClient, seBorder]
          ExplicitLeft = 405
          ExplicitWidth = 152
        end
        inherited SpeedButtonOutputBrowse: TSpeedButton
          Left = 557
          ExplicitLeft = 557
        end
      end
    end
    object GroupBoxByIntervals: TGroupBox
      Left = 5
      Top = 5
      Width = 284
      Height = 172
      Align = alLeft
      TabOrder = 1
      object LabelIndicator: TLabel
        Left = 16
        Top = 32
        Width = 76
        Height = 16
        Caption = 'Integer fields'
      end
      object LabelMinThickness: TLabel
        Left = 16
        Top = 136
        Width = 112
        Height = 16
        Caption = 'Minimum thickness'
      end
      object CheckBoxByIntervals: TCheckBox
        Left = 2
        Top = 1
        Width = 153
        Height = 17
        Caption = 'By intervals'
        TabOrder = 0
        OnClick = CheckBoxByIntervalsClick
      end
      object ListBoxIntegerAttributes: TListBox
        Left = 112
        Top = 32
        Width = 161
        Height = 81
        TabOrder = 1
      end
      object GBEditValueMinThickness: TGBEditValue
        Left = 199
        Top = 128
        Width = 74
        Height = 24
        TabOrder = 2
        Text = '0'
        Parent = GroupBoxByIntervals
        EnabledConvert = True
        AsInteger = 0
        ValueType = vtDouble
        Error = False
        Precision = 0
      end
    end
    object GroupBox: TGroupBox
      Left = 304
      Top = 5
      Width = 312
      Height = 172
      Align = alRight
      Caption = 'Classes'
      TabOrder = 2
      object StringGridClasses: TStringGrid
        Left = 2
        Top = 35
        Width = 308
        Height = 135
        Align = alClient
        ColCount = 4
        RowCount = 2
        FixedRows = 0
        Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goEditing]
        TabOrder = 0
        ColWidths = (
          64
          64
          64
          64)
        RowHeights = (
          24
          24)
      end
      object HeaderControlGrid: THeaderControl
        Left = 2
        Top = 18
        Width = 308
        Height = 17
        Sections = <
          item
            Alignment = taCenter
            ImageIndex = -1
            Text = 'No.'
            Width = 50
          end
          item
            Alignment = taCenter
            ImageIndex = -1
            Text = '>='
            Width = 90
          end
          item
            Alignment = taCenter
            ImageIndex = -1
            Text = '<'
            Width = 90
          end
          item
            Alignment = taCenter
            ImageIndex = -1
            Text = 'Kind'
            Width = 50
          end>
      end
    end
    object Panel1: TPanel
      Left = 5
      Top = 177
      Width = 611
      Height = 41
      Align = alBottom
      TabOrder = 3
      object LabelNumberOfClasses: TLabel
        Left = 315
        Top = 17
        Width = 112
        Height = 16
        Caption = 'Number of classes'
      end
      object LabelOutputField: TLabel
        Left = 19
        Top = 17
        Width = 66
        Height = 16
        Caption = 'Output field'
      end
      object EditOutputFieldName: TEdit
        Left = 114
        Top = 9
        Width = 161
        Height = 24
        TabOrder = 0
        Text = 'ORESORT'
      end
      object SpinEditClasses: TSpinEdit
        Left = 504
        Top = 8
        Width = 57
        Height = 26
        MaxValue = 12
        MinValue = 2
        TabOrder = 1
        Value = 2
        OnChange = SpinEditClassesChange
      end
    end
  end
  inherited PanelBottom: TPanel
    Top = 524
    Width = 621
    StyleElements = [seFont, seClient, seBorder]
    ExplicitTop = 524
    ExplicitWidth = 621
    inherited ButtonOK: TButton
      Left = 307
      ExplicitLeft = 307
    end
    inherited ButtonCancel: TButton
      Left = 417
      ExplicitLeft = 417
    end
    inherited ButtonHelp: TButton
      Left = 521
      ExplicitLeft = 521
    end
  end
end
