program TerraMorph;

uses
  Forms,
  fTerraMorph in 'fTerraMorph.pas' {FormTerramorf};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TFormTerramorf, FormTerramorf);
  Application.Run;
end.
