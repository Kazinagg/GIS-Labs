(* Data visualizer *)

unit fViewDataVisualizer;

interface

uses
  Winapi.Windows,
  Winapi.Messages,
  System.SysUtils,
  System.Variants,
  System.Classes,
  System.ImageList,

  Vcl.Graphics,
  Vcl.Controls,
  Vcl.Forms,
  Vcl.Dialogs,
  Vcl.ImgList,

  fmFirstForm;

type
  TfmInitialForm1 = class(TFormFirst)
  private

  public

  end;

var
  fmInitialForm1: TfmInitialForm1;

implementation //==============================================================

{$R *.dfm}

end.
