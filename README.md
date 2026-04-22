
# 🌍 Проектирование и программирование основ ГИС
> **Итоговый отчет по циклу из 5 лабораторных работ**

<p align="center">
  <img src="https://img.shields.io/badge/C%2B%2B-00599C?style=for-the-badge&logo=c%2B%2B&logoColor=white" />
  <img src="https://img.shields.io/badge/Delphi-Direct-E11922?style=for-the-badge&logo=delphi&logoColor=white" />
  <img src="https://img.shields.io/badge/Android-3DDC84?style=for-the-badge&logo=android&logoColor=white" />
  <img src="https://img.shields.io/badge/Google_Earth-4285F4?style=for-the-badge&logo=google-earth&logoColor=white" />
</p>

---

## 📑 Навигация по работам
| ЛР | Тема | Технологии | Статус |
| :--- | :--- | :--- | :---: |
| 1 | [Построение карт в изолиниях](#-лабораторная-работа-1) | `Surfer` | ✅ |
| 2 | [3D объект с геопривязкой](#-лабораторная-работа-2) | `SketchUp`, `KMZ` | ✅ |
| 3 | [3D Глобус и триангуляция](#-лабораторная-работа-3) | `C++`, `GLScene` | ✅ |
| 4 | [Android GPS Навигатор](#-лабораторная-работа-4) | `FireMonkey`, `GPS` | ✅ |
| 5 | [Локализация интерфейса](#-лабораторная-работа-5) | `i18n`, `Delphi` | ✅ |

---

> [!NOTE]
> **Студент:** Фролов А. А. (гр. 12002531)  
> **Преподаватель:** доц. Васильев П. В.

---

## 🗺 Лабораторная работа 1
### Построение карт в изолиниях в программе Surfer

> [!TIP]
> В этой работе мы использовали математический синтез ландшафта вместо обычного импорта точек.

#### Математическая модель рельефа:
Для генерации сетки (Grid) использовалась функция:
$$Z = 100 \cdot e^{-\frac{(X-50)^2+(Y-50)^2}{1000}} - 30 \cdot e^{-\frac{(X-Y)^2}{150}} + 15\sin\left(\frac{X}{6.5}\right)\cos\left(\frac{Y}{8.2}\right)$$

**Результат визуализации:**
<p align="center">
  <img src="img/image.png" width="850" alt="Surfer Output">
  <br><i>Рисунок 1 — 2D Изолинии и 3D поверхность</i>
</p>

---

## 🏢 Лабораторная работа 2
### Создание 3D объекта на карте с привязкой к геокоординатам

Здесь реализован пайплайн: **SketchUp → Export KMZ → Google Earth Pro**.

#### Этапы разработки:
<table align="center">
  <tr>
    <td align="center"><img src="img/image-0.png" width="350"><br><b>1. Моделирование</b></td>
    <td align="center"><img src="img/image-1.png" width="350"><br><b>2. Геопривязка</b></td>
  </tr>
  <tr>
    <td align="center"><img src="img/image-2.png" width="350"><br><b>3. Экспорт в KMZ</b></td>
    <td align="center"><img src="img/image-3.png" width="350"><br><b>4. Финальный рендер</b></td>
  </tr>
</table>

---

## 🌐 Лабораторная работа 3
### Создание модели глобуса с географической сеткой

Разработка ГИС-движка на **RAD Studio C++ Builder**.

> [!IMPORTANT]
> Для исключения эффекта **Z-fighting** (мерцания текстур), сфера сетки имеет радиус $R = 1.02 \cdot R_{earth}$.

#### Управление:
- <kbd>LMB</kbd> + `Mouse Move`: Вращение глобуса.
- <kbd>UI TreeView</kbd>: Переключение текстурных слоев (Топография/Температура).

**Интерфейс приложения:**
<p align="center">
  <img src="Lab3/image-1.png" width="600">
  <img src="Lab3/image-2.png" width="600">
  <img src="Lab3/image.png" width="600">
</p>

---

## 📍 Лабораторная работа 4
### Работа с GPS и картами в Android

> [!CAUTION]
> Начиная с Android 13, необходимо динамически запрашивать разрешение `ACCESS_FINE_LOCATION` в Runtime.

#### Особенности реализации:
- **Движок:** Delphi FireMonkey (FMX).
- **Картография:** Динамическая подгрузка `OpenStreetMap` через `TWebBrowser`.
- **Потоки:** Обратное геокодирование вынесено в отдельный поток через `TThread.Queue`.

<details>
<summary>📦 Посмотреть исходный код (Delphi Pascal)</summary>

```pascal
procedure TForm1.LocationSensor1LocationChanged(Sender: TObject; const OldLocation, NewLocation: TLocationCoord2D);
begin
  Lats := FloatToStr(NewLocation.Latitude, FS);
  Longs := FloatToStr(NewLocation.Longitude, FS);
  // Обновляем карту в браузере
  URL := Format('https://www.openstreetmap.org/?mlat=%s&mlon=%s', [Lats, Longs]);
  WebBrowser1.Navigate(URL);
end;
```
</details>

#### Тестирование на устройстве:
<!-- Специальная таблица для выравнивания вертикального скрина и горизонтальной карты -->
<table align="center">
  <tr>
    <th width="35%">📱 Мобильный клиент</th>
    <th width="65%">🗺 Координаты и адрес</th>
  </tr>
  <tr>
    <td align="center">
      <img src="Lab4/Screenshot_2026-04-06-18-15-56-67_57c6440c5213b5e28772eea05054fe6f.jpg" width="280">
    </td>
    <td align="center">
      <img src="Lab4/image.png" width="550">
    </td>
  </tr>
</table>

---

## 🇷🇺 Лабораторная работа 5
### Локализация (i18n) приложения

Реализована полная локализация интерфейса (Русский язык) с использованием встроенного менеджера ресурсов RAD Studio.

> [!NOTE]
> Переведены не только надписи на кнопках, но и системные уведомления, а также метаданные приложения.

<p align="center">
  <img src="Lab5/image.png" width="600">
</p>

<details>
<summary>🔍 Дополнительные формы</summary>

<p align="center">
  <img src="Lab5/image-1.png" width="400" style="margin-right: 10px;">
  <img src="Lab5/image-2.png" width="400">
</p>
</details>

---

## 🎓 Заключение
В ходе выполнения курса были освоены:
- [x] Работа с профессиональным ГИС-софтом (Surfer).
- [x] 3D-моделирование и работа с форматом KMZ.
- [x] Низкоуровневая разработка 3D-графики на C++.
- [x] Мобильная разработка под Android и работа с сенсорами.

---
<p align="center">Белгород, 2026</p>