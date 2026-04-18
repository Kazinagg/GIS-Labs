//----------------------------------------------------------------------------
// The modeling system Geoblock http://sourceforge.net/projects/geoblock
//----------------------------------------------------------------------------
(* Show options for vectors *)

unit fPerformVectors;

interface

uses
  Vcl.Graphics, 
  Vcl.Controls, 
  Vcl.Forms, 
  Vcl.Dialogs,
  Vcl.StdCtrls, 
  Vcl.Samples.Spin, 
  Vcl.ExtCtrls,

  
  fmBlankDialog,
  System.Classes;

type
  TFormPerformVectors = class(TFormBlankDialog)
    LabelShowEvery:    TLabel;
    SpinEditDisplayEvery: TSpinEdit;
    SpinEditLengthFactor: TSpinEdit;
    LabelLengthFactor: TLabel;
  private
     
  public
     
  end;

var
  FormPerformVectors: TFormPerformVectors;

implementation

{$R *.DFM}

end.
