# GIFT_Python_code
GIFT-64 lightweight cipher is modeled in software platform using Python.
#######GIFT_Encryption######
plaintext=0xa231fc9b8214de60
key=0x2b7e151628aed2a6abf7158809cf4f3c
round_func_out=round_func(plaintext)
print('round_func_out',hex(round_func_out))
keygen_func_out=keygen_func(key)
print('keygen_func_out',hex(keygen_func_out))
round1_out=addroundkey_func(key, round_func_out)
print('round1_out',hex(round1_out))

#######round_func######
def round_func(plaintext):
    sbox16_out=sbox16_func(plaintext)
    perm_out=perm_func(sbox16_out)
    lfsr_out=lfsr_func(0x00)
    addround_constant_out=addround_constant_func(lfsr_out,perm_out)
    print('addround_constant_out',hex(addround_constant_out))
    return addround_constant_out
    
#######keygen_func######
def keygen_func (data):
    data0=(data &   0xffffffffffffffffffffffff00000000)>>32
    data1= (data & 0x0000000000000000000000000000f000)>>12
    data2= (data & 0x00000000000000000000000000000fff)<<4
    data3=(data1 | data2)<<96
    data4= (data & 0x000000000000000000000000ffff0000)>>16
    data5=(data4 & 0x0003)<<14
    data6=(data4 & 0xfffc)>>2
    data7=(data5 | data6)<<112
    roundkey=data0 | data3|data7
    return roundkey
    
#######addroundkey_func######
def addroundkey_func(num, num1):
#extracting k1 key states bits
    k00=(num & 0x00000000000000000000000000000001)
    k01=(num & (0x00000000000000000000000000000002))>>1
    k02=(num & (0x00000000000000000000000000000004))>>2
    k03=(num & (0x00000000000000000000000000000008))>>3
    k04=(num & (0x00000000000000000000000000000010))>>4
    k05=(num & (0x00000000000000000000000000000020))>>5
    k06=(num & (0x00000000000000000000000000000040))>>6
    k07=(num & (0x00000000000000000000000000000080))>>7
    k08=(num & (0x00000000000000000000000000000100))>>8
    k09=(num & (0x00000000000000000000000000000200))>>9
    k010=(num & (0x00000000000000000000000000000400))>>10
    k011=(num & (0x00000000000000000000000000000800))>>11
    k012=(num & (0x00000000000000000000000000001000))>>12
    k013=(num & (0x00000000000000000000000000002000))>>13
    k014=(num & (0x00000000000000000000000000004000))>>14
    k015=(num & (0x00000000000000000000000000008000))>>15
    #extracting k1 bits
    k10=(num & (0x00000000000000000000000000010000))>>16
    k11=(num & (0x00000000000000000000000000020000))>>17
    k12=(num & (0x00000000000000000000000000040000))>>18
    k13=(num & (0x00000000000000000000000000080000))>>19
    k14=(num & (0x00000000000000000000000000100000))>>20
    k15=(num & (0x00000000000000000000000000200000))>>21
    k16=(num & (0x00000000000000000000000000400000))>>22
    k17=(num & (0x00000000000000000000000000800000))>>23
    k18=(num & (0x00000000000000000000000001000000))>>24
    k19=(num & (0x00000000000000000000000002000000))>>25
    k110=(num & (0x00000000000000000000000004000000))>>26
    k111=(num & (0x00000000000000000000000008000000))>>27
    k112=(num & (0x00000000000000000000000010000000))>>28
    k113=(num & (0x00000000000000000000000020000000))>>29
    k114=(num & (0x00000000000000000000000040000000))>>30
    k115=(num & (0x00000000000000000000000080000000))>>31
    # Extracting permuted bits
    bit0=(num1 &(0x0000000000000001))
    bit1=(num1 &(0x0000000000000002))>>1
    bit4=(num1 &(0x0000000000000010))>>4
    bit5=(num1 &(0x0000000000000020))>>5
    bit8=(num1 &(0x0000000000000100))>>8
    bit9=(num1 &(0x0000000000000200))>>9
    bit12=(num1 &(0x0000000000001000))>>12
    bit13=(num1 &(0x0000000000002000))>>13
    bit16=(num1 &(0x0000000000010000))>>16
    bit17=(num1 &(0x0000000000020000))>>17
    bit20=(num1 &(0x0000000000100000))>>20
    bit21=(num1 &(0x0000000000200000))>>21
    bit24=(num1 &(0x0000000001000000))>>24
    bit25=(num1 &(0x0000000002000000))>>25
    bit28=(num1 &(0x0000000010000000))>>28
    bit29=(num1 &(0x0000000020000000))>>29
    bit32=(num1 &(0x0000000100000000))>>32
    bit33=(num1 &(0x0000000200000000))>>33
    bit36=(num1 &(0x0000001000000000))>>36
    bit37=(num1 &(0x0000002000000000))>>37
    bit40=(num1 &(0x0000010000000000))>>40
    bit41=(num1 &(0x0000020000000000))>>41
    bit44=(num1 &(0x0000100000000000))>>44
    bit45=(num1 &(0x0000200000000000))>>45
    bit48=(num1 &(0x0001000000000000))>>48
    bit49=(num1 &(0x0002000000000000))>>49
    bit52=(num1 &(0x0010000000000000))>>52
    bit53=(num1 &(0x0020000000000000))>>53
    bit56=(num1 &(0x0100000000000000))>>56
    bit57=(num1 &(0x0200000000000000))>>57
    bit60=(num1 &(0x1000000000000000))>>60
    bit61=(num1 &(0x2000000000000000))>>61
    addroundkey0=(bit0^k00)
    addroundkey4=(bit4 ^ k01)<<4
    addroundkey8=(bit8 ^ k02)<<8
    addroundkey12=(bit12 ^ k03)<<12
    addroundkey0_12=addroundkey0|addroundkey4|addroundkey8|addroundkey12
    addroundkey16=(bit16 ^ k04)<<16
    addroundkey20=(bit20 ^ k05)<<20
    addroundkey24=(bit24 ^ k06)<<24
    addroundkey28=(bit28 ^ k07)<<28
    addroundkey16_28=addroundkey16|addroundkey20|addroundkey24|addroundkey28
    addroundkey32=(bit32 ^ k08)<<32
    addroundkey36=(bit36 ^ k09)<<36
    addroundkey40=(bit40 ^ k010)<<40
    addroundkey44=(bit44 ^ k011)<<44
    addroundkey32_44=addroundkey32|addroundkey36|addroundkey40|addroundkey44
    addroundkey48=(bit48 ^ k012)<<48
    addroundkey52=(bit52 ^ k013)<<52
    addroundkey56=(bit56 ^ k014)<<56
    addroundkey60=(bit60 ^ k015)<<60
    addroundkey48_60=addroundkey48|addroundkey52|addroundkey56|addroundkey60
    addroundkey0_60=addroundkey0_12|addroundkey16_28|addroundkey32_44|addroundkey48_60
    addroundkey1=(bit1 ^ k10)<<1
    addroundkey5=(bit5 ^ k11)<<5
    addroundkey9=(bit9 ^ k12)<<9
    addroundkey13=(bit13 ^ k13)<<13
    addroundkey1_13=addroundkey1|addroundkey5|addroundkey9|addroundkey13
    addroundkey17=(bit17 ^ k14)<<17
    addroundkey21=(bit21 ^ k15)<<21
    addroundkey25=(bit25 ^ k16)<<25
    addroundkey29=(bit29 ^ k17)<<29
    addroundkey17_29=addroundkey17|addroundkey21|addroundkey25|addroundkey29
    addroundkey33=(bit33 ^ k18)<<33
    addroundkey37=(bit37 ^ k19)<<37
    addroundkey41=(bit41 ^ k110)<<41
    addroundkey45=(bit45 ^ k111)<<45
    addroundkey33_45=addroundkey33|addroundkey37|addroundkey41|addroundkey45
    addroundkey49=(bit49 ^ k112)<<49
    addroundkey53=(bit53 ^ k113)<<53
    addroundkey57=(bit57 ^ k114)<<57
    addroundkey61=(bit61 ^ k115)<<61
    addroundkey49_61=addroundkey49|addroundkey53|addroundkey57|addroundkey61
    addroundkey1_61=addroundkey1_13|addroundkey17_29|addroundkey33_45|addroundkey49_61
    addkey=addroundkey0_60|addroundkey1_61
    x=(num1 & 0xcccccccccccccccc)
    addroundkey=addkey|x
    return addroundkey

#######addroundconstant_func######
def addround_constant_func(lfsr_out,perm_out):
    lfsr_out0=(lfsr_out & 0x20)
    #print('lfsr_out0',hex(lfsr_out0))
    lfsr_out1=(lfsr_out & 0x10)
    #print('lfsr_out1',hex(lfsr_out1))
    lfsr_out2=(lfsr_out & 0x08)
    #print('lfsr_out2',hex(lfsr_out2))
    lfsr_out3=(lfsr_out & 0x04)
    #print('lfsr_out3',hex(lfsr_out3))
    lfsr_out4=(lfsr_out & 0x02)
    #print('lfsr_out4',hex(lfsr_out4))
    lfsr_out5=(lfsr_out & 0x01)
    #print('lfsr_out5',hex(lfsr_out5))
    ###
    #perm_out63=(perm_out & 0x8000000000000000)>>63
    #print('perm_out63',hex(perm_out63))
    perm_out63=(((perm_out & 0x8000000000000000)>>63) ^ 1)<<63
    #print('perm_out63',hex(perm_out63))
    perm_out23=(((perm_out & 0x0000000000800000)>>23) ^lfsr_out0 )<<23
    #print('perm_out23',hex(perm_out23))
    perm_out19=(((perm_out & 0x0000000000080000)>>19) ^lfsr_out1)<<19
    #print('perm_out19',hex(perm_out19))
    perm_out15=(((perm_out & 0x0000000000008000)>>15) ^ lfsr_out2)<<15
    #print('perm_out15',hex(perm_out15))
    perm_out11=(((perm_out & 0x0000000000000800)>>11) ^ lfsr_out3)<<11
    #print('perm_out11',hex(perm_out11))
    perm_out7=(((perm_out & 0x0000000000000080)>>7) ^ lfsr_out4)<<7
    #print('perm_out7',hex(perm_out7))
    perm_out3=(((perm_out & 0x0000000000000008)>>3) ^ lfsr_out5)<<3
    #print('perm_out3',hex(perm_out3))
    perm_out_updated=(perm_out & 0x7fffffffff777777)
    add_round_constant=perm_out_updated |perm_out3 |perm_out7| perm_out11|perm_out15|perm_out19|perm_out23|perm_out63
    return add_round_constant

#######sbox16_func######
def sbox16_func(plaintext):
    plaintext0=(plaintext & 0xf000000000000000)>>60
    plaintext1=(plaintext & 0x0f00000000000000)>>56
    plaintext2=(plaintext & 0x00f0000000000000)>>52
    plaintext3=(plaintext & 0x000f000000000000)>>48
    plaintext4=(plaintext & 0x0000f00000000000)>>44
    plaintext5=(plaintext & 0x00000f0000000000)>>40
    plaintext6=(plaintext & 0x000000f000000000)>>36
    plaintext7=(plaintext & 0x0000000f00000000)>>32
    plaintext8=(plaintext & 0x00000000f0000000)>>28
    plaintext9=(plaintext & 0x000000000f000000)>>24
    plaintext10=(plaintext & 0x0000000000f00000)>>20
    plaintext11=(plaintext & 0x00000000000f0000)>>16
    plaintext12=(plaintext & 0x000000000000f000)>>12
    plaintext13=(plaintext & 0x0000000000000f00)>>8
    plaintext14=(plaintext & 0x00000000000000f0)>>4
    plaintext15=(plaintext & 0x000000000000000f)
    #print('plaintext0',hex(plaintext0))
    plaintext0=(sbox_func(plaintext0))<<60
    #print('plaintext0',hex(plaintext0))
    plaintext1=(sbox_func(plaintext1))<<56
    #print('plaintext1',hex(plaintext1))
    plaintext2=(sbox_func(plaintext2))<<52
    plaintext3=(sbox_func(plaintext3))<<48
    plaintext4=(sbox_func(plaintext4))<<44
    plaintext5=(sbox_func(plaintext5))<<40
    plaintext6=(sbox_func(plaintext6))<<36
    plaintext7=(sbox_func(plaintext7))<<32
    plaintext8=(sbox_func(plaintext8))<<28
    plaintext9=(sbox_func(plaintext9))<<24
    plaintext10=(sbox_func(plaintext10))<<20
    plaintext11=(sbox_func(plaintext11))<<16
    plaintext12=(sbox_func(plaintext12))<<12
    plaintext13=(sbox_func(plaintext13))<<8
    plaintext14=(sbox_func(plaintext14))<<4
    plaintext15=(sbox_func(plaintext15))
    sbox_out1=plaintext0|plaintext1|plaintext2|plaintext3|plaintext4|plaintext5|plaintext6|plaintext7
    sbox_out2=plaintext8|plaintext9|plaintext10|plaintext11|plaintext12|plaintext13|plaintext14|plaintext15
    sbox_out=sbox_out1|sbox_out2
    return sbox_out
    
#######sbox_func######
def sbox_func(sbox_in):
    sbox_out=int()
    if sbox_in==0:
            sbox_out=1;
    elif sbox_in==1:
            sbox_out=0xa;
    elif sbox_in==2:
            sbox_out=4;
    elif sbox_in==3:
            sbox_out=0xc;
    elif sbox_in==4:
            sbox_out=6;
    elif sbox_in==5:
            sbox_out=0xf;
    elif sbox_in==6:
            sbox_out=3;
    elif sbox_in==7:
            sbox_out=9;
    elif sbox_in==8:
            sbox_out=2;
    elif sbox_in==9:
            sbox_out=0xd;
    elif sbox_in==0xa:
            sbox_out=0xb;
    elif sbox_in==0xb:
            sbox_out=7;
    elif sbox_in==0xc:
            sbox_out=5;
    elif sbox_in==0xd:
            sbox_out=0;
    elif sbox_in==0xe:
            sbox_out=8;
    elif sbox_in==0xf:
            sbox_out=0xe;
    return sbox_out

#######perm_func######
def perm_func(num):
    num0=(num & 0x8000000000000000)>>0
    num1=(num & 0x4000000000000000)>>16
    num2=(num & 0x2000000000000000)>>32
    num3=(num & 0x1000000000000000)>>48
    num4=(num & 0x0800000000000000)>>44
    num5=(num & 0x0400000000000000)<<4
    num6=(num & 0x0200000000000000)>>12
    num7=(num & 0x0100000000000000)>>28
    num8=(num & 0x0080000000000000)>>24
    num9=(num & 0x0040000000000000)>>40
    num10=(num & 0x0020000000000000)<<8
    num11=(num & 0x0010000000000000)>>8
    num12=(num & 0x0008000000000000)>>4
    num13=(num & 0x0004000000000000)>>20
    num14=(num & 0x0002000000000000)>>36
    num15=(num & 0x0001000000000000)<<12
    num16=(num & 0x0000800000000000)<<12
    num17=(num & 0x0000400000000000)>>4
    num18=(num & 0x0000200000000000)>>20
    num19=(num & 0x0000100000000000)>>36
    num20=(num & 0x0000080000000000)>>32
    num21=(num & 0x0000040000000000)<<16
    num22=(num & 0x0000020000000000)
    num23=(num & 0x0000010000000000)>>16
    num24=(num & 0x0000008000000000)>>12
    num25=(num & 0x0000004000000000)>>28
    num26=(num & 0x0000002000000000)<<20
    num27=(num & 0x0000001000000000)<<4
    num28=(num & 0x0000000800000000)<<8
    num29=(num & 0x0000000400000000)>>8
    num30=(num & 0x0000000200000000)>>24
    num31=(num & 0x0000000100000000)<<24
    num32=(num & 0x0000000080000000)<<24
    num33=(num & 0x0000000040000000)<<8
    num34=(num & 0x0000000020000000)>>8
    num35=(num & 0x0000000010000000)>>24
    num36=(num & 0x0000000008000000)>>20
    num37=(num & 0x0000000004000000)<<28
    num38=(num & 0x0000000002000000)<<12
    num39=(num & 0x0000000001000000)<<21
    num40=(num & 0x0000000000800000)
    num41=(num & 0x0000000000400000)>>16
    num42=(num & 0x0000000000200000)<<32
    num43=(num & 0x0000000000100000)<<16
    num44=(num & 0x0000000000080000)<<20
    num45=(num & 0x0000000000040000)<<4
    num46=(num & 0x0000000000020000)>>12
    num47=(num & 0x0000000000010000)<<36
    num48=(num & 0x0000000000008000)<<36
    num49=(num & 0x0000000000004000)<<20
    num50=(num & 0x0000000000002000)<<4
    num51=(num & 0x0000000000001000)>>12
    num52=(num & 0x0000000000000800)>>8
    num53=(num & 0x0000000000000400)<<14
    num54=(num & 0x0000000000000200)<<24
    num55=(num & 0x0000000000000100)<<8
    num56=(num & 0x0000000000000080)<<12
    num57=(num & 0x0000000000000040)>>4
    num58=(num & 0x0000000000000020)<<44
    num59=(num & 0x0000000000000010)<<28
    num60=(num & 0x0000000000000008)<<32
    num61=(num & 0x0000000000000004)<<16
    num62=(num & 0x0000000000000002)
    num63=(num & 0x0000000000000001)<<48
    hex0=num0|num5|num10|num15      # 0-3
    hex1=num16|num21|num26|num31    # 4-7
    hex2=num32|num37|num42|num47    # 8-11
    hex3=num48|num53|num58|num63    # 12-15
    #temp1=(hex0|hex1|hex2|hex3)>>48
    hex4=num12|num1|num6|num11      # 16-19
    hex5=num28|num17|num22|num27    # 20-23
    hex6=num44|num33|num38|num43    # 24-27
    hex7=num60|num49|num54|num59    # 28-31
   #temp1=(hex5|hex6|hex7|hex8)>>48
    hex8=num8|num13|num2|num7       # 32-35
    hex9=num24|num29|num18|num23    # 36-39
    hex10=num40|num45|num34|num39   # 40-43
    hex11=num56|num61|num50|num55   # 44-47
    hex12=num4|num9|num14|num3     # 48-51
    hex13=num20|num25|num30|num19   # 52-55
    hex14=num36|num41|num46|num35   # 56-59
    hex15=num52|num57|num62|num51   # 60-63
    p_out1=(hex0|hex1|hex2|hex3)>>48
    p_out2=(hex4|hex5|hex6|hex7)<<16
    p_out3=(hex8|hex9|hex10|hex11)<<16
    p_out4=(hex12|hex13|hex14|hex15)<<16
    p_out=p_out2|p_out3|p_out4|p_out1
    return p_out
