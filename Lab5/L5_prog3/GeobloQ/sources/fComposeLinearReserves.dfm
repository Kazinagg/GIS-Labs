inherited fmComposeLinearReserves: TfmComposeLinearReserves
  Tag = 1
  Left = 349
  Top = 135
  HelpContext = 305
  Caption = 'Linear Reserves'
  ClientHeight = 479
  ClientWidth = 628
  StyleElements = [seFont, seClient, seBorder]
  ExplicitWidth = 654
  ExplicitHeight = 528
  TextHeight = 16
  inherited PanelTop: TPanel
    Width = 628
    StyleElements = [seFont, seClient, seBorder]
    ExplicitWidth = 628
    inherited GroupBoxInput: TGroupBox
      Width = 618
      ExplicitWidth = 618
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
          Left = 554
          ExplicitLeft = 554
        end
      end
      inherited GroupBoxRealAttribute: TGroupBox
        Left = 326
        Width = 290
        ExplicitLeft = 326
        ExplicitWidth = 290
        inherited ListBoxRealAttribute: TListBox
          Width = 286
          ExtendedSelect = False
          MultiSelect = False
          StyleElements = [seFont, seClient, seBorder]
          ExplicitWidth = 286
        end
      end
      inherited GroupBoxModel: TGroupBox
        Width = 324
        ExplicitWidth = 324
        inherited ListBoxInputNames: TListBox
          Width = 320
          StyleElements = [seFont, seClient, seBorder]
          ExplicitWidth = 320
        end
      end
    end
  end
  inherited PanelMiddle: TPanel
    Width = 628
    Height = 186
    StyleElements = [seFont, seClient, seBorder]
    ExplicitWidth = 628
    ExplicitHeight = 186
    object LabelIndicator: TLabel [0]
      Left = 16
      Top = 24
      Width = 51
      Height = 16
      Caption = 'Indicator'
    end
    object LabelActiveOreType: TLabel [1]
      Left = 344
      Top = 24
      Width = 129
      Height = 16
      Caption = 'Active ore type or sort'
    end
    inherited GroupBoxOutput: TGroupBox
      Top = 127
      Width = 618
      TabOrder = 2
      ExplicitTop = 127
      ExplicitWidth = 618
      inherited ToolBarShowAs: TToolBar
        Width = 614
        ExplicitWidth = 614
        inherited PanelOutPath: TPanel
          Width = 344
          StyleElements = [seFont, seClient, seBorder]
          ExplicitWidth = 344
        end
        inherited EditOutName: TEdit
          Left = 421
          StyleElements = [seFont, seClient, seBorder]
          ExplicitLeft = 421
        end
        inherited SpeedButtonOutputBrowse: TSpeedButton
          Left = 557
          ExplicitLeft = 557
        end
      end
    end
    object ListBoxIndicator: TListBox
      Left = 16
      Top = 43
      Width = 310
      Height = 73
      TabOrder = 0
      OnClick = ListBoxIndicatorClick
    end
    object ListBoxActiveInteger: TListBox
      Left = 336
      Top = 43
      Width = 281
      Height = 73
      TabOrder = 1
    end
  end
  inherited PanelBottom: TPanel
    Top = 433
    Width = 628
    StyleElements = [seFont, seClient, seBorder]
    ExplicitTop = 433
    ExplicitWidth = 628
    inherited ButtonOK: TButton
      Left = 314
      ExplicitLeft = 314
    end
    inherited ButtonCancel: TButton
      Left = 423
      ExplicitLeft = 423
    end
    inherited ButtonHelp: TButton
      Left = 528
      ExplicitLeft = 528
    end
  end
end
