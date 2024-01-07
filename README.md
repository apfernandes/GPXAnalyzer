![GPXAnalyzer](gpxAnalyze.png)
# GPXAnalyzer
Analyze GPX files exported from Strava (or others)

I like running and MTB, and being and engineer, I also like to analyze and visualize the data.

To bulk export your data from Strava refer to

https://support.strava.com/hc/en-us/articles/216918437-Exporting-your-Data-and-Bulk-Export#h_01GG58HC4F1BGQ9PQZZVANN6WF

The bulk export is buried inside Download or Delete Your Account which sounds kind of scary, but works fine.

The exported data should have a file structure like the following:

```
export_XXXXX
├── activities
├── clubs
├── media
└── routes
```

Inside the activities folder you will have all your GPX routes
```
...
6281806556.gpx
6289590445.gpx
6314478044.gpx
6329145080.gpx
6340842081.gpx
...
```

This is the folder that GPXAnalyzer will processs.

The APP currently just provides a button for you to select a folder with the GPX files.
It reads all the GPX files and dumps a sorted list, tab delimited, with the following sample information

```
Activity Type | Date       | Year | Day of The Year | Total Distance in km  | Total time in seconds
--------------|------------|------|-----------------|-----------------------|-----------------------
cycling	      | 2020-05-31 | 2020 | 152             | 25.57511413771457 km  |	9447.0	s
cycling	      | 2020-08-09 | 2020 | 222	            | 25.32350980764099	km  |	8720.0	s
running	      | 2018-08-12 | 2018 | 224             | 5.953241900450686 km  |	1940.0	s
running	      | 2018-08-15 | 2018 | 227	            | 10.726411593846963 km |	4192.0	s
running	      | 2018-11-03 | 2018 | 307	            | 14.751070878509887 km |	6928.0	s
```









