//------------------------------------------------------------------------------
// The modeling system Geoblock http://sourceforge.net/projects/geoblock
//------------------------------------------------------------------------------
(*  The dialog for drawing depth parameters *)


unit fDrawObjectDepth;

interface

uses
  Winapi.Windows,
  System.SysUtils, 
  System.Classes,
  Vcl.Graphics, 
  Vcl.Controls, 
  Vcl.Forms, 
  Vcl.Dialogs,
  Vcl.StdCtrls, 
  Vcl.ExtCtrls,

  
  fmBlankDialog,
  GBEditValue;

type
  TFormDrawObjectDepth = class(TFormBlankDialog)
    GroupBoxDepth:      TGroupBox;
    RadioButtonAverage: TRadioButton;
    RadioButtonSpecified: TRadioButton;
    EditValueDepth:     TGBEditValue;
    procedure RadioButtonAverageClick(Sender: TObject);
    procedure RadioButtonSpecifiedClick(Sender: TObject);
  private
     
  public
     
  end;

var
  FormDrawObjectDepth: TFormDrawObjectDepth;

implementation

{$R *.DFM}

procedure TFormDrawObjectDepth.RadioButtonAverageClick(Sender: TObject);
begin
  EditValueDepth.Enabled := False;
end;

procedure TFormDrawObjectDepth.RadioButtonSpecifiedClick(Sender: TObject);
begin
  EditValueDepth.Enabled := True;
end;

end.
