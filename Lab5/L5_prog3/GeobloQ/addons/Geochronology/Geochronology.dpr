program Geochronology;

uses
  Vcl.Forms,
  fGeochronology in 'fGeochronology.pas' {fmMainForm};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfmMainForm, fmMainForm);
  Application.Run;
end.
