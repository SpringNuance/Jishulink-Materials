文件说明

C3D8_uel_pack.f90			C3D8的uel支持文件
C3D8_uel_umat_main.f90		C3D8的uel主文件
C3D8_uel_umat_main-std.obj		obj文件, 使用命令abaqus make library=C3D8_uel_umat_main.f90生成, 这里给出的是一个单元(C3D8_uel_pack.f90文件中line17: NELEMENT = 1)生成的obj文件，如果job单元总数不同,需要修改该参数重新生成obj

Job-C3D8-built-in.inp                             一个单元单轴拉伸的计算inp文件,使用Abaqus内置的C3D8单元,可以使用命令行 abaqus job=Job-C3D8-built-in int 进行计算
Job-C3D8-uel-umat.inp		一个单元单轴拉伸的计算inp文件,使用自编的C3D8 uel单元,可以使用命令行 abaqus job=Job-C3D8-uel-umat user=C3D8_uel_umat_main-std.obj int 进行计算

Job-PlateWithHole-built-in.inp	带孔板单轴拉伸的计算inp文件，使用Abaqus内置的C3D8单元
Job-PlateWithHole-uel-umat.inp	带孔板单轴拉伸的计算inp文件,  使用自编的C3D8 uel单元

!!!注意：C3D8_uel_umat_main-std.obj进行计算时，一定要先修改C3D8_uel_pack.f90中NELEMENT = xxx 中具体的数值, 然后使用命令abaqus make library=C3D8_uel_umat_main.f90重新生成obj文件