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


