inherited FormMethodPitOptimization: TFormMethodPitOptimization
  Caption = 'Pit Optimization'
  StyleElements = [seFont, seClient, seBorder]
  TextHeight = 16
  inherited PanelTop: TPanel
    Height = 241
    StyleElements = [seFont, seClient, seBorder]
    ExplicitWidth = 554
    ExplicitHeight = 241
    inherited GroupBoxInput: TGroupBox
      Height = 231
      ExplicitWidth = 544
      ExplicitHeight = 231
      inherited PanelInputPath: TPanel
        StyleElements = [seFont, seClient, seBorder]
      end
      inherited PanelInputButtons: TPanel
        StyleElements = [seFont, seClient, seBorder]
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
      end
      inherited GroupBoxRealAttribute: TGroupBox
        Height = 147
        ExplicitWidth = 277
        ExplicitHeight = 147
        inherited ListBoxRealAttribute: TListBox
          Height = 127
          StyleElements = [seFont, seClient, seBorder]
          ExplicitWidth = 273
          ExplicitHeight = 127
        end
      end
      inherited GroupBoxModel: TGroupBox
        Height = 147
        ExplicitHeight = 147
        inherited ListBoxInputNames: TListBox
          Height = 127
          StyleElements = [seFont, seClient, seBorder]
          ExplicitHeight = 127
        end
      end
    end
  end
  inherited PanelMiddle: TPanel
    Top = 241
    Height = 216
    StyleElements = [seFont, seClient, seBorder]
    ExplicitTop = 241
    ExplicitHeight = 216
    inherited GroupBoxOutput: TGroupBox
      Top = 157
      ExplicitTop = 157
      inherited ToolBarShowAs: TToolBar
        inherited PanelOutPath: TPanel
          StyleElements = [seFont, seClient, seBorder]
        end
        inherited EditOutName: TEdit
          StyleElements = [seFont, seClient, seBorder]
        end
      end
    end
    object RadioGroupMethod: TRadioGroup
      Left = 12
      Top = 6
      Width = 530
      Height = 145
      Caption = 'Method'
      Columns = 2
      ItemIndex = 0
      Items.Strings = (
        'Floating Cone'
        'Lerchs Grossmann'
        'Maximum Pseudo Flow'
        'Genetic Algorithm'
        'Ant Colony'
        'Particle Swarm')
      TabOrder = 1
      OnClick = RadioGroupMethodClick
    end
  end
  inherited PanelBottom: TPanel
    StyleElements = [seFont, seClient, seBorder]
    inherited ButtonOK: TButton
      Left = 192
    end
    inherited ButtonCancel: TButton
      Left = 302
    end
    inherited ButtonHelp: TButton
      Left = 406
    end
  end
end
