unit dImages;

interface

uses
  System.SysUtils,
  System.Classes,
  Vcl.VirtualImageList,
  System.ImageList,
  Vcl.ImgList,
  Vcl.Controls;

type
  TdmImages = class(TDataModule)
    ImageList1: TImageList;
    VirtualImageList1: TVirtualImageList;
  private
  public
  end;

var
  dmImages: TdmImages;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

end.
