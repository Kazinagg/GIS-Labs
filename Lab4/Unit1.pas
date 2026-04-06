unit Unit1;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.WebBrowser,
  System.Sensors, System.Sensors.Components, FMX.Controls.Presentation, FMX.StdCtrls,
  System.Permissions; // Модуль для запроса разрешений Android

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
    FGeocoder: TGeocoder; // Объект для декодирования координат в адрес
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
  // Очищаем память от геокодера при закрытии программы
  if Assigned(FGeocoder) then
    FGeocoder.Free;
  inherited;
end;

// Событие при показе формы
procedure TForm1.FormShow(Sender: TObject);
begin
  // В современных версиях Android нужно запрашивать разрешение на GPS во время работы
  PermissionsService.RequestPermissions(
    ['android.permission.ACCESS_FINE_LOCATION', 'android.permission.ACCESS_COARSE_LOCATION'],
    RequestPermissionsResult,
    nil
  );
end;

// Обработка ответа пользователя на запрос разрешений
procedure TForm1.RequestPermissionsResult(Sender: TObject; const APermissions: TClassicStringDynArray; const AGrantResults: TClassicPermissionStatusDynArray);
begin
  // Если пользователь разрешил использовать GPS, включаем сенсор
  if (Length(AGrantResults) > 0) and (AGrantResults[0] = TPermissionStatus.Granted) then
    LocationSensor1.Active := True
  else
    ShowMessage('Для работы приложения необходим доступ к геолокации!');
end;

// Главное событие - датчик получил новые координаты
procedure TForm1.LocationSensor1LocationChanged(Sender: TObject; const OldLocation,
  NewLocation: TLocationCoord2D);
var
  Lats, Longs, URL: string;
  FS: TFormatSettings;
begin
  // Настраиваем формат, чтобы разделителем была точка, а не запятая (для URL Google карт)
  FS := TFormatSettings.Create('en-US');

  // Переводим числа в строки с точкой
  Lats := FloatToStr(NewLocation.Latitude, FS);
  Longs := FloatToStr(NewLocation.Longitude, FS);

  // Выводим координаты в Label1
  Label1.Text := Format('Широта: %s Долгота: %s', [Lats, Longs]);

  // Загружаем Google Карту
  URL := Format('https://maps.google.com/maps?q=%s,%s&z=16', [Lats, Longs]);
  WebBrowser1.Navigate(URL);

  // === РАБОТА С TGeocoder (Преобразование координат в адрес) ===

  // Создаем объект TGeocoder, если он еще не создан и если сервис доступен
  if not Assigned(FGeocoder) then
  begin
    if Assigned(TGeocoder.Current) then
    begin
      FGeocoder := TGeocoder.Current.Create;
      FGeocoder.OnGeocodeReverse := OnGeocodeReverseEvent; // Привязываем событие
    end;
  end;

  // Если объект создан и сейчас не занят запросом - отправляем координаты на сервер
  if Assigned(FGeocoder) and not FGeocoder.Geocoding then
    FGeocoder.GeocodeReverse(NewLocation);
end;

// Событие, которое срабатывает, когда Google вернул адрес
procedure TForm1.OnGeocodeReverseEvent(const Address: TCivicAddress);
begin
  // Ответ от сервера приходит в фоновом потоке.
  // В Android менять интерфейс (Label2.Text) можно ТОЛЬКО из главного потока (TThread.Queue).
  TThread.Queue(nil,
    procedure
    begin
      // Выводим полученный адрес (Страна, Регион, Улица и т.д.)
      Label2.Text := Address.CountryCode + ', ' + Address.AdminArea + ', ' + Address.Thoroughfare + ', ' + Address.FeatureName;
    end);
end;

end.
