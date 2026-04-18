//---------------------------------------------------------------------------
// The modeling system Geoblock http://sourceforge.net/projects/geoblock
//---------------------------------------------------------------------------
(* fInitialDialog is the parent form for inherited method dialogs *)

unit fmBlankDialog;

interface

uses
  Winapi.Windows,
  System.SysUtils,
  System.Classes,
  Vcl.Forms,
  Vcl.StdCtrls,
  Vcl.Controls,
  Vcl.ExtCtrls,
  
  fmFirstForm;

type
  TFormBlankDialog = class(TFormFirst)
    PanelTop:     TPanel;
    PanelMiddle:  TPanel;
    PanelBottom:  TPanel;
    ButtonOK:     TButton;
    ButtonCancel: TButton;
    ButtonHelp:   TButton;
    procedure ButtonHelpClick(Sender: TObject);
  private
     
  protected
  public
     
    function Execute: boolean; virtual;
  published
     
  end;

var
  FormBlankDialog: TFormBlankDialog;

implementation //=============================================================

{$R *.DFM}

procedure TFormBlankDialog.ButtonHelpClick(Sender: TObject);
begin
  Application.HelpContext(HelpContext);
end;


function TFormBlankDialog.Execute: boolean;
begin
  Result := ShowModal = mrOk;
end;

end.
