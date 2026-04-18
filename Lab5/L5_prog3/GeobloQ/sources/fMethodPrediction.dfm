inherited FormMethodPrediction: TFormMethodPrediction
  Left = 235
  Top = 84
  HelpContext = 315
  Caption = 'Dressing Prediction'
  ClientHeight = 561
  ClientWidth = 600
  StyleElements = [seFont, seClient, seBorder]
  ExplicitWidth = 626
  ExplicitHeight = 610
  TextHeight = 16
  inherited PanelTop: TPanel
    Width = 600
    Height = 185
    StyleElements = [seFont, seClient, seBorder]
    ExplicitWidth = 600
    ExplicitHeight = 185
    inherited GroupBoxInput: TGroupBox
      Width = 590
      Height = 175
      ExplicitWidth = 590
      ExplicitHeight = 175
      inherited PanelInputPath: TPanel
        Width = 586
        StyleElements = [seFont, seClient, seBorder]
        ExplicitWidth = 586
      end
      inherited PanelInputButtons: TPanel
        Width = 586
        StyleElements = [seFont, seClient, seBorder]
        ExplicitWidth = 586
        inherited ToolBarInput: TToolBar
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
          Left = 526
          ExplicitLeft = 526
        end
      end
      inherited GroupBoxRealAttribute: TGroupBox
        Left = 297
        Width = 291
        Height = 91
        ExplicitLeft = 297
        ExplicitWidth = 291
        ExplicitHeight = 91
        inherited ListBoxRealAttribute: TListBox
          Width = 287
          Height = 71
          ExtendedSelect = False
          MultiSelect = False
          StyleElements = [seFont, seClient, seBorder]
          ExplicitWidth = 287
          ExplicitHeight = 71
        end
      end
      inherited GroupBoxModel: TGroupBox
        Width = 295
        Height = 91
        ExplicitWidth = 295
        ExplicitHeight = 91
        inherited ListBoxInputNames: TListBox
          Width = 291
          Height = 71
          StyleElements = [seFont, seClient, seBorder]
          ExplicitWidth = 291
          ExplicitHeight = 71
        end
      end
    end
  end
  inherited PanelMiddle: TPanel
    Top = 185
    Width = 600
    Height = 330
    StyleElements = [seFont, seClient, seBorder]
    ExplicitTop = 185
    ExplicitWidth = 600
    ExplicitHeight = 330
    inherited GroupBoxOutput: TGroupBox
      Top = 271
      Width = 590
      ExplicitTop = 271
      ExplicitWidth = 590
      inherited ToolBarShowAs: TToolBar
        Width = 586
        ExplicitWidth = 586
        inherited PanelOutPath: TPanel
          Width = 344
          StyleElements = [seFont, seClient, seBorder]
          ExplicitWidth = 344
        end
        inherited EditOutName: TEdit
          Left = 421
          Width = 113
          StyleElements = [seFont, seClient, seBorder]
          ExplicitLeft = 421
          ExplicitWidth = 113
        end
        inherited SpeedButtonOutputBrowse: TSpeedButton
          Left = 534
          ExplicitLeft = 534
        end
      end
    end
    object RadioGroupGrainSize: TRadioGroup
      Left = 5
      Top = 5
      Width = 590
      Height = 57
      Align = alTop
      Caption = 'Grain size'
      Columns = 2
      ItemIndex = 0
      Items.Strings = (
        'Constant'
        'Variable')
      TabOrder = 1
    end
    object GroupBoxGranulometry: TGroupBox
      Left = 5
      Top = 62
      Width = 300
      Height = 209
      Align = alLeft
      Caption = 'Particles Distribution '
      ParentShowHint = False
      ShowHint = False
      TabOrder = 2
      object PanelDistributionButtons: TPanel
        Left = 2
        Top = 18
        Width = 296
        Height = 27
        Align = alTop
        TabOrder = 0
        object SpeedButtonASTM: TSpeedButton
          Left = 37
          Top = 1
          Width = 25
          Height = 24
          Hint = 'ASTM scale'
          GroupIndex = 1
          Glyph.Data = {
            F6000000424DF600000000000000760000002800000010000000100000000100
            0400000000008000000000000000000000001000000000000000000000000000
            80000080000000808000800000008000800080800000C0C0C000808080000000
            FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00777777777777
            77777774E7774E7774E77774E7774E7774E77774E7774E7474E77774E7774E44
            44E7744444E7444744E7744444E7447774E77777777777777777774E77477E44
            4E77774E7747747774777744444777774477774E77477744E7777744E74774E7
            77777774E74774777477777744E77E444E777777777777777777}
          ParentShowHint = False
          ShowHint = True
          Transparent = False
          OnClick = SpeedButtonASTMClick
        end
        object SpeedButtonPower: TSpeedButton
          Left = 9
          Top = 1
          Width = 24
          Height = 24
          Hint = 'Scale with power 2'
          GroupIndex = 1
          Down = True
          Glyph.Data = {
            F6000000424DF600000000000000760000002800000010000000100000000100
            0400000000008000000000000000000000001000000000000000000000000000
            80000080000000808000800000008000800080800000C0C0C000808080000000
            FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00777777777777
            7777777E44447777777777744EEE7777777777744E777777777777744E777777
            777777744E7744444E7777744E7744444E7777744E7744E7777777777777744E
            777777744E777744E77777744E7777744E77777EE77744744E77777777774474
            4E777777777744444E77777777777444E7777777777777777777}
          ParentShowHint = False
          ShowHint = True
          Transparent = False
          OnClick = SpeedButtonPowerClick
        end
      end
      object PanelDistribution: TPanel
        Left = 2
        Top = 45
        Width = 296
        Height = 162
        Align = alClient
        TabOrder = 1
        object StringGridMillProduct: TStringGrid
          Left = 1
          Top = 18
          Width = 294
          Height = 143
          Align = alClient
          ColCount = 3
          DefaultRowHeight = 18
          FixedCols = 2
          RowCount = 12
          FixedRows = 0
          Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goEditing]
          ScrollBars = ssVertical
          TabOrder = 0
          ColWidths = (
            57
            111
            146)
          RowHeights = (
            18
            18
            21
            19
            18
            20
            19
            18
            18
            18
            18
            18)
        end
        object HeaderControlSizes: THeaderControl
          Left = 1
          Top = 1
          Width = 294
          Height = 17
          Sections = <
            item
              ImageIndex = -1
              MaxWidth = 60
              MinWidth = 60
              Text = 'Class'
              Width = 60
            end
            item
              ImageIndex = -1
              MaxWidth = 112
              MinWidth = 110
              Text = 'Range'
              Width = 112
            end
            item
              ImageIndex = -1
              MaxWidth = 120
              MinWidth = 120
              Text = 'Value'
              Width = 120
            end>
          Style = hsFlat
        end
      end
    end
    object GroupBoxRecovery: TGroupBox
      Left = 305
      Top = 62
      Width = 290
      Height = 209
      Align = alClient
      Caption = 'Recovery Function'
      ParentShowHint = False
      ShowHint = False
      TabOrder = 3
      object PanelRecoveryButtons: TPanel
        Left = 2
        Top = 18
        Width = 286
        Height = 29
        Align = alTop
        TabOrder = 0
        DesignSize = (
          286
          29)
        object SpeedButtonLognorm: TSpeedButton
          Left = 43
          Top = 1
          Width = 25
          Height = 24
          Hint = 'Lognormal scale'
          Anchors = [akTop, akRight]
          GroupIndex = 2
          Glyph.Data = {
            F6000000424DF600000000000000760000002800000010000000100000000100
            0400000000008000000000000000000000001000000000000000000000000000
            80000080000000808000800000008000800080800000C0C0C000808080000000
            FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00777777777777
            7777744E777777777777744E77777777777777447777777777777744E7777777
            7777777447777777777777744E77777777777777447777777777777744E77777
            77777777744E77777777777777447777777777777744E77777777777777444E7
            777777777777444444E777777777774444477777777777777777}
          ParentShowHint = False
          ShowHint = True
          Transparent = False
          OnClick = SpeedButtonLognormClick
        end
        object SpeedButtonUniform: TSpeedButton
          Left = 14
          Top = 1
          Width = 26
          Height = 24
          Hint = 'Uniform scale'
          Anchors = [akTop, akRight]
          GroupIndex = 2
          Down = True
          Glyph.Data = {
            F6000000424DF600000000000000760000002800000010000000100000000100
            0400000000008000000000000000000000001000000000000000000000000000
            80000080000000808000800000008000800080800000C0C0C000808080000000
            FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00777777777777
            777774444E777777777774444E777777777777744E777777777777744E777777
            7777777444444E777777777444444E777777777777744E777777777777744E77
            77777777777444444E777777777444444E777777777777744E77777777777774
            4E77777777777774444777777777777444477777777777777777}
          ParentShowHint = False
          ShowHint = True
          Transparent = False
          OnClick = SpeedButtonUniformClick
        end
      end
      object PanelFunction: TPanel
        Left = 2
        Top = 47
        Width = 286
        Height = 160
        Align = alClient
        TabOrder = 1
        object StringGridRecoveryProduct: TStringGrid
          Left = 1
          Top = 18
          Width = 284
          Height = 141
          Align = alClient
          ColCount = 3
          DefaultRowHeight = 18
          FixedCols = 2
          RowCount = 12
          FixedRows = 0
          Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goEditing]
          ScrollBars = ssVertical
          TabOrder = 0
          ColWidths = (
            62
            112
            108)
          RowHeights = (
            18
            18
            18
            19
            18
            18
            18
            18
            18
            18
            18
            19)
        end
        object HeaderControlRecoveries: THeaderControl
          Left = 1
          Top = 1
          Width = 284
          Height = 17
          Sections = <
            item
              ImageIndex = -1
              MaxWidth = 70
              MinWidth = 65
              Text = 'Class'
              Width = 65
            end
            item
              ImageIndex = -1
              MaxWidth = 115
              MinWidth = 114
              Text = 'Range'
              Width = 114
            end
            item
              ImageIndex = -1
              MaxWidth = 100
              MinWidth = 95
              Text = 'Value'
              Width = 100
            end>
          Style = hsFlat
        end
      end
    end
    object SpinEditGrain: TSpinEdit
      Left = 199
      Top = 25
      Width = 65
      Height = 26
      MaxValue = 1000
      MinValue = 1
      TabOrder = 4
      Value = 50
    end
  end
  inherited PanelBottom: TPanel
    Top = 515
    Width = 600
    StyleElements = [seFont, seClient, seBorder]
    ExplicitTop = 515
    ExplicitWidth = 600
    inherited ButtonOK: TButton
      Left = 278
      ExplicitLeft = 278
    end
    inherited ButtonCancel: TButton
      Left = 388
      ExplicitLeft = 388
    end
    inherited ButtonHelp: TButton
      Left = 492
      ExplicitLeft = 492
    end
  end
end
