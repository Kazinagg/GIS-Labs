program Min_Sim;

uses 
  Math;

{--------------------------------------------------------------------------}
{-                     Copyright (C) by VasCom                            -}
{-                    Written by Paul Vasiliev                            -}
{- With this program you can pridict Results of Grinding and Liberation   -}
{  in Iron Ore using  Matrix Method for Mineral Processing (MP) Operations-}
{-                                                                        -}
{- Source:                                                                -}
{       1. Lynch A.J. Mineral Crushing and Grinding Circuits.             -}
{-         Elsevier Scientific Publishing Company.New York, 1977          -}
{-      2. Vasiliev.P.V. Method of stereologocal Analysis for             -}
{-         prediction main Technological parameters in Magnetite Ore.     -}
{-         Diss.Cand.Sci. Moscow Mining Institute. 1989.                  -}
{-                                                                        -}
{- Version Date:    January 1993                                          -}
{-                                                                        -}
{- Global Variables:                                                      -}
{-        Sel  -  Breakage rate vector, the fractional rate                 -}
{-              at  wich matereal is broken out of the i-th  size interval-}
{-        f  -  The mass fraction vector of the Mill Feed                 -}
{-        p  -  The mass fraction vector of the Mill Product              -}
{--------------------------------------------------------------------------}

const
     RoMin = 5.0;                    { Density of target mineral }
     RoGan = 2.5;                    { Density of waste ore }
     Ro = 3.0;                       { Density of ore }
     MetInMin = 0.7236;              { Value component in mineral }
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

{
}
{--------- Prepare Spectres of Composite Particles under Grinding------}
procedure SpecTree;

procedure GetResort;
begin
  FillChar(ResMat, sizeof(ResMat),0);
ResMat[1,1]:=1.0; ResMat[1,2]:=0.3; ResMat[1,3]:=0.1; ResMat[1,4]:=0.0; ResMat[1,5]:=0.0;
ResMat[2,1]:=0.0; ResMat[2,2]:=0.4; ResMat[2,3]:=0.25;ResMat[2,4]:=0.0; ResMat[2,5]:=0.0;
ResMat[3,1]:=0.0; ResMat[3,2]:=0.3; ResMat[3,3]:=0.3; ResMat[3,4]:=0.3; ResMat[3,5]:=0.0;
ResMat[4,1]:=0.0; ResMat[4,2]:=0.0; ResMat[4,3]:=0.25;ResMat[4,4]:=0.4; ResMat[4,5]:=0.0;
ResMat[5,1]:=0.0; ResMat[5,2]:=0.0; ResMat[5,3]:=0.1; ResMat[5,4]:=0.3; ResMat[5,5]:=1.0;
end; { GetResort }

procedure Scale_Of_Grade;
begin
     GradeScale[1]:=0; GradeScale[2]:=18; GradeScale[3]:=50; GradeScale[4]:=82;
     GradeScale[5]:=100;
end; { Scale_Of_Grade5 }


procedure GetFeedGrade;
begin
    FeedGrade[1]:=35;  FeedGrade[2]:= 23;  FeedGrade[3]:= 19;
    FeedGrade[4]:=12;  FeedGrade[5]:= 11;
end; { of GetFeedGrade }

procedure CalcLibMat;
var
   Row,Col: integer;
   Dummy:TSize;
   i,j:shortint;
   Entry:real;

{sub}procedure ResortOnGrade;
var
   i,j: shortint;
begin
   for i := 1 to MaxGClass do
    begin
      Entry := 0;
      for j:= 1 to MaxGClass do
        Entry := Entry + ResMat[i, j] * FeedGrade[j];
      Prod[i] := Entry;
    end;
end;

begin
  i:=1;
  for j:=1 to MaxGClass do
      Spectres[i,j]:=FeedGrade[j];
  Row:=2;
  ResortOnGrade;

  for j:=1 to MaxGClass do
      Spectres[i,j]:=Prod[j];
  Dummy:=Prod;

  for Row:=MaxSClass downto 3 do
   begin
      ResortOnGrade;
      {MultMatVec(MaxGClass,ResMat,Dummy,Prod);}
      for Col:=1 to MaxGClass do
          Spectres[Row,Col]:=Prod[Col];
      Dummy:=Prod;
   end;
end; { of CalcLibMat }

begin { main body of SpecTree }
  InitialMat(MaxGClass,ResMat);
  GetResort;
  Scale_Of_Grade;

  Writeln( 'The Resort Matrix : ');

  Show_SqMat(MaxGClass,ResMat);

  GetFeedGrade;

  CalcLibMat;
  Writeln(' LIBERATION MATRIX after grinding: ');
  Show_Mat(RowDimen,ColDimen,Spectres);
end; { of Spectree }

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
var
  i: integer;
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
procedure CalcGrindingProduct(var Feed: TSize;
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

    { sum product }
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
    CalcGrindingProduct(Feed,Sel,Prod);
    Show_Vec(Prod);
    Feed:=Prod;
  end;
  Temp:=Prod;
end;  { of procedure Lynch }

{-------------------- Calc fractions ---------------}
procedure Fraction(RowDimen: integer;
                   ColDimen: integer;
                   var Liber: TMat;
                   var Frac : TMat);
{ Make the Matrix of Fractions for the Mill Product }
var
   Row,Col: integer;

begin  { Fraction }
    SumMat:=0;
    for Row:=1 to RowDimen do
      for Col:=1 to ColDimen do
      begin
        Frac[Row,Col]:= Prod[Row] *  Liber[Row,Col] /100;
        SumMat:=SumMat + Frac[Row,Col]
      end;

  Writeln( ' YIELDS OF FRACTIONS: ');
  Show_Mat(RowDimen,ColDimen,Frac);

  Write( 'SUMMAT: ');  Writeln( SumMat:3:1);
end; { of Fraction }

procedure ChoiceLevel;
begin
    SLevel:= 3;
    GLevel:= 3;
end; { ChoiceLevel }

procedure IdealSeparation;

var
   Row,Col: integer;
begin
    AlfaMin:=0.0;
    GamaMin:=0.0;
    BetaMin:=0.0;
    for Row:=1 to RowDimen do
        for Col:=1 to ColDimen do
            AlfaMin:= AlfaMin + Frac[Row,Col] * GradeScale[Col]/100;
    for Row:= Slevel to RowDimen do
        for Col:=Glevel to ColDimen do
          begin
             GamaMin:= GamaMin + Frac[Row,Col];
             BetaMin:= BetaMin + Frac[Row,Col]*GradeScale[Col]/100;
          end;
    if GamaMin > 0 then
          BetaMin:= 100 * BetaMin/GamaMin
    else
          BetaMin:=0;
    if AlfaMin > 0 then
        EpsiMin:= GamaMin * BetaMin / AlfaMin
    else
        EpsiMin:=0;
end; { of IdealSeparation }

procedure Metall;
begin
   AlfaMet:= MetInMin * AlfaMin * RoMin/
             (AlfaMin - (100 - AlfaMin) * (RoGan/RoMin));
   BetaMet:= MetInMin * BetaMin * RoMin/
             (BetaMin - (100 - BetaMin) * (RoGan/RoMin));
   GamaMet:= GamaMin  * (AlfaMin * RoMin + (100 - AlfaMin)*RoGan)/
                        (BetaMin * RoMin + (100 - BetaMin)*RoGan);
   EpsiMet:= GamaMet  * BetaMet / AlfaMet;

end; { of Metall }

procedure ShowParams;
begin
   Clrscr;
   Writeln;
   Writeln('Parameters of Mineralurgy Process after Separation');
   Writeln('of Particles on Size Class ',Slevel,' and Grade Class ',Glevel);
       Writeln;
       Writeln('              MINERAL                    ');
       Writeln('CONTENTS in raw ore:         ',AlfaMin:8:2);
       Writeln('CONTENTS in concentrate:     ',BetaMin:8:2);
       Writeln('YIELD of concentrate:        ',GamaMin:8:2);
       Writeln('RECOVERY in conccentrate:    ',EpsiMin:8:2);

       Writeln('              METALL                     ');
       Writeln('CONTENTS in raw ore:         ',AlfaMet:8:2);
       Writeln('CONTENTS in concentrate:     ',BetaMet:8:2);
       Writeln('YIELD of concentrate:        ',GamaMet:8:2);
       Writeln('RECOVERY in conccentrate:    ',EpsiMet:8:2);

   Repeat until keypressed;
   Clrscr;
end; { ShowParams }

{---------------------------- MAIN BODY ------------------------------------}
begin
    ClrScr;
    Lynch;
    Readkey;
    RowDimen:=MaxSClass;
    ColDimen:=MaxGClass;

    SpecTree;
    readkey;
    Fraction(RowDimen,ColDimen,Spectres,Frac);

    ChoiceLevel;
    IdealSeparation;
    Metall;
    ShowParams;
end.


