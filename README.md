# c-nasm-task

+ `disasm-c.sh` -- выводит дизассемблированный код программы на Си

+ `make` -- собрать обе программы
+ `make clean` -- удалить собранные файлы ( бинарные и объектные файлы )
+ `make byter-c` -- собрать только программу на Си
+ `make byter-asm` -- собрать только программу на ассемблере

## Дизассемблированная программа на Си

```
00000000000010a0 <main>:
    10a0:       f3 0f 1e fa             endbr64 
    10a4:       48 83 ec 18             sub    rsp,0x18
    10a8:       48 8d 3d 55 0f 00 00    lea    rdi,[rip+0xf55]        # 2004 <_IO_stdin_used+0x4>
    10af:       64 48 8b 04 25 28 00    mov    rax,QWORD PTR fs:0x28
    10b6:       00 00 
    10b8:       48 89 44 24 08          mov    QWORD PTR [rsp+0x8],rax
    10bd:       31 c0                   xor    eax,eax
    10bf:       48 8d 74 24 04          lea    rsi,[rsp+0x4]
    10c4:       c7 44 24 04 00 00 00    mov    DWORD PTR [rsp+0x4],0x0
    10cb:       00 
    10cc:       e8 bf ff ff ff          call   1090 <__isoc99_scanf@plt>
    10d1:       85 c0                   test   eax,eax
    10d3:       74 7f                   je     1154 <main+0xb4>
    10d5:       8b 7c 24 04             mov    edi,DWORD PTR [rsp+0x4]
    10d9:       e8 82 01 00 00          call   1260 <print_bin>
    10de:       8b 44 24 04             mov    eax,DWORD PTR [rsp+0x4]
    10e2:       89 c2                   mov    edx,eax
    10e4:       0f b6 f0                movzx  esi,al
    10e7:       0f b6 cc                movzx  ecx,ah
    10ea:       c1 e8 18                shr    eax,0x18
    10ed:       c1 fa 10                sar    edx,0x10
    10f0:       0f b6 d2                movzx  edx,dl
    10f3:       39 ce                   cmp    esi,ecx
    10f5:       7e 06                   jle    10fd <main+0x5d>
    10f7:       89 f7                   mov    edi,esi
    10f9:       89 ce                   mov    esi,ecx
    10fb:       89 f9                   mov    ecx,edi
    10fd:       39 c2                   cmp    edx,eax
    10ff:       7e 06                   jle    1107 <main+0x67>
    1101:       89 d7                   mov    edi,edx
    1103:       89 c2                   mov    edx,eax
    1105:       89 f8                   mov    eax,edi
    1107:       39 d6                   cmp    esi,edx
    1109:       7e 06                   jle    1111 <main+0x71>
    110b:       89 f7                   mov    edi,esi
    110d:       89 d6                   mov    esi,edx
    110f:       89 fa                   mov    edx,edi
    1111:       39 c1                   cmp    ecx,eax
    1113:       7e 06                   jle    111b <main+0x7b>
    1115:       89 cf                   mov    edi,ecx
    1117:       89 c1                   mov    ecx,eax
    1119:       89 f8                   mov    eax,edi
    111b:       39 d1                   cmp    ecx,edx
    111d:       7f 2d                   jg     114c <main+0xac>
    111f:       c1 e0 18                shl    eax,0x18
    1122:       c1 e2 10                shl    edx,0x10
    1125:       89 c7                   mov    edi,eax
    1127:       c1 e1 08                shl    ecx,0x8
    112a:       09 f7                   or     edi,esi
    112c:       09 d7                   or     edi,edx
    112e:       09 cf                   or     edi,ecx
    1130:       e8 2b 01 00 00          call   1260 <print_bin>
    1135:       31 c0                   xor    eax,eax
    1137:       48 8b 74 24 08          mov    rsi,QWORD PTR [rsp+0x8]
    113c:       64 48 33 34 25 28 00    xor    rsi,QWORD PTR fs:0x28
    1143:       00 00 
    1145:       75 23                   jne    116a <main+0xca>
    1147:       48 83 c4 18             add    rsp,0x18
    114b:       c3                      ret    
    114c:       89 cf                   mov    edi,ecx
    114e:       89 d1                   mov    ecx,edx
    1150:       89 fa                   mov    edx,edi
    1152:       eb cb                   jmp    111f <main+0x7f>
    1154:       48 8d 35 b5 0e 00 00    lea    rsi,[rip+0xeb5]        # 2010 <_IO_stdin_used+0x10>
    115b:       bf 01 00 00 00          mov    edi,0x1
    1160:       e8 1b ff ff ff          call   1080 <__printf_chk@plt>
    1165:       83 c8 ff                or     eax,0xffffffff
    1168:       eb cd                   jmp    1137 <main+0x97>
    116a:       e8 01 ff ff ff          call   1070 <__stack_chk_fail@plt>

0000000000001260 <print_bin>:
    1260:       41 54                   push   r12
    1262:       41 bc 20 00 00 00       mov    r12d,0x20
    1268:       55                      push   rbp
    1269:       89 fd                   mov    ebp,edi
    126b:       53                      push   rbx
    126c:       bb 01 00 00 00          mov    ebx,0x1
    1271:       0f 1f 80 00 00 00 00    nop    DWORD PTR [rax+0x0]
    1278:       44 89 e1                mov    ecx,r12d
    127b:       89 ea                   mov    edx,ebp
    127d:       89 e8                   mov    eax,ebp
    127f:       bf 01 00 00 00          mov    edi,0x1
    1284:       29 d9                   sub    ecx,ebx
    1286:       48 8d 35 77 0d 00 00    lea    rsi,[rip+0xd77]        # 2004 <_IO_stdin_used+0x4>
    128d:       d3 fa                   sar    edx,cl
    128f:       89 d9                   mov    ecx,ebx
    1291:       48 83 c3 01             add    rbx,0x1
    1295:       d3 e0                   shl    eax,cl
    1297:       09 c2                   or     edx,eax
    1299:       31 c0                   xor    eax,eax
    129b:       83 e2 01                and    edx,0x1
    129e:       e8 dd fd ff ff          call   1080 <__printf_chk@plt>
    12a3:       48 83 fb 21             cmp    rbx,0x21
    12a7:       75 cf                   jne    1278 <print_bin+0x18>
    12a9:       5b                      pop    rbx
    12aa:       48 8d 35 56 0d 00 00    lea    rsi,[rip+0xd56]        # 2007 <_IO_stdin_used+0x7>
    12b1:       5d                      pop    rbp
    12b2:       bf 01 00 00 00          mov    edi,0x1
    12b7:       31 c0                   xor    eax,eax
    12b9:       41 5c                   pop    r12
    12bb:       e9 c0 fd ff ff          jmp    1080 <__printf_chk@plt>

```