# GB Bikepacking Routes

View GPX files sourced from a variety of sources in an R Shiny app to plan trips that follow multiple, connected routes.

`data/` should be manually populated with the GPX files of routes listed in `info.xlsx` with the exact same name. Once populated, run `utls.R` to produce `data.RDS` before running `app.R`.

Please note that GPX files cannot be download directly through the app so that users are routed to the route providers in case of route changes/to drive web traffic.

## Features to add

- Right now GPX files using route points must be manually converted to track points - `parse_file()` should accept both
- Elevation/surface profiles
- Import Strava heatmap
- Imperial units toggle
- Could maybe automate the population of `data/`
- {bslib} theming