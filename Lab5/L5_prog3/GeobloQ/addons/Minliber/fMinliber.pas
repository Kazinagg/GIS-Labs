unit fMinliber;

interface

uses
  Winapi.Windows,
  Winapi.Messages,
  System.SysUtils,
  System.Variants,
  System.Classes,
  Vcl.Graphics,
  Vcl.Controls,
  Vcl.Forms,
  Vcl.Dialogs,
  GLS.Scene,
  GLS.Objects,
  GLS.Coordinates,
  GLS.Cadencer,
  GLS.Material,
  GLS.SceneViewer,
  GLS.BaseClasses,
  Vcl.Menus,

  mlRandist;

type
  TForm3 = class(TForm)
    MainMenu1: TMainMenu;
    GLScene1: TGLScene;
    GLSceneViewer1: TGLSceneViewer;
    GLMaterialLibrary1: TGLMaterialLibrary;
    GLCadencer1: TGLCadencer;
    Camera: TGLCamera;
    dcRock: TGLDummyCube;
    Light: TGLLightSource;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form3: TForm3;

implementation

{$R *.dfm}

end.
