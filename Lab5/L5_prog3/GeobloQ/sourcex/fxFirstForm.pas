// ---------------------------------------------------------------------------
// This unit is part of the Geoblock Project, http://sourceforge.net/projects/geoblock
// ---------------------------------------------------------------------------
{ ! InitialForm is a parent for all inherited fmx forms }

unit fxFirstForm;

interface

uses
  System.Win.Registry,
  System.SysUtils,
  System.Types,
  System.UITypes,
  System.Classes,
  System.Variants,
  System.ImageList,
  System.IniFiles,

  FMX.Types,
  FMX.Controls,
  FMX.Forms,
  FMX.Dialogs,
  FMX.ImgList,
  FMX.Menus,
  FMX.Edit,
  FMX.Memo;


type
  TfmInitialForm = class(TForm)
  private
  public
    StyleID: Integer;
    PathExe: TFileName;
    IniFile:  TIniFile;
    procedure ReadIniFile; virtual;
    procedure WriteIniFile;
  end;

var
  fmInitialForm: TfmInitialForm;

implementation // ------------------------------------------------------------

{$R *.fmx}

//---------------------------------------------------------------------------
// TfmInitialForm
//---------------------------------------------------------------------------
procedure TfmInitialForm.ReadIniFile;
begin
  //   StyleID := 0;
  PathExe := ExtractFilePath(ParamStr(0));
  SetCurrentDir(PathExe);
  IniFile := TIniFile.Create(PathExe + 'Gexoblock.ini');
end;

procedure TfmInitialForm.WriteIniFile;
begin
  PathExe := ExtractFilePath(ParamStr(0));
  SetCurrentDir(PathExe);
  IniFile := TIniFile.Create(PathExe + 'Gexoblock.ini');
end;

initialization

end.
