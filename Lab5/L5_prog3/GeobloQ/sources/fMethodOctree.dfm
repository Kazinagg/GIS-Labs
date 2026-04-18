inherited FormMethodOctree: TFormMethodOctree
  Caption = 'Octree Construction'
  StyleElements = [seFont, seClient, seBorder]
  TextHeight = 16
  inherited PanelTop: TPanel
    StyleElements = [seFont, seClient, seBorder]
    ExplicitWidth = 554
    inherited GroupBoxInput: TGroupBox
      ExplicitWidth = 544
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
          inherited ToolButtonMeshes2D: TToolButton
            Visible = False
          end
          inherited ToolButtonMeshes3D: TToolButton
            Visible = False
          end
        end
      end
      inherited GroupBoxRealAttribute: TGroupBox
        ExplicitWidth = 277
        inherited ListBoxRealAttribute: TListBox
          StyleElements = [seFont, seClient, seBorder]
          ExplicitWidth = 273
        end
      end
      inherited GroupBoxModel: TGroupBox
        inherited ListBoxInputNames: TListBox
          StyleElements = [seFont, seClient, seBorder]
        end
      end
    end
  end
  inherited PanelMiddle: TPanel
    StyleElements = [seFont, seClient, seBorder]
    object lbLevels: TLabel [0]
      Left = 158
      Top = 64
      Width = 105
      Height = 16
      Caption = 'Number of Levels'
    end
    inherited GroupBoxOutput: TGroupBox
      inherited ToolBarShowAs: TToolBar
        inherited PanelOutPath: TPanel
          StyleElements = [seFont, seClient, seBorder]
        end
        inherited EditOutName: TEdit
          StyleElements = [seFont, seClient, seBorder]
        end
      end
    end
    object seNumberOfLevels: TSpinEdit
      Left = 289
      Top = 55
      Width = 49
      Height = 26
      Hint = 'Material ID'
      MaxValue = 12
      MinValue = 1
      TabOrder = 1
      Value = 4
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
