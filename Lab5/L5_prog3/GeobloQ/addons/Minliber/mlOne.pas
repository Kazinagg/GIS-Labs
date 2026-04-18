unit mlOne;

interface

uses
  System.Math,
  mlGlobals,
  mlGraph;

const
  Seed = 1024;

var
  ch: char;

procedure OneDim(Ore:POre);


implementation

procedure  MainScreen;
begin
  MainWindow;
  Menu('Linear Pattern');
  StatLine('Esc-Exit in Main Menu');
  Bar(0,0,MaxX,MaxY);
  SetColor(LightGray);
  SetTextStyle(DefaultFont, HorizDir, 2);
  SetTextJustify(CenterText, BottomText);
  OutTextXY((MaxX) div 2, TextHeight('B')+5,  'Linear Texture Model');
  if (MaxSClass>18) or (MaxGClass>12) then    { change font for large model }
         SetTextStyle(SmallFont,HorizDir,2)
  else
         SetTextStyle(DefaultFont,HorizDir,1);
end; { MainScreen }

{========================================================================}
{-   One Dimentional Mineral Liberation Respresentation  Model          -}
{------------------------------------------------------------------------}
procedure OneDim(Ore:POre);

{sub}procedure LineTexture;
var
   ViewPort: ViewPortType;
   i,j,k,n : word;
   phaser: Real;

begin
  GetViewSettings(ViewPort);
  with ViewPort do
  begin
    phaser:=0; n:=0;
    x1:=10; x2:=MaxX-10;
    y1:=150; y2:=160;
    setviewport(x1,y1,x2,y2,clipon);
    {with viewport do}
    while (phaser<(MaxX-20)) do
    begin
      inc(n);
      SetFillStyle(1,ore^[n].Mineralphase);
      Bar(round(phaser), 0, round(phaser+ore^[n].chord), 10);
      phaser:= phaser+ore^[n].chord;
    end; { while }
  end; { with ViewPort }
end;



{sub}procedure FracturePattern;
begin
end;

begin
  MainScreen;
  LineTexture;
  repeat
    ch:= readkey;
    if ch = #0 then ch := readkey;      { trap function keys }
    case Upcase(ch) of
       'L': begin
              MainScreen;
              LineTexture;
            end;
       'P': begin
              FracturePattern;
            end;
    end;
  until Upcase(Ch)= #27;
end;
end.
