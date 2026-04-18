unit MlLynch;

interface

uses 
  System.Math;
{==========================================================================}
{- Global Variables:                                                      -}
{-        Sel  -  Breakage rate vector, the fractional rate               -}
{-              at  wich matereal is broken out of the i-th  size interval-}
{-        f  -  The mass fraction vector of the Mill Feed                 -}
{-        p  -  The mass fraction vector of the Mill Product              -}
{--------------------------------------------------------------------------}

const
     RoMin = 5.0;                    { Плотность  магнетита }
     RoGan = 2.5;                    { Плотность  пустой породы }
     Ro = 3.0;                       { Плотность  руды }
     MaxSClass     = 7;
     MaxGClass    = 5;
     Nstage:word =4;

type
  TSize = array[1..MaxSClass] of real;
  TMat   = array[1..MaxSClass,1..MaxGClass] of real;
  TSqMat = array[1..MaxSClass, 1..MaxSClass] of real;

var
  Done: boolean;
  ch:Char;
  Stage,
  SLevel,GLevel,
  RowDimen,ColDimen    : integer;     { Size of the square matrix }
  SumMat               : real;
  Data,Spectres,Frac   : TMat;
  BreakMat,Diag,Inv,
  ResMat               : TSqMat;     { The matrix }
  SizeScale,GradeScale,
  FeedGrade,
  FeedSize,
  Feed, Prod,  Sel      : TSize;

  AlfaMin,GamaMin,BetaMin,EpsiMin,
  AlfaMet,GamaMet,BetaMet,EpsiMet : real;


implementation

{======================== P R O C E D U R E S ======================}

procedure Show_Mat(RowDimen: integer;
                    ColDimen: integer;
                    var Data: TMat);
var
   Row,Col : integer;
begin
   ClrScr;
   for Row := RowDimen downto 1 do
     begin
       for Col:= 1 to ColDimen do
       Write( Data[Row, Col]:8:2);
       Writeln;
     end;
     Writeln;
end; { Show_Mat }

procedure Show_SqMat(Dimen: ShortInt; var SqMat:TSqMat);
var
   Row,Col:integer;
begin
   for Row := Dimen downto 1 do
     begin
       for Col:= 1 to Dimen do
       Write(SqMat[Row, Col]:5:2);
       Writeln;
     end;
     Writeln;
end;

procedure Show_Vec(var Vec:TSize);
var  i:integer;
begin
    ClrScr;
    Writeln( '===============');
    for i:=MaxSClass downto 1 do
        Writeln(i:8,vec[i]:6:2);
end; { Show_Vec}

procedure InitialMat(Dimen : integer;
                     var  Mat   : TSqMat);
begin
  Dimen := 0;
  FillChar(Mat, SizeOf(Mat), 0);
end; { procedure InitialMat }

{=============== Lynch for grinding circuits ==============}
{-                                                        -}
{----------------------------------------------------------}
procedure Lynch;
var
  Temp: TSize;        { Template array for Prod }

procedure GetFeed;
var i: integer;
begin
    FillChar(feed, sizeof(feed),0);
   {test from Lynch}
    feed[7]:= 25;  feed[6]:= 21;  feed[5]:= 14;  feed[4]:=  8;
    feed[3]:=  5;  feed[2]:=  3;  feed[1]:= 24;   { Остаток }
end; { GetFeed }

{------------ Формирование вероятностей разрушения для размерных классов--- }
procedure GetSel;
var i: integer;
begin
   FillChar(sel,sizeof(sel),0);

   Sel[7]:=1;     Sel[6]:=0.7;   Sel[5]:=0.5;   Sel[4]:=0.35;
   Sel[3]:=0.25;  Sel[2]:=0.18;  Sel[1]:=0;
{
   i:=MaxSClass
   while i>0 do
   begin
     Sel[i]:=1 - (i+1)*(1/MaxSClass);
     dec(i);
   end;
}
end; { of GetSel }

{----------------- Use Broadbent-Callcott function ---------}
procedure MakeBreakMat;
var
   Row,Col:integer;
   base:integer;
   degree: integer;
   x,y:real;

{sub}function BroCal(x:real;y: real):real;
var
  M: real;
begin
   BroCal:=(1-exp(-x/y))/(1-exp(-1));
end; {BroCal}

begin
  { make B martix }
 FillChar(BreakMat, sizeof(Breakmat),0);
{
  for Col:=MaxSClass downto 2 do
    for Row:=MaxSClass downto 2 do
       BreakMat[Row,Col]:=BroCal(power(2,Col),power(2,Row));
}
  BreakMat[7,7]:= 0.15;
  for Col:=6 downto 1 do BreakMat[6,Col]:= 0;
  BreakMat[6,7]:= 0.20; BreakMat[6,6]:= 0.15;
  for Col:=5 downto 1 do BreakMat[6,Col]:= 0;
  BreakMat[5,7]:= 0.15; BreakMat[5,6]:= 0.20; BreakMat[5,5]:= 0.15;
  for Col:= 4 downto 1 do BreakMat[4,Col]:= 0;
  BreakMat[4,7]:= 0.10; BreakMat[4,6]:= 0.15; BreakMat[4,5]:= 0.20; BreakMat[4,4]:= 0.15;
  for Col:= 3 downto 1 do BreakMat[4,Col]:= 0;
  BreakMat[3,7]:= 0.10; BreakMat[3,6]:= 0.10; BreakMat[3,5]:= 0.15; BreakMat[3,4]:= 0.20;
      BreakMat[3,3]:= 0.15; BreakMat[3,2]:= 0;
  BreakMat[2,7]:= 0.10; BreakMat[2,6]:= 0.10; BreakMat[2,5]:= 0.10; BreakMat[2,4]:= 0.15;
     BreakMat[2,3]:= 0.20; BreakMat[2,2]:= 0.15;

end; { MakeBreakMat }


                            {   *   *   *   }
procedure CalcComminutionProduct(var Feed: TSize;
                               var Sel: TSize;
                              var Prod: TSize);
{---------------------------------------------------------------------------}
{-  1. Calc      вектор разрушенных частиц  Sf  путем умножения вектора    -}
{-     питания f на вектор вероятностей разрушения S                       -}
{-  2. Находит вектор неразрушенных частиц  [(I - S)f)]                    -}
{-  3. Находит вектор продукта из разрушенных частиц (BSf)                 -}
{-  4. Определяет суммарный продукт разрушения [(BS + I - S)f              -}
{---------------------------------------------------------------------------}
var
   Sf,Dummy,Zummy:TSize;
   Entry: real;
   i,j: shortint;


begin  {main body of CalcProduct }
    for i:=MaxSClass downto 1 do
        Sf[i]:= Feed[i]*Sel[i];                   { разрушенные частицы }
    {Dummy:=Prod;}
    for i:=MaxSClass downto 1 do
        Zummy[i]:= Feed[i]-Sf[i];              { неразрушаемые частицы }

    { продукт из разрушенных частиц }
    for i := MaxSClass downto 2 do
    begin
      Entry := 0;
      for j:= MaxSClass downto 2 do
        Entry := Entry + BreakMat[i, j] * Sf[j];
      Prod[i] := Entry;
    end;

    { cуммарный продукт }
    Entry:=0;
    for i:= MaxSClass downto 2 do
    begin
      Prod[i]:= Zummy[i] + Prod[i];
      Entry:= Entry + Prod[i];
    end;
    Prod[1]:=100-Entry;
end; { of CalcProduct }

                            {  *   *   *   }
begin { main body of Lynch }
  InitialMat(MaxSClass, BreakMat);
  GetFeed;
  Show_Vec(Feed);
  MakeBreakMat;
  Writeln('The Breakage Matrix : ');
  Show_SqMat(MaxSClass, BreakMat);
  GetSel;
  Show_Vec(Sel);
  for Stage:= 1 to Nstage do
  begin
    CalcComminutionProduct(Feed,Sel,Prod);
    Show_Vec(Prod);
    Feed:=Prod;
  end;
  Temp:=Prod;

end;  { of procedure Lynch }
end.


