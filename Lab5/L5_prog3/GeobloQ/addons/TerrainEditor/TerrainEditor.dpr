program TerrainEditor;

uses
  Forms,
  fTerraEditor in 'fTerraEditor.pas' {Form1},
  uTerrainEngine in 'uTerrainEngine.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
