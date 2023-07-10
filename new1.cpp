#include<stdio.h>
#include<string.h>

char str[1000];
int pos =0;
int f = 0;

void Exp();
void stat();
void extn();
void relop();

void X()
{
    if(pos+2<strlen(str) && str[pos]=='b' && str[pos+1]=='b')
    {
        pos+=2;
        X();
        return;
    }
    if(pos+2<strlen(str) && str[pos]=='b' && str[pos+1]=='c')
    {
        pos+=2;
        X();
        return;
    }
    f = 1;
    return;
}

void A()
{
    if(strlen(str)<2)
    {
        f=  0;
        return;
    }
    if(str[pos]!='a')
    {
        f = 0;
        return;
    }
    pos++;
    X();
    if(f==1)
    {
        if(pos+1==strlen(str) && str[pos]=='d')
        {
            pos++;
            f = 1;
            return;
        }
        else
        {
            f = 0;
            return;
        }
    }
    else
    {
        f = 0;
        return;
    }
}

void ID()
{
    if(pos<strlen(str) && str[pos]>='a' && str[pos]<='e')
    {
        pos++;
        f  =1;
        return;
    }
    f = 0;
    return;
}

void NUM()
{
    if(pos<strlen(str) && str[pos]>='0' && str[pos]<='9')
    {
        pos++;
        f  =1;
        return;
    }
    f = 0;
    return;
}

void Factor()
{
    ID();
    if(f==1)
        return;
    NUM();
    if(f==1)
        return;
    if(pos<strlen(str) && str[pos]=='(')
    {
        pos++;
        Exp();
        if(f==1)
        {
            if(pos<strlen(str) && str[pos]==')')
            {
                pos++;
                f = 1;
                return;
            }
            f = 0;
            return;
        }
        f = 0;
        return;

    }
    f =0;
    return;
}

void Term()
{
    Factor();
    if(pos==strlen(str) || f==0)
    {
        return;
    }
    if(str[pos]=='*' || str[pos]=='/')
    {
        pos++;
        Factor();
    }
}

void Exp()
{
    Term();
    if(pos==strlen(str) || f==0)
    {
        return;
    }
    if(str[pos]=='+' || str[pos]=='-')
    {
        pos++;
        Term();

    }
}
void init()
{
    f = pos = 0;
}

void expn()
{
    Exp();
    if(f==1)
    {
        extn();
        return;
    }
    return;
}

void extn()
{
    int temp = pos;
    relop();
    if(f==1)
    {
        Exp();
        if(f==1)
        {
            return;
        }
    }
    pos = temp;
    f= 1;
    return;
}

void extn1()
{
    int temp = pos;
    if(pos+3<strlen(str) && str[pos]=='e' && str[pos+1]=='l' && str[pos+2]=='s' && str[pos+3]=='e')
    {
        pos+=4;
        stat();
        if(f==1)
        {
            return;
        }

    }
    pos= temp;
    f =1;
    return;
}

void relop()
{
    if(pos+1<strlen(str) && str[pos]=='=' && str[pos+1]=='=')
    {
        f = 1;
        pos+=2;
        return;
    }

    if(pos+1<strlen(str) && str[pos]=='!' && str[pos+1]=='=')
    {
        f = 1;
        pos+=2;
        return;
    }
    if(pos+1<strlen(str) && str[pos]=='<' && str[pos+1]=='=')
    {
        f = 1;
        pos+=2;
        return;
    }
    if(pos+1<strlen(str) && str[pos]=='>' && str[pos+1]=='=')
    {
        f = 1;
        pos+=2;
        return;
    }
    if(pos<strlen(str) && str[pos]=='>')
    {
        f = 1;
        pos++;
        return;
    }
    if(pos<strlen(str) && str[pos]=='<')
    {
        f = 1;
        pos++;
        return;
    }
    f = 0;
    return;
}

void asgn_stat()
{
    ID();
    if(f==1)
    {
        if(pos<strlen(str) && str[pos]=='=')
        {
            pos++;
            expn();
            return;

        }
        f = 0;
        return;
    }
    return;
}

void loop_stat()
{
    int temp = pos;
    if(pos+5<strlen(str) && str[pos]=='w' && str[pos+1]=='h' && str[pos+2]=='i' && str[pos+3]=='l' && str[pos+4]=='e' && str[pos+5]=='(')
    {
        pos+= 6;
        expn();
        if(f==1 && pos<strlen(str) && str[pos]==')')
        {
            pos++;
            stat();
            if(f==1)
            {
                return;
            }
        }

    }
    pos = temp;
    if(pos+3<strlen(str) && str[pos]=='f' && str[pos+1]=='o' && str[pos+2]=='r' && str[pos+3]=='(')
    {
        pos+=4;
        asgn_stat();
        if(f==1)
        {
            if(pos<strlen(str) && str[pos]==';')
            {
                pos++;
                expn();
                if(f==1)
                {
                    if(pos<strlen(str) && str[pos]==';')
                    {
                        pos++;
                        asgn_stat();
                        if(pos<strlen(str) && str[pos]==')')
                        {
                            pos++;
                            stat();
                            if(f==1)
                                return;
                        }
                    }
                }
            }
        }

    }
    f=  0;
    return;
}

void dscn_stat()
{
    if(pos+2<strlen(str) && str[pos]=='i' && str[pos+1]=='f' && str[pos+2]=='(')
    {
        pos+=3;
        expn();
        if(f==1)
        {
            if(pos<strlen(str) && str[pos]==')')
            {
                pos++;
                stat();
                if(f==1)
                {
                    extn1();
                    return;
                }
                else
                {
                    return;
                }
            }
            else
            {
                f = 0;
                return;
            }
        }
        else
        {
            return;
        }
    }
    f = 0;
    return;
}

void stat()
{
    int temp  =pos;
    asgn_stat();
    if(f==1)
        return;
    pos = temp;
    dscn_stat();
    if(f==1)
        return;
    pos=temp;
    loop_stat();
    if(f==1)
        return;
    f = 0;
    return;
}
int main()
{

    scanf("%s",str);
    init();
    A();
    printf("1 = ");
    if(f  && pos==strlen(str))
        printf("String matched\n");
    else printf("String not matched\n");


    init();
    Exp();
    printf("2 = ");
    if(f==1 && pos==strlen(str))
        printf("String matched\n");
    else printf("String not matched\n");



    init();
    stat();
    printf("3 = ");
    if(f==1 && pos==strlen(str))
        printf("String matched\n");
    else printf("String not matched\n");


}
//ad
//abbd
//abcd
//abbbcbbd
//abb
//abc



//1+(2*3)
//1*4-5/6
//(1+2)*(3+4)+(a-c)/(9-0)
//(1+2)*(3+4)-1*8




//while(a==b)if(a==c)c=2elsec=3
//for(a=b;b<c;d=a)if(a==c)c=2
//if(a==b)c=2
//if(a+b)c=5