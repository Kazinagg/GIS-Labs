inherited FormMethodSetOperations: TFormMethodSetOperations
  Left = 206
  Top = 119
  HelpContext = 318
  Caption = 'Set Operations'
  ClientHeight = 477
  ClientWidth = 761
  StyleElements = [seFont, seClient, seBorder]
  ExplicitWidth = 787
  ExplicitHeight = 526
  TextHeight = 16
  inherited PanelTop: TPanel
    Width = 761
    StyleElements = [seFont, seClient, seBorder]
    ExplicitWidth = 761
    inherited GroupBoxInput: TGroupBox
      Width = 372
      ExplicitWidth = 372
      inherited PanelInputPath: TPanel
        Width = 368
        StyleElements = [seFont, seClient, seBorder]
        ExplicitWidth = 368
      end
      inherited PanelInputButtons: TPanel
        Width = 368
        StyleElements = [seFont, seClient, seBorder]
        ExplicitWidth = 368
        inherited ToolBarRight: TToolBar
          Left = 319
          Width = 44
          AutoSize = True
          ExplicitLeft = 319
          ExplicitWidth = 44
        end
      end
      inherited GroupBoxRealAttribute: TGroupBox
        Width = 182
        ExplicitWidth = 182
        inherited ListBoxRealAttribute: TListBox
          Width = 178
          ExtendedSelect = False
          MultiSelect = False
          StyleElements = [seFont, seClient, seBorder]
          ExplicitWidth = 178
        end
      end
      inherited GroupBoxModel: TGroupBox
        inherited ListBoxInputNames: TListBox
          StyleElements = [seFont, seClient, seBorder]
        end
      end
    end
    inherited GroupBoxInputB: TGroupBox
      Left = 387
      Width = 369
      ExplicitLeft = 387
      ExplicitWidth = 369
      inherited PanelInputPathB: TPanel
        Width = 365
        StyleElements = [seFont, seClient, seBorder]
        ExplicitWidth = 365
      end
      inherited PanelInputButtonsB: TPanel
        Width = 365
        StyleElements = [seFont, seClient, seBorder]
        ExplicitWidth = 365
        inherited ToolBarInputB: TToolBar
          Width = 251
          ButtonHeight = 23
          ExplicitWidth = 251
          inherited ToolButton5: TToolButton
            ExplicitHeight = 23
          end
          inherited ToolButtonHolesB: TToolButton
            ExplicitHeight = 23
          end
          inherited ToolButtonPoints2DB: TToolButton
            ExplicitHeight = 23
          end
          inherited ToolButtonPoints3DB: TToolButton
            ExplicitHeight = 23
          end
          inherited ToolButtonPolygonsB: TToolButton
            ExplicitHeight = 23
          end
          inherited ToolButtonTinsB: TToolButton
            ExplicitHeight = 23
          end
          inherited ToolButtonSolidsB: TToolButton
            ExplicitHeight = 23
          end
          inherited ToolButtonGrids2DB: TToolButton
            ExplicitHeight = 23
          end
          inherited ToolButtonGrids3DB: TToolButton
            ExplicitHeight = 23
          end
          inherited ToolButtonMeshes2DB: TToolButton
            ExplicitHeight = 23
          end
          inherited ToolButtonMeshes3DB: TToolButton
            ExplicitHeight = 23
          end
          inherited ToolButton16: TToolButton
            Width = 13
            ExplicitWidth = 13
            ExplicitHeight = 23
          end
        end
        inherited ToolBarBRight: TToolBar
          Left = 314
          Width = 46
          AutoSize = True
          ExplicitLeft = 314
          ExplicitWidth = 46
        end
      end
      inherited GroupBoxModelB: TGroupBox
        inherited ListBoxInputNamesB: TListBox
          StyleElements = [seFont, seClient, seBorder]
        end
      end
      inherited GroupBoxRealAttributeB: TGroupBox
        Width = 176
        ExplicitWidth = 176
        inherited ListBoxRealAttributeB: TListBox
          Width = 172
          ExtendedSelect = False
          MultiSelect = False
          StyleElements = [seFont, seClient, seBorder]
          ExplicitWidth = 172
        end
      end
    end
  end
  inherited PanelMiddle: TPanel
    Width = 761
    Height = 207
    StyleElements = [seFont, seClient, seBorder]
    ExplicitWidth = 761
    ExplicitHeight = 207
    inherited GroupBoxOutput: TGroupBox
      Top = 146
      Width = 751
      ExplicitTop = 146
      ExplicitWidth = 751
      inherited ToolBarShowAs: TToolBar
        Width = 747
        ExplicitWidth = 747
        inherited PanelOutPath: TPanel
          Width = 408
          StyleElements = [seFont, seClient, seBorder]
          ExplicitWidth = 408
        end
        inherited EditOutName: TEdit
          Left = 485
          StyleElements = [seFont, seClient, seBorder]
          ExplicitLeft = 485
        end
        inherited SpeedButtonOutputBrowse: TSpeedButton
          Left = 686
          ExplicitLeft = 686
        end
      end
    end
    object GroupBoxOperation: TGroupBox
      Left = 5
      Top = 5
      Width = 751
      Height = 141
      Align = alClient
      Caption = 'Operation'
      TabOrder = 1
      object RadioGroupOperation: TRadioGroup
        Left = 304
        Top = 16
        Width = 137
        Height = 111
        Hint = 'Operation'
        ItemIndex = 2
        Items.Strings = (
          'Union'
          'Difference'
          'Intersection')
        TabOrder = 0
        OnClick = RadioGroupOperationClick
      end
    end
  end
  inherited PanelBottom: TPanel
    Top = 425
    Width = 761
    StyleElements = [seFont, seClient, seBorder]
    ExplicitTop = 425
    ExplicitWidth = 761
    inherited ProgressBar: TProgressBar
      Width = 352
      ExplicitWidth = 352
    end
    inherited ButtonOK: TButton
      Left = 420
      ExplicitLeft = 420
    end
    inherited ButtonCancel: TButton
      Left = 529
      ExplicitLeft = 529
    end
    inherited ButtonHelp: TButton
      Left = 643
      ExplicitLeft = 643
    end
  end
end
