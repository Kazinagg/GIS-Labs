MINLIBER
version 1.62

The contents of the Miliber program are subject to the Mozilla Public License Version 1.1 
(the "License") for the programs with open source codes and you may not use this software 
except in compliance with the License. You may obtain a copy of the License at 
http://www.mozilla.org/MPL/.
Initial developer:  Getos Ltd. Copyright (c) 1991-2006

The MINLIBER program is designed to provide a software tool for predicting
mineral liberation in multi-phase ores before size reduction under
crushing and grinding operations. It uses the stochastic simulations
of ore textures in 1D and 2D cases. The program calculates spectra
and liberation degrees using defined specific volume fractions (sizes)
or specific mineral's surfaces from ore samples with assumption of
independence between ore texture and breakage pattern.
The programs will run in DOS mode or as DOS application under
Windows95/98/2000/NT/XP operation systems.

INSTALLATION
============
Please, unzip ML.ZIP file in your working directory and
execute MINLIBER.
The program runs in graphic DOS mode under Windows and is using
Borland's EGAVGA.BGI drivers file.
After first running it will create data files
MINERALS.ORE, SIZEDIST.MIL and EXTRACTS.CON in subdirectory DATA
with default values.
Use Up and Down arrow keys to choose an active target mineral,
Left and Right ones to display MILL and EXTRACT matrices.
Press highlighted characters to execute a menu command.
When you are in texture simulation window use 1,2,..5 keys
to change a number of germs per image.

ALGORITHM DETAILS
=================
1D case.
The model implemented in the program for one-dimensional case
includes some theoretical propositions from papers:

1.King, R.P., 1979, "A Model for the Quantitative Estimation of
  Mineral Liberation by Grinding". International Journal of Mineral
  Processing. Vol.6, pp.207-220.
2.Klimpel,R.R.,and Austin, L.B.,1983, "A Preliminary Model of
  Liberation from a Binary System". Powder Technology. Vol.34, pp.121-130.
3.Yingling J.C., 1991, "Liberation Model for Multi-Component Ores",
  Minerals & Metallurgical Processing, No.5, pp.65-72.
4. Vassiliev P.V., 1986. Application of Linear Stereological Analysis 
    for Mineral Liberation Prediction in Magnetite Iron Ores. 
    Zavodskaya Laboratoryja, No.5, p.34-36.(in Russian) 
5. Vassiliev P.V., Tikhonov O.N., 1988. Evaluation of Size-Grade Particles Distributions 
    in Ores Using Data from Image Analysis of Monolithic Textures. 
    Izvestyja vuzov, Tsvetnaya Metallurgyja (Non-ferrous Metallurgy), No.6, p.2-9. (in Russian) 
6. Whittle, D., Vassiliev, P., 1998. Synthesis of Stochastic Recovery Prediction 
    and Cut-off Optimization. Mine to Mill Conference, AusIMM, 11-14 October, Brisbane, Qld, pp.53-55 
7. Vassiliev, P., 1999, Optimizing Open Pit Limits Without and With Ore Dressing Predictions, 
    Proceedings of the Optimizing with Whittle Conference, Perth, WA, pp.197-206. 


Differences in analytical models and this software realization
exist in stochastic simulation of multi-phase textures and calculation
of liberation spectra for target minerals to characterize a continuous
ore. Instead of using a direct geometrical superposition of ore
texture and breakage pattern the current algorithm uses a "ready" expected
particle size distribution density for grinding products to multiply it with
liberation matrix and calculate "size-grade" distribution of particles.

The random volume size (chord) of a target mineral phase is
calculated with the Marsaglia-Bray algorithm, proposed
in MATH.PAS module in Delphi from Inprise International Inc.:

   function RandGauss(Mean, StdDev: Extended): Extended;
   var
     U1, S2: Extended;
   begin
     repeat
       U1 := 2*Random - 1;
       S2 := Sqr(U1) + Sqr(2*Random-1);
     until S2 < 1;
     RandGauss := Sqrt(-2*Ln(S2)/S2)*U1*StdDev + Mean;
   end;

The sum of all mean Vm (specific mineral volume fraction) in input file
is a Rythm, so the Vg (specific gangue volume fraction) of adjacent gangue
mineral phase is calculated as Vg := Rythm - Vm.

2D case.
The Delaunay triangulation Pascal code is a modification of C code
described in
    G.Macedonio and M.T.Pareschi, 1991, "An Algorithm for the
    Triangulation of Arbitrarily Distributed Points: Applications
    to Volume Estimate and Terrain Fitting", Computers & Geosciences,
    vol.17, No.7, pp.859-874

The Voronoi diagram is a dual graph of the Delaunay triangulation.
The Aggregates of grains are areas without inner boundaries between
Voronoi grains in the same mineral phase.

REPORTS
=======
The program accepts measurement data from text ASCII files:

MINERALS.ORE - the mean volumes of up to 14 minerals in raw rock
SIZEDIST.MIL - the volume per cents of milled particles in 16 size classes
EXTRACTS.CON - the extraction probabilities of particles for 12 grade classes

If there are no such files in INPUT directory the program will create
the files with stated names and default values.
You can work with your own data. Exit the program and edit files.

In MINERALS.ORE file on 2..14 lines you can write in comma
delimited format:

MINERAL - a name of Mineral with length not over 20 letters, string[20];
MEAN CHORD or SPECIFIC SURFACE for the mineral - a positive integer number;
COLOR of the mineral -  a positive integer number in range of 1..14

Example:

Magnetite, 39, 4
Quartz, 150, 3
Calcite, 87, 9

Only 14 lines for minerals are available in this version.
Choose different colors for phases to distinguish between them.

Edit MINERALS.ORE file to test your measurement data.
You can delete any line but you should have not less then 2 lines
in the file. You can rename or delete MINERALS.ORE file and
the program will automatically restore the initial default
MINERALS.ORE file.

In SIZEDIST.MIL file you can insert the lower levels for 16 size classes
and after comma a volume per cent in each size class, for example:

1,0
2,0
4,10
8,20
16,50
32,20
64,10
128,0
256,0
...,...

The sum must be 100 percents.

In EXTRACTS.CON file you can insert probabilities of recoveries (in %)
for 12 grade classes in a separator scheme, as follows:

1,0       or      1,0       and so on...
2,50              2,0
3,80              3,0
4,90              4,100
5,95              5,100
6,98              ...
...              11,0
12,99            12,0


REPORTS
======
From main menu you can Save results for every selected target mineral
in a text file with LIB extention automatically assigning the name of
TARGET mineral to the file. Exit the program and rename output files
if you want to save results for another set of input data.

For volumetric characterization of a milled sample:

                            Volume of Free Target Phase
Liberation Degree(%) =   ---------------------------------
                         Volume of Target Phase in Sample


                         Volume of Target Phase in Sample
Liberation Factor(%) =  ------------------------------------------
                       (Volume of Sample) - (Volume of Free Gangue)

Also you can save predicted values of yield, grade and recovery for
a concentrate after executing appropriate menu commands.

In the same directory you can find:

TEXTURE.VOR - file with coordinates of all grain centers and
              vertices of Voronoi polygons.
FRACTURE.VOR - file with coordinates of all crack centers and
              vertices of Voronoi polygons.

Load the text files of MINLIB to MS Excel to process data further
as tables or 3D Charts.
You can also print screens and insert images to your Word documents.

RESTRICTIONS
============
The program will work under Windows95/98/NT/XP more slowly then in DOS mode
on IBM compatible PC.
The number of mineral phases should be in the range from 2 to 14.
You can use only 14 colors for minerals (1..14) excepting
reserved colors like black (0) and white (15).
The mean intercept length (chord) of a mineral phase may not exceed 1000 microns. 
In Liberation, Mill and Extract Matrices are displayed rounded values.
Recovery probabilities in EXTRACT.CON file are applied for all target
mineral phases without account of its differences by physical properties.

The current simulations of 2D ore textures with growth of cubic crystals,
Delaunay triangulation and Voronoi tesselation within a convex hull of
random points are implemented for illustration purposes.
Because of randomization in computational procedures the results
slightly differ for each realization.

SUPPORT AND MODIFICATION
========================
You may use, copy, and distribute this shareware version of the program
free of charge provided that existing copyright notices and readme.txt
file are retained in all copies.


For more information, please, contact with
==================================

Getos Ltd.
Pavel Vassiliev              Phone:   +7-0722- 33-76-34
Kalinin St., 28-60           Ph/Fax   +7-0722- 26-78-41
308001, Belgorod, RUSSIA       E-mail:  minliber@getos.belgorod.su
-----------------------------------------------------------------------

Thank you for using Minliber.

Pavel Vassiliev