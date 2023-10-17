#自定義程式
def confirm(key):#進入每個功能都要跟使用者說一聲
        V=dictF[key]
        print("正在透過",V,"搜尋")

def update():#查詢資料後問使用者是否要更新資料
        global op,Find
        if list1==[]:
                print('查無資料，返回功能選單\n')
        else:
                Ans=input('上述資料是否需要更新（Y/N）')
                if Ans in 'Yy':
                        op="5"
                        print('')
                        Find=2
                else:
                        print('搜尋結束，返回功能選單\n')

def formatprint(A): #格式化列印百貨名稱&餐廳細項
        for i in A:
                V=A[i]
                print("%-2d"%i,V)

def printN(A,value):
        if value in A:
                i=0
                loop=1
                locat=A.index(value)#將value第一次出現的index指定給locat
                frequency=A.count(value)#計算value出現幾次
                while i < len(listF):
                        i=i+1
                        if i==locat:
                                print('%-5d'%locat,end=' ')
                                list1.append(locat)
                                for a in listF[locat]:#用格式化字串的方式印出該餐廳所有資訊
                                        print(a,end=' ')
                                print('')
                                loop=loop+1
                                if loop < frequency:#當loop尚未達到出現次數，就繼續尋找下一筆
                                        locat=A.index(value,locat+1)#尋找下一次value出現的index
                                        
def incomplete(info,A):#當使用者輸入店名時，為避免輸入不完整，會先搜尋是否有店名包含使用者輸入的字元，再將這些店家的詳細資歷料印出來
        global N,L,locat
        finding=''
        frequency=0
        loop=1
        for item in A:#看能否在儲存店名的串列中找到此筆資料
                if item.find(info)!=-1:
                        if item==finding:
                                continue
                        else:
                                loop=1
                                finding=item
                                locat=A.index(finding)#loc代表第幾筆資料有這個店名
                                frequency=A.count(finding)#n代表有幾筆資料是這個地名
                                print('')
                while loop<=frequency:
                        print('%-5d'%locat,end=' ')
                        list1.append(locat)
                        for a in listF[locat]:#用格式化字串的方式印出所有資訊
                                print(a,end=' ')
                        print('')
                        loop=loop+1
                        if loop<=frequency:
                                locat=A.index(finding,locat+1)
                        
def new(choose):#更新的功能 確認要更新哪一筆資料
        choose=int(choose)
        V=dictF[choose]
        new=input('請輸入新%s：'%V)
        return new

def add(N,L,C,T,P):
        l=[N,L,C,T,P]
        listF.append(l)
        listN.append(l[0])
        listL.append(l[1])
        listC.append(l[2])
        listT.append(l[3])
        listP.append(l[4])
        
def delet(location):#更新的功能 刪除整筆資料
        del listF[location]
        del listN[location]
        del listL[location]
        del listC[location]
        del listT[location]
        del listP[location]



      
#主程式
dictF={1:"店名",2:"百貨",3:"類別",4:"價位",5:"更新資料",0:"結束程式"}
dictL={1:"統一時代",2:'誠品信義',3:'微風南山',4:'微風信義',5:'微風松高',6:'新光三越A4',7:'新光三越A8',8:'新光三越A9',9:'新光三越A11',10:'遠百信義A13',11:'Neo19',12:'信義威秀',13:'Bellavita',14:'ATT4FUN',15:'台北101'}
dictC={1:'美妝保養品',2:'運動用品店',3:'餐廳'}
dictT={1:'中式',2:'日式',3:'火鍋',4:'台式',5:'印度',6:'自助',7:'西式',8:'法式',9:'美式',10:'泰式',11:'素食',12:'酒吧',13:'馬來西亞餐',14:'甜品',15:'港式',16:'越式',17:'新加坡菜',18:'粵式',19:'義式',20:'韓式'}
dictP={1:'$$$$',2:'$$$',3:'$$',4:'$'}
op=" "
choose=""
Find=0
list1=[]
listF=[]
listN=[]
listL=[]
listC=[]
listT=[]
listP=[]
file1=open('project_給我一百分.csv', 'a+', encoding='utf-8')#開info並把檔案中的資料都讀進來，檔案需要和程式碼檔案存在同一個資料夾中。
file1.seek(0,0)#把游標定位在第一行第一個字 #雖然沒交到 但為了避免讀不到檔案要用
lines=file1.readlines()
file1.close()
for line in lines:
        listF.append(line.strip().split(','))#以店家各項資訊作為一格儲存
for X in listF:
        listN.append(X[0])#以店名作為一格儲存，N為name
        listL.append(X[1])#以地點作為一格儲存，L為location
        listC.append(X[2])#以種類作為一格儲存，C為category
        listT.append(X[3])#以細項作為一格儲存，T為type
        listP.append(X[4])#以價為作為一格儲存，P為price


print("歡迎進入尋找店家小幫手")
print('離開前務必按0結束程式，以免資料被清除\n')

try:
        while op!="0":
                print("功能選單：1以店名搜尋 2以百貨搜尋 3以類別搜尋 4以價位搜尋 5更新資料 0結束程式")
                op=input("請輸入代碼")

                if op=="1":#以店名搜尋
                        confirm(1)#確認是否要使用此功能0
                        N=input('請輸入想要尋找的店家名稱:')
                        N=N.upper()
                        incomplete(N,listN)
                        update()#詢問是否要更新資料

                elif op=="2":#以百貨搜尋
                        confirm(2) 
                        choose=input("請選擇要輸入 1 百貨代碼 還是輸入 2 百貨名稱+樓層")
                        if choose == '1':
                                formatprint(dictL)
                                store=int(input("請輸入想要尋找的百貨代碼:"))
                                L=dictL[store]
                        elif choose== '2':
                                L=input("請輸入百貨＋樓層(中間以空格格開，樓層以F表示。例：Bellavita 6F)")
                        incomplete(L,listL)                    
                        update()
                        
                elif op=="3":#以類別搜尋
                        confirm(3)
                        choose=input("請輸入想要找的類別(1美妝保養品 2運動用品 3餐廳):")
                        if choose.isdigit():
                                C=dictC[int(choose)]
                        if choose in '12':
                                printN(listC,C)                                                                
                        elif choose=='3':
                                formatprint(dictT)
                                option=input("請輸入代碼")
                                T=dictT[int(option)]
                                printN(listT,T)
                        else:
                                print("查無此類別")
                                
                        update()
                        
                elif op=="4":#以價位搜尋
                        confirm(4)
                        p=int(input("請輸入想要尋找的價位1超高價位 2高價位 3中價位 4平價"))
                        P=dictP[p]
                        printN(listP,P)                                             
                        update()
                        
                elif op=="0":#結束程式
                        print("歡迎下次再度光臨\n")
                
                if op=="5":#更新資料
                        if Find!=2:
                                list1=[]
                                print("進入更新資料功能")
                                N=input("請輸入要更新的店家名稱（0返回功能選單 1新增店家）：")
                                N=N.upper()
                                Find=0
                                if N =='0':
                                        print("返回功能選單\n")
                                        Find=1
                                elif N=='1':
                                        N=input('請輸入店名')
                                        N=N.upper()
                                        L=input('請輸入百貨')
                                        C=input('請輸入類別')
                                        if C=='餐廳':
                                                T=input('請輸入細項')
                                                P=input('請輸入價位')
                                        add(N,L,C,T,P)
                                        Find=1
                                        print('已新增，返回功能選單\n')
                                else:
                                        for item in listN:#看能否在儲存店名的串列中找到此筆資料
                                                if item.find(N)!=-1:
                                                        Find=2
                                        incomplete(N,listN)
                        if Find==2:   
                                while len(list1)>1:
                                        locat=int(input('請輸入要更動的資料代碼：'))#詢問使用者要更新哪一筆資料
                                        if locat not in list1:
                                                print('資料代碼不在搜尋範圍，請重新輸入：')
                                        else:
                                                list1=[]
                                print("更新選項：1店名 2百貨 3類別 4價位 5刪除資料")#詢問要更新哪項資訊
                                ch=input('請輸入想要更新的內容：')
                                if ch=='1':
                                        N=new(ch)#回傳新的資訊，並將新的資訊更新到相關串列
                                        N=N.upper()
                                        listN[locat]=N
                                        listF[locat][0]=N
                                        print('已更新，返回功能選單\n')
                                elif ch=='2':
                                        L=new(ch)
                                        listL[locat]=L
                                        listF[locat][1]=L
                                        print('已更新，返回功能選單\n')
                                elif ch=='3':
                                        C=new(ch)
                                        listC[locat]=C
                                        listF[locat][2]=C
                                        if C=='餐廳':
                                                T=input('請輸入細項：')
                                                listT[locat]=T
                                                listF[locat][3]=T
                                        print('已更新，返回功能選單\n')
                                elif ch=='4':
                                        P=new(ch)
                                        listP[locat]=P
                                        listF[locat][4]=P
                                        print('已更新，返回功能選單\n')
                                elif ch=='5':
                                        print('準備刪除： %-3d'%locat,end='')#向使用者確認是否刪除資料
                                        for i in listF[locat]:
                                                print(' ',i,end='')
                                        print('\n（z取消 任意鍵繼續）',end='')
                                        z=input()
                                        if z in 'Zz':
                                                print('已取消,返回功能選單\n')
                                        else:   
                                                delet(locat)#刪除每個串列中的相關資訊
                                                print('已刪除，返回功能選單\n')
                                else:
                                        print("無此選項，返回功能選單\n")
                                        
                        elif Find==0:
                                print("此店名不在名單內，返回功能選單\n")
        
except Exception as X:
        print("\n發生錯誤請重新開始")
        print("錯誤原因",X)

finally:
        file1=open('project_給我一百分.csv', 'w+', encoding='utf-8')#重新開啟檔案，以w+的模式，刪掉所有資料後更新成現有資料
        for i in listF:
                for item in i:
                        file1.write(item)
                        file1.write(',')
                file1.write('\n')   
        file1.close()
