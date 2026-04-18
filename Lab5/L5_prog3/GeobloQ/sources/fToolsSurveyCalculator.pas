//-----------------------------------------------------------------------------
// The modeling system Geoblock http://sourceforge.net/projects/geoblock
//-----------------------------------------------------------------------------
(* Basic survey calculator for open pits and undeground mines *)

unit fToolsSurveyCalculator;

interface

uses
  System.Classes,
  System.Math,
  Vcl.Graphics, 
  Vcl.Controls, 
  Vcl.Forms,
  Vcl.Dialogs, 
  Vcl.StdCtrls, 
  Vcl.ComCtrls, 
  Vcl.ExtCtrls,

  
  fmPageDialog,
  GBEditValue;

type
  TFormToolsSurveyCalculator = class(TFormPageDialog)
    TabSheetStrippingFactor: TTabSheet;
    TabSheetLossesAndDilutions: TTabSheet;
    StaticTextLossesAndDilutions: TStaticText;
    StaticTextStrippingFactor: TStaticText;
    Image1:     TImage;
    Label2:     TLabel;
    Label1:     TLabel;
    LabelDilution: TLabel;
    Label3:     TLabel;
    GBEditValue1: TGBEditValue;
    GBEditValue2: TGBEditValue;
  private
    FUpdateCount: integer;
    function GetInUpdate: boolean;
    procedure SetInUpdate(const Value: boolean);
     
  public
     
    procedure BeginUpdate;
    procedure EndUpdate;
    property inUpdate: boolean Read GetInUpdate Write SetInUpdate;
  end;

var
  FormToolsSurveyCalculator: TFormToolsSurveyCalculator;

implementation //==============================================================

{$R *.dfm}

{ TfmToolsSurveyCalculator }

procedure TFormToolsSurveyCalculator.BeginUpdate;
begin
  Inc(FUpdateCount);
end;

procedure TFormToolsSurveyCalculator.EndUpdate;
begin
  FUpdateCount := Max(0, FUpdateCount - 1);
end;

function TFormToolsSurveyCalculator.GetInUpdate: boolean;
begin
  Result := boolean(FUpdateCount);
end;

procedure TFormToolsSurveyCalculator.SetInUpdate(const Value: boolean);
begin
  case Value of
    False:
      EndUpdate;
    True:
      BeginUpdate;
  end;
end;

end.
