unit Unit1;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.WebBrowser,
  System.Sensors, System.Sensors.Components, FMX.Controls.Presentation, FMX.StdCtrls,
  System.Permissions;

type
  TForm1 = class(TForm)
    LocationSensor1: TLocationSensor;
    WebBrowser1: TWebBrowser;
    Label1: TLabel;
    Label2: TLabel;
    procedure FormShow(Sender: TObject);
    procedure LocationSensor1LocationChanged(Sender: TObject; const OldLocation,
      NewLocation: TLocationCoord2D);
  private
    { Private declarations }
    FGeocoder: TGeocoder;
    procedure OnGeocodeReverseEvent(const Address: TCivicAddress);
    procedure RequestPermissionsResult(Sender: TObject; const APermissions: TClassicStringDynArray; const AGrantResults: TClassicPermissionStatusDynArray);
  public
    { Public declarations }
    destructor Destroy; override;
  end;

var
  Form1: TForm1;

implementation

{$R *.fmx}

destructor TForm1.Destroy;
begin

  if Assigned(FGeocoder) then
    FGeocoder.Free;
  inherited;
end;

procedure TForm1.FormShow(Sender: TObject);
begin

  PermissionsService.RequestPermissions(
    ['android.permission.ACCESS_FINE_LOCATION', 'android.permission.ACCESS_COARSE_LOCATION'],
    RequestPermissionsResult,
    nil
  );
end;

procedure TForm1.RequestPermissionsResult(Sender: TObject; const APermissions: TClassicStringDynArray; const AGrantResults: TClassicPermissionStatusDynArray);
begin

  if (Length(AGrantResults) > 0) and (AGrantResults[0] = TPermissionStatus.Granted) then
    LocationSensor1.Active := True
  else
    ShowMessage('��� ������ ���������� ��������� ������ � ����������!');
end;

procedure TForm1.LocationSensor1LocationChanged(Sender: TObject; const OldLocation,
  NewLocation: TLocationCoord2D);
var
  Lats, Longs, URL: string;
  FS: TFormatSettings;
begin

  FS := TFormatSettings.Create('en-US');

  Lats := FloatToStr(NewLocation.Latitude, FS);
  Longs := FloatToStr(NewLocation.Longitude, FS);

  Label1.Text := Format('������: %s �������: %s', [Lats, Longs]);

  URL := Format('https://www.openstreetmap.org/?mlat=%s&mlon=%s#map=16/%s/%s', [Lats, Longs, Lats, Longs]);
  WebBrowser1.Navigate(URL);

  if not Assigned(FGeocoder) then
  begin
    if Assigned(TGeocoder.Current) then
    begin
      FGeocoder := TGeocoder.Current.Create;
      FGeocoder.OnGeocodeReverse := OnGeocodeReverseEvent;
    end;
  end;

  if Assigned(FGeocoder) and not FGeocoder.Geocoding then
    FGeocoder.GeocodeReverse(NewLocation);
end;

procedure TForm1.OnGeocodeReverseEvent(const Address: TCivicAddress);
begin

  TThread.Queue(nil,
    procedure
    begin

      Label2.Text := Address.CountryCode + ', ' + Address.AdminArea + ', ' + Address.Thoroughfare + ', ' + Address.FeatureName;
    end);
end;

end.
