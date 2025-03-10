#0 // JP s
SETPC

#1 // RETD e
TRANSFER MSP PCSL INC(SP_INC)
TRANSFER MSP PCSH INC(SP_INC)
TRANSFER MSP PCP  INC(SP_INC)
JMP #9 // LBPX MX, e

#2 // JP C, s
JMP NC #96 // If carry not set, NOP
SETPC

#3 // JP NC, s
JMP C #96 // If carry set, NOP
SETPC

#4 // CALL s
CALLSTART PCP // TRANSFER PCP MSP_DEC INC(SP_DEC)
CALLSTART PCSH // TRANSFER PCSH MSP_DEC INC(SP_DEC)
CALLEND COPY

#5 // CALZ s
CALLSTART PCP // TRANSFER PCP MSP_DEC INC(SP_DEC)
CALLSTART PCSH // TRANSFER PCSH MSP_DEC INC(SP_DEC)
CALLEND ZERO

#6 // JP Z, s
JMP NZ #96 // If zero not set, NOP
SETPC

#7 // JP NZ, s
JMP Z #96 // If zero set, NOP
SETPC

#8 // LD Y, e
TRANSFER IMMH YH
TRANSFER IMML YL

#9 // LBPX MX, e
TRANSFER IMML MX INC(XHL)
TRANSFER IMMH MX INC(XHL)

#10 // ADC XH, i
TRANSFER XH TEMPA
TRANSFER IMML TEMPB
TRANSALU ADC_NO_DEC XH

#11 // ADC XL, i
TRANSFER XL TEMPA
TRANSFER IMML TEMPB
TRANSALU ADC_NO_DEC XL

#12 // ADC YH, i
TRANSFER YH TEMPA
TRANSFER IMML TEMPB
TRANSALU ADC_NO_DEC YH

#13 // ADC YL, i
TRANSFER YL TEMPA
TRANSFER IMML TEMPB
TRANSALU ADC_NO_DEC YL

#14 // CP XH, i
TRANSFER XH TEMPA
TRANSFER IMML TEMPB
TRANSALU CP TEMPA

#15 // CP XL, i
TRANSFER XL TEMPA
TRANSFER IMML TEMPB
TRANSALU CP TEMPA

#16 // CP YH, i
TRANSFER YH TEMPA
TRANSFER IMML TEMPB
TRANSALU CP TEMPA

#17 // CP YL, i
TRANSFER YL TEMPA
TRANSFER IMML TEMPB
TRANSALU CP TEMPA

#18 // ADD r, q
TRANSFER IMM_ADDR_H TEMPA
TRANSFER IMM_ADDR_L TEMPB
TRANSALU ADD IMM_ADDR_H

#19 // ADC r, q
TRANSFER IMM_ADDR_H TEMPA
TRANSFER IMM_ADDR_L TEMPB
TRANSALU ADC IMM_ADDR_H

#20 // SUB r, q
TRANSFER IMM_ADDR_H TEMPA
TRANSFER IMM_ADDR_L TEMPB
TRANSALU SUB IMM_ADDR_H

#21 // SBC r, q
TRANSFER IMM_ADDR_H TEMPA
TRANSFER IMM_ADDR_L TEMPB
TRANSALU SBC IMM_ADDR_H

#22 // AND r, q
TRANSFER IMM_ADDR_H TEMPA
TRANSFER IMM_ADDR_L TEMPB
TRANSALU AND IMM_ADDR_H

#23 // OR r, q
TRANSFER IMM_ADDR_H TEMPA
TRANSFER IMM_ADDR_L TEMPB
TRANSALU OR IMM_ADDR_H

#24 // XOR r, q
TRANSFER IMM_ADDR_H TEMPA
TRANSFER IMM_ADDR_L TEMPB
TRANSALU XOR IMM_ADDR_H

#25 // RLC r
TRANSFER IMM_ADDR_L TEMPA
TRANSALU RLC IMM_ADDR_L

#26 // LD X, e
TRANSFER IMMH XH
TRANSFER IMML XL

#27 // ADD r, i
TRANSFER IMM_ADDR_P TEMPA
TRANSFER IMML TEMPB
TRANSALU ADD IMM_ADDR_P

#28 // ADC r, i
TRANSFER IMM_ADDR_P TEMPA
TRANSFER IMML TEMPB
TRANSALU ADC IMM_ADDR_P

#29 // AND r, i
TRANSFER IMM_ADDR_P TEMPA
TRANSFER IMML TEMPB
TRANSALU AND IMM_ADDR_P

#30 // OR r, i
TRANSFER IMM_ADDR_P TEMPA
TRANSFER IMML TEMPB
TRANSALU OR IMM_ADDR_P

#31 // XOR r, i
TRANSFER IMM_ADDR_P TEMPA
TRANSFER IMML TEMPB
TRANSALU XOR IMM_ADDR_P

#32 // SBC r, i
TRANSFER IMM_ADDR_P TEMPA
TRANSFER IMML TEMPB
TRANSALU SBC IMM_ADDR_P

#33 // FAN r, i
TRANSFER IMM_ADDR_P TEMPA
TRANSFER IMML TEMPB
TRANSALU AND TEMPA // Transfer result _somewhere_, and transfer zero flag

#34 // CP r, i
TRANSFER IMM_ADDR_P TEMPA
TRANSFER IMML TEMPB
TRANSALU CP TEMPA

#35 // LD r, i
TRANSFER IMML IMM_ADDR_P

#36 // PSET p
TRANSFER IMMH NBP
TRANSFER IMML NPP

#37 // LDPX MX, i
TRANSFER IMML MX INC(XHL)

#38 // LDPX MY, i
TRANSFER IMML MY INC(YHL)

#39 // LD XP, r
TRANSFER IMM_ADDR_L XP

#40 // LD XH, r
TRANSFER IMM_ADDR_L XH

#41 // LD XL, r
TRANSFER IMM_ADDR_L XL

#42 // RRC r
TRANSFER IMM_ADDR_L TEMPA
TRANSALU RRC IMM_ADDR_L

#43 // LD YP, r
TRANSFER IMM_ADDR_L YP

#44 // LD YH, r
TRANSFER IMM_ADDR_L YH

#45 // LD YL, r
TRANSFER IMM_ADDR_L YL

#46 // LD r, XP
TRANSFER XP IMM_ADDR_L

#47 // LD r, XH
TRANSFER XH IMM_ADDR_L

#48 // LD r, XL
TRANSFER XL IMM_ADDR_L

#49 // LD r, YP
TRANSFER YP IMM_ADDR_L

#50 // LD r, YH
TRANSFER YH IMM_ADDR_L

#51 // LD r, YL
TRANSFER YL IMM_ADDR_L

#52 // LD r, q
TRANSFER IMM_ADDR_L TEMPA
TRANSFER TEMPA IMM_ADDR_H

// INC X isn't a dedicated instruction

#53 // LDPX r, q
TRANSFER IMM_ADDR_L TEMPA
TRANSFER TEMPA IMM_ADDR_H INC(XHL)

// INC Y isn't a dedicated instruction

#54 // LDPY r, q
TRANSFER IMM_ADDR_L TEMPA
TRANSFER TEMPA IMM_ADDR_H INC(YHL)

#55 // CP r, q
TRANSFER IMM_ADDR_H TEMPA
TRANSFER IMM_ADDR_L TEMPB
TRANSALU CP TEMPA

#56 // FAN r, q
TRANSFER IMM_ADDR_H TEMPA
TRANSFER IMM_ADDR_L TEMPB
TRANSALU AND TEMPA // Transfer result _somewhere_, and transfer zero flag

#57 // ACPX MX, r
TRANSFER MX TEMPA
TRANSFER IMM_ADDR_L TEMPB
TRANSALU ADC MX INC(XHL)

#58 // ACPY MY, r
TRANSFER MY TEMPA
TRANSFER IMM_ADDR_L TEMPB
TRANSALU ADC MY INC(YHL)

#59 // SCPX MX, r
TRANSFER MX TEMPA
TRANSFER IMM_ADDR_L TEMPB
TRANSALU SBC MX INC(XHL)

#60 // SCPY MY, r
TRANSFER MY TEMPA
TRANSFER IMM_ADDR_L TEMPB
TRANSALU SBC MY INC(YHL)

#61 // SET F, i
TRANSFER FLAGS TEMPA
TRANSFER IMML TEMPB
TRANSALU OR FLAGS

#62 // RST F, i
TRANSFER FLAGS TEMPA
TRANSFER IMML TEMPB
TRANSALU AND FLAGS

#63 // INC Mn
TRANSFER Mn TEMPA
TRANSFER HARDCODED_1 TEMPB
TRANSALU ADD_NO_DEC Mn

#64 // DEC Mn
TRANSFER Mn TEMPA
TRANSFER HARDCODED_1 TEMPB
TRANSALU SUB_NO_DEC Mn

#65 // LD Mn, A
TRANSFER A Mn

#66 // LD Mn, B
TRANSFER B Mn

#67 // LD A, Mn
TRANSFER Mn A

#68 // LD B, Mn
TRANSFER Mn B

#69 // PUSH r
TRANSFER IMM_ADDR_L TEMPA
TRANSFER TEMPA MSP_DEC INC(SP_DEC)

#70 // PUSH XP
TRANSFER XP MSP_DEC INC(SP_DEC)

#71 // PUSH XH
TRANSFER XH MSP_DEC INC(SP_DEC)

#72 // PUSH XL
TRANSFER XL MSP_DEC INC(SP_DEC)

#73 // PUSH YP
TRANSFER YP MSP_DEC INC(SP_DEC)

#74 // PUSH YH
TRANSFER YH MSP_DEC INC(SP_DEC)

#75 // PUSH YL
TRANSFER YL MSP_DEC INC(SP_DEC)

#76 // PUSH F
TRANSFER FLAGS MSP_DEC INC(SP_DEC)

#77 // DEC SP
TRANSFER TEMPA TEMPA INC(SP_DEC)

#78 // POP r
TRANSFER MSP TEMPA
TRANSFER TEMPA IMM_ADDR_L INC(SP_INC)

#79 // POP XP
TRANSFER MSP XP INC(SP_INC)

#80 // POP XH
TRANSFER MSP XH INC(SP_INC)

#81 // POP XL
TRANSFER MSP XL INC(SP_INC)

#82 // POP YP
TRANSFER MSP YP INC(SP_INC)

#83 // POP YH
TRANSFER MSP YH INC(SP_INC)

#84 // POP YL
TRANSFER MSP YL INC(SP_INC)

#85 // POP F
TRANSFER MSP FLAGS INC(SP_INC)

#86 // INC SP
TRANSFER TEMPA TEMPA INC(SP_INC)

#87 // RETS
TRANSFER MSP PCSL INC(SP_INC)
TRANSFER MSP PCSH INC(SP_INC)
TRANSFER MSP PCP INC(SP_INC)
JMP #96 // NOP

#88 // RET
TRANSFER MSP PCSL INC(SP_INC)
RETEND PCSH // TRANSFER MSP PCSH INC(SP_INC)
RETEND PCP // TRANSFER MSP PCP INC(SP_INC)

#89 // LD SPH, r
TRANSFER IMM_ADDR_L SPH

#90 // LD r, SPH
TRANSFER SPH IMM_ADDR_L

#91 // JPBA
TRANSFER B PCSH
JPBAEND

#92 // LD SPL, r
TRANSFER IMM_ADDR_L SPL

#93 // LD r, SPL
TRANSFER SPL IMM_ADDR_L

#94 // HALT
HALT

#95 // SLP
HALT SLEEP

#96 // NOP5
// Do nothing

#97 // NOP7
JMP #96

#100 // Interrupt step 1. Push old PC to stack
STARTINTERRUPT // TRANSFER PCP MSP_DEC INC(SP_DEC)
TRANSFER PCSH MSP_DEC INC(SP_DEC)
TRANSFER PCSL MSP_DEC INC(SP_DEC)
JMP #101

#101 // Interrupt step 2. Set PC to interrupt vector
TRANSFER HARDCODED_1 NPP
SETPC