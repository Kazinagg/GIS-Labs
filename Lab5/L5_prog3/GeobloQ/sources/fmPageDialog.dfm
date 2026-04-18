inherited FormPageDialog: TFormPageDialog
  Caption = 'Page Dialog'
  Constraints.MinWidth = 320
  StyleElements = [seFont, seClient, seBorder]
  OnClose = FormClose
  OnCreate = FormCreate
  TextHeight = 16
  inherited PanelTop: TPanel
    Height = 11
    BevelOuter = bvNone
    StyleElements = [seFont, seClient, seBorder]
    ExplicitHeight = 11
  end
  inherited PanelMiddle: TPanel
    Top = 11
    Height = 390
    BevelOuter = bvNone
    BorderWidth = 5
    StyleElements = [seFont, seClient, seBorder]
    ExplicitTop = 11
    ExplicitHeight = 365
    object PageControl: TPageControl
      Left = 5
      Top = 5
      Width = 557
      Height = 380
      Align = alClient
      MultiLine = True
      TabOrder = 0
      ExplicitWidth = 549
      ExplicitHeight = 355
    end
  end
  inherited PanelBottom: TPanel
    Top = 401
    Height = 47
    BevelOuter = bvNone
    StyleElements = [seFont, seClient, seBorder]
    ExplicitTop = 376
    ExplicitWidth = 559
    ExplicitHeight = 47
    DesignSize = (
      567
      47)
  end
end
