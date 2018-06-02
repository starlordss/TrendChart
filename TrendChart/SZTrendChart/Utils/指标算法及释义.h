### KDJ 指标
RSV(n) = [(Ct-Ln)/(Hn-Ln)] ×100，其中Ct：今日收盘价，Ln：n天内的最低价，Hn：n天内最低价
今日K值 = 2/3×昨日K值 + 1/3×今日RSV
今日D值 = 2/3×昨日D值 + 1/3×今日K值
J = 3K-2D

从KD的取值方面考虑，80以上为超买区，20以下为超卖区，KD超过80应考虑卖出，低于20就应考虑买入。
KD指标的交叉方面考虑，K上穿D是金叉，为买入信号，金叉在超卖区出现或进行二次穿越较为可靠。
KD指标的背离
（1）当KD处在高位，并形成依次向下的峰，而此时汇价形成依次向上的峰，叫顶背离，是卖出的信号。
（2）当KD处在低位，并形成依次向上的谷，而此时汇价形成依次向下的谷，叫底背离，是买入信号。
J指标取值超过100和低于0，都属于价格的非正常区域，大于100为超买，小于0为超卖，并且，J值的讯号不会经常出现，一旦出现，则可靠度相当高。


### RSI 指标
RSI的计算
　　　强弱指标的计算公式如下:
RSI=100-[100/(1+RS)]
　　其中 RS=14天内收市价上涨数之和的平均值/14天内收市价下跌数之和的平均值
　　　举例说明：
　　如果最近14天涨跌情形是：
　　第一天升2元，第二天跌2元，第三至第五天各升3元；第六天跌4元第七天升2元，第八天跌5元；第九天跌6元，第十至十二天各升1元；第十三至十四天各跌3元。
　　　那么，计算RSI的步骤如下：
　　　(一)将14天上升的数目相加，除以14，上例中总共上升16元除以14得1.143(精确到小数点后三位)；
　　　(二)将14天下跌的数目相加，除以14，上例中总共下跌23元除以14得1.643(精确到小数点后三位)；
　　　(三)求出相对强度RS，即RS=1.143/1.643=0.696%(精确到小数点后三位)；
　　　(四)1+RS=1+0.696=1.696；
　　　(五)以100除以1+RS，即100/1.696=58.962；
　　　(六)100-58.962=41.038。
　　　结果14天的强弱指标RS1为41.038。

或者算法二
假设A为N日内收盘价的正数之和，B为N日内收盘价的负数之和乘以（-1）,这样，A和B均为正，将A、B代入RSI计算公式，则
RSI（N）=A ÷（A＋B）×100

RSI的原理简单来说是以数字计算的方法求出买卖双方的力量对比，譬如有100个人面对一件商品，如果50个人以上要买，竞相抬价，商品价格必涨。相反，如果50个人以上争着卖出，价格自然下跌。
RSI的计算公式实际上就是反映了某一阶段价格上涨所产生的波动占总的波动的百分比率，百分比越大，强势越明显；百分比越小，弱势越明显。RSI的取值介于0—100之间。在计算出某一日的RSI值以后，可采用平滑运算法计算以后的RSI值，根据RSI值在坐标图上连成的曲线，即为RSI线。
以日为计算周期为例，计算RSI值一般是以5日、10日、14日为一周期。另外也有以6日、12日、24日为计算周期。一般而言，若采用的周期的日数短，RSI指标反应可能比较敏感；日数较长，可能反应迟钝。目前，沪深股市中RSI所选用的基准周期为6日和12日。
RSI数值的超买超卖
一般而言，RSI的数值在80以上和20以下为超买超卖区的分界线。
1、当RSI值超过80时，则表示整个市场力度过强，多方力量远大于空方力量，双方力量对比悬殊，多方大胜，市场处于超买状态，后续行情有可能出现回调或转势，此时，投资者可卖出股票。
2、当RSI值低于20时，则表示市场上卖盘多于买盘，空方力量强于多方力量，空方大举进攻后，市场下跌的幅度过大，已处于超卖状态，股价可能出现反弹或转势，投资者可适量建仓、买入股票。
3、当RSI值处于50左右时，说明市场处于整理状态，投资者可观望。
4、对于超买超卖区的界定，投资者应根据市场的具体情况而定。一般市道中，RSI数值在80以上就可以称为超买区，20以下就可以称为超卖区。但有时在特殊的涨跌行情中，RSI的超卖超买区的划分要视具体情况而定。比如，在牛市中或对于牛股，超买区可定为90以上，而在熊市中或对于熊股，超卖区可定为10以下（对于这点是相对于参数设置小的RSI而言的，如果参数设置大，则RSI很难到达90以上和10以下）。


### MA(C, N)

MA(X,N)简单算术平均
求X的N日移动平均值，不分轻重，平均算。算法是：
(X1+X2+X3+…..+Xn)/N
例如：MA(C，20)表示20日的平均收盘价。C表示CLOSE。

