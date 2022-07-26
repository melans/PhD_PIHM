# script name
me="$BASH_SOURCE"
# current folder
ME=$(realpath .)
tmp="$ME/tmp";
dt1="1961";
dt2="2010";
observed_monthly="$tmp/observed/monthly";
observed_daily="$tmp/observed/daily";
forecast_monthly="$tmp/forecast/monthly";
forecast_daily="$tmp/forecast/daily";
forecast_rslts="$tmp/forecast/rslts";

unset count;

################################################################################
# https://unix.stackexchange.com/questions/415421/linux-how-to-create-simple-progress-bar-in-bash
function prog(){
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
		##############################################################
		MSG "Create the basic folders";
		mkdir -p $observed_monthly $observed_daily $forecast_monthly $forecast_daily;

		X1="-98.8125";
		X2="-97.3125";
		Y1="29.3125";
		Y2="30.3125";
		# XY_limits="Y/$Y1/$Y2/RANGEEDGES/X/$X1/$X2/RANGEEDGES";
		X_range=$(seq $X1 .125 $X2);
		Y_range=$(seq $Y1 .125 $Y2);

		MSG "collect coloumns 4,5,6,7 fom the observed data";
		for y in $Y_range;do
			for x in $X_range;do
				f="../1_downscaling/tmp/observed/daily/data_"$y"_"$x;
				MSGx "Copying ($f) to (${observed_daily//$ME\/}${f##*/})";
				# cp $f $observed_daily/${f##*/};
				awk '{print $4,$5,$6,$7}' $f > $observed_daily/${f##*/};
			done;
		done;

		echo;

		# octave mestudy.m data/input_observed_daily_30.9375_-84.9375 data/input_forecast_monthly_30.9375_-84.9375 data/output_forecast_daily_30.9375_-84.9375
		MSG "Put the downscaled data in (1 year per line) format";
		grids=($(ls ../1_downscaling/tmp/cptresults/CV_*1.txt|awk -F_ '{print $(NF-3)"_"$(NF-2)}'|sort|uniq));

		for L in {1..6};do
			for g in ${grids[@]};do
				MSGx "Generating grid ($g) for ($L) leadtime ==> ${forecast_monthly//$ME\/}/data_$g"_"$L";
				pr -mts" " ../1_downscaling/tmp/cptresults/CV_$g*_$L.txt|awk '$1*1>1960'|sed 's/\t/ /g'|cut -d" " -f$(seq -s, 2 2 24) > \
				$forecast_monthly/data_$g"_"$L;
			done
		done
		##############################################################
		MSG "Done";
		# . "$me" 2;

	;;
	"2")
		##############################################################
		MSG "Building dis-aggregation octave script";
		# octave mestudy.m data/input_observed_daily_30.9375_-84.9375 data/input_forecast_monthly_30.9375_-84.9375 data/output_forecast_daily_30.9375_-84.9375
		progcount=$(ls $forecast_monthly/*|wc -l);
		progcounter=1;
		echo -n "">octaves

		for monthly in $forecast_monthly/*;do
			obs=${monthly//forecast\/monthly/observed\/daily};
			obs=${obs::-2};
			daily=${monthly//monthly/daily};
			# MSGx "Dis-aggregating (${monthly//$ME\/}) to (${daily//$ME\/}) using (${obs//$ME\/})";
			# MSGx "Generating (${daily//$ME\/}) from (${monthly//$ME\/})";
			# MSGx "Building octave commands for (${daily//$ME\/})";
			prog  "$progcounter" "$progcount" "Building octave commands for (${daily//$ME\/})";
			echo octave mestudy.m "${obs//$ME\/}" "${monthly//$ME\/}" "${daily//$ME\/}" >> octaves;
			progcounter=$((progcounter+1));
		done
		##############################################################
		MSG "Done";
		MSG "Run : parallel -j 4 < octaves";
		# . "$me" 3;

	;;
	"3")
		##############################################################
		MSG "Testing";
		mkdir -p $forecast_rslts;

		# progcount=$(ls $forecast_daily/*|wc -l);
		# progcounter=1;

		for f in $forecast_daily/*;do
			prog  "$progcounter" "$progcount" "Testing (${f//$ME\/})";
			Rscript --vanilla <(sed '1,/^# RSCRIPT START/d;/^# RSCRIPT END/,$d' "$me") "$f" "${f//daily/monthly}" "${f//daily/rslts}";
			progcounter=$((progcounter+1));
		done
		##############################################################
		MSG "Done";
		rsltsf=$tmp/forecast/rslts.txt;
		echo -n "">$rsltsf;

		for f in $forecast_rslts/*;do 
			if [[ -s "$f" ]];then
				echo ${f//$ME\/} >> $rsltsf && cat $f >> $rsltsf;
			fi
		done
		MSG "R2 < 75% ==> ${rslts//$ME\/}";
		##############################################################
		MSG "Done";
	;;
	*)
		echo "Usage: . $me [1|2|3|4]";

	;;

esac
################################################################################

################################################################################
return
################################################################################


################################################################################
# RSCRIPT START



# libraries <- c("dplyer")
# # # install.packages(libraries, repos="http://cran.us.r-project.org", dependencies = TRUE);
# invisible(suppressMessages(suppressWarnings(lapply(libraries, FUN=function(x){
# 	require(x, character.only = TRUE, warn.conflicts=FALSE, quietly=FALSE)
# }))))


args <- commandArgs(TRUE);

# daily <- "/home/mr/servers/z/scratch/phd/pihm/sanmarcos/finalrun/data/2_disaggregation/tmp/forecast/daily/data_29.8125_-98.8125_4";
# monthly <- "/home/mr/servers/z/scratch/phd/pihm/sanmarcos/finalrun/data/2_disaggregation/tmp/forecast/monthly/data_29.8125_-98.8125_4";
# rslts <- "/home/mr/servers/z/scratch/phd/pihm/sanmarcos/finalrun/data/2_disaggregation/tmp/forecast/rslts/rslts_29.8125_-98.8125_4";

daily <- args[1];
monthly <- args[2];
rslts <- args[3];

m <- read.csv(monthly, header=F, sep=" ");
d <- read.csv(daily, header=F, sep=" ");
d$date <- as.Date(with(d, paste(d$V1, d$V2, d$V3,sep="-")), "%Y-%m-%d");
mm <- aggregate(d$V4 ~ d$V2 + d$V1, d, FUN=sum);
names(mm) <- c("month","year","val");
mm <- reshape(mm, direction = "wide", idvar = "year" , timevar = "month");

sink(rslts);
invisible(
  lapply(seq.int(dim(mm)[1]), function(r){
    r2 <- round(cor(t(m[r,]),t(mm[r,-1]), use="complete.obs")^2, 2)
    if(r2<.75)
      cat(paste0(mm[r,1]," ==> ",r2,"\n"));
  })
);
sink();
    


# RSCRIPT END
################################################################################
