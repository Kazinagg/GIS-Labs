program Distribs;

{ Generator }

uses
  mlRanDist;

const
   maxpoints = 16;

var
   i,j,k: integer;
   x: real;
   Rmean: real;
   StDev:Real;
   seed: integer;
   ch: char;

procedure Initparams;
begin
   Textbackground(blue);
   Textcolor(white);
   Randomize;
   Rmean:= 5;
   StDev:= 0.5;
end;

begin
  InitParams;
  repeat
   InitParams;
   Writeln('                            Random Numbers');

   writeln(' Real Uniform in range 0..1 ');
   for i:=1 to maxpoints do
   begin
    x:= Random;
    write(x:10:4);
   end;
   writeln;

   writeln(' Integer Uniform in range 20..40');
   for i:=1 to maxpoints do
   begin
     x:=RandUniform(20,40);
     write(x:10:0);
   end;

   writeln(' Real Exponential');
   writeln(' Mean = ',rmean:5:0);
   for i:=1 to MaxPoints do
   begin
     x:=RandExponent(Rmean);
     write(x:10:2);
   end;

   writeln(' Real Normal');
   writeln(' Mean = ',Rmean:5:0, ' StDev = ',StDev:8:2);
   for I:=1 to MaxPoints do
   begin
     x:=RandNorm(Rmean,StDev);
     write(x:10:2);
   end;

   writeln(' Real Gaussian');
   writeln(' Mean = ',Rmean:5:0, ' StDev = ',StDev:8:2);
   for i:=1 to MaxPoints do
   begin
     x:=RandGauss(Rmean,StDev);
     write(x:10:2);
   end;


    writeln(' Real LogNormal');
    writeln(' Mean = ',Rmean:5:0, ' StDev = ',StDev:8:2);
    for i:=1 to MaxPoints do
    begin
      x:=RandLogNorm(Rmean,StDev);
      write(x:10:2);
    end;

    ch:=readkey;
  until upcase(ch) = #27;
end.