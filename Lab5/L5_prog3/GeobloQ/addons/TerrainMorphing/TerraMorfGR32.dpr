program TerraMorfGR32;

uses
  Forms,
  fTerraMorph in 'fTerraMorph.pas' {FormTerramorph};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TFormTerramorph, FormTerramorph);
  Application.Run;
end.
