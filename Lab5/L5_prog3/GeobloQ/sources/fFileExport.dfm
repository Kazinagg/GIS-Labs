inherited FormFileExport: TFormFileExport
  Left = 301
  Top = 182
  Caption = 'Export'
  ClientHeight = 211
  ClientWidth = 576
  StyleElements = [seFont, seClient, seBorder]
  OnActivate = FormActivate
  ExplicitWidth = 592
  ExplicitHeight = 250
  TextHeight = 16
  inherited PanelTop: TPanel
    Width = 576
    Height = 73
    StyleElements = [seFont, seClient, seBorder]
    ExplicitWidth = 576
    ExplicitHeight = 73
    object GroupBoxInput: TGroupBox
      Left = 1
      Top = 1
      Width = 574
      Height = 71
      Align = alClient
      Caption = 'Input'
      TabOrder = 0
      object PanelInputFile: TPanel
        Left = 16
        Top = 25
        Width = 529
        Height = 24
        Alignment = taLeftJustify
        BevelOuter = bvLowered
        TabOrder = 0
      end
    end
  end
  inherited PanelMiddle: TPanel
    Top = 73
    Width = 576
    Height = 90
    StyleElements = [seFont, seClient, seBorder]
    ExplicitTop = 73
    ExplicitWidth = 576
    ExplicitHeight = 90
    object GroupBoxOutput: TGroupBox
      Left = 1
      Top = 1
      Width = 574
      Height = 88
      Align = alClient
      Caption = 'Output'
      TabOrder = 0
      object SpeedButtonBrowse: TSpeedButton
        Left = 513
        Top = 33
        Width = 24
        Height = 24
        Caption = '...'
        OnClick = SpeedButtonBrowseClick
      end
      object LabelType: TLabel
        Left = 247
        Top = 105
        Width = 35
        Height = 16
        Caption = 'Type:'
      end
      object PanelOutputPath: TPanel
        Left = 16
        Top = 33
        Width = 305
        Height = 24
        Alignment = taLeftJustify
        BevelOuter = bvLowered
        ParentShowHint = False
        ShowHint = True
        TabOrder = 0
      end
      object EditOutputName: TEdit
        Left = 329
        Top = 33
        Width = 168
        Height = 24
        TabOrder = 1
        OnChange = EditOutputNameChange
      end
      object ComboBoxType: TComboBox
        Left = 328
        Top = 97
        Width = 209
        Height = 24
        Style = csDropDownList
        ParentShowHint = False
        ShowHint = True
        TabOrder = 2
        OnChange = ComboBoxTypeChange
        Items.Strings = (
          'Regions of MapInfo (*.MIF)'
          'Text Data (*.TXT)'
          'Block Model Four-X (*.MOD)'
          'Data in ASCII (*.DAT)'
          'Regular Grid (*.GRD)'
          'Economic Grid Three-D (*.ECO)'
          'Mining Sequence Four-X (*.MSQ)'
          'AutoCAD data (*.DXF)'
          'All')
      end
    end
  end
  inherited PanelBottom: TPanel
    Top = 163
    Width = 576
    StyleElements = [seFont, seClient, seBorder]
    ExplicitTop = 163
    ExplicitWidth = 576
    inherited ButtonOK: TButton
      Left = 460
      OnClick = ButtonOKClick
      ExplicitLeft = 460
    end
    inherited ButtonCancel: TButton
      Left = 580
      ExplicitLeft = 580
    end
    inherited ButtonHelp: TButton
      Left = 702
      ExplicitLeft = 702
    end
    object ProgressBar: TProgressBar
      Left = 9
      Top = 12
      Width = 128
      Height = 21
      Step = 1
      TabOrder = 3
    end
  end
end
