// ----------------------------------------------------------------------------
// Stereonet unit for Geoblock, http://sourceforge.net/projects/geoblock
// ----------------------------------------------------------------------------
//
// ! The Stereonet unit for Stereonet program
{
  Hystory log
  12/05/06 - PVV - Last modified
  15/01/04 - PVV - Added Tree component
  01/01/00 - PVV - Creation;
}
unit uStereonet;

interface

// The Initial Developer of the Original Code:
// Written by Walter L.Pilant
// Department of Geology and Planetary Science,
// University of Pittsburgh, PA 15260, USA
// ==============================================
// Published in:
// Walter L.Pilant.
// A PC-Interactive Stereonet Plotting Program.
// Computers & Geosciences
// Vol.15, No 1, pp 43-58, 1989
// =============================================\\
// Modified for Borland Delphi by Getos Ltd., 1999

uses
  SysUtils;

implementation

(*
  This program generates both the Wulff Net and
  the Schmidt Net screens for the interactive stereo package.
  This program could have been included with the main routines
  but it is much faster to prepare the screens before and
  dump them into screen memory then to recalculate them each time
*)

// label
// 51,52,53,59;

type
  StorPtr = ^Storage;
  Storage = Array [0 .. 16383] of Byte;

var
  OK: boolean;
  i, j, k, ix, iy, LineMax, Symbol: integer;
  Ln, Dt, Sb: array [1 .. 250] of integer;
  x, y, z, Lat, Long, CD, SD, Temp, Rot, DelRot, Tilt, DelTilt: real;
  St, Dp, XLoc, YLoc: array [1 .. 250] of real;
  Ch, Ans: char;
  FileName: string[8];
  FileVar: text;
  SterFile: file;
  Wnet, Snet, BlankScreen: StorPtr;

var
  d, r, e: integer;
  m, mm, n, nn: integer;
  u, theta, DelGrid, arg, Sth, Cth, Tth, xcurr, xprev, ycurr, yprev: real;

  Screen: Array [0 .. 16383] of Byte;

  // Procedures needed for main program
procedure GPlot(var ix, iy, Symbol: integer);
var
  m, n: integer;
begin
  m := ix;
  n := 200 - iy;
  case Symbol of
    0:
      begin
        // Plot(m,n,3);
      end;
    1:
      begin
        // Plot(m,n,1);Plot(m+1,n,1);Plot(m-1,n,1);
        // Plot(m,n+1,1);Plot(m,n-1,1);
      end;
    2:
      begin
        // Plot(m,n,3);Plot(m+1,n,3);Plot(m-1,n,3);
        // Plot(m,n+1,3);Plot(m,n-1,3);
      end;
    3:
      begin
        // Plot(m,n,1);Plot(m+1,n+1,1);Plot(m-1,n-1,1);
        // Plot(m-1,n+1,1);Plot(m+1,n-1,1);
      end;
    4:
      begin
        // Plot(m,n,3);Plot(m+1,n+1,3);Plot(m-1,n-1,3);
        // Plot(m-1,n+1,3);Plot(m+1,n-1,3);
      end;
    5:
      begin
        // Plot(m,n,1);Plot(m+1,n+1,1);Plot(m-1,n+1,1);Plot(m,n-1,1);
      end;
    6:
      begin
        // Plot(m,n,3);Plot(m+1,n+1,3);Plot(m-1,n+1,3);Plot(m,n-1,3);
      end;
    7:
      begin
        // Plot(m,n,1);Plot(m+1,n-1,1);Plot(m-1,n-1,1);Plot(m,n+1,1);
      end;
    8:
      begin
        // Plot(m,n,3);Plot(m+1,n-1,3);Plot(m-1,n-1,3);Plot(m,n+1,3);
      end;
    9:
      begin
        // Plot(m+1,n,1);Plot(m-1,n,1);Plot(m,n+1,1);Plot(m,n-1,1);
      end;
    10:
      begin
        // Plot(m+1,n,3);Plot(m-1,n,3);Plot(m,n+1,3);Plot(m,n-1,3);
      end;
    11:
      begin
        // Plot(m+1,n+1,1);Plot(m,n+1,1);Plot(m-1,n+1,1);Plot(m+1,n-1,1);
        // Plot(m,n-1,1);Plot(m-1,n-1,1);Plot(m+1,n,1);Plot(m-1,n,1);
      end;
    12:
      begin
        // Plot(m+1,n+1,3);Plot(m,n+1,3);Plot(m-1,n+1,3);Plot(m+1,n-1,3);
        // Plot(m,n-1,3);Plot(m-1,n-1,3);Plot(m+1,n,3);Plot(m-1,n,3);
      end;
  else
    begin
    end;
  end; // case
end; // GPlot

procedure Plot13(var x, y: real); { Plots Pole and circle }
var { for Wulff net }
  r, xc, yc, xd, yd, xp, yp, rad, xdsq, ydsq: real;
  m, n: integer;

begin
  m := 208 + round(110 * x);
  n := 100 - round(99 * y);

  // Plot(m,n,1);Plot(m+1,n,1);Plot(m-1,n,1);Plot(m+2,n,1);Plot(m-2,n,1);
  // Plot(m,n+1,1);Plot(m,n-1,1);Plot(m,n+2,1);Plot(m,n-2,1);
  r := sqrt(x * x + y * y);
  rad := (1 + r * r) / (1.000001 - r * r);
  xc := 2 * x / (1.000001 - r * r);
  yc := 2 * y / (1.000001 - r * r);
  m := 88;
  while m < 319 do
  begin
    xp := (m - 208) / 110;
    xd := abs(xp - xc);
    ydsq := rad * rad - xd * xd;
    if ydsq > 0.0 then
    begin
      yd := sqrt(ydsq);
      if xd <= yd then
      begin
        yp := yc + yd;
        if (xp * xp + yp * yp) < 1.0 then
        begin
          n := 100 - round(99 * yp);
          // Plot(m,n,1);
        end;
        yp := yc - yd;
        if (xp * xp + yp * yp) < 1.0 then
        begin
          n := 100 - round(99 * yp);
          // Plot(m,n,1);
        end;
      end;
    end;
    m := m + 1;
  end;
  n := 1;
  while n < 200 do
  begin
    yp := (100 - n) / 99;
    yd := abs(yp - yc);
    xdsq := rad * rad - yd * yd;
    if xdsq > 0.0 then
    begin
      xd := sqrt(xdsq);
      if yd <= xd then
      begin
        xp := xc + xd;
        if (xp * xp + yp * yp) < 1.0 then
        begin
          m := 208 + round(110 * xp);
          // Plot(m,n,1);
        end;
        xp := xc - xd;
        if (xp * xp + yp * yp) < 1.0 then
        begin
          m := 208 + round(110 * xp);
          // Plot(m,n,1);
        end;
      end;
    end;
    n := n + 1;
  end;
end; { Plot13 }

{ Plots heavy cross only, Schmidt Net }
procedure P13(var x, y: real);
var
  m, n: integer;

begin
  m := 208 + round(110 * x);
  n := 100 - round(99 * y);
  // Plot(m,n,1);Plot(m+1,n,1);Plot(m-1,n,1);Plot(m+2,n,1);Plot(m-2,n,1);
  // Plot(m,n+1,1);Plot(m,n-1,1);Plot(m,n+2,1);Plot(m,n-2,1);
end; { P13 }

procedure PutWulffData;
begin
  for i := 1 to LineMax do
  begin
    if (Dt[i] = 1) or (Dt[i] = 2) then
    begin
      ix := 208 + round(110 * XLoc[i]);
      iy := 100 + round(99 * YLoc[i]);
      if Sb[i] = 13 then
        Plot13(XLoc[i], YLoc[i])
      else
        GPlot(ix, iy, Sb[i]);
    end;
  end;
end; { PutWulffData }

procedure PutSchmidtData;
var
  xs, ys, v: real;
begin
  for i := 1 to LineMax do
  begin
    if (Dt[i] = 1) or (Dt[i] = 2) then
    begin
      v := sqrt(1 + XLoc[i] * XLoc[i] + YLoc[i] * YLoc[i]);
      xs := 1.414 * XLoc[i] / v;
      ys := 1.414 * YLoc[i] / v;
      ix := 208 + round(110 * xs);
      iy := 100 + round(99 * ys);
      if Sb[i] = 13 then
        P13(xs, ys)
      else
        GPlot(ix, iy, Sb[i]);
    end;
  end;
end; { PutSchmidtData }

procedure Rotate;
begin
  Move(BlankScreen^, Screen, 16384);
  Move(Wnet^, Screen, 16384);
  Rot := Rot + DelRot;

  // GoToXY(1,1);
  Writeln('Rot =', Rot:6:1);
  Writeln('Tilt=', Tilt:6:1);
  CD := Cos(DelRot * pi / 180);
  SD := Sin(DelRot * pi / 180);
  for i := 1 to LineMax do
  begin
    if (Dt[i] = 1) or (Dt[i] = 2) then
    begin
      Temp := XLoc[i] * CD - YLoc[i] * SD;
      ix := 208 + round(110 * Temp);
      YLoc[i] := YLoc[i] * CD + XLoc[i] * SD;
      iy := 100 + round(99 * YLoc[i]);
      XLoc[i] := Temp;
      // if not keypressed then
      if Sb[i] = 13 then
        Plot13(XLoc[i], YLoc[i])
      else
        GPlot(ix, iy, Sb[i]);
    end;
  end;
end; { Rotate }

procedure Revolve;
var
  xw, yw, xsq, ysq, xo, yo, arglat, arglong: real;
begin
  Move(BlankScreen^, Screen, 16384);
  Move(Wnet^, Screen, 16384);
  Tilt := Tilt + DelTilt;
  // GoToXY(1,1);
  Writeln('Rot =', Rot:6:1);
  Writeln('Tilt=', Tilt:6:1);
  for i := 1 to LineMax do
  begin
    if (Dt[i] = 1) or (Dt[i] = 2) then
    begin
      xw := XLoc[i];
      yw := YLoc[i];
      xsq := xw * xw;
      ysq := yw * yw;
      if abs(xw) < 0.0001 then
        Long := 0.0
      else
      begin
        if xw > 0 then
          xo := (1 - xsq - ysq) / 2 / xw + 0.000001
        else
          xo := (1 - xsq - ysq) / 2 / xw - 0.000001;
        Long := ArcTan(1.0 / xo) / pi * 180;
      end;
      Long := Long - DelTilt;
      if abs(yw) < 0.0001 then
        Lat := 0.0
      else
      begin
        if abs(xw) < 0.0001 then
          yo := (1 + ysq) / 2 / yw
        else
          yo := (xsq + ysq + xw * xo) / yw;
        Lat := yw / abs(yw) * ArcTan(1.0 / sqrt(yo * yo - 0.9999999)) /
          pi * 180;
      end;
      if (DelTilt > 0) and (Long < -90.0) then
      begin
        Long := Long + 180;
        Lat := -Lat;
      end;
      if (DelTilt < 0) and (Long > 90.0) then
      begin
        Long := Long - 180;
        Lat := -Lat;
      end;
      arglat := pi * Lat / 180;
      arglong := pi * Long / 180;
      x := Cos(arglat) * Sin(arglong);
      y := Sin(arglat);
      z := 1 + Cos(arglat) * Cos(arglong);
      XLoc[i] := x / z;
      YLoc[i] := y / z;
      ix := 208 + round(110 * XLoc[i]);
      iy := 100 + round(99 * YLoc[i]);
      // if not KeyPressed then
      if Sb[i] = 13 then
        Plot13(XLoc[i], YLoc[i])
      else
        GPlot(ix, iy, Sb[i]);
    end;
  end;
end; { Revolve }

{
  Main program - input and initialization
}
begin
  {
    51:Writeln('What file would you like shown in STEREONET plot?');
    Writeln(' Up to eight characters please: "dat" will be appended');
    Readln(FileName);
    Writeln;
    Writeln('The chosen file name is ', FileName+'.dat');
    Assign(FileVar,FileName+'.dat');
    Reset(FileVar);
    New(Wnet); New(Snet); New(BlankScreen);
    FillChar(BlankScreen^,16384,#0);
    Assign(SterFile,'Wulff.Pic');
    Reset(SterFile);
    BlockRead(SterFile,WNet^,128);
    Close(SterFile);
    Assign(SterFile,'Schmidt.Pic');
    Reset(SterFile);
    BlockRead(SterFile,SNet^,128);
    Close(SterFile);
    //   GraphColorMode; GraphBackGround(0); Palette(3);
    Move(BlankScreen^,Screen,16384);
    Move(WNet^,Screen,16384);
    Rot:=0.0; Tilt:= 0.0;
    //   GoToXY(1,1);
    //   Writeln('Rot =',Rot:6:1); Writeln('Tilt=',Tilt:6:1);
    for i:= 1 to 250 do
    begin
    Ln[i]:= 0; Dt[i]:=0; St[i]:=0; Dp[i]:=0;
    XLoc[i]:=0; YLoc[i]:=0;
    end;
    i:=1;
    while not eof(Filevar) do
    begin
    Read(Filevar,Dt[i]);
    k:= Dt[i];
    case k of
    1: begin
    readln(Filevar,St[i],Dp[i],Sb[i]);
    XLoc[i]:= - sin(pi*Dp[i]/360)/cos(pi*Dp[i]/360)
    *cos(pi*St[i]/180);
    YLoc[i]:= + sin(pi*Dp[i]/360)/cos(pi*Dp[i]/360)
    *sin(pi*St[i]/180);
    end;
    2: begin
    readln(Filevar,St[i],Dp[i],Sb[i]);
    XLoc[i]:= sin(pi*(90-Dp[i])/360)/cos(pi*(90-Dp[i])/360)
    *sin(pi*St[i]/180);
    YLoc[i]:= sin(pi*(90-Dp[i])/360)/cos(pi*(90-Dp[i])/360)
    *cos(pi*St[i]/180);
    end;
    else Begin
    Readln(FileVar);
    end;
    end;
    i:= i+1;
    end;
    Close(Filevar);
    LineMax:= i-1;
    PutWulffData;

    // INTERACTIVE PORTION

    //   52: //repeat until keypressed;
    //Ch:=Readkey;

    if ch = Chr(43) then
    begin
    //         TextColor(0);
    //         GoToXY(1,1);
    Writeln('Rot =',Rot:6:1); Writeln('Tilt=',Tilt:6:1);
    //         GoToXY(1,14);
    Writeln('INTERACTIVE KEYS');  Writeln;
    Writeln('-->  Rot Rt');
    Writeln('<--  Rot Lft');
    Writeln('PgDn Tilt Rt');
    Writeln('End  Tilt Lft');
    Writeln('Home to DOS');
    Writeln('PgUp Restore');
    Writeln('+ Del Text');
    Writeln('- Schmidt Net');
    //        Delay(3000);
    FillChar(Screen,16384,0);
    ix:= 318; iy:= 100;
    //        Plot(ix,iy,i);
    ix:= 208; iy:= 100;
    //        Plot(ix,iy,i);
    ix:= 98; iy:= 100;
    //        Plot(ix,iy,i);
    PutWulffData;
    //        Delay(3000);
    Move(BlankScreen^,Screen,16384);
    Move(WNet^,Screen,16384);
    PutWulffData;
    //        TextColor(3);
    //        GoToXY(1,1);
    Writeln('Rot =',Rot:6:1); Writeln('Tilt=',Tilt:6:1);
    //        GoToXY(1,14);
    Writeln('INTERACTIVE KEYS');  Writeln;
    Writeln('-->  Rot Rt');
    Writeln('<--  Rot Lft');
    Writeln('PgDn Tilt Rt');
    Writeln('End  Tilt Lft');
    Writeln('Home to DOS');
    Writeln('PgUp Restore');
    Writeln('+ Del Text');
    Writeln('- Schmidt Net');
    //        GoToXY(1,3);
    //        GOTO 52;
    end;

    if Ch = Chr(45) then         // MINUS key struck -- get Schmidt net
    begin
    Move(BlankScreen^,Screen,16384);
    Move(SNet^,Screen,16384);
    //        GoToXY(1,1);
    Writeln('Rot =',Rot:6:1); Writeln('Tilt=',Tilt:6:1);
    PutSchmidtData;
    //   53:  // Repeat Until Keypressed;
    // Ch:= Readkey;
    if Ch = Chr(43) then            // PLUS key struck -- erase text
    begin
    //          TextColor(0);
    //          GoToXY(1,1);
    Writeln('Rot =',Rot:6:1); Writeln('Tilt=',Tilt:6:1);
    //          GoToXY(1,14);
    Writeln('КЛАВИШИ ');  Writeln; Writeln;
    //          GoToXY(1,23);
    Writeln('+ Уд.  текстa');
    Writeln('- Сеть Шмидта');
    //          Delay(3000);
    FillChar(Screen,16384,0);
    ix:= 318; iy:= 100;
    //         Plot(ix,iy,i);
    ix:= 208; iy:= 100;
    //         Plot(ix,iy,i);
    ix:= 98; iy:= 100;
    //         Plot(ix,iy,i);
    PutSchmidtData;
    //         Delay(3000);
    Move(BlankScreen^,Screen,16384);
    Move(WNet^,Screen,16384);
    PutSchmidtData;
    //         TextColor(3);
    //         GoToXY(1,1);
    Writeln('Rot =',Rot:6:1); Writeln('Tilt=',Tilt:6:1);
    //         GoToXY(1,14);
    Writeln('КЛАВИШИ ');  Writeln;  Writeln;
    //          GoToXY(1,23);
    Writeln('+ Уд.  текстa');
    Writeln('- Сеть Вульфа');
    //          GoToXY(1,3);
    //          GoTo 53;
    end;
    if Ch = Chr(45) then    // MINUS key struck -- return to Wulff Net
    begin
    Move(BlankScreen^,Screen,16384);
    Move(WNet^,Screen,16384);
    //        GoToXY(1,1);
    Writeln('Rot =',Rot:6:1); Writeln('Tilt=',Tilt:6:1);
    PutWulffData;
    //        GoTo 52;
    end;
    //       if Ch = Chr(27) then Ch:= Readkey;
    Writeln('Нажмите клавишу + или - ');
    //       GoTo 53;
    end;

    // if initial key was not + or -, we arrive at this point

    if Ch = Chr(27) then               // Test cursor pad
    begin
    //         Ch:= Readkey;
    if Ch = Chr(71) then           // Home - Returne to DOS
    begin
    //          GoTo 59;
    end;
    if Ch = Chr(73) then         // PgUp - Restore Orig Data
    begin
    Move(BlankScreen^,Screen,16384);
    Move(WNet^,Screen,16384);
    For i:= 1 to LineMax do
    begin
    k:= Dt[i];
    Case k of
    1: begin
    XLoc[i]:= -sin(pi*Dp[i]/360)/cos(pi*Dp[i]/360)
    *cos(pi*St[i]/180);
    YLoc[i]:= +sin(pi*Dp[i]/360)/cos(pi*Dp[i]/360)
    *sin(pi*St[i]/180);
    end;
    2: begin
    XLoc[i]:= sin(pi*(90-Dp[i])/360)/cos(pi*(90-Dp[i])/360)
    *sin(pi*St[i]/180);
    YLoc[i]:= sin(pi*(90-Dp[i])/360)/cos(pi*(90-Dp[i])/360)
    *cos(pi*St[i]/180);
    end;
    else Begin End;
    end;
    end;
    PutWulffData;
    Rot:= 0.0; Tilt:= 0.0;
    //       GoToXY(1,1);
    Writeln('Rot =',Rot:6:1); Writeln('Tilt =',Tilt:6:1);
    //       GoTo 52;
    end;
    if Ch = Chr(26) then           // Левая стрелка - вращение
    begin
    DelRot:= 1.0;
    Rotate;
    //        Goto 52;
    end;
    if Ch = Chr(115) then
    begin
    DelRot:= 5.0;
    Rotate;
    //        Goto 52;
    end;
    if Ch = Chr(27) then          // RightArrow -- Rotate CW
    begin
    DelRot:= -1.0;
    Rotate;
    //        Goto 52;
    end;
    if Ch = Chr(116) then
    begin
    DelRot:= -5.0;
    Rotate;
    //        Goto 52;
    end;
    if Ch = Chr(79) then
    begin
    DelTilt:= +1.0;
    Revolve;
    //        Goto 52;
    end;
    if Ch = Chr(117) then
    begin
    DelTilt:= +5.0;
    Revolve;
    //        Goto 52;
    end;
    if Ch = Chr(81) then
    begin
    DelTilt:= -1.0;
    Revolve;
    //        Goto 52;
    end;
    if Ch = Chr(118) then
    begin
    DelTilt:= -5.0;
    Revolve;
    //        Goto 52;
    end;
    //  end;

    Writeln(' Incorrect key pressed, see list below!');
    //  GoTo 52;

    //  59: Begin end;
    //      TextMode(2);

    // Main program
    begin
    //   GraphColorMode;
    //     GraphBackGround(0); Palette(3);
    //   TextColor(3);
    DelGrid:=30.0;                // Установка размера решетки сетки Вульфа
    For n:= 6 to 100 do
    begin
    nn:= 200-n;
    //          Plot(208,n,2); Plot(208,nn,2);
    end;
    theta:= DelGrid;
    While theta < 89.0 do
    begin
    arg:= pi*theta/180;
    Sth:= sin(arg);
    Cth:= cos(arg);
    Tth:= Sth/Cth;
    For n:= 1 to 100 do
    begin
    nn:= 200 - n;
    y:= (100 - n)/99;
    x:= Sqrt(1/Sth/Sth - y*y) - Cth/Sth;
    m:= 208 - round(110*x);
    mm:=416 - m;
    if y < 1 - 0.05*Cth then
    begin
    //                Plot(m,n,2);Plot(m,nn,2);
    //                Plot(mm,n,2);Plot(mm,nn,2);
    end;
    theta:= theta + DelGrid;
    end;
    For m:= 99 to 208 do
    begin
    mm:=416 - m;
    //         Plot(m,100,2); Plot(mm,100,2);
    end;
    theta:= DelGrid;
    While theta < 89.0 do
    begin
    arg:= pi*theta/180;
    Sth:= sin(arg);
    Cth:= cos(arg);
    Tth:= Sth/Cth;
    For m:= 99 to 208 do
    begin
    mm:= 416 - m;
    x:= (208 - m)/110;
    if (1/Tth - x) > 0 then
    begin
    y:= 1/Sth- Sqrt(1/Tth/Tth - x*x);
    if (x*x+y*y) < 1.0 then
    begin
    n:= 100- round(99*y);
    nn:=200 - n;
    //                 Plot(m,n,2);Plot(m,nn,2);
    //                 Plot(mm,n,2);Plot(mm,nn,2);
    end;
    end;
    end;
    theta:= theta + DelGrid;
    end;
    n:=100;
    While n > 38 do
    begin
    y:= (100 - n)/99;
    x:=sqrt(1 - y*y);
    m:= 208 - round(110*x); mm:= 416 - m; nn:= 200 - n;
    //          Plot(m,n,2); Plot(m,nn,2);
    //          Plot(mm,n,2);Plot(mm,nn,2);
    n:= n - 1;
    end;
    m:= m + 1;
    While m < 209 do
    begin
    x:= (208 - m)/110;
    y:= sqrt(1 - x*x);
    n:= 100 - round(99*y); nn:= 200 - n; mm:= 416 - m;
    //          Plot(m,n,2); Plot(m,nn,2);
    //          Plot(mm,n,2);Plot(mm,nn,2);
    m:= m + 1;
    end;
    //        GoToXY(1,14);
    Writeln('КЛАВИШИ ');  Writeln;
    Writeln('-->  Вращ вП');
    Writeln('<--  Вращ вЛ');
    Writeln('PgDn Tilt вП');
    Writeln('End  Tilt вЛ');
    Writeln('Home - в DOS');
    Writeln('PgUp  Восст.');
    Writeln('+ Уд.  текстa');
    Writeln('- Сеть Шмидта');
    Assign(SterFile,'Wulff.Pic');
    Rewrite(SterFile);
    BlockWrite(SterFile,Screen,128);    // Сохранение экрана в Wulff.Pic
    FillChar(Screen,16384,#0);          // Опустошение экрана
    Reset(SterFile);
    BlockRead(SterFile,Screen,128);     // Восстановление Wulff.Pic
    Close(SterFile);
    //        Delay(5000);
    FillChar(Screen,16384,#0);

    //  Следующий алгоритм является точным при различных X и Y, но
    //  начинаются сложности при попытке достичь линии толщиной в
    //  один пиксель. Довольно грубоватый метод, реализованный ниже,
    //  позволяет избежать решения квадратического уравнения.

    DelGrid:= 15.0;
    for n:= 6 to 100 do
    begin
    nn:= 200 - n;
    //            plot(208,n,2); plot(208,nn,2);
    end;
    long:= DelGrid;
    While long < 89.0 do
    begin
    lat:= - 85.0;                      // Инициализация широты
    ycurr:= 1;
    While lat < 1.0 do
    begin
    x:= cos(pi*lat/180)*sin(pi*long/180);
    y:= sin(pi*lat/180);
    z:= 1.0 +sqrt(1.0 - x*x -y*y);
    u:= sqrt(x*x + y*y + z*z);
    ycurr:= Int(y/u*99*1.414);      // Расчет позиции Y-пикселя
    if ((ycurr - yprev) > 0) then
    begin
    m:= 208 + round(x/u*110*1.414); mm:= 416 - m;
    n:= 100 - round(y/u*99*1.414);  nn:= 200 - n;
    //                 Plot(m,n,2); Plot(m,nn,2); Plot(mm,n,2); Plot(mm,nn,2);
    end;
    yprev:= ycurr;                   // Сброс позиции пикселя
    lat:= lat + 0.2;
    end;
    long:= long + DelGrid;
    end;
    for m:= 99 to 208 do
    begin
    mm:= 416 - m;
    //              plot(m,100,2); plot(mm,100,2);
    end;
    lat:= DelGrid;
    While lat < 89.0 do
    begin
    long:= - 89.5;                      // Инициализация долготы
    xprev:= 208;
    While long < 1.0 do
    begin
    x:= cos(pi*lat/180)*sin(pi*long/180);
    y:= sin(pi*lat/180);
    z:= 1.0 +sqrt(1.0 - x*x -y*y);
    u:= sqrt(x*x + y*y + z*z);
    xcurr:= Int(x/u*99*1.414);      // Расчет позиции X-пикселя
    if ((xcurr - xprev) > 0) then
    begin
    m:= 208 + round(x/u*110*1.414); mm:= 416 - m;
    n:= 100 - round(y/u*99*1.414);  nn:= 200 - n;
    //                 Plot(m,n,2); Plot(m,nn,2); Plot(mm,n,2); Plot(mm,nn,2);
    end;
    xprev:= xcurr;                     // Сброс позиции пикселя
    long:= long + 0.2;
    end;
    lat:= lat + DelGrid;
    end;
    n:= 100;                                  // Создание граничного круга
    While n > 38 do                           // Почти вертикальные линии
    begin
    y:= (100 - n)/99;
    x:= sqrt(1 - y*y);
    m:= 208 - round(110*x); mm:= 416 - m; nn:= 200 - n;
    //         Plot(m,n,2); Plot(m,nn,2); Plot(mm,n,2); Plot(mm,nn,2);
    n:= n - 1;
    end;
    m:= m + 1;
    While m < 209 do                          // Почти горизонтальн линии
    begin
    x:= (208 - m)/110;
    y:= sqrt(1 - x*x);
    n:= 100 - round(99*y); nn:= 200 - n; mm:= 416 - m;
    //         Plot(m,n,2); Plot(m,nn,2); Plot(mm,n,2); Plot(mm,nn,2);
    m:= m + 1;
    end;

    //     GoToXY(1,14);
    Writeln('КЛАВИШИ ');  Writeln;
    //     GoToXY(1,23);
    Writeln('+ Уд.  текстa');
    Writeln('- Сеть Вульфа');
    Assign(SterFile,'Schmidt.Pic');
    Rewrite(SterFile);
    BlockWrite(SterFile,Screen,128);       // Сохранение экрана в Schmidt.Pic
    FillChar(Screen,16384,#0);             // Опустошение экрана
    Reset(SterFile);
    BlockRead(SterFile,Screen,128);        // Восстановление Schmidt.Pic
    Close(SterFile);
    //     Delay(5000);                         // Для возможного нажатия PrtSc
    //     TextMode(2);
    end;
    end;
    end;
  }

end. { Stereo }
