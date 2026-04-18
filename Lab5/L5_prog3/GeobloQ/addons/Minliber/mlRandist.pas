{$N+}
unit mlRandist;

interface

uses
  mlGlobals;

const
   MaxClass = 14;

type
   Vec = array[1..MaxClass] of real;

function RandUniform(RLow,RHigh:Real):Real;
function RandExponent(Mean:Real): Real;
function RandNorm(Mean, StDev:Real):Real;
function RandLogNorm(Mean, StDev:Real):Real;
function RandGauss(Mean, StdDev: Extended): Extended;
function RandEmpiric(X:Vec; Fx:Vec; NClass:word): real;


implementation

{=======================================================}
{       Uniform Random numbers in RLow..RHigh range     }
{-------------------------------------------------------}
function RandUniform(RLow,RHigh:Real):Real;
begin
  RandUniform:= RLow + (RHigh-RLow)*Random;
end;

 {------------------------------------------------------}
 {                  RANDOM EXPONENTIAL                  }
 {------------------------------------------------------}

 function RandExponent(Mean:Real): Real;
 begin
    RandExponent:= -Mean * Ln(Random);
 end;

 {------------------------------------------------------}
 {                   RANDOM  NORMAL                     }
 {------------------------------------------------------}

 function RandNorm(Mean, StDev:Real):Real;
 var
   S, Y, U1, U2: Real;
 begin
   repeat
     U1:= 2*Random - 1;
     U2:= 2*Random - 1;
     S := U1*U1 + U2*U2;
   until (S<1);
   Y:= U2*Sqrt(-2*Ln(S)/S);
   RandNorm:= Mean + StDev * Y
 end; { of Normal }


{-------------------------------------------------------}
{              RANDOM GAUSSIAN                          }
{-------------------------------------------------------}
function RandGauss(Mean, StdDev: Extended): Extended;
{ Marsaglia-Bray algorithm }
var
  U1, S2: Extended;
begin
  repeat
    U1 := 2*Random - 1;
    S2 := Sqr(U1) + Sqr(2*Random-1);
  until S2 < 1;
  RandGauss := Sqrt(-2*Ln(S2)/S2)*U1*StdDev + Mean;
end;
{------------------------------------------------------}
{                RANDOM  LOGNORMAL                     }
{------------------------------------------------------}
function RandLogNorm(Mean, StDev:Real):Real;
var
  S, Y, U1, U2: Real;
begin
  S:=0.0;
  repeat
    U1:= 2*Random - 1;
    U2:= 2*Random - 1;
    S := U1*U1 + U2*U2;
  until (S<1);
  Y:= Sqrt(-2*Ln(S)/S)*U2;
  RandLogNorm:= Exp(Y) + Mean;
end; { of LogNorm }


{============================================}
{  Random Number for Empiricle Distribution  }
{                                            }
{ X[I]  - middle of I-interval               }
{ Fx[I] - cummulative empiricle distribs     }
{         with values in [0..1]              }
{--------------------------------------------}
function RandEmpiric(X:Vec; Fx:Vec; NClass:word): real;

{sub}procedure MakeChord(Chord:Real);
var
  I: word;
  R: real;
  Sum:Real;
  Fdm: array[1..MaxMineral] of Real;        { cummulative diameters }

begin
  FillChar(Fdm, Sizeof(Fdm),0);
  sum:=0;
  for I:=1 to MaxMineral do Sum:=Sum+MChord[I];
  for I:=1 to MaxMineral do Fdm[I]:=MChord[I]/Sum;
  R:=0;
  for I:=1 to MaxMineral do
  begin
    r:=r+MChord[i]/sum;
    fdm[i]:=r;
  end;
  for i:=1 to MaxMineral do
  begin
    R:=Random;
    if (R<=Fdm[i]) then Chord:=MChord[i];
  end;
end;

var
  I: word;
  R: real;
begin
  R:=random;
  for I:=1 to NClass do
  begin
    if (R<=Fx[i]) then RandEmpiric:=X[i];
  end;
end;
end. { RanDist }

 {                      TEST                            }
 {                           Unif.      Expo.    Norm.  }
 {Total Numbers             100000     100000   100000  }
 {Given Mean                    50         25       25  }
 {Computed Mean               49.9       24.9     24.9  }
 {Expect.Strd_Dev               29         25        1  }




