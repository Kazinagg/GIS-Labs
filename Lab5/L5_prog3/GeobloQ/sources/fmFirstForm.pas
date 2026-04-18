//------------------------------------------------------------------------------
// The modeling system Geoblock http://sourceforge.net/projects/geoblock
//------------------------------------------------------------------------------
(* The Initial form to inherit all child Forms *)

unit fmFirstForm;


interface

uses
  System.Classes,
  System.ImageList,
  Vcl.Forms,
  Vcl.ImgList,
  Vcl.Controls,

  usCommon;


type
  TFormFirst = class(TForm)
    ImageListInterface: TImageList;
    ImageListPictures: TImageList;
    procedure FormCreate(Sender: TObject);
  public
    procedure ReadIniFile; virtual;
  protected
  end;

var
  FormFirst: TFormFirst;

implementation //==============================================================

{$R *.dfm}

//-------------------------------
// TfmInitialForm
//-------------------------------

//Here goes the translation of all component strings
procedure TFormFirst.FormCreate(Sender: TObject);
begin
  //
  inherited;
end;


procedure TFormFirst.ReadIniFile;
begin
  //
end;

end.
