inherited FormFileOpenModel: TFormFileOpenModel
  Tag = 1
  Top = 181
  HelpContext = 111
  Caption = 'Open Model'
  ClientHeight = 401
  ClientWidth = 631
  StyleElements = [seFont, seClient, seBorder]
  ExplicitWidth = 657
  ExplicitHeight = 450
  TextHeight = 16
  inherited PanelTop: TPanel
    Width = 631
    StyleElements = [seFont, seClient, seBorder]
    ExplicitWidth = 631
  end
  inherited PanelMiddle: TPanel
    Width = 631
    Height = 349
    StyleElements = [seFont, seClient, seBorder]
    ExplicitWidth = 631
    ExplicitHeight = 349
    inherited SpeedButton1: TSpeedButton
      Left = 777
      ExplicitLeft = 762
    end
    inherited SpeedButton2: TSpeedButton
      Left = 819
      ExplicitLeft = 804
    end
    inherited PageControl: TPageControl
      Width = 621
      Height = 94
      ActivePage = TabSheetHoles
      ExplicitWidth = 621
      ExplicitHeight = 94
      object TabSheetHoles: TTabSheet
        Caption = 'Dholes'
        ImageIndex = 32
      end
      object TabSheetPoints2D: TTabSheet
        Tag = 1
        Caption = 'Points 2D'
        ImageIndex = 38
      end
      object TabSheetPoints3D: TTabSheet
        Tag = 2
        Caption = 'Points 3D'
        ImageIndex = 41
      end
      object TabSheetPolygons: TTabSheet
        Tag = 3
        Caption = 'Polygons'
        ImageIndex = 44
      end
      object TabSheetTins: TTabSheet
        Tag = 4
        Caption = 'Tins'
        ImageIndex = 48
      end
      object TabSheetSolids: TTabSheet
        Tag = 5
        Caption = 'Solids'
        ImageIndex = 66
      end
      object TabSheetGrids2D: TTabSheet
        Tag = 6
        Caption = 'Grid 2D'
        ImageIndex = 55
      end
      object TabSheetGrids3D: TTabSheet
        Tag = 7
        Caption = 'Grid 3D'
        ImageIndex = 60
      end
      object TabSheetMeshes2D: TTabSheet
        Tag = 8
        Caption = 'Meshes 2D'
        ImageIndex = 69
      end
      object TabSheetMeshes3D: TTabSheet
        Tag = 9
        Caption = 'Mesh 3D'
        ImageIndex = 73
      end
    end
    inherited PanelDirectory: TPanel
      Top = 99
      Width = 621
      Height = 85
      StyleElements = [seFont, seClient, seBorder]
      ExplicitTop = 99
      ExplicitWidth = 621
      ExplicitHeight = 85
      inherited SpeedButtonBrowse: TSpeedButton
        Left = 477
        Top = 32
        Height = 27
        ExplicitLeft = 485
        ExplicitTop = 32
        ExplicitHeight = 27
      end
      inherited SpeedButtonDelete: TSpeedButton
        Left = 508
        Top = 30
        Height = 29
        ExplicitLeft = 516
        ExplicitTop = 30
        ExplicitHeight = 29
      end
      inherited LabelPath: TLabel
        Left = 6
        Top = 40
        StyleElements = [seFont, seClient, seBorder]
        ExplicitLeft = 6
        ExplicitTop = 40
      end
      inherited PanelInputPath: TPanel
        Left = 71
        Top = 35
        StyleElements = [seFont, seClient, seBorder]
        ExplicitLeft = 71
        ExplicitTop = 35
      end
    end
    inherited ListView: TListView
      Top = 184
      Width = 621
      Height = 106
      Columns = <
        item
          Caption = 'Name'
          Width = 320
        end
        item
          Caption = 'Size'
          Width = 100
        end
        item
          Caption = 'Changed'
          Width = 100
        end>
      ExplicitTop = 184
      ExplicitWidth = 621
      ExplicitHeight = 106
    end
    inherited GroupBoxOutput: TGroupBox
      Top = 290
      Width = 621
      ExplicitTop = 290
      ExplicitWidth = 621
      inherited ToolBarShowAs: TToolBar
        Width = 617
        ExplicitWidth = 617
        inherited ToolButtonGraph: TToolButton
          Caption = '`'
        end
        inherited EditOutName: TEdit
          StyleElements = [seFont, seClient, seBorder]
        end
        object ToolButton4: TToolButton
          Left = 213
          Top = 0
          Caption = '`'
        end
      end
    end
  end
  inherited PanelBottom: TPanel
    Top = 350
    Width = 631
    StyleElements = [seFont, seClient, seBorder]
    ExplicitTop = 350
    ExplicitWidth = 631
    inherited ButtonOK: TButton
      Left = 296
      Top = 6
      ExplicitLeft = 296
      ExplicitTop = 6
    end
    inherited ButtonCancel: TButton
      Left = 408
      Top = 6
      Height = 32
      ExplicitLeft = 408
      ExplicitTop = 6
      ExplicitHeight = 32
    end
    inherited ButtonHelp: TButton
      Left = 524
      Top = 6
      Height = 33
      ExplicitLeft = 524
      ExplicitTop = 6
      ExplicitHeight = 33
    end
    inherited PanelLeft: TPanel
      StyleElements = [seFont, seClient, seBorder]
    end
  end
end
