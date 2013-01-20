set term pngcairo
set output "hist.png"

binwidth=1.5
bin(x,width)=width*floor(x/width)

set label font ",10"

plot 'BLA1:C1-C5-C2' using (bin($2,binwidth)):(1.0) smooth freq with boxes, \
'' using (bin($2,binwidth)):(1.0):(sprintf("[%.0f,%.0f]",$1,$2)) smooth freq with labels
