program Mendeleev;



uses
  Vcl.Forms,
  fMendeleev in 'fMendeleev.pas' {fmMendeleev},
  fAtoms in 'fAtoms.pas' {FormAtoms},
  usGlobals in '..\..\source\usGlobals.pas',
  fAtomicRotation in 'fAtomicRotation.pas' {FormAtomicRotation};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfmMendeleev, fmMendeleev);
  Application.CreateForm(TFormAtomicRotation, FormAtomicRotation);
  Application.Run;
end.
