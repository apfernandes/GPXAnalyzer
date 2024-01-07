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

This is the folder that GPXAnalyzer will processs





