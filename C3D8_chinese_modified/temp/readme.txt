File description

C3D8_uel_pack.f90 C3D8 uel support file
C3D8_uel_umat_main.f90 C3D8 uel main file
C3D8_uel_umat_main-std.obj obj file, generated using the command abaqus make library=C3D8_uel_umat_main.f90. What is given here is the obj file generated by one unit (line17: NELEMENT = 1 in the C3D8_uel_pack.f90 file). If the total number of job units is different, you need Modify this parameter to regenerate obj

Job-C3D8-built-in.inp is a calculation inp file for uniaxial stretching of a unit. It uses the built-in C3D8 unit of Abaqus. You can use the command line abaqus job=Job-C3D8-built-in int for calculation.
Job-C3D8-uel-umat.inp is a unit uniaxial stretching calculation inp file. Using the self-written C3D8 uel unit, you can use the command line abaqus job=Job-C3D8-uel-umat user=C3D8_uel_umat_main-std.obj int Make calculations

Job-PlateWithHole-built-in.inp Calculation inp file for uniaxial stretching of a hole plate, using Abaqus’ built-in C3D8 unit
Job-PlateWithHole-uel-umat.inp Calculation inp file for uniaxial stretching of a plate with holes, using the self-written C3D8 uel unit

!!!Note: When calculating C3D8_uel_umat_main-std.obj, you must first modify the specific value in NELEMENT = xxx in C3D8_uel_pack.f90, and then use the command abaqus make library=C3D8_uel_umat_main.f90 to regenerate the obj file