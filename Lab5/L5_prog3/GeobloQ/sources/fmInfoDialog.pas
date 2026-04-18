//-----------------------------------------------------------------------------
// The modeling system Geoblock http://sourceforge.net/projects/geoblock
//-----------------------------------------------------------------------------
{! The dialog to output information and translated messages instead of System dialogs }

unit fmInfoDialog;

interface

uses
  Winapi.Windows,
  System.SysUtils,
  System.Variants,
  System.Classes,
  Vcl.Graphics,
  Vcl.Controls,
  Vcl.Forms,
  Vcl.Dialogs,
  Vcl.ComCtrls,
  Vcl.ToolWin,
  Vcl.StdCtrls,
  Vcl.ExtCtrls,

  fmBlankDialog;

type
  TfrmInfoDialog = class(TFormBlankDialog)
    RichEdit: TRichEdit;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
  public
    procedure CopyToClipboard;
    procedure PasteFromClipboard;
  end;

var
  frmInfoDialog: TfrmInfoDialog;

implementation //===========================================================

uses
  usGlobals,
  usCommon;

{$R *.dfm}

procedure TfrmInfoDialog.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure TfrmInfoDialog.CopyToClipboard;
begin
  RichEdit.CopyToClipboard;
end;

procedure TfrmInfoDialog.PasteFromClipboard;
begin
  RichEdit.PasteFromClipboard;
end;

end.
