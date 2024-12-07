txt="<HTML><BODY><TABLE>"

x=list("0123456789ABCDEF")
#x=list("02468ACF")

def color(x):
    txt=""
    for i in list(x):
        for j in x :
            txt=txt + "<TR>\n"
            for k in x :
                color=f'#{i}{j}{k}'
                txt=txt+f'<TD style="background-color:{color}">{color}</TD>\n'
            txt=txt + "</TR>\n"
    return txt

txt=txt+color("02468ACF")
txt=txt+color("0123456789ABCDEF")

f=open("color.html","w")
f.write(txt)
f.close



