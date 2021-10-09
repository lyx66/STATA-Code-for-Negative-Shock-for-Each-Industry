clear all
global path_1 = "C:\Users\Lenovo\Desktop\new_intitution_0923\data_2_财务数据"
global path_2 = "C:\Users\Lenovo\Desktop\new_intitution_0923\save-5_行业负向冲击"
global path_3 = "C:\Users\Lenovo\Desktop\new_intitution_0923\save-5_行业负向冲击\合并后的冲击"


/*cd $path_1
import excel using "教育.xlsx",firstrow clear
drop in -2/-1
drop 证券代码
/*正则表达式无敌了*/
drop *2006*
keep 证券简称 总资产报酬率ROA报告期*报单位 总资产报告期*年报报表类型合并报表币种
renames 总资产报酬率ROA报告期2007年报单位-总资产报酬率ROA报告期2020年报单位 \ ROA2007-ROA2020
/*保留2007以后无缺失值的firms*/
forvalue y_=2007/2020 {
	drop if ROA`y_' == . | 总资产报告期`y_'年报报表类型合并报表币种 == .
	}
/*参考杨子晖（2021），取前行业内的10大firms*/
egen total_size_of_each_firm = rsum(总资产报告期*年报报表类型合并报表币种)
gsort -total_size_of_each_firm /*对size进行排序*/

if _N>10 {
	keep if _n<=10
	}
drop total_size_of_each_firm

/*计算行业每年的规模加权平均ROA*/
forvalue y_=2007/2020 {
	egen Total_size_`y_' = total(ln(总资产报告期`y_'年报报表类型合并报表币种))
	
	gen Wight_`y_' = ln(总资产报告期`y_'年报报表类型合并报表币种) / Total_size_`y_'
	gen ROA_w_`y_' = ROA`y_' * Wight_`y_' /*得到 each firm 的加权ROA*/
	egen ROA_mean_`y_' = total(ROA_w_`y_')
	drop Total_size_`y_' Wight_`y_' ROA_w_`y_'
	}
keep ROA_mean_*
keep in 1
xpose, clear v
gen year = _n+2006
drop _varname
tset year
ren v1 ROA
qui reg ROA L.ROA L2.ROA
predict shock, r
drop ROA
local file_name=plural(2,"`file'", "-.xlsx")
gen name1 = "`file_name'"*/

/*全年冲击*/
cd $path_1
fs *.xlsx
foreach file in `r(files)'{
	cd $path_1
	import excel using `file',firstrow clear
	drop in -2/-1
	drop 证券代码
	/*正则表达式无敌了*/
	drop *2006*
	keep 证券简称 总资产报酬率ROA报告期*年报单位 总资产报告期*年报报表类型合并报表币种
	renames 总资产报酬率ROA报告期2007年报单位-总资产报酬率ROA报告期2020年报单位 \ ROA2007-ROA2020
	/*保留2007以后无缺失值的firms*/
	forvalue y_=2007/2020 {
		drop if ROA`y_' == . | 总资产报告期`y_'年报报表类型合并报表币种 == .
		}
	/*参考杨子晖（2021），取前行业内的10大firms*/
	egen total_size_of_each_firm = rsum(总资产报告期*年报报表类型合并报表币种)
	gsort -total_size_of_each_firm /*对size进行排序*/

	if _N>10 {
		keep if _n<=10
		}
	drop total_size_of_each_firm

	/*计算行业每年的规模加权平均ROA*/
	forvalue y_=2007/2020 {
		egen Total_size_`y_' = total(ln(总资产报告期`y_'年报报表类型合并报表币种))
		
		gen Wight_`y_' = ln(总资产报告期`y_'年报报表类型合并报表币种) / Total_size_`y_'
		gen ROA_w_`y_' = ROA`y_' * Wight_`y_' /*得到 each firm 的加权ROA*/
		egen ROA_mean_`y_' = total(ROA_w_`y_')
		drop Total_size_`y_' Wight_`y_' ROA_w_`y_'
		}
	keep ROA_mean_*
	keep in 1
	xpose, clear v
	gen Year = _n+2006
	drop _varname
	tset Year
	ren v1 ROA
	*qui reg ROA L.ROA L2.ROA L3.ROA
	qui reg ROA L.ROA L2.ROA
	predict shock, r
	drop ROA
	local file_name=plural(2,"`file'", "-.xlsx")
	gen name1 = "`file_name'"
	cd $path_2
	drop if shock == .
	replace Year = hofd(mdy(12,1,Year))
	save `file_name'_2, replace
	}
	
clear
cd $path_2
fs *_2.dta
foreach file in `r(files)'{
	append using `file'
	}
cd $path_3	
save "合并冲击_2", replace

/*半年冲击*/	
cd $path_1
fs *.xlsx
foreach file in `r(files)'{
	cd $path_1
	import excel using `file',firstrow clear
	drop in -2/-1
	drop 证券代码
	/*正则表达式无敌了*/
	drop *2006*
	keep 证券简称 总资产报酬率ROA报告期*中报单位 总资产报告期*年报报表类型合并报表币种
	renames 总资产报酬率ROA报告期2007中报单位-总资产报酬率ROA报告期2020中报单位 \ ROA2007-ROA2020
	/*保留2007以后无缺失值的firms*/
	forvalue y_=2007/2020 {
		drop if ROA`y_' == . | 总资产报告期`y_'年报报表类型合并报表币种 == .
		}
	/*参考杨子晖（2021），取前行业内的10大firms*/
	egen total_size_of_each_firm = rsum(总资产报告期*年报报表类型合并报表币种)
	gsort -total_size_of_each_firm /*对size进行排序*/

	if _N>10 {
		keep if _n<=10
		}
	drop total_size_of_each_firm

	/*计算行业每年的规模加权平均ROA*/
	forvalue y_=2007/2020 {
		egen Total_size_`y_' = total(ln(总资产报告期`y_'年报报表类型合并报表币种))
		
		gen Wight_`y_' = ln(总资产报告期`y_'年报报表类型合并报表币种) / Total_size_`y_'
		gen ROA_w_`y_' = ROA`y_' * Wight_`y_' /*得到 each firm 的加权ROA*/
		egen ROA_mean_`y_' = total(ROA_w_`y_')
		drop Total_size_`y_' Wight_`y_' ROA_w_`y_'
		}
	keep ROA_mean_*
	keep in 1
	xpose, clear v
	gen Year = _n+2006
	drop _varname
	tset Year
	ren v1 ROA
	*qui reg ROA L.ROA L2.ROA L3.ROA
	qui reg ROA L.ROA L2.ROA
	predict shock, r
	drop ROA
	local file_name=plural(2,"`file'", "-.xlsx")
	gen name1 = "`file_name'"
	cd $path_2
	drop if shock == .
	replace Year = hofd(mdy(5,1,Year))
	save `file_name'_1, replace
	}
	
clear	
cd $path_2
fs *_1.dta
foreach file in `r(files)'{
	append using `file'
	}
cd $path_3	
save "合并冲击_1", replace	

use "合并冲击_1", clear	
	
append using "合并冲击_2"
format %th Year	
sort name1 Year
ren name1 source1
save "合并冲击", replace
	
	
/*全年冲击（用于金融化test）*/
cd $path_1
fs *.xlsx
foreach file in `r(files)'{
	cd $path_1
	import excel using `file',firstrow clear
	drop in -2/-1
	drop 证券代码
	/*正则表达式无敌了*/
	drop *2006*
	keep 证券简称 总资产报酬率ROA报告期*年报单位 总资产报告期*年报报表类型合并报表币种
	renames 总资产报酬率ROA报告期2007年报单位-总资产报酬率ROA报告期2020年报单位 \ ROA2007-ROA2020
	/*保留2007以后无缺失值的firms*/
	forvalue y_=2007/2020 {
		drop if ROA`y_' == . | 总资产报告期`y_'年报报表类型合并报表币种 == .
		}
	/*参考杨子晖（2021），取前行业内的10大firms*/
	egen total_size_of_each_firm = rsum(总资产报告期*年报报表类型合并报表币种)
	gsort -total_size_of_each_firm /*对size进行排序*/

	if _N>10 {
		keep if _n<=10
		}
	drop total_size_of_each_firm

	/*计算行业每年的规模加权平均ROA*/
	forvalue y_=2007/2020 {
		egen Total_size_`y_' = total(ln(总资产报告期`y_'年报报表类型合并报表币种))
		
		gen Wight_`y_' = ln(总资产报告期`y_'年报报表类型合并报表币种) / Total_size_`y_'
		gen ROA_w_`y_' = ROA`y_' * Wight_`y_' /*得到 each firm 的加权ROA*/
		egen ROA_mean_`y_' = total(ROA_w_`y_')
		drop Total_size_`y_' Wight_`y_' ROA_w_`y_'
		}
	keep ROA_mean_*
	keep in 1
	xpose, clear v
	gen Year = _n+2006
	drop _varname
	tset Year
	ren v1 ROA
	*qui reg ROA L.ROA L2.ROA L3.ROA
	qui reg ROA L.ROA L2.ROA
	predict shock, r
	drop ROA
	local file_name=plural(2,"`file'", "-.xlsx")
	gen name1 = "`file_name'"
	cd $path_2
	drop if shock == .
	save `file_name'_2, replace
	}
	
clear
cd $path_2
fs *_2.dta
foreach file in `r(files)'{
	append using `file'
	}
ren name1 source1
cd $path_3	
save "合并冲击_金融化", replace
	
	
	
	
	
	
	
	
	
	
renames 营业利润报告期2000中报报表类型合并报表单-营业利润报告期2020年报报表类型合并报表单 \ a1-a42
renames 投资收益报告期2000中报报表类型合并报表单-投资收益报告期2020年报报表类型合并报表单 \ b1-b42
renames 公允价值变动净收益报告期2000中报报表类型合并-公允价值变动净收益报告期2020年报报表类型合并 \ c1-c42
renames 其他综合收益报告期2000中报报表类型合并报表-其他综合收益报告期2020年报报表类型合并报表 \ d1-d42


forvalue i=1(2)39 {
	drop a`i'
	drop b`i'
	drop c`i'
	drop d`i'
	}
drop a42 b42 c42 d42

renames a2-a41 \ 营业利润2000-营业利润2020
renames b2-b41 \ 投资收益2000-投资收益2020
renames c2-c41 \ 公允价值变动净收益2000-公允价值变动净收益2020
renames d2-d41 \ 其他综合收益2000-其他综合收益2020

drop if strmatch(证券简称,"*ST*")==1
drop if strmatch(证券简称,"ST*")==1
drop if 营业利润2011==.&营业利润2010==.
 

forvalue i=2000/2020 {
egen a`i'=total(营业利润`i')
egen b`i'=total(投资收益`i')
egen c`i'=total(公允价值变动净收益`i')
egen d`i'=total(其他综合收益`i')
}

drop 营业利润2000-其他综合收益2020



drop 证券简称




	forvalue i=2000/2020 {
	gen y`i' = (b`i'+c`i'+d`i')/a`i'*100
	}
	drop a2000-d2020
	keep in 1
	xpose,clear v
	gen year=_n+1999
	drop _varname
	drop if year<2006
	
	local file_name=plural(2,"`file'", "-.xlsx")
	gen source = "`file_name'"
	
	cd $path_2
	save "`file_name'.dta",replace

foreach file in `r(files)'{
	cd $path_1
	import excel using "`file'",firstrow clear
	import excel using "电气机械和器材制造.xlsx",firstrow clear
	drop in -4/-1

	renames 营业利润报告期2000中报报表类型合并报表单-营业利润报告期2020年报报表类型合并报表单 \ a1-a42
	renames 投资收益报告期2000中报报表类型合并报表单-投资收益报告期2020年报报表类型合并报表单 \ b1-b42
	renames 公允价值变动净收益报告期2000中报报表类型合并-公允价值变动净收益报告期2020年报报表类型合并 \ c1-c42
	renames 其他综合收益报告期2000中报报表类型合并报表-其他综合收益报告期2020年报报表类型合并报表 \ d1-d42

	drop 证券代码

	forvalue i=1(2)39 {
		drop a`i'
		drop b`i'
		drop c`i'
		drop d`i'
		}
	drop a42 b42 c42 d42

	renames a2-a41 \ 营业利润2000-营业利润2020
	renames b2-b41 \ 投资收益2000-投资收益2020
	renames c2-c41 \ 公允价值变动净收益2000-公允价值变动净收益2020
	renames d2-d41 \ 其他综合收益2000-其他综合收益2020

	drop if strmatch(证券简称,"*ST*")==1
	drop if strmatch(证券简称,"ST*")==1
	drop if 营业利润2011==.&营业利润2010==.
	 

	forvalue i=2000/2020 {
	egen a`i'=total(营业利润`i')
	egen b`i'=total(投资收益`i')
	egen c`i'=total(公允价值变动净收益`i')
	egen d`i'=total(其他综合收益`i')
	}

	drop 营业利润2000-其他综合收益2020



	drop 证券简称




	forvalue i=2000/2020 {
	gen y`i' = (b`i'+c`i'+d`i')/a`i'*100
	}
	drop a2000-d2020
	keep in 1
	xpose,clear v
	gen year=_n+1999
	drop _varname
	drop if year<2006
	
	local file_name=plural(2,"`file'", "-.xlsx")
	gen source = "`file_name'"
	
	cd $path_2
	save "`file_name'.dta",replace
}

clear
cd $path_2
fs *.dta

foreach file in `r(files)'{
     append using "`file'"
}


	


cd $path_1
save "33个行业的金融渠道获利占比数据.dta",replace
	
*计算实体各个部门对金融的溢出.(房地产单独作为一个部门，月度)
global path_3 = "C:\Users\Lenovo\Desktop\讨论后\金融分业\网络输出的结果（完成第5次清洗）"
cd $path_3
use Delta_CoVaR.dta,replace
sort date time source target

recode source (1/4=2) (5/5=1) (6/9=2) (10/10=3) (11/27=2) (28/29=1) (30/37=2),gen(source2)
recode target (1/4=2) (5/5=1) (6/9=2) (10/10=3) (11/27=2) (28/29=1) (30/37=2),gen(target2)

keep if (source2==2 & target2==1)



gen year=year(date)


ren dcovar dc1
gen dc2=. /*正向溢出*/
gen dc3=. /*负向溢出*/

replace dc2=dc1 if dc1>=0
replace dc3=dc1 if dc1<0

collapse (sum) dc1 ,by(source year)
replace dc1 = dc1/3
drop if year<2006
/*forvalues i= 1/3 {
preserve
collapse (mean) dc`i'  ,by(source2 target)

*考虑实体部门、金融部门和房地产部门行业数量不同.


replace dc`i'=dc`i'/34





*grss tw  line dc`i' Month   ,by(source2 target2,yrescale)

*tabulate source2 target2,sum(dcovar)
sort dc`i'
save 金融对实体分部门（正负）（剥离房地产，月度）_`i'.dta,replace
restore
}*/
cd $path_1
save "33个行业对金融部门的年溢出.dta",replace

import excel using "(3)33个实体行业年溢出-金融渠道获利占比.xlsx",firstrow clear
gen id = .
sort source
forvalue i = 1/33 {
	replace id = `i' if (_n>(`i'-1)*15 & _n<=`i'*15)
	}
drop if v1<0
xtset id year
xtreg v1 dc3

*估计固定效应模型，存储结果
xtreg v1 dc3,fe
est store fe

*估计随机效应模型，存储结果
xtreg v1 dc3,re
est store re

*进行hausman检验
hausman fe



cd $path_3
fs *.xlsx
foreach file in `r(files)'{
	cd $path_3
	import excel using "`file'",firstrow clear
	*import excel using "电气机械和器材制造.xlsx",firstrow clear
	drop in -4/-1
	local file_name=plural(2,"`file'", "-.xlsx")
	save "`file_name'.dta",replace
	}
fs *.dta
foreach file in `r(files)'{
	cd $path_3
	append using "`file'"
	*import excel using "电气机械和器材制造.xlsx",firstrow clear
	
	}

	renames 营业利润报告期2000中报报表类型合并报表单-营业利润报告期2020年报报表类型合并报表单 \ a1-a42
	renames 投资收益报告期2000中报报表类型合并报表单-投资收益报告期2020年报报表类型合并报表单 \ b1-b42
	renames 公允价值变动净收益报告期2000中报报表类型合并-公允价值变动净收益报告期2020年报报表类型合并 \ c1-c42
	renames 其他综合收益报告期2000中报报表类型合并报表-其他综合收益报告期2020年报报表类型合并报表 \ d1-d42

	drop 证券代码

	forvalue i=1(2)39 {
		drop a`i'
		drop b`i'
		drop c`i'
		drop d`i'
		}
	drop a42 b42 c42 d42

	renames a2-a41 \ 营业利润2000-营业利润2020
	renames b2-b41 \ 投资收益2000-投资收益2020
	renames c2-c41 \ 公允价值变动净收益2000-公允价值变动净收益2020
	renames d2-d41 \ 其他综合收益2000-其他综合收益2020

	drop if strmatch(证券简称,"*ST*")==1
	drop if strmatch(证券简称,"ST*")==1
	drop if 营业利润2011==.&营业利润2010==.
	 

	forvalue i=2000/2020 {
	egen a`i'=total(营业利润`i')
	egen b`i'=total(投资收益`i')
	egen c`i'=total(公允价值变动净收益`i')
	egen d`i'=total(其他综合收益`i')
	}

	drop 营业利润2000-其他综合收益2020



	drop 证券简称




	forvalue i=2000/2020 {
	gen y`i' = (b`i'+c`i'+d`i')/a`i'*100
	}
	drop a2000-d2020
	keep in 1
	xpose,clear v
	gen year=_n+1999
	drop _varname
	drop if year<2003
	
	cd "C:\Users\Lenovo\Desktop"
	save "所有实体行业金融渠道获利占比.dta",replace


global path_4="C:\Users\Lenovo\Desktop\讨论后\金融分业\VaR和残差（分位数回归---250）\网络输出的结果（正负）（完成第5次清洗）"
global path_5="C:\Users\Lenovo\Desktop\讨论后\金融分业\网络输出的结果（完成第5次清洗）"
	
cd $path_4
use Delta_CoVaR.dta,replace
sort date source target

recode source (1/4=2) (5/5=1) (6/9=2) (10/10=1) (11/27=2) (28/29=1) (30/37=2),gen(source2)
recode target (1/4=2) (5/5=1) (6/9=2) (10/10=1) (11/27=2) (28/29=1) (30/37=2),gen(target2)

keep if (source2==2 & target2==2)



gen year=year(date)





collapse (sum) dcovar  ,by(year)


replace dcovar=dcovar/(33*32)

cd "C:\Users\Lenovo\Desktop"
save "实体部门年溢出比.dta",replace
