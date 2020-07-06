# GIFT_Python_code
GIFT-64 lightweight cipher is modeled in software platform using Python.
def sbox_func(sbox_in):
#print("Enter the input")
#sbox_in=int(input())
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
#print("output:",sbox_out)
#sbox_func(0)
