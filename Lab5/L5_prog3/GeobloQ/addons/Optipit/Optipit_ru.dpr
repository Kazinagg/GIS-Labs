program Optipit_ru;

uses
  Forms,
  fpOptipit_ru in 'fpOptipit_ru.pas' {FormOptipit},
  fpAbout_ru in 'fpAbout_ru.pas' {FormAbout},
  Geos.Profuns in '..\..\src\Geos.Profuns.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TFormOptipit, FormOptipit);
  Application.Run;
end.
