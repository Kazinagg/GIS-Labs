inherited fmComposeByHorizons: TfmComposeByHorizons
  Tag = 1
  Left = 364
  Top = 136
  HelpContext = 306
  Caption = 'Compose by Horizons'
  ClientHeight = 524
  StyleElements = [seFont, seClient, seBorder]
  OnDestroy = FormDestroy
  ExplicitHeight = 573
  TextHeight = 16
  inherited PanelTop: TPanel
    Height = 217
    StyleElements = [seFont, seClient, seBorder]
    ExplicitWidth = 554
    ExplicitHeight = 217
    inherited GroupBoxInput: TGroupBox
      Height = 207
      ExplicitWidth = 544
      ExplicitHeight = 207
      inherited PanelInputPath: TPanel
        StyleElements = [seFont, seClient, seBorder]
      end
      inherited PanelInputButtons: TPanel
        StyleElements = [seFont, seClient, seBorder]
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
      end
      inherited GroupBoxRealAttribute: TGroupBox
        Height = 123
        ExplicitWidth = 277
        ExplicitHeight = 123
        inherited ListBoxRealAttribute: TListBox
          Height = 103
          StyleElements = [seFont, seClient, seBorder]
          ExplicitWidth = 273
          ExplicitHeight = 103
        end
      end
      inherited GroupBoxModel: TGroupBox
        Height = 123
        ExplicitHeight = 123
        inherited ListBoxInputNames: TListBox
          Height = 103
          StyleElements = [seFont, seClient, seBorder]
          ExplicitHeight = 103
        end
      end
    end
  end
  inherited PanelMiddle: TPanel
    Top = 217
    Height = 261
    StyleElements = [seFont, seClient, seBorder]
    ExplicitTop = 217
    ExplicitHeight = 236
    inherited GroupBoxOutput: TGroupBox
      Top = 202
      TabOrder = 1
      ExplicitTop = 177
      inherited ToolBarShowAs: TToolBar
        inherited PanelOutPath: TPanel
          StyleElements = [seFont, seClient, seBorder]
        end
        inherited EditOutName: TEdit
          StyleElements = [seFont, seClient, seBorder]
        end
      end
    end
    object DBGridHorizonts: TDBGrid
      Left = 5
      Top = 64
      Width = 544
      Height = 138
      Align = alClient
      DataSource = DataSourceHorizons
      Options = [dgEditing, dgTitles, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgConfirmDelete, dgCancelOnExit]
      TabOrder = 0
      TitleFont.Charset = DEFAULT_CHARSET
      TitleFont.Color = clWindowText
      TitleFont.Height = -13
      TitleFont.Name = 'MS Sans Serif'
      TitleFont.Style = []
      Columns = <
        item
          Expanded = False
          FieldName = 'Start'
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'Thickness'
          Width = 143
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'Count'
          Width = 150
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'To'
          ReadOnly = True
          Title.Caption = 'Last'
          Width = 139
          Visible = True
        end>
    end
    object GroupBoxHorizons: TGroupBox
      Left = 5
      Top = 5
      Width = 544
      Height = 59
      Align = alTop
      Caption = 'Horizons'
      TabOrder = 2
      ExplicitWidth = 536
      DesignSize = (
        544
        59)
      object SpeedButtonHorizonsBrowse: TSpeedButton
        Left = 502
        Top = 26
        Width = 22
        Height = 23
        Hint = 'Browse'
        Anchors = [akTop, akRight]
        Caption = '...'
        ParentShowHint = False
        ShowHint = True
        OnClick = SpeedButtonInputBrowseClick
      end
      object PanelTableHorizons: TPanel
        Left = 16
        Top = 24
        Width = 481
        Height = 25
        Alignment = taLeftJustify
        BevelOuter = bvLowered
        ParentShowHint = False
        ShowHint = True
        TabOrder = 0
      end
    end
  end
  inherited PanelBottom: TPanel
    Top = 478
    StyleElements = [seFont, seClient, seBorder]
    ExplicitTop = 453
  end
  object DataSourceHorizons: TDataSource
    DataSet = TableHorizons
    Left = 176
    Top = 128
  end
  object TableHorizons: TTable
    BeforeEdit = TableHorizonsBeforeEdit
    BeforePost = TableHorizonsBeforePost
    AfterPost = TableHorizonsAfterPost
    OnCalcFields = TableHorizonsCalcFields
    Left = 320
    Top = 120
    object TableHorizonsStart: TFloatField
      FieldName = 'Start'
    end
    object TableHorizonsThickness: TFloatField
      FieldName = 'Thickness'
    end
    object TableHorizonsCount: TIntegerField
      FieldName = 'Count'
    end
    object TableHorizonsTo: TFloatField
      FieldKind = fkCalculated
      FieldName = 'To'
      Calculated = True
    end
  end
end
