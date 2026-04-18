//----------------------------------------------------------------------------
// The Stereonet plugin for Geoblock
// This unit is a part of the Geoblock Project, http://sourceforge.net/projects/geoblock
//----------------------------------------------------------------------------
{! The Main Form for tacheometry plugin }
{
  Hystory log
     10/05/06 - PVV - Last modified
     01/08/97 - Pavel Vassiliev - Creation;
}

unit fStereonet;

interface

uses
  Winapi.Windows,
  Winapi.Messages,
  System.SysUtils,
  System.Classes,
  Vcl.Graphics,
  Vcl.Controls,
  Vcl.Forms,
  Vcl.Dialogs,
  Vcl.StdCtrls,
  Vcl.ExtCtrls,
  Vcl.ComCtrls,
  DBCtrls,
  Db,
///  DBTables,
  Grids,
  DBGrids,
  Registry,
  IniFiles;

type
  TfmMain = class(TForm)
    PanelTitle: TPanel;
    PanelBottom: TPanel;
    ButtonCancel: TButton;
    ButtonOK: TButton;
    ButtonHelp: TButton;
    procedure FormCreate(Sender: TObject);
    procedure ButtonOKClick(Sender: TObject);
  private
    FLanguage: Integer;
    RegIni: TRegistryIniFile;
  public
    procedure SetLanguage;
  end;

var
  fmMain: TfmMain;

implementation   //----------------------------------------------------------

uses
  usGlobals,
  Geos.Profuns,
  usCommon,
  uStereonet;

{$R *.DFM}




procedure TfmMain.FormCreate(Sender: TObject);
begin
   inherited;
   SetLanguage;
end;

procedure TfmMain.SetLanguage;
begin
  RegIni := TRegistryIniFile.Create(GeneralSection);
  AppPath := RegIni.ReadString(GeneralSection,'AppPath',AppPath);

  RegIni.Free;
end;

procedure TfmMain.ButtonOKClick(Sender: TObject);
begin
  Close;
end;

end.

