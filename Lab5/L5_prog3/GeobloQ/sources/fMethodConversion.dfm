inherited FormMethodConversion: TFormMethodConversion
  Left = 268
  Top = 134
  HelpContext = 132
  Caption = 'Conversion'
  ClientHeight = 436
  ClientWidth = 623
  StyleElements = [seFont, seClient, seBorder]
  ExplicitWidth = 649
  ExplicitHeight = 485
  TextHeight = 16
  inherited PanelTop: TPanel
    Width = 623
    StyleElements = [seFont, seClient, seBorder]
    ExplicitWidth = 623
    inherited GroupBoxInput: TGroupBox
      Width = 613
      ExplicitWidth = 613
      inherited PanelInputPath: TPanel
        Width = 609
        StyleElements = [seFont, seClient, seBorder]
        ExplicitWidth = 609
      end
      inherited PanelInputButtons: TPanel
        Width = 609
        StyleElements = [seFont, seClient, seBorder]
        ExplicitWidth = 609
        inherited ToolBarRight: TToolBar
          Left = 549
          ExplicitLeft = 549
        end
      end
      inherited GroupBoxRealAttribute: TGroupBox
        Left = 305
        Width = 306
        ExplicitLeft = 305
        ExplicitWidth = 306
        inherited ListBoxRealAttribute: TListBox
          Width = 302
          Enabled = False
          ExtendedSelect = False
          MultiSelect = False
          StyleElements = [seFont, seClient, seBorder]
          ExplicitWidth = 302
        end
      end
      inherited GroupBoxModel: TGroupBox
        Width = 303
        ExplicitWidth = 303
        inherited ListBoxInputNames: TListBox
          Width = 299
          StyleElements = [seFont, seClient, seBorder]
          ExplicitWidth = 299
        end
      end
    end
  end
  inherited PanelMiddle: TPanel
    Width = 623
    Height = 143
    StyleElements = [seFont, seClient, seBorder]
    ExplicitWidth = 623
    ExplicitHeight = 143
    inherited GroupBoxOutput: TGroupBox
      Top = 41
      Width = 613
      Height = 97
      ExplicitTop = 41
      ExplicitWidth = 613
      ExplicitHeight = 97
      inherited ToolBarShowAs: TToolBar
        Top = 73
        Width = 609
        Align = alBottom
        ExplicitTop = 73
        ExplicitWidth = 609
        inherited PanelOutPath: TPanel
          Width = 360
          StyleElements = [seFont, seClient, seBorder]
          ExplicitWidth = 360
        end
        inherited EditOutName: TEdit
          Left = 437
          Width = 122
          StyleElements = [seFont, seClient, seBorder]
          ExplicitLeft = 437
          ExplicitWidth = 122
        end
        inherited SpeedButtonOutputBrowse: TSpeedButton
          Left = 559
          ExplicitLeft = 559
        end
      end
      object ToolBarOutput: TToolBar
        Left = 2
        Top = 18
        Width = 609
        Height = 22
        AutoSize = True
        Caption = 'Output model'
        EdgeInner = esNone
        EdgeOuter = esNone
        TabOrder = 1
        object ToolButton5: TToolButton
          Left = 0
          Top = 0
          Width = 8
          Caption = 'ToolButton1'
          ImageIndex = 76
          Style = tbsSeparator
        end
        object ToolButtonDholesOut: TToolButton
          Left = 8
          Top = 0
          Hint = 'Drillholes'
          Grouped = True
          ImageIndex = 32
          ParentShowHint = False
          ShowHint = True
          Style = tbsCheck
          OnClick = ToolButtonOutputClick
        end
        object ToolButtonPoints2DOut: TToolButton
          Tag = 1
          Left = 31
          Top = 0
          Hint = 'Points 2D'
          Grouped = True
          ImageIndex = 38
          ParentShowHint = False
          ShowHint = True
          Style = tbsCheck
          OnClick = ToolButtonOutputClick
        end
        object ToolButtonPoints3DOut: TToolButton
          Tag = 2
          Left = 54
          Top = 0
          Hint = 'Points 3D'
          Grouped = True
          ImageIndex = 41
          ParentShowHint = False
          ShowHint = True
          Style = tbsCheck
          OnClick = ToolButtonOutputClick
        end
        object ToolButtonPolygonsOut: TToolButton
          Tag = 3
          Left = 77
          Top = 0
          Hint = 'Polygons'
          Grouped = True
          ImageIndex = 44
          ParentShowHint = False
          ShowHint = True
          Style = tbsCheck
          OnClick = ToolButtonOutputClick
        end
        object ToolButtonTinOut: TToolButton
          Tag = 4
          Left = 100
          Top = 0
          Hint = 'Tin'
          Caption = '`'
          Grouped = True
          ImageIndex = 48
          ParentShowHint = False
          ShowHint = True
          Style = tbsCheck
          OnClick = ToolButtonOutputClick
        end
        object ToolButtonSolidsOut: TToolButton
          Tag = 5
          Left = 123
          Top = 0
          Hint = 'Solids'
          Grouped = True
          ImageIndex = 66
          ParentShowHint = False
          ShowHint = True
          Style = tbsCheck
          OnClick = ToolButtonOutputClick
        end
        object ToolButtonGrid2DOut: TToolButton
          Tag = 6
          Left = 146
          Top = 0
          Hint = 'Grid 2D'
          Grouped = True
          ImageIndex = 55
          ParentShowHint = False
          ShowHint = True
          Style = tbsCheck
          OnClick = ToolButtonOutputClick
        end
        object ToolButtonGrid3DOut: TToolButton
          Tag = 7
          Left = 169
          Top = 0
          Hint = 'Grid 3D'
          Grouped = True
          ImageIndex = 60
          ParentShowHint = False
          ShowHint = True
          Style = tbsCheck
          OnClick = ToolButtonOutputClick
        end
        object ToolButtonMesh2DOut: TToolButton
          Tag = 8
          Left = 192
          Top = 0
          Hint = 'Mesh 2D'
          Grouped = True
          ImageIndex = 69
          ParentShowHint = False
          ShowHint = True
          Style = tbsCheck
          OnClick = ToolButtonOutputClick
        end
        object ToolButtonMesh3DOut: TToolButton
          Tag = 9
          Left = 215
          Top = 0
          Hint = 'Mesh 3D'
          Grouped = True
          ImageIndex = 73
          ParentShowHint = False
          ShowHint = True
          Style = tbsCheck
          OnClick = ToolButtonOutputClick
        end
        object ToolButton16: TToolButton
          Left = 238
          Top = 0
          Width = 11
          Caption = 'ToolButton2'
          ImageIndex = 76
          Style = tbsSeparator
        end
      end
      object EditSolidBottom: TEdit
        Left = 453
        Top = 36
        Width = 65
        Height = 24
        Hint = 'Solid bottom'
        ParentShowHint = False
        ShowHint = True
        TabOrder = 2
        Text = '0'
        Visible = False
      end
      object CheckBoxSolidBottom: TCheckBox
        Left = 329
        Top = 42
        Width = 97
        Height = 22
        Hint = 'Check solid bottom'
        Caption = 'Solid bottom'
        TabOrder = 3
      end
    end
  end
  inherited PanelBottom: TPanel
    Top = 390
    Width = 623
    StyleElements = [seFont, seClient, seBorder]
    ExplicitTop = 390
    ExplicitWidth = 623
    inherited ButtonOK: TButton
      Left = 301
      ExplicitLeft = 301
    end
    inherited ButtonCancel: TButton
      Left = 411
      ExplicitLeft = 411
    end
    inherited ButtonHelp: TButton
      Left = 515
      ExplicitLeft = 515
    end
  end
end
