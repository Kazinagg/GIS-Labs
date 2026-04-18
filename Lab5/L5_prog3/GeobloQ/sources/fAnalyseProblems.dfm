inherited FormAnalyseProblems: TFormAnalyseProblems
  Tag = 1
  Left = 258
  Top = 190
  HelpContext = 702
  Caption = 'Problem Book'
  ClientHeight = 363
  ClientWidth = 604
  Constraints.MinWidth = 0
  StyleElements = [seFont, seClient, seBorder]
  ExplicitWidth = 620
  ExplicitHeight = 402
  TextHeight = 16
  inherited PanelTop: TPanel
    Width = 604
    StyleElements = [seFont, seClient, seBorder]
    ExplicitWidth = 596
  end
  inherited PanelMiddle: TPanel
    Width = 604
    Height = 305
    StyleElements = [seFont, seClient, seBorder]
    ExplicitWidth = 596
    ExplicitHeight = 280
    inherited PageControl: TPageControl
      Width = 594
      Height = 295
      ExplicitWidth = 586
      ExplicitHeight = 270
    end
  end
  inherited PanelBottom: TPanel
    Top = 316
    Width = 604
    StyleElements = [seFont, seClient, seBorder]
    ExplicitTop = 291
    ExplicitWidth = 596
    inherited ButtonOK: TButton
      Left = 241
      ModalResult = 0
      OnClick = ButtonOKClick
      ExplicitLeft = 233
    end
    inherited ButtonCancel: TButton
      Left = 361
      ExplicitLeft = 353
    end
    inherited ButtonHelp: TButton
      Left = 483
      ExplicitLeft = 475
    end
  end
end
