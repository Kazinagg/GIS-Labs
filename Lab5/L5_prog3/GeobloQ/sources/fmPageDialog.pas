//-----------------------------------------------------------------------------
// The modeling system Geoblock http://sourceforge.net/projects/geoblock
//-----------------------------------------------------------------------------
(*  Parent page dialog *)

unit fmPageDialog;

interface

uses
  System.SysUtils,
  System.Classes,
  System.IniFiles,
  Vcl.Graphics, 
  Vcl.Controls, 
  Vcl.Forms, 
  Vcl.Dialogs,
  Vcl.ExtCtrls, 
  Vcl.ComCtrls, 
  Vcl.StdCtrls,

  
  usGlobals,
  fmBlankDialog;

type
  TFormPageDialog = class(TFormBlankDialog)
    PageControl: TPageControl;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  public
    procedure ReadIniFile; override;
    procedure WriteIniFile;
  end;

var
  FormPageDialog: TFormPageDialog;

//===========================================================================
implementation
//===========================================================================

{$R *.DFM}

{ TfmPageDialog }

//----------------------------------------------------------------------------
procedure TFormPageDialog.FormCreate(Sender: TObject);
begin
  inherited;
  ReadIniFile;
end;


//----------------------------------------------------------------------------
procedure TFormPageDialog.ReadIniFile;
begin
  IniFile := TIniFile.Create(ChangeFileExt(ParamStr(0), '.ini'));
  with IniFile do
    try
      PageControl.TabIndex := ReadInteger(Name, 'TabIndex', 0);
    finally
      IniFile.Free;
    end;
end;

//----------------------------------------------------------------------------
procedure TFormPageDialog.WriteIniFile;
begin
  IniFile := TIniFile.Create(ChangeFileExt(ParamStr(0), '.ini'));
  with IniFile do
    try
      WriteInteger(Name, 'TabIndex', PageControl.ActivePageIndex);
    finally
      IniFile.Free;
    end;
end;

//----------------------------------------------------------------------------
procedure TFormPageDialog.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  WriteIniFile;
  inherited;
end;

end.
