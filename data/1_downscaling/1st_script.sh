# script name
me="$BASH_SOURCE"
# current folder
ME=$(realpath .)
cptd="$ME/11.03";    #  for TAMUK HPC2
cptx="CPT.x";
dt1="1957";
dt2="2010";
tmp="$ME/tmp";
xy=$tmp/xy;
_X="$xy/X";
_Y="$xy/Y";
# observed=($tmp/observed_*);
observed=$tmp/observed;
forecast=$tmp/forecast;
cptfiles=$tmp/cptfiles;
cptresults=$tmp/cptresults;
cptoutputs=$tmp/cptoutputs;
xyLimits=$tmp/xyLimits;
unset count;

################################################################################
function prog(){
# https://unix.stackexchange.com/questions/415421/linux-how-to-create-simple-progress-bar-in-bash
	local w=80 x1=$1 x2=$2;  shift 2;
	p1=$(( $x1*80/$x2 ));
	p2=$(( $x1*100/$x2 ));
	# echo -en "\r ... $x1 - $x2 - $p ... ";
	printf -v dash "%*s" "$(( $w-$p1 ))" ""; dash=${dash// /_};
	printf -v hash "%*s>" "$p1" ""; hash=${hash// /=};

	printf "\r%s\t\e[K[%-*s] %3d%%" "$*" "$w" "$hash$dash" "$p2"; 
}
################################################################################

################################################################################
function MSG {
  # MSGs
  # set +x  
  echo -en "\n";
  text="$1";delay="$2";if [ -z $delay ]; then delay=".001"; fi
  for i in $(seq 0 $(expr length "${text}")); do printf "${text:$i:1}";sleep ${delay};done;
  counter;
  echo -en "\n";
}
################################################################################

################################################################################
function MSGx {
  echo -en "\r$1";
  counter;
}
################################################################################

################################################################################
function counter {
  count=$[$count+1];
  echo -en "\r\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t ..... $count";
}
################################################################################

################################################################################
case "$1" in
	"1")
		# Downloading
		MSG "################################################################################";
		MSG "1.Downloading the data";
		# sanmarcos=""
		# limits

		# 08172000 SAN MARCOS RIVER AT LULING, TX Latitude : 29 : 39 : 54N Longitude : 097 : 38 : 59W Datum : 322.05 ft .
		# Drainage area : 838 sq.mi. In hydrologic unit 12100203 and in state of TX ( county 055 ) .
		# Daily and longer averages for 49 water years are acceptable ( all years except partial years ) .
		# 4 ----80---- 5 --- 90---- 5 ---00 ---- 5 --- 10 ---- 5 ---20 ---- 5 --- 30 ---- 5 --- 4 *******

		################################################################################
		stn="08172000";
		# xy="-99/-97,29/30.5"; # San Marcos
		# XY_limits="X/${xy//,//RANGEEDGES/Y/}/RANGEEDGES";
		# XY_ranges=(${xy//,/ })
		# X_range=$(seq ${XY_ranges[0]//\// .0625 })
		# Y_range=$(seq ${XY_ranges[1]//\// .0625 })

		# calculating the spatial average for the 1/8 grids covering the basin
		# basin limits
		# X1="-98.7";
		# X2="-97.4";
		# Y1="29.44";
		# Y2="30.2";
		XYURI="http://waterservices.usgs.gov/nwis/site/?format=rdb&sites=08172000";
		mapURI="http://water.usgs.gov/wsc/cat/";
		gridsURI="http://iridl.ldeo.columbia.edu/SOURCES/.IRI/.FD/.ECHAM4p5/.Forecast/.ca_sst/.ensemble24/.MONTHLY/[M]average/.prec";

		################################################################################
		# X,Y limits and ranges
		# X1="-100";
		# X2="-95";
		# Y1="26";
		# Y2="33";
		# XY_limits="Y/$Y1/$Y2/RANGEEDGES/X/$X1/$X2/RANGEEDGES";
		# X_range=$(seq $X1 .0625 $X2)
		# Y_range=$(seq $Y1 .0625 $Y2)
		################################################################################
		# mkdir -p $tmp observed forecast 

		################################################################################
		# edmaurer observed gridded data => monthly total mm
		# http://hydro.engr.scu.edu/files/gridded_obs/daily/ascii/gulf_daily_met.tgz
		# http://hydro.engr.scu.edu/files/gridded_obs/monthly/ascii/gulf_monthly_met.tgz
		# https://iridl.ldeo.columbia.edu/SOURCES/.IRI/.FD/.ECHAM4p5/.Forecast/.ca_sst/.ensemble24/.MONTHLY/%5BM%5Daverage/.prec/Y/29.3125/30.3125/RANGEEDGES/X/-98.8125/-97.3125/RANGEEDGES
		
		mkdir -p $observed/{daily,monthly} $forecast;
		X1="-98.8125";
		X2="-97.3125";
		Y1="29.3125";
		Y2="30.3125";
		XY_limits="Y/$Y1/$Y2/RANGEEDGES/X/$X1/$X2/RANGEEDGES";
		X_range=$(seq $X1 .125 $X2);
		Y_range=$(seq $Y1 .125 $Y2);
		################################################################################
		# observed data
		################################################################################
		if [ ! -f $observed/*daily*.tgz ];then
			MSG "Downloading observed daily";
			wget "http://hydro.engr.scu.edu/files/gridded_obs/daily/ascii/gulf_daily_met.tgz" -P $observed;
			MSG "Extracting observed daily";
			tar xzf $observed/*daily*.tgz -C $observed/daily --strip-components=1;
		fi;
		if [ ! -f $observed/*monthly*.tgz ];then
			MSG "Downloading observed monthly";
			wget "http://hydro.engr.scu.edu/files/gridded_obs/monthly/ascii/gulf_monthly_met.tgz" -P $observed;
			MSG "Extracting observed monthly";
			tar xzf $observed/*monthly*.tgz -C $observed/monthly --strip-components=1;
		fi;
		allobs="";
		for y in $Y_range;do
			for x in $X_range;do
				MSGx "Copying (${observed//$ME\/}/monthly/data_$y"_"$x) to (${observed//$ME\/}/observed_$y"_$x")";
				awk '$1>="'$dt1'"&&$1<="'$dt2'"{f="'${observed//$ME\/}"/observed_"$y"_"$x'";print $1,$3>sprintf("%s_%02d",f,$2)}' "${observed//$ME\/}/monthly/data_"$y"_"$x;
				allobs=$allobs" ${observed//$ME\/}/monthly/data_"$y"_"$x;
			done;
		done;

		echo;

		# find the files within the limits
		# ls data/data_*|awk -F_ '$2>='"$Y1"'&&$2<='"$Y2"'&&$3>='"$X1"'&&$3<='"$X2"''
		# save to pcpt.obs.avg (monthly total mm)
		MSG "Calculating ${observed//$ME\/}/observed.pcpt.avg";
		# awk '{ a[FNR]=(a[FNR]?a[FNR]:"")+$3;b[FNR]+=!!a[FNR];y[FNR]=$1;m[FNR]=$2} END { for(i=1;i<=FNR;i++) print y[i],m[i],a[i]/b[i] }' $(ls $observed/observed_*|awk -F_ '$(NF-1)>='"$Y1"'&&$(NF-1)<='"$Y2"'&&$(NF)>='"$X1"'&&$(NF)<='"$X2"'')>$observed/observed.pcpt.avg
		awk '{ a[FNR]=(a[FNR]?a[FNR]:"")+$3;b[FNR]+=!!a[FNR];y[FNR]=$1;m[FNR]=$2} END { for(i=1;i<=FNR;i++) print y[i],m[i],a[i]/b[i] }' $(ls $allobs)>${observed//$ME\/}/observed.pcpt.avg;

		MSG "Building ${observed//$ME\/}/observed.grids.csv";
		ls $allobs|awk -F_ 'BEGIN{print "X Y"}{print $(NF),$(NF-1)}'>${observed//$ME\/}/observed.grids.csv

		################################################################################
		# ECHAM4.5 forcast data => monthly avg m/s
		# X1="-98.6875";
		# X2="-97.4375";
		# Y1="29.4375";
		# Y2="30.1875";

		# X	-101.25
		# X	-95.625
		# Y	26.51077
		# Y	32.09194

		X1="-101";
		X2="-95";
		Y1="27";
		Y2="32";
		XY_limits="Y/$Y1/$Y2/RANGEEDGES/X/$X1/$X2/RANGEEDGES";
		X_range=$(seq $X1 .0625 $X2);
		Y_range=$(seq $Y1 .0625 $Y2);
		# download ECHAM4.5 preciptation forecast data
		# detail: http://iridl.ldeo.columbia.edu/SOURCES/.IRI/.FD/.ECHAM4p5/.Forecast/.ca_sst/.ensemble24/.MONTHLY/%5BM%5Daverage/.prec/Y/26/33/RANGEEDGES/X/-100/-95/RANGEEDGES/
		if [ ! -f $forecast/forecast.pcpt ];then
			echo "Downloading ECHAM4.5 forecasts X ($X1,$X2), Y($Y1,$Y2) ==> (${forecast//$tmp\/}/forecast.pcpt)";
			wget "http://iridl.ldeo.columbia.edu/SOURCES/.IRI/.FD/.ECHAM4p5/.Forecast/.ca_sst/.ensemble24/.MONTHLY/[M]average/.prec/Y/$Y1/$Y2/RANGEEDGES/X/$X1/$X2/RANGEEDGES/gridtable.tsv" --output-document $forecast/forecast.pcpt;
		fi

		MSG "Calculating ${forecast//$tmp\/}/forecast.grids.csv";
		awk 'NR>1{print $2,$3}' $forecast/forecast.pcpt|sort|uniq|sed '1iX Y'>$forecast/forecast.grids.csv;
		MSG "Generating ${forecast//$tmp\/}/forecast_{grids}_{lead_times}";
		awk 'NR>1{t=mktime("2000 "$5*1+1" 1 0 0 0");y=strftime("%Y",t)-40;m=strftime("%m",t);d=strftime("%d",t);print y,$1>"'$forecast'/forecast_"$3"_"$2"_"m"_"($4*1+.5)}' "$forecast/forecast.pcpt";

		# . "$me" 2;

	;;
	"2")
		MSG "################################################################################";
		MSG "2.Generating X & Y Files";

		mkdir -p $xy;
		_X="$xy/X_";
		_Y="$xy/Y_";
		MLs=(`ls $forecast/forecast_*|awk -F_ '{print $(NF-1)"_"$(NF)}'|sort|uniq`);
		for ml in ${MLs[@]};do
			MSGx "Generating (${_X//$ME\/}$ml) from (${forecast//$ME\/}/forecast_*_$ml)";
			forecasts="${forecast//$ME\/}/forecast_*$ml";
			ls $forecasts|awk -F_ 'BEGIN{s="STN";y="LAT";x="LON"}{s=s",forecast"NR;y=y","$(NF-3);x=x","$(NF-2)}END{print s"\n"y"\n"x}'>$_X$ml;
			pr -mts" " $forecasts|awk '$1>="'$dt1'"&&$1<="'$dt2'"{f="'$_X$ml'";for(i=0;i++<=NF;)if(i==1||i%2==0)printf $i" ">>f;printf "\n">>f}';
		done

		obs=(${observed//$ME\/}/observed_*);
		for f in "${!obs[@]}";do
			MSGx "Generating (${obs[f]//observed\/observed/xy/Y}) from (${obs[f]//$tmp\/})";
			echo "${obs[f]}" |awk -F_ '{print "STN,"$(NF)"\nLAT,"$(NF-2)"\nLON,"$(NF-1) > "'${obs[f]//observed\/observed/xy/Y}'"}';
			cat "${obs[f]}" >> ${obs[f]//observed\/observed/xy/Y} ;
		done
		echo;

		MSG "Calculating the X Limits";
		echo -e "X\t`Rscript --vanilla <(sed '1,/^# RSCRIPT START/d;/^# RSCRIPT END/,$d' "$me") "$xy/X_01_1"`" > $xyLimits;
		MSG "Calculating the Y Limits";
		for y in $xy/Y_*01; do
			MSGx "${y//$ME\/}";
			echo -e "${y//$ME\/}\t`Rscript --vanilla <(sed '1,/^# RSCRIPT START/d;/^# RSCRIPT END/,$d' "$me") "$y"`" >> $xyLimits;
		done

		MSG "Done";

		# . "$me" 3;

	;;
	"3")
		MSG "################################################################################";
		MSG "3.Generating CPT Files";
		mkdir -p $cptfiles;
		# MSG "Finding the X limits:";
		# cptLimitsX="`Rscript --vanilla <(sed '1,/^# RSCRIPT START/d;/^# RSCRIPT END/,$d' "$me") "$xy/X_01_1"`";
		cptLimitsX=$(awk 'NR<2{print $2}' $xyLimits)
		MSGx "$cptLimitsX";
		Xs=($xy/X*);
		Ys=($xy/Y*);

		ms=$(ls tmp/xy/X_*|awk -F_ '{print $2}'|sort|uniq);
		Ls=$(ls tmp/xy/X_*|awk -F_ '{print $3}'|sort|uniq);

		progcount=$(ls $xy/Y_*|wc -l);
		progcounter=1;


		for y in $xy/Y_*; do
			if [[ "$y" == *01 ]];then 
				cptLimitsY=$(awk '$1=="'${y//$ME\/}'"{print $2}' $xyLimits)
				# cptLimitsY="`Rscript --vanilla <(sed '1,/^# RSCRIPT START/d;/^# RSCRIPT END/,$d' "$me") "$y"`";
				# MSGx "\nFinding the Y limits: $cptLimitsY\n";
			fi;

			m=${y//*_};
			for L in $Ls; do
				mL=$m"_"$L;

				cpt_X=${y//Y*/X}_$mL;
				cpt_Y=$y;
				cpt_CV=${y//xy\/Y/cptresults/CV}_$L;
				cpt_cpt=${y//xy\/Y/cptfiles\/cpt}_$L;

				awk '{print $1}' <(sed '1,/^# cpt_CV_cfg START/d;/^# cpt_CV_cfg END/,$d' "$me") |\
				sed 's%X_%'$cpt_X'%g'|\
				sed 's%Y_%'$cpt_Y'%g'|\
				sed 's%CV_%'$cpt_CV'%g'|\
				sed 's%cptLimitsX%'${cptLimitsX//,/\\n}'%g'|\
				sed 's%cptLimitsY%'${cptLimitsY//,/\\n}'%g'\
				> $cpt_cpt;

				prog  "$progcounter" "$progcount" "${cpt_cpt//$ME\/}";
			done
			progcounter=$((progcounter+1));
		# echo " ... $progcounter" "$progcount";#return
		done

		MSG "Done";

		# . "$me" 4;
	;;
	"4")
		MSG "################################################################################";
		MSG "3.Running CPT";
		mkdir -p $cptoutputs $cptresults
		cd $cptd;
		# CPTs=($cptfiles_*??);
		progcount=$(ls $cptfiles/*|wc -l);
		progcounter=1;
		for f in $cptfiles/*;do
			# MSGx "running : $f";
			prog  "$progcounter" "$progcount" "${f//$ME\/}";
			./$cptx < $f > ${f//cptfiles\/cpt/cptoutputs/cptoutput};
			progcounter=$((progcounter+1));
		done

		cd "$ME";

		MSG "Done";

	;;
	# "5")
	# 	MSG "################################################################################";
	# 	MSG "Convert results to forecast monthly";
	# 	for f in $cptresults/*;do
	# 		sed '1,6d' $f > ${f};
	# 	done

	;;
	# "tst")
	# 	phases=( 
	# 		'Locating Jebediah Kerman...'
	# 		'Motivating Kerbals...'
	# 		'Treating Kessler Syndrome...'
	# 		'Recruiting Kerbals...'
	# 	)   

	# 	for i in $(seq 1 100); do  
	# 		sleep 0.1

	# 		if [ $i -eq 100 ]; then
	# 			echo -e "XXX\n100\nDone!\nXXX"
	# 		elif [ $(($i % 25)) -eq 0 ]; then
	# 			let "phase = $i / 25"
	# 			echo -e "XXX\n$i\n${phases[phase]}\nXXX"
	# 		else
	# 			echo $i
	# 		fi 
	# 	done | whiptail --title 'Kerbal Space Program' --gauge "${phases[0]}" 6 60 0
	# ;;
	# "tst2")
	# 	prog() {
	# 		local w=80 p=$1;  shift
	# 		# create a string of spaces, then change them to dots
	# 		printf -v dots "%*s" "$(( $p*$w/100 ))" ""; dots=${dots// /.};
	# 		# print those dots on a fixed-width space plus the percentage etc. 
	# 		printf "\r\e[K|%-*s| %3d %% %s" "$w" "$dots" "$p" "$*"; 
	# 	}
	# 	# test loop
	# 	for x in {1..100} ; do
	# 		prog "$x" still working...
	# 		sleep .1   # do some work here
	# 	done ; echo

	# ;;
	*)
		echo "Usage: . $me [1|2|3|4|5]";

	;;

esac


################################################################################
return
################################################################################




################################################################################
# PERL START


perl -nl -MPOSIX -e 'print ceil($_);'
perl -nl -MPOSIX -e 'print floor($_);'

# PERL END
################################################################################





################################################################################
# RSCRIPT START



# libraries <- c("tidyverse","split")
# # install.packages(libraries, repos="http://cran.us.r-project.org", dependencies = TRUE);
# invisible(suppressMessages(suppressWarnings(lapply(libraries, FUN=function(x){
# 	require(x, character.only = TRUE, warn.conflicts=FALSE, quietly=FALSE)
# }))))


args <- commandArgs(TRUE);
# f <- "/home/mr/servers/z/scratch/phd/pihm/sanmarcos/finalrun/data/1_downscaling/tmp/xy/X_01_1";
# f <- "/home/mr/servers/z/scratch/phd/pihm/sanmarcos/finalrun/data/1_downscaling/tmp/xy/Y_29.3125_-97.3125_01";

f <- args[1];
		
d <- read.csv(f, header=F, skip=1, sep=",");
cat(paste(
	ceiling(max(d[1,-1])),
	floor(min(d[1,-1])),
	floor(min(d[2,-1])),
	ceiling(max(d[2,-1])),
	sep = ","
));


# RSCRIPT END
################################################################################

################################################################################
# cpt_CV_cfg START
2	2.  Principal Components Regression (PCR)
1	X Input File
X_
cptLimitsX
1	Minimum number of X modes: 1
4	Maximum number of X modes: 4
2	Y Input File
Y_
cptLimitsY
552	552.  Forecast settings
95	Confidence level (%): 95
1	Number of ensemble members: 500
1	1. Cross-validated error variance			3. Fitted error variance
0	0. Odds			1. Odds relative to climatology
4 Number of decimal places (maximum is 8): 4
8	8.  Length of cross-validation window
3	Length of cross-validation period (must be odd): 3
311	311.  Perform cross-validated analysis
111	111.  Data output
4	4. Cross-Validated Predictions
CV_	CV output
0
0
# cpt_CV_cfg END
################################################################################

