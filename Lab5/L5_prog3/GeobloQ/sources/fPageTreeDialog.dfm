inherited fmPageTreeDialog: TfmPageTreeDialog
  Caption = 'Page Tree Dialog'
  ClientHeight = 419
  ClientWidth = 610
  StyleElements = [seFont, seClient, seBorder]
  ExplicitWidth = 626
  ExplicitHeight = 458
  TextHeight = 16
  inherited PanelTop: TPanel
    Width = 610
    Height = 13
    StyleElements = [seFont, seClient, seBorder]
    ExplicitWidth = 602
    ExplicitHeight = 13
  end
  inherited PanelMiddle: TPanel
    Top = 13
    Width = 610
    Height = 359
    StyleElements = [seFont, seClient, seBorder]
    ExplicitTop = 13
    ExplicitWidth = 602
    ExplicitHeight = 334
    inherited PageControl: TPageControl
      Left = 200
      Width = 413
      Height = 349
      ExplicitLeft = 200
      ExplicitWidth = 397
      ExplicitHeight = 324
    end
    object TreeView: TTreeView
      Left = 5
      Top = 5
      Width = 195
      Height = 349
      Align = alLeft
      Indent = 19
      TabOrder = 1
    end
  end
  inherited PanelBottom: TPanel
    Top = 372
    Width = 610
    StyleElements = [seFont, seClient, seBorder]
    ExplicitTop = 347
    ExplicitWidth = 602
    DesignSize = (
      610
      47)
    inherited ButtonOK: TButton
      Left = 486
      ExplicitLeft = 486
    end
    inherited ButtonCancel: TButton
      Left = 606
      ExplicitLeft = 606
    end
    inherited ButtonHelp: TButton
      Left = 728
      ExplicitLeft = 728
    end
  end
end
