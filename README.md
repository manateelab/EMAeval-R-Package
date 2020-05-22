EMAeval 
==================
5/22/2020

The R package EMAeval contains functions created to help researchers identify careless responses as well as responders ine EMA data. An example dataset is included in the package to help the user better understand the uses of each function. This dataset "EMAeval\_Data" is used in the example code below.

There are 4 "participants," each having 50 assessments. Each was asked 8 questions per assessment.

<table class="table" style="margin-left: auto; margin-right: auto;">
<caption>
EMAeval_Data Example
</caption>
<thead>
<tr>
<th style="text-align:left;">
</th>
<th style="text-align:right;">
ID
</th>
<th style="text-align:left;">
StartDate
</th>
<th style="text-align:left;">
EndDate
</th>
<th style="text-align:right;">
Q1
</th>
<th style="text-align:right;">
Q2
</th>
<th style="text-align:right;">
Q3
</th>
<th style="text-align:right;">
Q4
</th>
<th style="text-align:right;">
Q5
</th>
<th style="text-align:right;">
Q6
</th>
<th style="text-align:right;">
Q7
</th>
<th style="text-align:right;">
Q8
</th>
</tr>
</thead>
<tbody>
<tr>
<td style="text-align:left;">
1
</td>
<td style="text-align:right;">
1001
</td>
<td style="text-align:left;">
2020-01-02 09:59:34
</td>
<td style="text-align:left;">
2020-01-02 09:59:51
</td>
<td style="text-align:right;">
7
</td>
<td style="text-align:right;">
4
</td>
<td style="text-align:right;">
19
</td>
<td style="text-align:right;">
65
</td>
<td style="text-align:right;">
88
</td>
<td style="text-align:right;">
3
</td>
<td style="text-align:right;">
99
</td>
<td style="text-align:right;">
85
</td>
</tr>
<tr>
<td style="text-align:left;">
56
</td>
<td style="text-align:right;">
1002
</td>
<td style="text-align:left;">
2020-01-07 09:59:45
</td>
<td style="text-align:left;">
2020-01-07 10:00:00
</td>
<td style="text-align:right;">
54
</td>
<td style="text-align:right;">
50
</td>
<td style="text-align:right;">
51
</td>
<td style="text-align:right;">
54
</td>
<td style="text-align:right;">
54
</td>
<td style="text-align:right;">
52
</td>
<td style="text-align:right;">
53
</td>
<td style="text-align:right;">
45
</td>
</tr>
<tr>
<td style="text-align:left;">
111
</td>
<td style="text-align:right;">
1003
</td>
<td style="text-align:left;">
2020-01-12 09:59:24
</td>
<td style="text-align:left;">
2020-01-12 09:59:48
</td>
<td style="text-align:right;">
65
</td>
<td style="text-align:right;">
99
</td>
<td style="text-align:right;">
94
</td>
<td style="text-align:right;">
51
</td>
<td style="text-align:right;">
95
</td>
<td style="text-align:right;">
11
</td>
<td style="text-align:right;">
69
</td>
<td style="text-align:right;">
12
</td>
</tr>
<tr>
<td style="text-align:left;">
172
</td>
<td style="text-align:right;">
1004
</td>
<td style="text-align:left;">
2020-01-23 10:00:37
</td>
<td style="text-align:left;">
2020-01-23 10:03:24
</td>
<td style="text-align:right;">
65
</td>
<td style="text-align:right;">
5
</td>
<td style="text-align:right;">
93
</td>
<td style="text-align:right;">
22
</td>
<td style="text-align:right;">
86
</td>
<td style="text-align:right;">
91
</td>
<td style="text-align:right;">
10
</td>
<td style="text-align:right;">
24
</td>
</tr>
</tbody>
</table>

Functions
==================

Below are the functions in the R package EMAeval. The functions are:

-   flagging\_df
-   flagging\_plots
-   TPI\_cutoff
-   SD\_cutoff
-   Combined\_cutoff
-   Combined\_cutoff\_percent

Each section will be dedicated to a particular function, giving an example of the usage with the EMAeval\_Data and showing the output.



flagging\_df
------------

*This function creates a dataframe that reports Time to Complete (TTC), Time per Item (TPI), Item Standard Deviation (SD), and Longstring. If the Longstring returns NA, then there was no longstring response because all item responses were different. The partial results of the flagging\_df function are based from the EMAeval\_Data Example above.*

``` r
flaggingDF <- flagging_df(EMAeval_Data, ttc.colnames = c("StartDate", "EndDate"), item.colnames = colnames(EMAeval_Data[,4:11]))
```

<table class="table" style="margin-left: auto; margin-right: auto;">
<caption>
Flagging Dataframe Example
</caption>
<thead>
<tr>
<th style="text-align:left;">
</th>
<th style="text-align:right;">
TTC
</th>
<th style="text-align:right;">
TPI
</th>
<th style="text-align:right;">
SD
</th>
<th style="text-align:left;">
Longstring
</th>
</tr>
</thead>
<tbody>
<tr>
<td style="text-align:left;">
1
</td>
<td style="text-align:right;">
17
</td>
<td style="text-align:right;">
2.125
</td>
<td style="text-align:right;">
41.95
</td>
<td style="text-align:left;">
NA
</td>
</tr>
<tr>
<td style="text-align:left;">
56
</td>
<td style="text-align:right;">
15
</td>
<td style="text-align:right;">
1.875
</td>
<td style="text-align:right;">
3.07
</td>
<td style="text-align:left;">
54
</td>
</tr>
<tr>
<td style="text-align:left;">
111
</td>
<td style="text-align:right;">
24
</td>
<td style="text-align:right;">
3.000
</td>
<td style="text-align:right;">
35.38
</td>
<td style="text-align:left;">
NA
</td>
</tr>
<tr>
<td style="text-align:left;">
172
</td>
<td style="text-align:right;">
167
</td>
<td style="text-align:right;">
20.875
</td>
<td style="text-align:right;">
38.05
</td>
<td style="text-align:left;">
NA
</td>
</tr>
</tbody>
</table>

flagging\_plots
---------------

*This function creates a histograms of each of the calculations reported in the flagging\_df function. This can be used to help users identify the cutoff values for TPI and SD.*

``` r
flagging_plots(EMAeval_Data, ttc.colnames = c("StartDate", "EndDate"), item.colnames = colnames(EMAeval_Data[,4:11]), number.items = 8)
```

<img src="README_files/figure-markdown_github/unnamed-chunk-5-1.png" style="display: block; margin: auto;" />

*Note: the Longstring histogram has a much smaller scale for the Count. This is due to the lack of longstring values because many assessments do not have a Longstring value because all item responses differ.*



TPI\_cutoff
-----------

*This function creates a dataframe of ID and data indices in which the assessment met the cutoff criterion for Time per Item. The user inputs their own cutoff for TPI. If responses to all items are mandatory, then the following response should be included:*

    mandatory.response = TRUE

*Below is the code for the function.*

``` r
TPI_cutoff(EMAeval_Data, cutoff = 2, ttc.colnames = c("StartDate", "EndDate"),  number.items = 8, mandatory.response = TRUE, item.colnames = colnames(EMAeval_Data[,4:11]), ID.colname = "ID")
```

<table class="table" style="margin-left: auto; margin-right: auto;">
<caption>
Assessments Flagged by TPI Cutoff
</caption>
<thead>
<tr>
<th style="text-align:right;position: sticky; top:0; background-color: #FFFFFF;">
ID
</th>
<th style="text-align:right;position: sticky; top:0; background-color: #FFFFFF;">
Index_of_Flagged_Assessment
</th>
</tr>
</thead>
<tbody>
<tr>
<td style="text-align:right;">
1001
</td>
<td style="text-align:right;">
6
</td>
</tr>
<tr>
<td style="text-align:right;">
1001
</td>
<td style="text-align:right;">
13
</td>
</tr>
<tr>
<td style="text-align:right;">
1001
</td>
<td style="text-align:right;">
14
</td>
</tr>
<tr>
<td style="text-align:right;">
1001
</td>
<td style="text-align:right;">
17
</td>
</tr>
<tr>
<td style="text-align:right;">
1001
</td>
<td style="text-align:right;">
27
</td>
</tr>
<tr>
<td style="text-align:right;">
1001
</td>
<td style="text-align:right;">
40
</td>
</tr>
<tr>
<td style="text-align:right;">
1001
</td>
<td style="text-align:right;">
49
</td>
</tr>
<tr>
<td style="text-align:right;">
1002
</td>
<td style="text-align:right;">
51
</td>
</tr>
<tr>
<td style="text-align:right;">
1002
</td>
<td style="text-align:right;">
52
</td>
</tr>
<tr>
<td style="text-align:right;">
1002
</td>
<td style="text-align:right;">
53
</td>
</tr>
<tr>
<td style="text-align:right;">
1002
</td>
<td style="text-align:right;">
55
</td>
</tr>
<tr>
<td style="text-align:right;">
1002
</td>
<td style="text-align:right;">
56
</td>
</tr>
<tr>
<td style="text-align:right;">
1002
</td>
<td style="text-align:right;">
57
</td>
</tr>
<tr>
<td style="text-align:right;">
1002
</td>
<td style="text-align:right;">
58
</td>
</tr>
<tr>
<td style="text-align:right;">
1002
</td>
<td style="text-align:right;">
59
</td>
</tr>
<tr>
<td style="text-align:right;">
1002
</td>
<td style="text-align:right;">
61
</td>
</tr>
<tr>
<td style="text-align:right;">
1002
</td>
<td style="text-align:right;">
62
</td>
</tr>
<tr>
<td style="text-align:right;">
1002
</td>
<td style="text-align:right;">
63
</td>
</tr>
<tr>
<td style="text-align:right;">
1002
</td>
<td style="text-align:right;">
64
</td>
</tr>
<tr>
<td style="text-align:right;">
1002
</td>
<td style="text-align:right;">
68
</td>
</tr>
<tr>
<td style="text-align:right;">
1002
</td>
<td style="text-align:right;">
69
</td>
</tr>
<tr>
<td style="text-align:right;">
1002
</td>
<td style="text-align:right;">
70
</td>
</tr>
<tr>
<td style="text-align:right;">
1002
</td>
<td style="text-align:right;">
71
</td>
</tr>
<tr>
<td style="text-align:right;">
1002
</td>
<td style="text-align:right;">
73
</td>
</tr>
<tr>
<td style="text-align:right;">
1002
</td>
<td style="text-align:right;">
74
</td>
</tr>
<tr>
<td style="text-align:right;">
1002
</td>
<td style="text-align:right;">
75
</td>
</tr>
<tr>
<td style="text-align:right;">
1002
</td>
<td style="text-align:right;">
77
</td>
</tr>
<tr>
<td style="text-align:right;">
1002
</td>
<td style="text-align:right;">
78
</td>
</tr>
<tr>
<td style="text-align:right;">
1002
</td>
<td style="text-align:right;">
79
</td>
</tr>
<tr>
<td style="text-align:right;">
1002
</td>
<td style="text-align:right;">
80
</td>
</tr>
<tr>
<td style="text-align:right;">
1002
</td>
<td style="text-align:right;">
81
</td>
</tr>
<tr>
<td style="text-align:right;">
1002
</td>
<td style="text-align:right;">
82
</td>
</tr>
<tr>
<td style="text-align:right;">
1002
</td>
<td style="text-align:right;">
83
</td>
</tr>
<tr>
<td style="text-align:right;">
1002
</td>
<td style="text-align:right;">
85
</td>
</tr>
<tr>
<td style="text-align:right;">
1002
</td>
<td style="text-align:right;">
87
</td>
</tr>
<tr>
<td style="text-align:right;">
1002
</td>
<td style="text-align:right;">
88
</td>
</tr>
<tr>
<td style="text-align:right;">
1002
</td>
<td style="text-align:right;">
90
</td>
</tr>
<tr>
<td style="text-align:right;">
1002
</td>
<td style="text-align:right;">
91
</td>
</tr>
<tr>
<td style="text-align:right;">
1002
</td>
<td style="text-align:right;">
93
</td>
</tr>
<tr>
<td style="text-align:right;">
1002
</td>
<td style="text-align:right;">
95
</td>
</tr>
<tr>
<td style="text-align:right;">
1002
</td>
<td style="text-align:right;">
97
</td>
</tr>
<tr>
<td style="text-align:right;">
1002
</td>
<td style="text-align:right;">
98
</td>
</tr>
<tr>
<td style="text-align:right;">
1002
</td>
<td style="text-align:right;">
100
</td>
</tr>
<tr>
<td style="text-align:right;">
1003
</td>
<td style="text-align:right;">
109
</td>
</tr>
<tr>
<td style="text-align:right;">
1004
</td>
<td style="text-align:right;">
151
</td>
</tr>
<tr>
<td style="text-align:right;">
1004
</td>
<td style="text-align:right;">
171
</td>
</tr>
</tbody>
</table>

SD\_cutoff
----------

*This function creates a dataframe of ID and data indices in which the assessment met the cutoff criterion for Item Score Standard Deviation. The user inputs their own cutoff for SD.*

*Below is the code for the function.*

``` r
SD_cutoff(EMAeval_Data, cutoff = 5, item.colnames = colnames(EMAeval_Data[,4:11]), ID.colname = "ID")
```

<table class="table" style="margin-left: auto; margin-right: auto;">
<caption>
Assessments Flagged by SD Cutoff
</caption>
<thead>
<tr>
<th style="text-align:right;position: sticky; top:0; background-color: #FFFFFF;">
ID
</th>
<th style="text-align:right;position: sticky; top:0; background-color: #FFFFFF;">
Index_of_Flagged_Assessment
</th>
</tr>
</thead>
<tbody>
<tr>
<td style="text-align:right;">
1002
</td>
<td style="text-align:right;">
51
</td>
</tr>
<tr>
<td style="text-align:right;">
1002
</td>
<td style="text-align:right;">
52
</td>
</tr>
<tr>
<td style="text-align:right;">
1002
</td>
<td style="text-align:right;">
53
</td>
</tr>
<tr>
<td style="text-align:right;">
1002
</td>
<td style="text-align:right;">
54
</td>
</tr>
<tr>
<td style="text-align:right;">
1002
</td>
<td style="text-align:right;">
55
</td>
</tr>
<tr>
<td style="text-align:right;">
1002
</td>
<td style="text-align:right;">
56
</td>
</tr>
<tr>
<td style="text-align:right;">
1002
</td>
<td style="text-align:right;">
57
</td>
</tr>
<tr>
<td style="text-align:right;">
1002
</td>
<td style="text-align:right;">
58
</td>
</tr>
<tr>
<td style="text-align:right;">
1002
</td>
<td style="text-align:right;">
59
</td>
</tr>
<tr>
<td style="text-align:right;">
1002
</td>
<td style="text-align:right;">
60
</td>
</tr>
<tr>
<td style="text-align:right;">
1002
</td>
<td style="text-align:right;">
61
</td>
</tr>
<tr>
<td style="text-align:right;">
1002
</td>
<td style="text-align:right;">
62
</td>
</tr>
<tr>
<td style="text-align:right;">
1002
</td>
<td style="text-align:right;">
63
</td>
</tr>
<tr>
<td style="text-align:right;">
1002
</td>
<td style="text-align:right;">
64
</td>
</tr>
<tr>
<td style="text-align:right;">
1002
</td>
<td style="text-align:right;">
65
</td>
</tr>
<tr>
<td style="text-align:right;">
1002
</td>
<td style="text-align:right;">
66
</td>
</tr>
<tr>
<td style="text-align:right;">
1002
</td>
<td style="text-align:right;">
67
</td>
</tr>
<tr>
<td style="text-align:right;">
1002
</td>
<td style="text-align:right;">
68
</td>
</tr>
<tr>
<td style="text-align:right;">
1002
</td>
<td style="text-align:right;">
69
</td>
</tr>
<tr>
<td style="text-align:right;">
1002
</td>
<td style="text-align:right;">
70
</td>
</tr>
<tr>
<td style="text-align:right;">
1002
</td>
<td style="text-align:right;">
71
</td>
</tr>
<tr>
<td style="text-align:right;">
1002
</td>
<td style="text-align:right;">
72
</td>
</tr>
<tr>
<td style="text-align:right;">
1002
</td>
<td style="text-align:right;">
73
</td>
</tr>
<tr>
<td style="text-align:right;">
1002
</td>
<td style="text-align:right;">
74
</td>
</tr>
<tr>
<td style="text-align:right;">
1002
</td>
<td style="text-align:right;">
75
</td>
</tr>
<tr>
<td style="text-align:right;">
1002
</td>
<td style="text-align:right;">
76
</td>
</tr>
<tr>
<td style="text-align:right;">
1002
</td>
<td style="text-align:right;">
77
</td>
</tr>
<tr>
<td style="text-align:right;">
1002
</td>
<td style="text-align:right;">
78
</td>
</tr>
<tr>
<td style="text-align:right;">
1002
</td>
<td style="text-align:right;">
79
</td>
</tr>
<tr>
<td style="text-align:right;">
1002
</td>
<td style="text-align:right;">
80
</td>
</tr>
<tr>
<td style="text-align:right;">
1002
</td>
<td style="text-align:right;">
81
</td>
</tr>
<tr>
<td style="text-align:right;">
1002
</td>
<td style="text-align:right;">
82
</td>
</tr>
<tr>
<td style="text-align:right;">
1002
</td>
<td style="text-align:right;">
83
</td>
</tr>
<tr>
<td style="text-align:right;">
1002
</td>
<td style="text-align:right;">
84
</td>
</tr>
<tr>
<td style="text-align:right;">
1002
</td>
<td style="text-align:right;">
85
</td>
</tr>
<tr>
<td style="text-align:right;">
1002
</td>
<td style="text-align:right;">
86
</td>
</tr>
<tr>
<td style="text-align:right;">
1002
</td>
<td style="text-align:right;">
87
</td>
</tr>
<tr>
<td style="text-align:right;">
1002
</td>
<td style="text-align:right;">
88
</td>
</tr>
<tr>
<td style="text-align:right;">
1002
</td>
<td style="text-align:right;">
89
</td>
</tr>
<tr>
<td style="text-align:right;">
1002
</td>
<td style="text-align:right;">
90
</td>
</tr>
<tr>
<td style="text-align:right;">
1002
</td>
<td style="text-align:right;">
91
</td>
</tr>
<tr>
<td style="text-align:right;">
1002
</td>
<td style="text-align:right;">
92
</td>
</tr>
<tr>
<td style="text-align:right;">
1002
</td>
<td style="text-align:right;">
93
</td>
</tr>
<tr>
<td style="text-align:right;">
1002
</td>
<td style="text-align:right;">
94
</td>
</tr>
<tr>
<td style="text-align:right;">
1002
</td>
<td style="text-align:right;">
95
</td>
</tr>
<tr>
<td style="text-align:right;">
1002
</td>
<td style="text-align:right;">
96
</td>
</tr>
<tr>
<td style="text-align:right;">
1002
</td>
<td style="text-align:right;">
97
</td>
</tr>
<tr>
<td style="text-align:right;">
1002
</td>
<td style="text-align:right;">
98
</td>
</tr>
<tr>
<td style="text-align:right;">
1002
</td>
<td style="text-align:right;">
99
</td>
</tr>
<tr>
<td style="text-align:right;">
1002
</td>
<td style="text-align:right;">
100
</td>
</tr>
</tbody>
</table>



Combined\_cutoff
----------------

*This function creates a dataframe of ID and data indices in which the assessment met the cutoff criteria for Time per Item as well as Item Score Standard Deviation. The user inputs their own cutoff for TPI. If responses to all items are mandatory, then the following response should be included:*

    mandatory.response = TRUE

*Below is the code for the function.*

``` r
Combined_cutoff(EMAeval_Data, SD.cutoff = 5, TPI.cutoff = 2, ttc.colnames = c("StartDate", "EndDate"),  number.items = 8, mandatory.response = TRUE, item.colnames = colnames(EMAeval_Data[,4:11]), ID.colname = "ID")
```

<table class="table" style="margin-left: auto; margin-right: auto;">
<caption>
Assessments Flagged by both TPI and SD Cutoffs
</caption>
<thead>
<tr>
<th style="text-align:right;position: sticky; top:0; background-color: #FFFFFF;">
ID
</th>
<th style="text-align:right;position: sticky; top:0; background-color: #FFFFFF;">
Index_of_Flagged_Assessment
</th>
</tr>
</thead>
<tbody>
<tr>
<td style="text-align:right;">
1002
</td>
<td style="text-align:right;">
51
</td>
</tr>
<tr>
<td style="text-align:right;">
1002
</td>
<td style="text-align:right;">
52
</td>
</tr>
<tr>
<td style="text-align:right;">
1002
</td>
<td style="text-align:right;">
53
</td>
</tr>
<tr>
<td style="text-align:right;">
1002
</td>
<td style="text-align:right;">
55
</td>
</tr>
<tr>
<td style="text-align:right;">
1002
</td>
<td style="text-align:right;">
56
</td>
</tr>
<tr>
<td style="text-align:right;">
1002
</td>
<td style="text-align:right;">
57
</td>
</tr>
<tr>
<td style="text-align:right;">
1002
</td>
<td style="text-align:right;">
58
</td>
</tr>
<tr>
<td style="text-align:right;">
1002
</td>
<td style="text-align:right;">
59
</td>
</tr>
<tr>
<td style="text-align:right;">
1002
</td>
<td style="text-align:right;">
61
</td>
</tr>
<tr>
<td style="text-align:right;">
1002
</td>
<td style="text-align:right;">
62
</td>
</tr>
<tr>
<td style="text-align:right;">
1002
</td>
<td style="text-align:right;">
63
</td>
</tr>
<tr>
<td style="text-align:right;">
1002
</td>
<td style="text-align:right;">
64
</td>
</tr>
<tr>
<td style="text-align:right;">
1002
</td>
<td style="text-align:right;">
68
</td>
</tr>
<tr>
<td style="text-align:right;">
1002
</td>
<td style="text-align:right;">
69
</td>
</tr>
<tr>
<td style="text-align:right;">
1002
</td>
<td style="text-align:right;">
70
</td>
</tr>
<tr>
<td style="text-align:right;">
1002
</td>
<td style="text-align:right;">
71
</td>
</tr>
<tr>
<td style="text-align:right;">
1002
</td>
<td style="text-align:right;">
73
</td>
</tr>
<tr>
<td style="text-align:right;">
1002
</td>
<td style="text-align:right;">
74
</td>
</tr>
<tr>
<td style="text-align:right;">
1002
</td>
<td style="text-align:right;">
75
</td>
</tr>
<tr>
<td style="text-align:right;">
1002
</td>
<td style="text-align:right;">
77
</td>
</tr>
<tr>
<td style="text-align:right;">
1002
</td>
<td style="text-align:right;">
78
</td>
</tr>
<tr>
<td style="text-align:right;">
1002
</td>
<td style="text-align:right;">
79
</td>
</tr>
<tr>
<td style="text-align:right;">
1002
</td>
<td style="text-align:right;">
80
</td>
</tr>
<tr>
<td style="text-align:right;">
1002
</td>
<td style="text-align:right;">
81
</td>
</tr>
<tr>
<td style="text-align:right;">
1002
</td>
<td style="text-align:right;">
82
</td>
</tr>
<tr>
<td style="text-align:right;">
1002
</td>
<td style="text-align:right;">
83
</td>
</tr>
<tr>
<td style="text-align:right;">
1002
</td>
<td style="text-align:right;">
85
</td>
</tr>
<tr>
<td style="text-align:right;">
1002
</td>
<td style="text-align:right;">
87
</td>
</tr>
<tr>
<td style="text-align:right;">
1002
</td>
<td style="text-align:right;">
88
</td>
</tr>
<tr>
<td style="text-align:right;">
1002
</td>
<td style="text-align:right;">
90
</td>
</tr>
<tr>
<td style="text-align:right;">
1002
</td>
<td style="text-align:right;">
91
</td>
</tr>
<tr>
<td style="text-align:right;">
1002
</td>
<td style="text-align:right;">
93
</td>
</tr>
<tr>
<td style="text-align:right;">
1002
</td>
<td style="text-align:right;">
95
</td>
</tr>
<tr>
<td style="text-align:right;">
1002
</td>
<td style="text-align:right;">
97
</td>
</tr>
<tr>
<td style="text-align:right;">
1002
</td>
<td style="text-align:right;">
98
</td>
</tr>
<tr>
<td style="text-align:right;">
1002
</td>
<td style="text-align:right;">
100
</td>
</tr>
</tbody>
</table>

Combined\_cutoff\_percent
-------------------------

*This function creates a dataframe of ID and data indices in which the assessment met the cutoff criteria for Time per Item as well as Item Score Standard Deviation. The user inputs their own cutoff for TPI. If responses to all items are mandatory, then the following response should be included:*

    mandatory.response = TRUE

*Below is the code for the function.*

``` r
Combined_cutoff_percent(EMAeval_Data, SD.cutoff = 5, TPI.cutoff = 2, ttc.colnames = c("StartDate", "EndDate"),  number.items = 8, mandatory.response = TRUE, item.colnames = colnames(EMAeval_Data[,4:11]), ID.colname = "ID")
```

<table class="table" style="margin-left: auto; margin-right: auto;">
<caption>
Percentage of Assessments Flagged by both TPI and SD Cutoffs
</caption>
<thead>
<tr>
<th style="text-align:right;">
ID
</th>
<th style="text-align:right;">
Percent_Flagged
</th>
</tr>
</thead>
<tbody>
<tr>
<td style="text-align:right;">
1002
</td>
<td style="text-align:right;">
72
</td>
</tr>
</tbody>
</table>




For now, these are the only functions in the EMAeval package. They will be updated based on the need for further expansion of uses. If you have any question, please see the DESCRIPTION file to contact the maintainer.
