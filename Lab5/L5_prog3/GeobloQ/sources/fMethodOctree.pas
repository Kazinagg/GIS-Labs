//------------------------------------------------------------------------------
// The modeling system Geoblock http://sourceforge.net/projects/geoblock
//------------------------------------------------------------------------------
(* The dialog for octree model parameters *)

unit fMethodOctree;

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
  Vcl.StdCtrls,
  Vcl.ComCtrls,
  Vcl.Buttons,
  Vcl.ToolWin,
  Vcl.ExtCtrls,
  Vcl.Samples.Spin,
  fmMethodDialog;

type
  TFormMethodOctree = class(TFormMethodDialog)
    lbLevels: TLabel;
    seNumberOfLevels: TSpinEdit;
    procedure ButtonOKClick(Sender: TObject);
  private
  public
  end;

var
  FormMethodOctree: TFormMethodOctree;

implementation //=============================================================

{$R *.dfm}

procedure TFormMethodOctree.ButtonOKClick(Sender: TObject);
begin
  OutModelName := OutModelName + '_octree';
  // Construct Octree;
  // Write Octree in 3D Grid type
end;

end.
