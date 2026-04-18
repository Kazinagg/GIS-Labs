unit fxGridGeneration;

interface

uses
  System.SysUtils,
  System.Types,
  System.UITypes,
  System.Classes,
  System.Variants,
  System.ImageList,
  FMX.Types,
  FMX.Graphics,
  FMX.Controls,
  FMX.Forms,
  FMX.Dialogs,
  FMX.StdCtrls,
  FMX.ImgList,
  FMX.Edit,
  FMX.Layouts,
  FMX.ListBox,
  FMX.Controls.Presentation,
  FMX.Objects,

  uxGlobals,
  fxMethodDialog;


type
  TFormGridGeneration = class(TfmMethodDialog)
    gbModelSize: TGroupBox;
    Image1: TImage;
    Image2: TImage;
    Image3: TImage;
    procedure FormCreate(Sender: TObject);
  private
  public
  end;

var
  FormGridGeneration: TFormGridGeneration;

implementation //------------------------------------------------------------

{$R *.fmx}

procedure TFormGridGeneration.FormCreate(Sender: TObject);
begin
  inherited;
 //
end;

//---------------------------------------------------------------------------

end.
