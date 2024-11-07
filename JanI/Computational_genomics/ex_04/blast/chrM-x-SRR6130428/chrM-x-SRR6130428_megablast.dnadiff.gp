set terminal postscript color solid "Courier" 8
set output "/home/jj/Desktop/Bioinformatics/3rd_year/1term/Computational_genomics/Seminars/exercise_04/blast/chrM-x-SRR6130428/chrM-x-SRR6130428_megablast.dnadiff.ps"
set ytics ( \
 "7978" 1, \
 "*6336" 3453, \
 "8560" 3755, \
 "*6600" 10232, \
 "6876" 10602, \
 "*7352" 11118, \
 "9364" 12396, \
 "*7694" 29858, \
 "*7100" 32142, \
 "6988" 32953, \
 "*7708" 33616, \
 "8344" 35921, \
 "*5942" 41028, \
 "*8048" 41257, \
 "6234" 44943, \
 "*7306" 45222, \
 "8164" 46379, \
 "*6636" 50573, \
 "*8510" 50959, \
 "8496" 57088, \
 "8524" 63160, \
 "*6806" 69403, \
 "*8842" 69872, \
 "7590" 78856, \
 "6752" 80778, \
 "*7564" 81222, \
 "7730" 83074, \
 "7414" 85475, \
 "187" 86917, \
 "2375" 86980, \
 "727" 87056, \
 "1879" 87120, \
 "9638" 87191, \
 "6622" 117729, \
 "3041" 118111, \
 "5642" 118199, \
 "2347" 118396, \
 "3561" 118472, \
 "2567" 118575, \
 "1401" 118654, \
 "2265" 118721, \
 "6370" 118796, \
 "2549" 119103, \
 "2715" 119182, \
 "6644" 119263, \
 "" 119699 \
)
set size 3,3
set grid
unset key
set border 10
set tics scale 0
set xlabel "Scer_chrM"
set ylabel "QRY"
set format "%.0f"
set mouse format "%.0f"
set mouse mouseformat "[%.0f, %.0f]"
if(GPVAL_VERSION < 5) set mouse clipboardformat "[%.0f, %.0f]"
set xrange [1:85779]
set yrange [1:119699]
set style line 1  lt 1 lw 2 pt 6 ps 0.5
set style line 2  lt 3 lw 2 pt 6 ps 0.5
set style line 3  lt 2 lw 2 pt 6 ps 0.5
plot \
 "/home/jj/Desktop/Bioinformatics/3rd_year/1term/Computational_genomics/Seminars/exercise_04/blast/chrM-x-SRR6130428/chrM-x-SRR6130428_megablast.dnadiff.fplot" title "FWD" w lp ls 1, \
 "/home/jj/Desktop/Bioinformatics/3rd_year/1term/Computational_genomics/Seminars/exercise_04/blast/chrM-x-SRR6130428/chrM-x-SRR6130428_megablast.dnadiff.rplot" title "REV" w lp ls 2
