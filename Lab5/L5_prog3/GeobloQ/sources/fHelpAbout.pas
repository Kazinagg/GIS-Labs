//--------------------------------------------------------------------------
// The modeling system Geoblock http://sourceforge.net/projects/geoblock
//--------------------------------------------------------------------------
{! The form About for version information }

unit fHelpAbout;

interface

uses
  Winapi.Windows, 
  Winapi.ShellApi,
  System.SysUtils, 
  System.Classes,
  Vcl.Graphics, 
  Vcl.Controls, 
  Vcl.Forms, 
  Vcl.Dialogs, 
  Vcl.ComCtrls,
  Vcl.StdCtrls, 
  Vcl.ExtCtrls, 
  Vcl.Imaging.Jpeg, 
  Vcl.Buttons,
  
  fmBlankDialog;

procedure LogoShow;
procedure LogoClose;

type
  TFormHelpAbout = class(TFormBlankDialog)
    LabelGeoblock: TLabel;
    LabelVersion: TLabel;
    LabelDepositModeling: TLabel;
    LabelOreReserveCalculation: TLabel;
    ImageGeoblock: TImage;
    StaticTextMessage: TStaticText;
    StaticTextVersion: TStaticText;
    LabelMinePlanning: TLabel;
    PageControl1: TPageControl;
    TabSheetSoftware: TTabSheet;
    ImageSourceForge: TImage;
    oglImage: TImage;
    LabelCopyright: TLabel;
    FreeAndOpenSource: TLabel;
    glsImage: TImage;
    PanelYears: TPanel;
    StaticTextCompanyName: TStaticText;
    TabSheetLicense: TTabSheet;
    Image1: TImage;
    procedure FormCreate(Sender: TObject);
    procedure LabelGeoblockDblClick(Sender: TObject);
    procedure ImageSourceForgeDblClick(Sender: TObject);
    procedure ImageGeoblockDblClick(Sender: TObject);
    procedure BuiltWithDelphiDblClick(Sender: TObject);
    procedure StaticTextCompanyNameDblClick(Sender: TObject);
    procedure FreeAndOpenSourceDblClick(Sender: TObject);
  private
    function GetFileInfo(const FileName: TFileName): TVSFixedFileInfo;
    // Read the application version and return it as a string
    function ReadVersionInfo(FileName: TFileName): TFileName;
  end;

var
  FormHelpAbout: TFormHelpAbout;

implementation //==============================================================

uses
  usGlobals,
  Geos.ResStrings;

{$R *.DFM}

procedure GotoURL(Handle: integer; const URL: string);
var
  S: array[0..255] of char;
begin
  ShellExecute(Handle, 'Open', StrPCopy(S, URL), nil, nil, SW_SHOW);
end;

procedure LogoShow;
begin
  FormHelpAbout := TFormHelpAbout.Create(Application);
  FormHelpAbout.BorderStyle := bsNone; // bsSingle;
  FormHelpAbout.StaticTextMessage.Visible := True;
  FormHelpAbout.ButtonOK.Visible := False;
  FormHelpAbout.ButtonHelp.Visible := False;
  FormHelpAbout.Show;
  FormHelpAbout.Update;
end;

procedure LogoClose;
begin
  FormHelpAbout.Free;
end;

// HelpAbout
procedure TFormHelpAbout.BuiltWithDelphiDblClick(Sender: TObject);
begin
  inherited;
  GotoURL(Handle, 'http://www.embarcadero.com');
end;

procedure TFormHelpAbout.FormCreate(Sender: TObject);
begin
  inherited;
  StaticTextVersion.Caption := ReadVersionInfo(ParamStr(0));
end;


procedure TFormHelpAbout.FreeAndOpenSourceDblClick(Sender: TObject);
begin
  GotoURL(Handle, 'http://www.mozilla.org/MPL/');
end;

procedure TFormHelpAbout.ImageGeoblockDblClick(Sender: TObject);
begin
  ShellExecute(0, 'open', 'mailto:geoblock@mail.ru', '', '',  SW_SHOW);
end;

procedure TFormHelpAbout.ImageSourceForgeDblClick(Sender: TObject);
begin
  GotoURL(Handle, 'http://www.sourceforge.net/projects/geoblock/');
end;

procedure TFormHelpAbout.LabelGeoblockDblClick(Sender: TObject);
begin
  GotoURL(Handle, 'http://geoblock.sourceforge.net/');
end;

function TFormHelpAbout.GetFileInfo(const FileName: TFileName): TVSFixedFileInfo;
var
  Handle, VersionSize: DWord;
  SubBlock: string;
  Temp:     Pointer;
  Data:     Pointer;
begin
  SubBlock    := '\';
  VersionSize := GetFileVersionInfoSize(PWideChar(FileName), Handle);
  if VersionSize > 0 then
  begin
    GetMem(Temp, VersionSize);
    try
      if GetFileVersionInfo(PWideChar(FileName), Handle, VersionSize, Temp) then
        if VerQueryValue(Temp, PWideChar(SubBlock), Data, VersionSize) then
          Result := PVSFixedFileInfo(Data)^;
    finally
      FreeMem(Temp);
    end;
  end;
end;

function TFormHelpAbout.ReadVersionInfo(FileName: TFileName): TFileName;
type
  TGetWords = record
    case boolean of
      True: (C: cardinal);
      False: (Lo, Hi: word);
  end;
var
  VerSize, Wnd: cardinal;
  Buf, Value: Pointer;
  MS, LS: TGetWords;
begin
  VerSize := GetFileVersionInfoSize(PChar(FileName), Wnd);
  if VerSize > 0 then
  begin
    GetMem(Buf, VerSize);
    GetFileVersionInfo(PChar(ParamStr(0)), 0, VerSize, Buf);

    VerQueryValue(Buf, '\', Value, VerSize);
    with TVSFixedFileInfo(Value^) do
    begin
      MS.C   := dwFileVersionMS;
      LS.C   := dwFileVersionLS;
      Result := Format('%d.%d.%d  Build %d', [MS.Hi, MS.Lo, LS.Hi, LS.Lo]);
    end;
    FreeMem(Buf);
  end
  else
    Result := LoadResString(@rsUnknown);
end;

procedure TFormHelpAbout.StaticTextCompanyNameDblClick(Sender: TObject);
begin
  GotoURL(Handle, 'mailto:' + StaticTextCompanyName.Hint);
end;

//============================================================
initialization
//============================================================

end.
