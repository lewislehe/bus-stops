library(gtfs2gps)

file_loc <- "gtfs_AnnArbor_2019.zip"

#load GTFS file
gtfs_dat <- read_gtfs(file_loc)

#filter the GTFS file
gtfs_dat <- filter_by_route_type(gtfs_dat, 3)

#create gps database 
df <- gtfs2gps(gtfs_dat, parallel = TRUE, spatial_resolution = 30)
df <- na.omit(df)

#get spacings and stop locations
dist <- df$cumdist[2:length(df$cumdist)] - df$cumdist[1:(length(df$cumdist)-1)]
dist <- as.numeric(dist)
lat1 <- df$shape_pt_lat[1:(length(df$shape_pt_lat)-1)]
lon1 <- df$shape_pt_lon[1:(length(df$shape_pt_lon)-1)]
lat2 <- df$shape_pt_lat[2:length(df$shape_pt_lat)]
lon2 <- df$shape_pt_lon[2:length(df$shape_pt_lon)]
spacings_db <- data.frame("dist" = dist, "lat1" = lat1, "lon1" = lon1, "lat2" = lat2, "lon2" = lon2)

#save as csv
name <- unlist(strsplit(file_loc, split = ".", fixed = TRUE))[1]
name <- unlist(strsplit(file_loc, split = "_", fixed = TRUE))[2]
name <- paste0(name, '.csv')
write.csv(spacings_db, file = name, row.names = FALSE)